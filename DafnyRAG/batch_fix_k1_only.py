"""
批量处理 Dafny 代码修复工具 - 从目录读取版本
从指定目录读取 .dfy 文件和对应的验证日志
增加功能：
1. 只处理失败的 task_id
2. 只处理 k_1
3. 断点续跑（跳过已处理的）
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


# ========================================
# 失败的 task_id（需要修复）
# ========================================
FAILED_TASKS = ['105', '11', '113', '116', '119', '126', '131', '133', '139', '142', 
                '161', '166', '167', '170', '19', '2', '233', '235', '239', '256', 
                '261', '270', '281', '282', '283', '284', '287', '290', '291', '305', 
                '308', '312', '388', '389', '394', '395', '399', '401', '412', '415', 
                '420', '426', '428', '432', '436', '437', '439', '443', '445', '450', 
                '451', '457', '470', '476', '479', '554', '557', '559', '56', '564', 
                '57', '572', '581', '587', '589', '598', '603', '604', '606', '61', 
                '618', '619', '622', '626', '628', '639', '66', '67', '68', '7', '70', 
                '72', '728', '747', '748', '751', '759', '763', '769', '772', '776', 
                '777', '799', '8', '80', '806', '82', '85', '89', '9', '93', '96']


def load_test_cases_from_directory(input_dir: str, output_base_dir: str) -> List[Dict]:
    """
    从目录读取测试案例
    
    目录结构:
    output-dynamic_29/
    ├── task_id_2-gpt-4.1-nano-temp_0.5-k_1.dfy
    ├── task_id_2-gpt-4.1-nano-temp_0.5-k_1_verification_log.txt
    └── ...
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
        
        # ===== 新增1：跳过已处理的任务 =====
        output_dir_name = f"task_id_{task_id}_k_1_fixed"
        output_path = os.path.join(output_base_dir, output_dir_name)
        if os.path.exists(output_path):
            print(f"⏭️  跳过 task_{task_id} (已处理)")
            continue
        # ===== 结束 =====
        
        # ===== 新增2：只处理失败的 task_id =====
        if task_id not in FAILED_TASKS:
            continue
        # ===== 结束 =====
        
        # ===== 新增3：只处理 k_1 =====
        if 'k_1' not in dfy_file:
            continue
        # ===== 结束 =====
        
        # 读取 .dfy 文件
        dfy_path = os.path.join(input_dir, dfy_file)
        try:
            with open(dfy_path, 'r', encoding='utf-8') as f:
                buggy_code = f.read()
        except Exception as e:
            print(f"✗ 读取失败 {dfy_file}: {e}")
            continue
        
        # 查找对应的验证日志文件
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
            verifier_errors = ["Error: Unknown error (no verification log found)"]
        else:
            # 读取验证日志并提取错误
            try:
                with open(log_path, 'r', encoding='utf-8') as f:
                    log_content = f.read()
                
                # 提取错误信息
                verifier_errors = []
                
                # 方法1: 提取包含 "Error:" 的行
                for line in log_content.split('\n'):
                    line = line.strip()
                    if ': Error:' in line or line.startswith('Error:'):
                        verifier_errors.append(line)
                
                # 方法2: 如果没找到,尝试提取其他错误信息
                if not verifier_errors:
                    for line in log_content.split('\n'):
                        line = line.strip()
                        if any(keyword in line.lower() for keyword in [
                            'error:', 'could not be proved', 'might not hold',
                            'invariant violation', 'out of range', 'postcondition'
                        ]):
                            verifier_errors.append(line)
                
                # ===== 方法3: 如果没有错误，检查是否有警告 =====
                if not verifier_errors:
                    for line in log_content.split('\n'):
                        line = line.strip()
                        if 'Warning:' in line or (line.lower().startswith('warning') and ':' in line):
                            verifier_errors.append(line)
                # ===== 结束 =====
                
                # 检查是否已通过验证（需要无错误且无警告）
                if not verifier_errors:
                    summary_match = re.search(r'(\d+)\s+verified,\s+(\d+)\s+errors?', 
                                             log_content, re.IGNORECASE)
                    if summary_match:
                        verified_count = int(summary_match.group(1))
                        error_count = int(summary_match.group(2))
                        
                        # ===== 检查是否有警告 =====
                        has_warning = 'Warning:' in log_content or 'warning' in log_content.lower()
                        
                        if error_count == 0 and verified_count > 0 and not has_warning:
                            # 真正通过验证（无错误且无警告），跳过
                            print(f"⚠️  跳过 task_{task_id} (完全通过: {verified_count} verified, 0 errors, 0 warnings)")
                            continue
                        elif error_count == 0 and verified_count > 0 and has_warning:
                            # 有警告，需要处理
                            # 统计警告数量
                            warning_count = len([line for line in log_content.split('\n') 
                                               if 'Warning:' in line or 'warning:' in line.lower()])
                            verifier_errors = ["Warning: Code has warnings that need to be fixed"]
                            print(f"  ✓ Task {task_id} (k_1): {warning_count} 个警告")
                        elif error_count > 0:
                            verifier_errors = [f"Error: Verification failed with {error_count} errors"]
                        # ===== 结束 =====
                    else:
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
        
        # ===== 显示时区分错误和警告 =====
        if verifier_errors:
            # 检查是否全是警告
            all_warnings = all('Warning' in err or 'warning' in err.lower() 
                              for err in verifier_errors)
            if all_warnings:
                print(f"  ✓ Task {task_id} (k_1): {len(verifier_errors)} 个警告")
            else:
                print(f"  ✓ Task {task_id} (k_1): {len(verifier_errors)} 个错误")
        # ===== 结束 =====
    
    return test_cases


def save_results_summary(output_dir: str, results: List[Dict]):
    """保存结果汇总"""
    summary_file = os.path.join(output_dir, "batch_summary_k1.json")
    
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
    output_base_dir: str = "./fixed_k1_cases",
    max_iterations: int = 5,
    case_db_dir: str = "./chroma_db",
    error_db_dir: str = "./chroma_db_error",
    grammar_db_dir: str = "./chroma_db_grammar"
):
    """
    从目录批量修复 Dafny 代码
    """
    print("=" * 70)
    print(f"批量处理 Dafny 代码修复 (只处理失败的 k_1)")
    print(f"输入目录: {input_dir}")
    print(f"输出目录: {output_base_dir}")
    print("=" * 70)
    
    # ===== 新增：检测已完成的任务并统计成功率 =====
    completed_tasks = {}  # {task_id: success}
    if os.path.exists(output_base_dir):
        for dirname in os.listdir(output_base_dir):
            if not os.path.isdir(os.path.join(output_base_dir, dirname)):
                continue
            if not dirname.endswith('_fixed'):
                continue
            
            # 提取 task_id
            match = re.search(r'task_id_(\d+)_k_1_fixed', dirname)
            if not match:
                continue
            task_id = match.group(1)
            
            # 检查是否修复成功（查看最后一次迭代的日志）
            task_dir = os.path.join(output_base_dir, dirname)
            log_files = [f for f in os.listdir(task_dir) if f.endswith('_log.txt')]
            
            success = False
            if log_files:
                # 找到最大迭代次数的日志
                max_iter = 0
                latest_log = None
                for log_file in log_files:
                    iter_match = re.search(r'iter_(\d+)_log', log_file)
                    if iter_match:
                        iter_num = int(iter_match.group(1))
                        if iter_num > max_iter:
                            max_iter = iter_num
                            latest_log = log_file
                
                # 检查最后一次迭代是否成功
                if latest_log:
                    log_path = os.path.join(task_dir, latest_log)
                    try:
                        with open(log_path, 'r', encoding='utf-8') as f:
                            log_content = f.read()
                        
                        # ===== 修改：更准确的成功判定 =====
                        # 方法1: 检查是否有 "X verified, 0 errors"
                        verified_match = re.search(r'(\d+)\s+verified,\s+0\s+errors?', log_content, re.IGNORECASE)
                        if verified_match and int(verified_match.group(1)) > 0:
                            success = True
                        else:
                            # 方法2: 检查是否有实际的错误行（以 "Error:" 开头或包含 ": Error:"）
                            error_lines = [line for line in log_content.split('\n') 
                                         if line.strip().startswith('Error:') or ': Error:' in line]
                            if not error_lines:
                                # 没有实际错误行，判断为成功
                                success = True
                        # ===== 结束 =====
                    except:
                        pass
            
            completed_tasks[task_id] = success
        
        if completed_tasks:
            completed_success = sum(1 for s in completed_tasks.values() if s)
            print(f"✓ 检测到已完成的任务: {len(completed_tasks)} 个")
            print(f"  - 成功: {completed_success} 个")
            print(f"  - 失败: {len(completed_tasks) - completed_success} 个")
    # ===== 结束 =====
    
    # 读取测试案例（会自动跳过已处理的）
    test_cases = load_test_cases_from_directory(input_dir, output_base_dir)
    
    if not test_cases:
        print("\n✗ 未找到需要修复的案例（可能都已处理完成）")
        return []
    
    print(f"\n✓ 待处理: {len(test_cases)} 个测试案例")
    
    # 创建输出基础目录
    if not os.path.exists(output_base_dir):
        os.makedirs(output_base_dir)
    
    all_results = []
    
    # 初始化修复器
    fixer = ImprovedDafnyFixer(
        api_key=api_key,
        base_url=base_url,
        output_dir=output_base_dir,
        clean_output=False
    )
    
    # 加载知识库
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
        print("继续处理，但没有知识库参考")
    
    # 处理每个任务
    for idx, test_case in enumerate(test_cases, 1):
        task_id = test_case['task_id']
        
        print("\n" + "=" * 70)
        print(f"任务 {idx}/{len(test_cases)}: Task {task_id} (k_1)")
        print("=" * 70)
        
        # 为每个任务创建独立的输出目录
        task_output_dir = os.path.join(
            output_base_dir,
            f"task_id_{task_id}_k_1_fixed"
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
    
    # ===== 计算全局统计（包括之前完成的）=====
    # 合并本次结果和之前完成的
    all_task_results = dict(completed_tasks)  # 复制已完成的
    for result in all_results:
        all_task_results[result['task_id']] = result['final_success']
    
    total_attempted = len(all_task_results)
    total_success = sum(1 for s in all_task_results.values() if s)
    total_failed = total_attempted - total_success
    
    # 显示最终统计
    print("\n" + "=" * 70)
    print("批量处理完成")
    print("=" * 70)
    
    print(f"\n【本次运行】")
    print(f"处理任务数: {summary['total_tasks']}")
    print(f"成功: {summary['successful']}")
    print(f"失败: {summary['failed']}")
    
    print(f"\n【全局统计】（共 {len(FAILED_TASKS)} 个失败任务）")
    print(f"已尝试修复: {total_attempted} 个")
    print(f"修复成功: {total_success} 个 ({total_success/len(FAILED_TASKS)*100:.1f}%)")
    print(f"修复失败: {total_failed} 个 ({total_failed/len(FAILED_TASKS)*100:.1f}%)")
    print(f"未处理: {len(FAILED_TASKS) - total_attempted} 个")
    
    print(f"\n所有结果已保存到: {output_base_dir}/")
    # ===== 结束 =====
    
    return all_results, {
        'total_failed_tasks': len(FAILED_TASKS),
        'total_attempted': total_attempted,
        'total_success': total_success,
        'total_failed': total_failed,
        'success_rate': total_success / len(FAILED_TASKS) * 100,
        'all_task_results': all_task_results
    }


def main():
    """主函数"""
    
    print("=" * 70)
    print("Dafny 代码修复工具 - 只修复失败的 k_1 案例")
    print("=" * 70)
    
    # ========== 配置 ==========
    API_KEY = "sk-3mKCbVHEJAOiU1cW72yhmqcYKG9FIWPoIqIA00ImxZ2vwI9b"
    BASE_URL = "https://turingai.plus/v1"
    
    # 输入目录 (新的测试数据)
    INPUT_DIR = r"C:\Users\Lenovo\Desktop\000论文\RAG\output-dynamic_29"
    # INPUT_DIR = r"D:\RAG\111"
    
    # 输出基础目录
    OUTPUT_BASE_DIR = r"fixed_k1_cases"
    
    # 知识库配置
    CASE_DB_DIR = "./chroma_db"
    ERROR_DB_DIR = "./chroma_db_error"
    GRAMMAR_DB_DIR = "./chroma_db_grammar"
    
    MAX_ITERATIONS = 5
    # ==========================
    
    print(f"\n输入目录: {INPUT_DIR}")
    print(f"输出目录: {OUTPUT_BASE_DIR}")
    print(f"失败任务数: {len(FAILED_TASKS)}")
    
    # 检查输入目录
    if not os.path.exists(INPUT_DIR):
        print(f"\n✗ 错误: 输入目录不存在")
        print(f"   {INPUT_DIR}")
        return
    
    # 显示将要处理的任务
    print(f"\n将要处理的失败任务 (前10个):")
    for i, task_id in enumerate(FAILED_TASKS[:10], 1):
        print(f"  {i}. task_id_{task_id}_k_1")
    if len(FAILED_TASKS) > 10:
        print(f"  ... 还有 {len(FAILED_TASKS) - 10} 个任务")
    
    # 确认执行
    print("\n" + "=" * 70)
    confirm = input(f"是否开始处理? (y/n, 默认y): ").strip().lower()
    if confirm and confirm != 'y':
        print("已取消")
        return
    
    # 执行批量修复
    results, global_stats = batch_fix_from_directory(
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
    print(f"\n📊 最终成绩单:")
    print(f"失败任务总数: {global_stats['total_failed_tasks']}")
    print(f"成功修复: {global_stats['total_success']}/{global_stats['total_failed_tasks']} ({global_stats['success_rate']:.1f}%)")
    print(f"\n输出目录: {OUTPUT_BASE_DIR}")
    print(f"汇总文件: {OUTPUT_BASE_DIR}\\batch_summary_k1.json")


if __name__ == "__main__":
    main()