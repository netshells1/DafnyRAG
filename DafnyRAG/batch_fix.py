"""
批量处理 Dafny 代码修复工具 - 从目录读取版本
从指定目录读取 .dfy 文件和对应的验证日志
"""

import sys
import os
import json
import re
from typing import List, Dict

# 添加项目根目录到路径
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)

from core.improved_fixer import ImprovedDafnyFixer


def load_test_cases_from_directory(input_dir: str) -> List[Dict]:
    """
    从目录读取测试案例
    
    目录结构:
    xiaorong-N/
    ├── task_id_18-gpt-4.1-nano-temp_0.5-k_1.dfy
    ├── task_id_18-gpt-4.1-nano-temp_0.5-k_1_verification_log.txt
    ├── task_id_61-gpt-4.1-nano-temp_0.5-k_1.dfy
    └── task_id_61-gpt-4.1-nano-temp_0.5-k_1_verification_log.txt
    """
    test_cases = []
    
    if not os.path.exists(input_dir):
        print(f"✗ 目录不存在: {input_dir}")
        return test_cases
    
    print(f"✓ 从目录读取: {input_dir}")
    
    # 查找所有 .dfy 文件
    dfy_files = [f for f in os.listdir(input_dir) if f.endswith('.dfy')]
    
    print(f"✓ 找到 {len(dfy_files)} 个 .dfy 文件")
    
    for dfy_file in sorted(dfy_files):
        # 提取 task_id
        match = re.search(r'task_id[_-](\d+)', dfy_file)
        if not match:
            print(f"⚠️  跳过文件 (无法提取task_id): {dfy_file}")
            continue
        
        task_id = match.group(1)
        
        # 读取 .dfy 文件
        dfy_path = os.path.join(input_dir, dfy_file)
        try:
            with open(dfy_path, 'r', encoding='utf-8') as f:
                buggy_code = f.read()
        except Exception as e:
            print(f"✗ 读取失败 {dfy_file}: {e}")
            continue
        
        # 查找对应的验证日志文件
        # 可能的格式: task_id_XX-..._verification_log.txt 或 task_id_XX-...verification_log.txt
        base_name = dfy_file[:-4]  # 去掉 .dfy
        
        possible_log_names = [
            f"{base_name}_verification_log.txt",
            f"{base_name}-verification_log.txt",
            f"{base_name}verification_log.txt",
            f"{base_name}.verification_log.txt"
        ]
        
        log_path = None
        for log_name in possible_log_names:
            log_file = os.path.join(input_dir, log_name)
            if os.path.exists(log_file):
                log_path = log_file
                break
        
        if not log_path:
            print(f"⚠️  未找到验证日志: {base_name}_verification_log.txt")
            # 如果没有日志,假设有语法错误
            verifier_errors = ["Error: Unknown error (no verification log found)"]
        else:
            # 读取验证日志并提取错误
            try:
                with open(log_path, 'r', encoding='utf-8') as f:
                    log_content = f.read()
                
                # 提取错误信息 - 支持多种格式
                verifier_errors = []
                
                # 方法1: 提取包含 "Error:" 的行 (不要求在行首)
                for line in log_content.split('\n'):
                    line = line.strip()
                    if ': Error:' in line or line.startswith('Error:'):
                        verifier_errors.append(line)
                
                # 方法2: 如果没找到,尝试提取 "Related message" 和其他错误信息
                if not verifier_errors:
                    for line in log_content.split('\n'):
                        line = line.strip()
                        if any(keyword in line.lower() for keyword in [
                            'error:', 'could not be proved', 'might not hold',
                            'invariant violation', 'out of range', 'postcondition'
                        ]):
                            verifier_errors.append(line)
                
                # 检查是否已通过验证
                if not verifier_errors:
                    # 检查汇总行: "X verified, Y errors"
                    summary_match = re.search(r'(\d+)\s+verified,\s+(\d+)\s+errors?', log_content, re.IGNORECASE)
                    if summary_match:
                        verified_count = int(summary_match.group(1))
                        error_count = int(summary_match.group(2))
                        
                        if error_count == 0 and verified_count > 0:
                            # 已经通过验证,跳过
                            print(f"⚠️  跳过 task_{task_id} (已通过验证: {verified_count} verified, 0 errors)")
                            continue
                        elif error_count > 0:
                            # 有错误但没有提取到具体错误信息
                            verifier_errors = [f"Error: Verification failed with {error_count} errors (see log for details)"]
                    else:
                        # 无法判断,包含日志的前几行
                        verifier_errors = [log_content[:300] if len(log_content) > 300 else log_content]
                
            except Exception as e:
                print(f"✗ 读取日志失败 {log_path}: {e}")
                verifier_errors = [f"Error: Failed to read verification log: {e}"]
        
        test_cases.append({
            'task_id': task_id,
            'buggy_code': buggy_code,
            'verifier_errors': verifier_errors,
            'original_file': dfy_file
        })
        
        print(f"  ✓ Task {task_id}: {len(verifier_errors)} 个错误")
    
    return test_cases


def save_results_summary(output_dir: str, results: List[Dict]):
    """保存结果汇总"""
    summary_file = os.path.join(output_dir, "batch_summary.json")
    
    summary = {
        "total_tasks": len(results),
        "successful": sum(1 for r in results if r['final_success']),
        "failed": sum(1 for r in results if not r['final_success']),
        "results": [
            {
                "task_id": r['task_id'],
                "success": r['final_success'],
                "iterations": r['total_iterations'],
                "final_error_count": r['final_error_count']
            }
            for r in results
        ]
    }
    
    with open(summary_file, 'w', encoding='utf-8') as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
    
    print(f"\n✓ 结果汇总已保存: {summary_file}")
    return summary


def batch_fix_from_directory(
    input_dir: str,
    api_key: str,
    base_url: str,
    output_base_dir: str = "./bench_test_fixed",
    max_iterations: int = 5,
    case_db_dir: str = "./chroma_db",
    error_db_dir: str = "./chroma_db_error",
    grammar_db_dir: str = "./chroma_db_grammar"
):
    """
    从目录批量修复 Dafny 代码
    """
    print("=" * 70)
    print(f"批量处理 Dafny 代码修复")
    print(f"输入目录: {input_dir}")
    print(f"输出目录: {output_base_dir}")
    print("=" * 70)
    
    # 读取测试案例
    test_cases = load_test_cases_from_directory(input_dir)
    
    if not test_cases:
        print("\n✗ 未找到有效的测试案例")
        return []
    
    print(f"\n✓ 成功加载 {len(test_cases)} 个测试案例")
    
    # 创建输出基础目录
    if not os.path.exists(output_base_dir):
        os.makedirs(output_base_dir)
    
    all_results = []
    
    # 初始化修复器 (在循环外,只初始化一次)
    fixer = ImprovedDafnyFixer(
        api_key=api_key,
        base_url=base_url,
        output_dir=output_base_dir,  # 临时目录
        clean_output=False
    )
    
    # 加载知识库 (只加载一次)
    print("\n" + "=" * 70)
    print("加载知识库")
    print("=" * 70)
    try:
        fixer.load_all_vectorstores(
            case_db_dir=case_db_dir,
            case_db_name="dafny_error_cases",
            error_db_dir=error_db_dir,
            error_db_name="error_documents",
            grammar_db_dir=grammar_db_dir,
            grammar_db_name="grammar_documents"
        )
    except Exception as e:
        print(f"⚠️  加载知识库失败: {e}")
        print("继续处理,但没有知识库参考")
    
    # 处理每个任务
    for idx, test_case in enumerate(test_cases, 1):
        task_id = test_case['task_id']
        
        print("\n" + "=" * 70)
        print(f"任务 {idx}/{len(test_cases)}: Task {task_id}")
        print("=" * 70)
        
        # 为每个任务创建独立的输出目录
        task_output_dir = os.path.join(
            output_base_dir,
            f"task_id_{task_id}-gpt-4.1-nano-temp_0.5-k_1"
        )
        
        # 更新 fixer 的输出目录
        fixer.output_dir = task_output_dir
        if not os.path.exists(task_output_dir):
            os.makedirs(task_output_dir)
        
        # 执行修复
        try:
            result = fixer.iterative_fix_pipeline(
                buggy_code=test_case['buggy_code'],
                verifier_errors=test_case['verifier_errors'],
                task_id=task_id,
                max_iterations=max_iterations
            )
            
            all_results.append(result)
            
            # 显示本任务结果
            status = "✓ 成功" if result['final_success'] else "✗ 失败"
            print(f"\n{status} | 任务 {task_id} | 迭代: {result['total_iterations']}/{max_iterations}")
            
        except Exception as e:
            print(f"\n✗ 任务 {task_id} 处理失败: {e}")
            import traceback
            traceback.print_exc()
            
            all_results.append({
                'task_id': task_id,
                'final_success': False,
                'total_iterations': 0,
                'final_error_count': -1,
                'error': str(e)
            })
    
    # 保存汇总结果
    summary = save_results_summary(output_base_dir, all_results)
    
    # 显示最终统计
    print("\n" + "=" * 70)
    print("批量处理完成")
    print("=" * 70)
    print(f"\n总任务数: {summary['total_tasks']}")
    print(f"成功: {summary['successful']} ({summary['successful']/summary['total_tasks']*100:.1f}%)")
    print(f"失败: {summary['failed']} ({summary['failed']/summary['total_tasks']*100:.1f}%)")
    
    print(f"\n所有结果已保存到: {output_base_dir}/")
    
    return all_results


def main():
    """主函数"""
    
    print("=" * 70)
    print("Dafny 代码修复工具 - 从目录批量处理")
    print("=" * 70)
    
    # ========== 配置 ==========
    API_KEY = "sk-3mKCbVHEJAOiU1cW72yhmqcYKG9FIWPoIqIA00ImxZ2vwI9b"
    BASE_URL = "https://turingai.plus/v1"
    
    # 输入目录 (你的 dafny 文件所在目录)
    INPUT_DIR = r"D:\RAG\bench_test\xiaorong-N"
    
    # 输出基础目录
    OUTPUT_BASE_DIR = r"D:\RAG\bench_test_fixed\xiaorong-N"
    
    # 知识库配置
    CASE_DB_DIR = "./chroma_db"
    ERROR_DB_DIR = "./chroma_db_error"
    GRAMMAR_DB_DIR = "./chroma_db_grammar"
    
    MAX_ITERATIONS = 5
    # ==========================
    
    print(f"\n输入目录: {INPUT_DIR}")
    print(f"输出目录: {OUTPUT_BASE_DIR}")
    
    # 检查输入目录
    if not os.path.exists(INPUT_DIR):
        print(f"\n✗ 错误: 输入目录不存在")
        print(f"   {INPUT_DIR}")
        print("\n请检查路径是否正确")
        return
    
    # 显示将要处理的文件
    dfy_files = [f for f in os.listdir(INPUT_DIR) if f.endswith('.dfy')]
    print(f"\n找到 {len(dfy_files)} 个 .dfy 文件:")
    for i, f in enumerate(sorted(dfy_files)[:10], 1):  # 最多显示10个
        print(f"  {i}. {f}")
    if len(dfy_files) > 10:
        print(f"  ... 还有 {len(dfy_files) - 10} 个文件")
    
    # 确认执行
    print("\n" + "=" * 70)
    confirm = input(f"是否开始批量处理? (y/n, 默认y): ").strip().lower()
    if confirm and confirm != 'y':
        print("已取消")
        return
    
    # 执行批量修复
    results = batch_fix_from_directory(
        input_dir=INPUT_DIR,
        api_key=API_KEY,
        base_url=BASE_URL,
        output_base_dir=OUTPUT_BASE_DIR,
        max_iterations=MAX_ITERATIONS,
        case_db_dir=CASE_DB_DIR,
        error_db_dir=ERROR_DB_DIR,
        grammar_db_dir=GRAMMAR_DB_DIR
    )
    
    print("\n" + "=" * 70)
    print("处理完成!")
    print("=" * 70)
    print(f"\n输出目录: {OUTPUT_BASE_DIR}")
    print(f"汇总文件: {OUTPUT_BASE_DIR}\\batch_summary.json")


if __name__ == "__main__":
    main()