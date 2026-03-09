"""
使用 Dafny 验证器直接验证所有修复后的代码
"""
import os
import re
import subprocess
from pathlib import Path
from typing import Tuple


def run_dafny_verify(dfy_file: Path, timeout: int = 30) -> Tuple[bool, str]:
    """
    运行 Dafny 验证器
    
    Returns:
        (success, output)
    """
    try:
        result = subprocess.run(
            ["dafny", "verify", str(dfy_file)],
            capture_output=True,
            text=True,
            timeout=timeout
        )
        
        output = result.stdout + result.stderr
        
        # 判断是否成功
        # 查找 "X verified, 0 errors"
        verified_match = re.search(r'(\d+)\s+verified,\s+0\s+errors?', output, re.IGNORECASE)
        if verified_match:
            verified_count = int(verified_match.group(1))
            if verified_count > 0:
                return (True, output)
        
        # 查找 "X verified, Y errors" (Y > 0)
        error_match = re.search(r'(\d+)\s+verified,\s+(\d+)\s+errors?', output, re.IGNORECASE)
        if error_match:
            error_count = int(error_match.group(2))
            if error_count > 0:
                return (False, output)
        
        # 检查是否有 parse errors
        if 'parse error' in output.lower():
            return (False, output)
        
        # 默认判断为失败
        return (False, output)
        
    except subprocess.TimeoutExpired:
        return (False, f"Timeout (>{timeout}s)")
    except FileNotFoundError:
        return (False, "Dafny not found")
    except Exception as e:
        return (False, f"Error: {e}")


def find_latest_dfy_file(task_dir: Path) -> Path:
    """找到最后一次迭代的 .dfy 文件"""
    dfy_files = list(task_dir.glob("*.dfy"))
    
    if not dfy_files:
        return None
    
    # 找到最大迭代次数的文件
    max_iter = -1
    latest_file = None
    
    for dfy_file in dfy_files:
        # 尝试匹配 iter_X 或 iteration_X 或 task_id_X-iter-X
        iter_match = re.search(r'iter[_-]?(\d+)', dfy_file.name)
        if iter_match:
            iter_num = int(iter_match.group(1))
            if iter_num > max_iter:
                max_iter = iter_num
                latest_file = dfy_file
    
    # 如果没有找到带迭代号的，返回第一个
    if latest_file is None and dfy_files:
        latest_file = dfy_files[0]
    
    return latest_file


def verify_all_tasks(base_dir: str):
    """验证所有任务"""
    
    base_path = Path(base_dir)
    
    if not base_path.exists():
        print(f"✗ 目录不存在: {base_dir}")
        return
    
    print("=" * 70)
    print(f"使用 Dafny 验证器验证所有修复代码")
    print(f"目录: {base_dir}")
    print("=" * 70)
    
    # 获取所有任务目录
    task_dirs = [d for d in base_path.iterdir() 
                 if d.is_dir() and d.name.endswith('_fixed')]
    
    print(f"\n找到 {len(task_dirs)} 个任务目录\n")
    
    # 统计
    successful_tasks = []
    failed_tasks = []
    timeout_tasks = []
    
    # 遍历每个任务
    for idx, task_dir in enumerate(sorted(task_dirs), 1):
        # 提取 task_id
        match = re.search(r'task_id_(\d+)', task_dir.name)
        if not match:
            print(f"⚠️  [{idx}/{len(task_dirs)}] 跳过 {task_dir.name} (无法提取task_id)")
            continue
        
        task_id = match.group(1)
        
        # 找到最后一次迭代的 .dfy 文件
        dfy_file = find_latest_dfy_file(task_dir)
        
        if not dfy_file:
            print(f"⚠️  [{idx}/{len(task_dirs)}] Task {task_id}: 没有 .dfy 文件")
            failed_tasks.append((task_id, "没有dfy文件"))
            continue
        
        # 运行 Dafny 验证
        print(f"🔍 [{idx}/{len(task_dirs)}] 验证 Task {task_id} ({dfy_file.name})...", end=" ")
        
        success, output = run_dafny_verify(dfy_file)
        
        if "Timeout" in output:
            print("⏱️  超时")
            timeout_tasks.append((task_id, dfy_file.name))
        elif success:
            # 提取验证信息
            verified_match = re.search(r'(\d+)\s+verified', output)
            verified_count = verified_match.group(1) if verified_match else "?"
            print(f"✓ 成功 ({verified_count} verified)")
            successful_tasks.append((task_id, dfy_file.name, output))
        else:
            # 提取错误信息
            error_match = re.search(r'(\d+)\s+errors?', output)
            if error_match:
                error_count = error_match.group(1)
                print(f"✗ 失败 ({error_count} errors)")
            else:
                print(f"✗ 失败")
            failed_tasks.append((task_id, dfy_file.name, output))
    
    # 显示汇总
    print("\n" + "=" * 70)
    print("验证汇总")
    print("=" * 70)
    
    total = len(successful_tasks) + len(failed_tasks) + len(timeout_tasks)
    
    print(f"\n总任务数: {total}")
    print(f"✓ 验证通过: {len(successful_tasks)} ({len(successful_tasks)/total*100:.1f}%)")
    print(f"✗ 验证失败: {len(failed_tasks)} ({len(failed_tasks)/total*100:.1f}%)")
    print(f"⏱️  验证超时: {len(timeout_tasks)} ({len(timeout_tasks)/total*100:.1f}%)")
    
    # 显示成功的任务（完整列表）
    if successful_tasks:
        print(f"\n✓ 验证通过的任务 ({len(successful_tasks)} 个):")
        success_ids = sorted([t[0] for t in successful_tasks], key=lambda x: int(x))
        # 每行显示10个
        for i in range(0, len(success_ids), 10):
            print(f"  {success_ids[i:i+10]}")
    
    # 显示失败的任务（完整列表）
    if failed_tasks:
        print(f"\n✗ 验证失败的任务 ({len(failed_tasks)} 个):")
        failed_ids = sorted([t[0] for t in failed_tasks], key=lambda x: int(x))
        # 每行显示10个
        for i in range(0, len(failed_ids), 10):
            print(f"  {failed_ids[i:i+10]}")
    
    # 显示超时的任务（完整列表）
    if timeout_tasks:
        print(f"\n⏱️  验证超时的任务 ({len(timeout_tasks)} 个):")
        timeout_ids = sorted([t[0] for t in timeout_tasks], key=lambda x: int(x))
        # 每行显示10个
        for i in range(0, len(timeout_ids), 10):
            print(f"  {timeout_ids[i:i+10]}")
    
    # 保存详细结果
    output_file = base_path / "verification_results.txt"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("=" * 70 + "\n")
        f.write("Dafny 验证结果（直接运行验证器）\n")
        f.write("=" * 70 + "\n\n")
        
        f.write(f"总任务数: {total}\n")
        f.write(f"验证通过: {len(successful_tasks)} ({len(successful_tasks)/total*100:.1f}%)\n")
        f.write(f"验证失败: {len(failed_tasks)} ({len(failed_tasks)/total*100:.1f}%)\n")
        f.write(f"验证超时: {len(timeout_tasks)} ({len(timeout_tasks)/total*100:.1f}%)\n\n")
        
        f.write("=" * 70 + "\n")
        f.write("通过验证的任务\n")
        f.write("=" * 70 + "\n\n")
        for task_id, dfy_file, output in sorted(successful_tasks, key=lambda x: int(x[0])):
            f.write(f"Task {task_id} ({dfy_file}):\n")
            # 只保存关键信息
            for line in output.split('\n'):
                if 'verified' in line.lower() or 'error' in line.lower():
                    f.write(f"  {line}\n")
            f.write("\n")
        
        f.write("=" * 70 + "\n")
        f.write("验证失败的任务\n")
        f.write("=" * 70 + "\n\n")
        for task_id, dfy_file, output in sorted(failed_tasks, key=lambda x: int(x[0])):
            f.write(f"Task {task_id} ({dfy_file}):\n")
            # 保存前5个错误
            error_count = 0
            for line in output.split('\n'):
                if 'Error:' in line or 'error' in line.lower():
                    f.write(f"  {line}\n")
                    error_count += 1
                    if error_count >= 5:
                        break
            f.write("\n")
        
        if timeout_tasks:
            f.write("=" * 70 + "\n")
            f.write("验证超时的任务\n")
            f.write("=" * 70 + "\n\n")
            for task_id, dfy_file in sorted(timeout_tasks, key=lambda x: int(x[0])):
                f.write(f"Task {task_id} ({dfy_file})\n")
    
    print(f"\n✓ 详细结果已保存到: {output_file}")


if __name__ == "__main__":
    # 修改这里的路径
    BASE_DIR = r"D:\RAG\fixed_k1_cases"
    
    verify_all_tasks(BASE_DIR)