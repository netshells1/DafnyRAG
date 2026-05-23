"""
Command-line interface for repairing Dafny files.

Example:
    python -m dafnyrag.repair --input path/to/file.dfy --llm gpt-4 --max-iters 5
"""

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from subprocess import CalledProcessError, TimeoutExpired, check_output
from typing import Dict, List, Tuple


REPO_ROOT = Path(__file__).resolve().parents[2]
LEGACY_PACKAGE_DIR = REPO_ROOT / "DafnyRAG"
if str(LEGACY_PACKAGE_DIR) not in sys.path:
    sys.path.insert(0, str(LEGACY_PACKAGE_DIR))


MODEL_ALIASES = {
    "GPT-4": "gpt-4",
    "GPT-4O": "gpt-4o",
    "GPT-4.1": "gpt-4.1",
    "GPT-4.1-NANO": "gpt-4.1-nano",
}


def load_fixer_class():
    """Import the repair core lazily so --help works without optional deps."""
    from core.improved_fixer import ImprovedDafnyFixer

    return ImprovedDafnyFixer


def normalize_model_name(model: str) -> str:
    """Normalize common paper-style model names to API model identifiers."""
    key = model.strip().upper()
    return MODEL_ALIASES.get(key, model.strip())


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Repair Dafny files with DafnyRAG."
    )
    parser.add_argument(
        "--input",
        required=True,
        help="Path to a buggy .dfy file, or a directory for batch mode.",
    )
    parser.add_argument(
        "--llm",
        default=os.getenv("OPENAI_MODEL", "gpt-4"),
        help="Model identifier, e.g. GPT-4, claude-4-5-sonnet, or deepseek-v3.",
    )
    parser.add_argument(
        "--max-iters",
        type=int,
        default=5,
        help="Iteration budget per task.",
    )
    parser.add_argument(
        "--kb-dir",
        default=str(REPO_ROOT),
        help="Directory containing chroma_db, chroma_db_error, and chroma_db_grammar.",
    )
    parser.add_argument(
        "--out-dir",
        default=str(REPO_ROOT / "repair_outputs"),
        help="Directory where repair records and fixed .dfy files are stored.",
    )
    parser.add_argument(
        "--api-key",
        default=os.getenv("OPENAI_API_KEY"),
        help="OpenAI-compatible API key. Defaults to OPENAI_API_KEY.",
    )
    parser.add_argument(
        "--base-url",
        default=os.getenv("OPENAI_BASE_URL", "https://api.openai.com/v1"),
        help="OpenAI-compatible API base URL.",
    )
    parser.add_argument(
        "--temperature",
        type=float,
        default=0.2,
        help="LLM sampling temperature.",
    )
    return parser.parse_args()


def run_dafny_verify(dfy_file: Path, timeout: int = 60) -> Tuple[int, int, str]:
    """Verify a Dafny file and return (verified_count, error_count, output)."""
    try:
        output = check_output(
            ["dafny", "/compile:0", str(dfy_file)],
            timeout=timeout,
            text=True,
            stderr=subprocess.STDOUT,
        )
    except TimeoutExpired:
        return (0, -1, f"Timeout (>{timeout}s)")
    except CalledProcessError as e:
        output = e.output
    except FileNotFoundError:
        return (0, -2, "Dafny not found on PATH")
    except Exception as e:
        return (0, -2, f"Error: {e}")

    verified_count = 0
    error_count = 0

    parse_error_match = re.search(r"(\d+)\s+parse\s+errors?", output, re.IGNORECASE)
    if parse_error_match:
        return (0, int(parse_error_match.group(1)), output)

    for line in output.splitlines():
        verified_match = re.search(r"(\d+)\s+verified", line, re.IGNORECASE)
        if verified_match:
            verified_count = int(verified_match.group(1))

        error_match = re.search(r"(\d+)\s+errors?", line, re.IGNORECASE)
        if error_match:
            error_count = int(error_match.group(1))
            break

    if error_count == 0 and verified_count == 0:
        for line in output.splitlines():
            stripped = line.strip()
            if (
                ": Error:" in stripped
                or ": error:" in stripped
                or stripped.startswith("Error:")
                or stripped.startswith("error:")
            ):
                error_count += 1

    return (verified_count, error_count, output)


def parse_verifier_errors(output: str) -> List[str]:
    """Extract verifier error lines from Dafny output."""
    errors = []
    for line in output.splitlines():
        stripped = line.strip()
        if (
            ": Error:" in stripped
            or ": error:" in stripped
            or stripped.startswith("Error:")
            or stripped.startswith("error:")
        ):
            errors.append(stripped)

    if not errors and "errors" in output.lower():
        for line in output.splitlines():
            stripped = line.strip()
            if any(
                marker in stripped.lower()
                for marker in ["violation", "failure", "could not be proved"]
            ):
                errors.append(stripped)

    return errors


def discover_inputs(input_path: Path) -> List[Path]:
    """Return one .dfy file or all .dfy files under a directory."""
    if input_path.is_file():
        if input_path.suffix != ".dfy":
            raise ValueError(f"Input file must have .dfy extension: {input_path}")
        return [input_path]

    if input_path.is_dir():
        return sorted(input_path.rglob("*.dfy"))

    raise FileNotFoundError(f"Input path does not exist: {input_path}")


def resolve_kb_dirs(kb_dir: Path) -> Dict[str, Path]:
    """Resolve knowledge-base directories."""
    case_db = kb_dir / "chroma_db"
    error_db = kb_dir / "chroma_db_error"
    grammar_db = kb_dir / "chroma_db_grammar"

    if not case_db.exists() and (kb_dir / "DafnyRAG" / "chroma_db").exists():
        case_db = kb_dir / "DafnyRAG" / "chroma_db"
        error_db = kb_dir / "DafnyRAG" / "chroma_db_error"
        grammar_db = kb_dir / "DafnyRAG" / "chroma_db_grammar"

    return {
        "case_db_dir": case_db,
        "error_db_dir": error_db,
        "grammar_db_dir": grammar_db,
    }


def repair_file(
    fixer,
    dfy_file: Path,
    max_iters: int,
) -> Dict:
    """Verify and repair a single Dafny file."""
    print("\n" + "=" * 70)
    print(f"Input: {dfy_file}")
    print("=" * 70)

    buggy_code = dfy_file.read_text(encoding="utf-8")
    verified_count, error_count, verifier_output = run_dafny_verify(dfy_file)
    verifier_errors = parse_verifier_errors(verifier_output)

    if error_count == 0 and verified_count > 0:
        print("Input already verifies; skipping repair.")
        return {
            "task_id": dfy_file.stem,
            "input_file": str(dfy_file),
            "skipped": True,
            "final_success": True,
            "final_error_count": 0,
            "total_iterations": 0,
        }

    if not verifier_errors:
        verifier_errors = [verifier_output[:1000]]

    result = fixer.iterative_fix_pipeline(
        buggy_code=buggy_code,
        verifier_errors=verifier_errors,
        task_id=dfy_file.stem,
        max_iterations=max_iters,
    )
    result["input_file"] = str(dfy_file)
    result["skipped"] = False
    return result


def main() -> int:
    args = parse_args()

    if not args.api_key:
        print("Missing API key. Set OPENAI_API_KEY or pass --api-key.", file=sys.stderr)
        return 2

    input_path = Path(args.input).resolve()
    out_dir = Path(args.out_dir).resolve()
    kb_dir = Path(args.kb_dir).resolve()
    model = normalize_model_name(args.llm)

    dfy_files = discover_inputs(input_path)
    if not dfy_files:
        print(f"No .dfy files found under {input_path}", file=sys.stderr)
        return 1

    kb_dirs = resolve_kb_dirs(kb_dir)
    fixer_cls = load_fixer_class()

    fixer = fixer_cls(
        api_key=args.api_key,
        base_url=args.base_url,
        output_dir=str(out_dir),
        clean_output=True,
        model=model,
        temperature=args.temperature,
    )
    fixer.load_all_vectorstores(
        case_db_dir=str(kb_dirs["case_db_dir"]),
        case_db_name="dafny_error_cases",
        error_db_dir=str(kb_dirs["error_db_dir"]),
        error_db_name="error_documents",
        grammar_db_dir=str(kb_dirs["grammar_db_dir"]),
        grammar_db_name="grammar_documents",
    )

    results = []
    for dfy_file in dfy_files:
        results.append(repair_file(fixer, dfy_file, args.max_iters))

    summary_path = out_dir / "repair_summary.json"
    summary = {
        "input": str(input_path),
        "llm": model,
        "max_iters": args.max_iters,
        "kb_dir": str(kb_dir),
        "out_dir": str(out_dir),
        "total_tasks": len(results),
        "successful": sum(1 for r in results if r.get("final_success")),
        "failed": sum(1 for r in results if not r.get("final_success")),
        "results": [
            {
                "task_id": r.get("task_id"),
                "input_file": r.get("input_file"),
                "success": r.get("final_success"),
                "iterations": r.get("total_iterations"),
                "final_error_count": r.get("final_error_count"),
                "skipped": r.get("skipped", False),
            }
            for r in results
        ],
    }
    summary_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")

    print("\n" + "=" * 70)
    print("Repair run complete")
    print("=" * 70)
    print(f"Tasks: {summary['total_tasks']}")
    print(f"Successful: {summary['successful']}")
    print(f"Failed: {summary['failed']}")
    print(f"Summary: {summary_path}")

    return 0 if summary["failed"] == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
