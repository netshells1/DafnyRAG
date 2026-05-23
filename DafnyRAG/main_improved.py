"""
Dafny Code Repair Tool - Main Program
"""

import os
import sys
from pathlib import Path

CURRENT_DIR = Path(__file__).resolve().parent
if str(CURRENT_DIR) not in sys.path:
    sys.path.insert(0, str(CURRENT_DIR))

from core.improved_fixer import ImprovedDafnyFixer


def main():
    """Main function"""
    
    print("=" * 70)
    print("Dafny Code Repair Tool")
    print("=" * 70)
    
    # ========== Configuration ==========
    API_KEY = os.getenv("OPENAI_API_KEY")
    BASE_URL = os.getenv("OPENAI_BASE_URL", "https://api.openai.com/v1")
    MODEL = os.getenv("OPENAI_MODEL", "gpt-4")

    if not API_KEY:
        print("Missing API key. Set OPENAI_API_KEY before running this script.")
        return
    
    # Vector store configuration
    CASE_DB_DIR = str(CURRENT_DIR / "chroma_db")
    CASE_DB_NAME = "dafny_error_cases"
    
    ERROR_DB_DIR = str(CURRENT_DIR / "chroma_db_error")
    ERROR_DB_NAME = "error_documents"
    
    GRAMMAR_DB_DIR = str(CURRENT_DIR / "chroma_db_grammar")
    GRAMMAR_DB_NAME = "grammar_documents"
    
    OUTPUT_DIR = str(CURRENT_DIR / "output_fixed_improved")
    MAX_ITERATIONS = 5
    CLEAN_OUTPUT = True
    # ====================================
    
    # Initialize fixer
    fixer = ImprovedDafnyFixer(
        api_key=API_KEY,
        base_url=BASE_URL,
        output_dir=OUTPUT_DIR,
        clean_output=CLEAN_OUTPUT,
        model=MODEL,
    )
    
    # Load knowledge bases
    try:
        fixer.load_all_vectorstores(
            case_db_dir=CASE_DB_DIR,
            case_db_name=CASE_DB_NAME,
            error_db_dir=ERROR_DB_DIR,
            error_db_name=ERROR_DB_NAME,
            grammar_db_dir=GRAMMAR_DB_DIR,
            grammar_db_name=GRAMMAR_DB_NAME,
        )
    except Exception as e:
        print(f"Failed to load knowledge bases: {e}")
        print("Please ensure the knowledge base directories exist and contain valid data.")
        return
    
    # ========== Test Cases ==========
    # Case 1: Simple unresolved identifier error
    test_case_1 = {
        "task_id": "82",
        "buggy_code": """
method SphereVolume(radius: real) returns (volume: real)
    requires radius > 0.0
    ensures volume == (4.0 / 3.0) * Pi * radius * radius * radius
{
    volume := (4.0 / 3.0) * Pi * radius * radius * radius;
}
        """,
        "verifier_errors": [
            "Error: unresolved identifier: Pi",
        ],
    }
    
    # Case 2: Complex loop invariant error
    test_case_2 = {
        "task_id": "loop_test",
        "buggy_code": """
method Sum(n: int) returns (sum: int)
    requires n >= 0
    ensures sum == n * (n + 1) / 2
{
    sum := 0;
    var i := 0;
    while i < n
    {
        i := i + 1;
        sum := sum + i;
    }
}
        """,
        "verifier_errors": [
            "Error: A postcondition might not hold on this return path.",
            "Error: Loop invariant might not be maintained by the loop.",
        ],
    }
    
    # Select test case
    print("\n" + "=" * 70)
    print("Select a Test Case:")
    print("  1. Simple case (unresolved identifier)")
    print("  2. Complex case (loop invariant)")
    print("=" * 70)
    
    choice = input("\nEnter your choice (1/2, default: 1): ").strip()
    
    if choice == "2":
        test_case = test_case_2
        print("\nSelected Case 2: Loop Invariant Error")
    else:
        test_case = test_case_1
        print("\nSelected Case 1: Unresolved Identifier")
    
    buggy_code = test_case["buggy_code"]
    verifier_errors = test_case["verifier_errors"]
    task_id = test_case["task_id"]
    
    # Display input
    print("\n" + "=" * 70)
    print("Input Information")
    print("=" * 70)
    print(f"\nTask ID: {task_id}")
    print("\nBuggy Code:")
    print(buggy_code)
    print("\nVerifier Errors:")
    for i, err in enumerate(verifier_errors, 1):
        print(f"  {i}. {err}")
    
    # Run repair pipeline
    result = fixer.iterative_fix_pipeline(
        buggy_code=buggy_code,
        verifier_errors=verifier_errors,
        task_id=task_id,
        max_iterations=MAX_ITERATIONS,
    )
    
    # Display final result
    print("\n" + "=" * 70)
    print("Final Result")
    print("=" * 70)
    
    print(f"\nTask ID: {result['task_id']}")
    print(f"Total Iterations: {result['total_iterations']}/{result['max_iterations']}")
    print(f"Repair Status: {'Success' if result['final_success'] else 'Failed'}")
    print(f"Remaining Errors: {result['final_error_count']}")
    
    # Display code analysis
    if 'code_analysis' in result:
        analysis = result['code_analysis']
        print(f"\nCode Analysis:")
        print(f"  - Difficulty: {analysis.get('difficulty', 'N/A')}")
        print(f"  - Intent: {analysis.get('intent', 'N/A')[:100]}...")
    
    # Display iteration history
    print("\n" + "=" * 70)
    print("Iteration History")
    print("=" * 70)
    
    for record in result['fix_history']:
        status = "Success" if record['success'] else f"Failed ({record['error_count']} errors)"
        print(f"\nIteration {record['iteration']}: {status}")
        print(f"  File: {record['dfy_file_path']}")
        print(f"  Log:  {record['verification_log_path']}")
        
        if record.get('key_changes'):
            print(f"  Changes: {', '.join(record['key_changes'][:2])}...")
        
        if record['iteration'] == 1:
            if record.get('understanding'):
                print(f"  Understanding: {record['understanding'][:80]}...")
        else:
            if record.get('reflection'):
                print(f"  Reflection: {record['reflection'][:80]}...")
    
    # Display final code
    if result['final_success']:
        print("\n" + "=" * 70)
        print("Successfully Repaired Code")
        print("=" * 70)
        print(result['final_code'])
    else:
        print("\n" + "=" * 70)
        print("Repair Failed")
        print("=" * 70)
        print("Suggestions:")
        print("  1. Check whether the knowledge base contains relevant cases")
        print("  2. Try increasing the maximum number of iterations")
        print("  3. Verify that error types are correctly classified")
        print("  4. Review the detailed verification logs for specifics")


if __name__ == "__main__":
    main()
