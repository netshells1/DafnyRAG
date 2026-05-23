"""
Batch repair Dafny files from a directory.
"""

import argparse
import json
import os
import re
import sys
from typing import Dict, List


current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)

from core.improved_fixer import ImprovedDafnyFixer


def extract_task_id(filename: str) -> str | None:
    match = re.search(r"task_id[_-](\d+)", filename)
    return match.group(1) if match else None


def find_verification_log(input_dir: str, dfy_file: str) -> str | None:
    base_name = dfy_file[:-4]
    possible_log_names = [
        f"{base_name}_verification_log.txt",
        f"{base_name}-verification_log.txt",
        f"{base_name}verification_log.txt",
        f"{base_name}.verification_log.txt",
    ]

    for log_name in possible_log_names:
        log_file = os.path.join(input_dir, log_name)
        if os.path.exists(log_file):
            return log_file

    return None


def parse_verifier_errors(log_content: str) -> List[str]:
    verifier_errors = []

    for line in log_content.splitlines():
        stripped = line.strip()
        if ": Error:" in stripped or stripped.startswith("Error:"):
            verifier_errors.append(stripped)

    if verifier_errors:
        return verifier_errors

    for line in log_content.splitlines():
        stripped = line.strip()
        if any(
            keyword in stripped.lower()
            for keyword in [
                "error:",
                "could not be proved",
                "might not hold",
                "invariant violation",
                "out of range",
                "postcondition",
            ]
        ):
            verifier_errors.append(stripped)

    if verifier_errors:
        return verifier_errors

    summary_match = re.search(
        r"(\d+)\s+verified,\s+(\d+)\s+errors?",
        log_content,
        re.IGNORECASE,
    )
    if summary_match:
        verified_count = int(summary_match.group(1))
        error_count = int(summary_match.group(2))

        if error_count == 0 and verified_count > 0:
            return []
        if error_count > 0:
            return [
                f"Error: Verification failed with {error_count} errors "
                "(see log for details)"
            ]

    return [log_content[:300] if len(log_content) > 300 else log_content]


def load_test_cases_from_directory(input_dir: str) -> List[Dict]:
    """Load test cases and verifier errors from a directory."""
    test_cases = []

    if not os.path.exists(input_dir):
        print(f"Directory does not exist: {input_dir}")
        return test_cases

    print(f"Reading from directory: {input_dir}")

    dfy_files = [f for f in os.listdir(input_dir) if f.endswith(".dfy")]
    print(f"Found {len(dfy_files)} .dfy files")

    for dfy_file in sorted(dfy_files):
        task_id = extract_task_id(dfy_file)
        if not task_id:
            print(f"Skipping file without task_id: {dfy_file}")
            continue

        dfy_path = os.path.join(input_dir, dfy_file)
        try:
            with open(dfy_path, "r", encoding="utf-8") as f:
                buggy_code = f.read()
        except Exception as e:
            print(f"Failed to read {dfy_file}: {e}")
            continue

        log_path = find_verification_log(input_dir, dfy_file)
        if not log_path:
            print(f"No verification log found for {dfy_file}")
            verifier_errors = ["Error: Unknown error (no verification log found)"]
        else:
            try:
                with open(log_path, "r", encoding="utf-8") as f:
                    log_content = f.read()
                verifier_errors = parse_verifier_errors(log_content)
            except Exception as e:
                print(f"Failed to read verification log {log_path}: {e}")
                verifier_errors = [f"Error: Failed to read verification log: {e}"]

        if not verifier_errors:
            print(f"Skipping task {task_id}: already verified")
            continue

        test_cases.append(
            {
                "task_id": task_id,
                "buggy_code": buggy_code,
                "verifier_errors": verifier_errors,
                "original_file": dfy_file,
            }
        )

        print(f"  Task {task_id}: {len(verifier_errors)} issue(s)")

    return test_cases


def save_results_summary(output_dir: str, results: List[Dict]) -> Dict:
    """Save a JSON summary for the batch run."""
    summary_file = os.path.join(output_dir, "batch_summary.json")

    summary = {
        "total_tasks": len(results),
        "successful": sum(1 for r in results if r.get("final_success")),
        "failed": sum(1 for r in results if not r.get("final_success")),
        "results": [
            {
                "task_id": r.get("task_id"),
                "success": r.get("final_success"),
                "iterations": r.get("total_iterations"),
                "final_error_count": r.get("final_error_count"),
            }
            for r in results
        ],
    }

    with open(summary_file, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)

    print(f"\nSaved result summary: {summary_file}")
    return summary


def batch_fix_from_directory(
    input_dir: str,
    api_key: str,
    base_url: str,
    output_base_dir: str = "./bench_test_fixed",
    max_iterations: int = 5,
    case_db_dir: str = "./chroma_db",
    error_db_dir: str = "./chroma_db_error",
    grammar_db_dir: str = "./chroma_db_grammar",
    model: str = "gpt-4",
) -> List[Dict]:
    """Batch repair Dafny files from a directory."""
    print("=" * 70)
    print("Batch Dafny repair")
    print(f"Input directory: {input_dir}")
    print(f"Output directory: {output_base_dir}")
    print("=" * 70)

    test_cases = load_test_cases_from_directory(input_dir)
    if not test_cases:
        print("\nNo valid test cases found")
        return []

    print(f"\nLoaded {len(test_cases)} test case(s)")
    os.makedirs(output_base_dir, exist_ok=True)

    all_results = []

    fixer = ImprovedDafnyFixer(
        api_key=api_key,
        base_url=base_url,
        output_dir=output_base_dir,
        clean_output=False,
        model=model,
    )

    print("\n" + "=" * 70)
    print("Loading knowledge bases")
    print("=" * 70)
    try:
        fixer.load_all_vectorstores(
            case_db_dir=case_db_dir,
            case_db_name="dafny_error_cases",
            error_db_dir=error_db_dir,
            error_db_name="error_documents",
            grammar_db_dir=grammar_db_dir,
            grammar_db_name="grammar_documents",
        )
    except Exception as e:
        print(f"Warning: failed to load knowledge bases: {e}")
        print("Continuing without loaded knowledge bases may reduce repair quality.")

    for idx, test_case in enumerate(test_cases, 1):
        task_id = test_case["task_id"]

        print("\n" + "=" * 70)
        print(f"Task {idx}/{len(test_cases)}: Task {task_id}")
        print("=" * 70)

        task_output_dir = os.path.join(
            output_base_dir,
            f"task_id_{task_id}-gpt-4.1-nano-temp_0.5-k_1",
        )

        fixer.output_dir = task_output_dir
        os.makedirs(task_output_dir, exist_ok=True)

        try:
            result = fixer.iterative_fix_pipeline(
                buggy_code=test_case["buggy_code"],
                verifier_errors=test_case["verifier_errors"],
                task_id=task_id,
                max_iterations=max_iterations,
            )

            all_results.append(result)

            status = "success" if result.get("final_success") else "failed"
            print(
                f"\n{status} | Task {task_id} | "
                f"Iterations: {result.get('total_iterations')}/{max_iterations}"
            )

        except Exception as e:
            print(f"\nTask {task_id} failed during processing: {e}")
            import traceback

            traceback.print_exc()

            all_results.append(
                {
                    "task_id": task_id,
                    "final_success": False,
                    "total_iterations": 0,
                    "final_error_count": -1,
                    "error": str(e),
                }
            )

    summary = save_results_summary(output_base_dir, all_results)

    print("\n" + "=" * 70)
    print("Batch processing complete")
    print("=" * 70)

    total_tasks = summary["total_tasks"]
    success_rate = summary["successful"] / total_tasks * 100 if total_tasks else 0.0
    failed_rate = summary["failed"] / total_tasks * 100 if total_tasks else 0.0

    print(f"\nTotal tasks: {total_tasks}")
    print(f"Successful: {summary['successful']} ({success_rate:.1f}%)")
    print(f"Failed: {summary['failed']} ({failed_rate:.1f}%)")
    print(f"\nAll results saved to: {output_base_dir}/")

    return all_results


def parse_args():
    parser = argparse.ArgumentParser(description="Batch repair Dafny files from a directory.")
    parser.add_argument("--input-dir", required=True, help="Directory containing .dfy files.")
    parser.add_argument(
        "--out-dir",
        default=os.path.join(current_dir, "bench_test_fixed"),
        help="Output directory.",
    )
    parser.add_argument(
        "--max-iters",
        type=int,
        default=5,
        help="Maximum repair iterations per task.",
    )
    parser.add_argument(
        "--llm",
        default=os.getenv("OPENAI_MODEL", "gpt-4"),
        help="Model identifier.",
    )
    parser.add_argument(
        "--base-url",
        default=os.getenv("OPENAI_BASE_URL", "https://api.openai.com/v1"),
        help="OpenAI-compatible API base URL.",
    )
    parser.add_argument(
        "--case-db-dir",
        default=os.path.join(current_dir, "chroma_db"),
        help="Case vector database directory.",
    )
    parser.add_argument(
        "--error-db-dir",
        default=os.path.join(current_dir, "chroma_db_error"),
        help="Error vector database directory.",
    )
    parser.add_argument(
        "--grammar-db-dir",
        default=os.path.join(current_dir, "chroma_db_grammar"),
        help="Grammar vector database directory.",
    )
    return parser.parse_args()


def main():
    args = parse_args()

    print("=" * 70)
    print("Dafny Batch Repair Tool")
    print("=" * 70)

    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        print("Missing API key. Set OPENAI_API_KEY before running this script.")
        return

    input_dir = args.input_dir
    output_base_dir = args.out_dir

    print(f"\nInput directory: {input_dir}")
    print(f"Output directory: {output_base_dir}")

    if not os.path.exists(input_dir):
        print("\nError: input directory does not exist")
        print(f"   {input_dir}")
        return

    dfy_files = [f for f in os.listdir(input_dir) if f.endswith(".dfy")]
    print(f"\nFound {len(dfy_files)} .dfy files:")
    for i, file_name in enumerate(sorted(dfy_files)[:10], 1):
        print(f"  {i}. {file_name}")
    if len(dfy_files) > 10:
        print(f"  ... {len(dfy_files) - 10} more file(s)")

    print("\n" + "=" * 70)
    confirm = input("Start batch processing? (y/n, default y): ").strip().lower()
    if confirm and confirm != "y":
        print("Cancelled.")
        return

    batch_fix_from_directory(
        input_dir=input_dir,
        api_key=api_key,
        base_url=args.base_url,
        output_base_dir=output_base_dir,
        max_iterations=args.max_iters,
        case_db_dir=args.case_db_dir,
        error_db_dir=args.error_db_dir,
        grammar_db_dir=args.grammar_db_dir,
        model=args.llm,
    )

    print("\n" + "=" * 70)
    print("Processing complete")
    print("=" * 70)
    print(f"\nOutput directory: {output_base_dir}")
    print(f"Summary file: {os.path.join(output_base_dir, 'batch_summary.json')}")


if __name__ == "__main__":
    main()
