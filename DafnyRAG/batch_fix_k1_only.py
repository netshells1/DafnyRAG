"""
Batch repair only the failed k=1 Dafny cases.
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


FAILED_TASKS = [
    "105", "11", "113", "116", "119", "126", "131", "133", "139", "142",
    "161", "166", "167", "170", "19", "2", "233", "235", "239", "256",
    "261", "270", "281", "282", "283", "284", "287", "290", "291", "305",
    "308", "312", "388", "389", "394", "395", "399", "401", "412", "415",
    "420", "426", "428", "432", "436", "437", "439", "443", "445", "450",
    "451", "457", "470", "476", "479", "554", "557", "559", "56", "564",
    "57", "572", "581", "587", "589", "598", "603", "604", "606", "61",
    "618", "619", "622", "626", "628", "639", "66", "67", "68", "7", "70",
    "72", "728", "747", "748", "751", "759", "763", "769", "772", "776",
    "777", "799", "8", "80", "806", "82", "85", "89", "9", "93", "96",
]


def extract_task_id(filename: str) -> str | None:
    match = re.search(r"task_id[_-](\d+)", filename)
    return match.group(1) if match else None


def find_verification_log(input_dir: str, dfy_file: str) -> str | None:
    base_name = dfy_file[:-4]
    possible_names = [
        f"{base_name}_verification_log.txt",
        f"{base_name}-verification_log.txt",
        f"{base_name}verification_log.txt",
        f"{base_name}.verification_log.txt",
    ]

    for name in possible_names:
        path = os.path.join(input_dir, name)
        if os.path.exists(path):
            return path

    return None


def parse_verifier_errors(log_content: str) -> List[str]:
    errors = []
    for line in log_content.splitlines():
        stripped = line.strip()
        if ": Error:" in stripped or stripped.startswith("Error:"):
            errors.append(stripped)

    if not errors:
        for line in log_content.splitlines():
            stripped = line.strip()
            if any(
                keyword in stripped.lower()
                for keyword in [
                    "error:",
                    "warning:",
                    "could not be proved",
                    "might not hold",
                    "invariant violation",
                    "out of range",
                    "postcondition",
                ]
            ):
                errors.append(stripped)

    if not errors:
        summary_match = re.search(
            r"(\d+)\s+verified,\s+(\d+)\s+errors?",
            log_content,
            re.IGNORECASE,
        )
        if summary_match and int(summary_match.group(2)) > 0:
            errors.append(
                f"Error: Verification failed with {summary_match.group(2)} errors"
            )

    return errors


def load_test_cases_from_directory(input_dir: str, output_base_dir: str) -> List[Dict]:
    test_cases = []

    if not os.path.exists(input_dir):
        print(f"Input directory does not exist: {input_dir}")
        return test_cases

    dfy_files = [f for f in os.listdir(input_dir) if f.endswith(".dfy")]
    print(f"Found {len(dfy_files)} .dfy files")

    for dfy_file in sorted(dfy_files):
        task_id = extract_task_id(dfy_file)
        if not task_id or task_id not in FAILED_TASKS:
            continue

        if "_k_1" not in dfy_file and "-k_1" not in dfy_file:
            continue

        output_dir_name = f"task_id_{task_id}_k_1_fixed"
        output_path = os.path.join(output_base_dir, output_dir_name)
        if os.path.exists(output_path):
            print(f"Skipping task {task_id}: output already exists")
            continue

        dfy_path = os.path.join(input_dir, dfy_file)
        try:
            with open(dfy_path, "r", encoding="utf-8") as f:
                buggy_code = f.read()
        except Exception as e:
            print(f"Failed to read {dfy_file}: {e}")
            continue

        log_path = find_verification_log(input_dir, dfy_file)
        if log_path:
            try:
                with open(log_path, "r", encoding="utf-8") as f:
                    verifier_errors = parse_verifier_errors(f.read())
            except Exception as e:
                verifier_errors = [f"Error: Failed to read verification log: {e}"]
        else:
            verifier_errors = ["Error: Unknown error (no verification log found)"]

        if not verifier_errors:
            print(f"Skipping task {task_id}: no verifier errors found")
            continue

        test_cases.append(
            {
                "task_id": task_id,
                "buggy_code": buggy_code,
                "verifier_errors": verifier_errors,
                "original_file": dfy_file,
            }
        )
        print(f"Task {task_id} (k_1): {len(verifier_errors)} issue(s)")

    return test_cases


def save_results_summary(output_dir: str, results: List[Dict]) -> Dict:
    summary_file = os.path.join(output_dir, "batch_summary_k1.json")
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
    output_base_dir: str = "./fixed_k1_cases",
    max_iterations: int = 5,
    case_db_dir: str = "./chroma_db",
    error_db_dir: str = "./chroma_db_error",
    grammar_db_dir: str = "./chroma_db_grammar",
    model: str = "gpt-4",
):
    print("=" * 70)
    print("Batch Dafny repair for failed k_1 cases")
    print(f"Input directory: {input_dir}")
    print(f"Output directory: {output_base_dir}")
    print("=" * 70)

    test_cases = load_test_cases_from_directory(input_dir, output_base_dir)
    if not test_cases:
        print("\nNo valid failed k_1 cases found")
        return [], {
            "total_failed_tasks": len(FAILED_TASKS),
            "total_attempted": 0,
            "total_success": 0,
            "total_failed": 0,
            "success_rate": 0.0,
            "all_task_results": [],
        }

    os.makedirs(output_base_dir, exist_ok=True)

    fixer = ImprovedDafnyFixer(
        api_key=api_key,
        base_url=base_url,
        output_dir=output_base_dir,
        clean_output=False,
        model=model,
    )

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

    all_results = []
    for idx, test_case in enumerate(test_cases, 1):
        task_id = test_case["task_id"]
        print("\n" + "=" * 70)
        print(f"Task {idx}/{len(test_cases)}: task_id_{task_id}_k_1")
        print("=" * 70)

        task_output_dir = os.path.join(output_base_dir, f"task_id_{task_id}_k_1_fixed")
        os.makedirs(task_output_dir, exist_ok=True)
        fixer.output_dir = task_output_dir

        try:
            result = fixer.iterative_fix_pipeline(
                buggy_code=test_case["buggy_code"],
                verifier_errors=test_case["verifier_errors"],
                task_id=task_id,
                max_iterations=max_iterations,
            )
        except Exception as e:
            result = {
                "task_id": task_id,
                "final_success": False,
                "total_iterations": 0,
                "final_error_count": -1,
                "error": str(e),
            }

        all_results.append(result)
        status = "success" if result.get("final_success") else "failed"
        print(f"Task {task_id}: {status}")

    summary = save_results_summary(output_base_dir, all_results)
    total_attempted = len(all_results)
    total_success = summary["successful"]
    total_failed = summary["failed"]

    return all_results, {
        "total_failed_tasks": len(FAILED_TASKS),
        "total_attempted": total_attempted,
        "total_success": total_success,
        "total_failed": total_failed,
        "success_rate": total_success / total_attempted * 100 if total_attempted else 0.0,
        "all_task_results": all_results,
    }


def parse_args():
    parser = argparse.ArgumentParser(description="Batch repair failed k=1 Dafny cases.")
    parser.add_argument("--input-dir", required=True, help="Directory containing k=1 .dfy files.")
    parser.add_argument(
        "--out-dir",
        default=os.path.join(current_dir, "fixed_k1_cases"),
        help="Output directory.",
    )
    parser.add_argument("--max-iters", type=int, default=5, help="Maximum repair iterations per task.")
    parser.add_argument("--llm", default=os.getenv("OPENAI_MODEL", "gpt-4"), help="Model identifier.")
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
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        print("Missing API key. Set OPENAI_API_KEY before running this script.")
        return

    results, stats = batch_fix_from_directory(
        input_dir=args.input_dir,
        api_key=api_key,
        base_url=args.base_url,
        output_base_dir=args.out_dir,
        max_iterations=args.max_iters,
        case_db_dir=args.case_db_dir,
        error_db_dir=args.error_db_dir,
        grammar_db_dir=args.grammar_db_dir,
        model=args.llm,
    )

    print("\n" + "=" * 70)
    print("Batch processing complete")
    print("=" * 70)
    print(f"Attempted: {stats['total_attempted']}")
    print(f"Successful: {stats['total_success']}")
    print(f"Failed: {stats['total_failed']}")
    print(f"Output directory: {args.out_dir}")


if __name__ == "__main__":
    main()
