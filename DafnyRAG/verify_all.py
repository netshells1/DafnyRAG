"""
Verify repaired Dafny files with the Dafny verifier.
"""

import argparse
import re
import subprocess
from pathlib import Path
from typing import Optional, Tuple


def run_dafny_verify(dfy_file: Path, timeout: int = 30) -> Tuple[bool, str]:
    """
    Run the Dafny verifier.

    Returns:
        (success, output)
    """
    try:
        result = subprocess.run(
            ["dafny", "verify", str(dfy_file)],
            capture_output=True,
            text=True,
            timeout=timeout,
        )

        output = result.stdout + result.stderr

        verified_match = re.search(
            r"(\d+)\s+verified,\s+0\s+errors?",
            output,
            re.IGNORECASE,
        )
        if verified_match:
            verified_count = int(verified_match.group(1))
            if verified_count > 0:
                return (True, output)

        error_match = re.search(
            r"(\d+)\s+verified,\s+(\d+)\s+errors?",
            output,
            re.IGNORECASE,
        )
        if error_match:
            error_count = int(error_match.group(2))
            if error_count > 0:
                return (False, output)

        if "parse error" in output.lower():
            return (False, output)

        return (False, output)

    except subprocess.TimeoutExpired:
        return (False, f"Timeout (>{timeout}s)")
    except FileNotFoundError:
        return (False, "Dafny not found")
    except Exception as e:
        return (False, f"Error: {e}")


def find_latest_dfy_file(task_dir: Path) -> Optional[Path]:
    """Find the .dfy file from the latest repair iteration."""
    dfy_files = list(task_dir.glob("*.dfy"))

    if not dfy_files:
        return None

    max_iter = -1
    latest_file = None

    for dfy_file in dfy_files:
        iter_match = re.search(r"iter[_-]?(\d+)", dfy_file.name)
        if iter_match:
            iter_num = int(iter_match.group(1))
            if iter_num > max_iter:
                max_iter = iter_num
                latest_file = dfy_file

    if latest_file is None and dfy_files:
        latest_file = dfy_files[0]

    return latest_file


def percent(count: int, total: int) -> float:
    """Return a percentage, avoiding division by zero."""
    return count / total * 100 if total else 0.0


def verify_all_tasks(base_dir: str):
    """Verify all repaired task directories."""
    base_path = Path(base_dir)

    if not base_path.exists():
        print(f"Directory does not exist: {base_dir}")
        return

    print("=" * 70)
    print("Verifying repaired Dafny files")
    print(f"Directory: {base_dir}")
    print("=" * 70)

    task_dirs = [
        d for d in base_path.iterdir()
        if d.is_dir() and d.name.endswith("_fixed")
    ]

    print(f"\nFound {len(task_dirs)} task directories\n")

    successful_tasks = []
    failed_tasks = []
    timeout_tasks = []

    for idx, task_dir in enumerate(sorted(task_dirs), 1):
        match = re.search(r"task_id_(\d+)", task_dir.name)
        if not match:
            print(f"[{idx}/{len(task_dirs)}] Skipping {task_dir.name}: cannot extract task_id")
            continue

        task_id = match.group(1)
        dfy_file = find_latest_dfy_file(task_dir)

        if not dfy_file:
            print(f"[{idx}/{len(task_dirs)}] Task {task_id}: no .dfy file found")
            failed_tasks.append((task_id, "no dfy file", ""))
            continue

        print(f"[{idx}/{len(task_dirs)}] Verifying Task {task_id} ({dfy_file.name})...", end=" ")

        success, output = run_dafny_verify(dfy_file)

        if "Timeout" in output:
            print("timeout")
            timeout_tasks.append((task_id, dfy_file.name))
        elif success:
            verified_match = re.search(r"(\d+)\s+verified", output)
            verified_count = verified_match.group(1) if verified_match else "?"
            print(f"success ({verified_count} verified)")
            successful_tasks.append((task_id, dfy_file.name, output))
        else:
            error_match = re.search(r"(\d+)\s+errors?", output)
            if error_match:
                error_count = error_match.group(1)
                print(f"failed ({error_count} errors)")
            else:
                print("failed")
            failed_tasks.append((task_id, dfy_file.name, output))

    print("\n" + "=" * 70)
    print("Verification Summary")
    print("=" * 70)

    total = len(successful_tasks) + len(failed_tasks) + len(timeout_tasks)

    print(f"\nTotal tasks: {total}")
    print(f"Passed: {len(successful_tasks)} ({percent(len(successful_tasks), total):.1f}%)")
    print(f"Failed: {len(failed_tasks)} ({percent(len(failed_tasks), total):.1f}%)")
    print(f"Timed out: {len(timeout_tasks)} ({percent(len(timeout_tasks), total):.1f}%)")

    if successful_tasks:
        print(f"\nPassed tasks ({len(successful_tasks)}):")
        success_ids = sorted([t[0] for t in successful_tasks], key=lambda x: int(x))
        for i in range(0, len(success_ids), 10):
            print(f"  {success_ids[i:i + 10]}")

    if failed_tasks:
        print(f"\nFailed tasks ({len(failed_tasks)}):")
        failed_ids = sorted([t[0] for t in failed_tasks], key=lambda x: int(x))
        for i in range(0, len(failed_ids), 10):
            print(f"  {failed_ids[i:i + 10]}")

    if timeout_tasks:
        print(f"\nTimed-out tasks ({len(timeout_tasks)}):")
        timeout_ids = sorted([t[0] for t in timeout_tasks], key=lambda x: int(x))
        for i in range(0, len(timeout_ids), 10):
            print(f"  {timeout_ids[i:i + 10]}")

    output_file = base_path / "verification_results.txt"
    with open(output_file, "w", encoding="utf-8") as f:
        f.write("=" * 70 + "\n")
        f.write("Dafny Verification Results\n")
        f.write("=" * 70 + "\n\n")

        f.write(f"Total tasks: {total}\n")
        f.write(f"Passed: {len(successful_tasks)} ({percent(len(successful_tasks), total):.1f}%)\n")
        f.write(f"Failed: {len(failed_tasks)} ({percent(len(failed_tasks), total):.1f}%)\n")
        f.write(f"Timed out: {len(timeout_tasks)} ({percent(len(timeout_tasks), total):.1f}%)\n\n")

        f.write("=" * 70 + "\n")
        f.write("Passed Tasks\n")
        f.write("=" * 70 + "\n\n")
        for task_id, dfy_file, output in sorted(successful_tasks, key=lambda x: int(x[0])):
            f.write(f"Task {task_id} ({dfy_file}):\n")
            for line in output.split("\n"):
                if "verified" in line.lower() or "error" in line.lower():
                    f.write(f"  {line}\n")
            f.write("\n")

        f.write("=" * 70 + "\n")
        f.write("Failed Tasks\n")
        f.write("=" * 70 + "\n\n")
        for task_id, dfy_file, output in sorted(failed_tasks, key=lambda x: int(x[0])):
            f.write(f"Task {task_id} ({dfy_file}):\n")
            error_count = 0
            for line in output.split("\n"):
                if "Error:" in line or "error" in line.lower():
                    f.write(f"  {line}\n")
                    error_count += 1
                    if error_count >= 5:
                        break
            f.write("\n")

        if timeout_tasks:
            f.write("=" * 70 + "\n")
            f.write("Timed-Out Tasks\n")
            f.write("=" * 70 + "\n\n")
            for task_id, dfy_file in sorted(timeout_tasks, key=lambda x: int(x[0])):
                f.write(f"Task {task_id} ({dfy_file})\n")

    print(f"\nDetailed results saved to: {output_file}")


def parse_args():
    parser = argparse.ArgumentParser(description="Verify repaired Dafny task directories.")
    parser.add_argument(
        "--base-dir",
        default=str(Path(__file__).resolve().parent / "fixed_k1_cases"),
        help="Directory containing repaired task folders.",
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    verify_all_tasks(args.base_dir)
