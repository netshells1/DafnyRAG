"""
改进版 Dafny 代码修复工具 - 主程序
"""

import sys
sys.path.append('/home/claude/dafny_fixer_improved')

from core.improved_fixer import ImprovedDafnyFixer


def main():
    """主函数"""
    
    print("=" * 70)
    print("改进版 Dafny 代码修复工具")
    print("主要改进:")
    print("  ✓ 细化错误分类 (10+ 种错误类型)")
    print("  ✓ 智能多查询检索")
    print("  ✓ 代码理解 + 推理步骤")
    print("  ✓ 带反思的迭代修复")
    print("  ✓ 增强的 Prompt 设计")
    print("=" * 70)
    
    # ========== 配置 ==========
    API_KEY = "sk-3mKCbVHEJAOiU1cW72yhmqcYKG9FIWPoIqIA00ImxZ2vwI9b"
    BASE_URL = "https://turingai.plus/v1"
    
    # 知识库配置
    CASE_DB_DIR = "./chroma_db"
    CASE_DB_NAME = "dafny_error_cases"
    
    ERROR_DB_DIR = "./chroma_db_error"
    ERROR_DB_NAME = "error_documents"
    
    GRAMMAR_DB_DIR = "./chroma_db_grammar"
    GRAMMAR_DB_NAME = "grammar_documents"
    
    OUTPUT_DIR = "./output_fixed_improved"
    MAX_ITERATIONS = 5
    CLEAN_OUTPUT = True
    # ==========================
    
    # 初始化修复器
    fixer = ImprovedDafnyFixer(
        api_key=API_KEY,
        base_url=BASE_URL,
        output_dir=OUTPUT_DIR,
        clean_output=CLEAN_OUTPUT
    )
    
    # 加载知识库
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
        print(f"✗ 加载知识库失败: {e}")
        print("请确保知识库目录存在且包含正确的数据")
        return
    
    # ========== 测试案例 ==========
    # 案例1: 简单的未定义标识符错误
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
    
    # 案例2: 复杂的循环不变量错误
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
    
    # 选择测试案例
    print("\n" + "=" * 70)
    print("选择测试案例:")
    print("  1. 简单案例 (未定义标识符)")
    print("  2. 复杂案例 (循环不变量)")
    print("=" * 70)
    
    choice = input("\n请输入选择 (1/2，默认1): ").strip()
    
    if choice == "2":
        test_case = test_case_2
        print("\n✓ 选择了案例2: 循环不变量错误")
    else:
        test_case = test_case_1
        print("\n✓ 选择了案例1: 未定义标识符")
    
    buggy_code = test_case["buggy_code"]
    verifier_errors = test_case["verifier_errors"]
    task_id = test_case["task_id"]
    
    # 显示输入
    print("\n" + "=" * 70)
    print("输入信息")
    print("=" * 70)
    print(f"\n任务ID: {task_id}")
    print("\n错误代码:")
    print(buggy_code)
    print("\n验证器报错:")
    for i, err in enumerate(verifier_errors, 1):
        print(f"  {i}. {err}")
    
    # 执行修复
    result = fixer.iterative_fix_pipeline(
        buggy_code=buggy_code,
        verifier_errors=verifier_errors,
        task_id=task_id,
        max_iterations=MAX_ITERATIONS,
    )
    
    # 显示最终结果
    print("\n" + "=" * 70)
    print("最终结果")
    print("=" * 70)
    
    print(f"\n任务ID: {result['task_id']}")
    print(f"总迭代次数: {result['total_iterations']}/{result['max_iterations']}")
    print(f"修复状态: {'✓ 成功' if result['final_success'] else '✗ 失败'}")
    print(f"最终错误数: {result['final_error_count']}")
    
    # 显示代码分析
    if 'code_analysis' in result:
        analysis = result['code_analysis']
        print(f"\n代码分析:")
        print(f"  - 难度: {analysis.get('difficulty', 'N/A')}")
        print(f"  - 意图: {analysis.get('intent', 'N/A')[:100]}...")
    
    # 显示迭代历史
    print("\n" + "=" * 70)
    print("迭代历史")
    print("=" * 70)
    
    for record in result['fix_history']:
        status = "✓ 成功" if record['success'] else f"✗ 失败 ({record['error_count']} 个错误)"
        print(f"\n第 {record['iteration']} 次尝试: {status}")
        print(f"  文件: {record['dfy_file_path']}")
        print(f"  日志: {record['verification_log_path']}")
        
        if record.get('key_changes'):
            print(f"  改动: {', '.join(record['key_changes'][:2])}...")
        
        if record['iteration'] == 1:
            if record.get('understanding'):
                print(f"  理解: {record['understanding'][:80]}...")
        else:
            if record.get('reflection'):
                print(f"  反思: {record['reflection'][:80]}...")
    
    # 显示最终代码
    if result['final_success']:
        print("\n" + "=" * 70)
        print("✓ 修复成功的代码")
        print("=" * 70)
        print(result['final_code'])
    else:
        print("\n" + "=" * 70)
        print("✗ 修复失败")
        print("=" * 70)
        print("建议:")
        print("  1. 检查知识库是否包含相关案例")
        print("  2. 尝试增加最大迭代次数")
        print("  3. 手动检查错误类型是否正确分类")
        print("  4. 查看详细的验证日志了解具体问题")


if __name__ == "__main__":
    main()