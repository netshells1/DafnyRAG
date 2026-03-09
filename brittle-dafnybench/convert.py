import os
import pandas as pd

def export_dafny_files(csv_path, output_dir="dafnybench", id_start=636, id_end=692):
    # 读入 CSV
    df = pd.read_csv(csv_path, encoding="latin1")
    
    # 过滤 id 范围
    df_filtered = df[(df["id"] >= id_start) & (df["id"] <= id_end)]
    
    # 创建输出目录
    os.makedirs(output_dir, exist_ok=True)

    # 遍历每一行并保存文件
    for _, row in df_filtered.iterrows():
        id_val = int(row["id"])

        # 获取内容
        code_content = row["code"] if isinstance(row["code"], str) else ""
        gt_content = row["ground_truth"] if isinstance(row["ground_truth"], str) else ""

        # 构建文件名
        code_file = os.path.join(output_dir, f"{id_val}_code.dfy")
        gt_file = os.path.join(output_dir, f"{id_val}_gt.dfy")

        # 写入 code 文件
        with open(code_file, "w", encoding="utf-8") as f:
            f.write(code_content)

        # 写入 ground_truth 文件
        with open(gt_file, "w", encoding="utf-8") as f:
            f.write(gt_content)

    print(f"Done! Exported {len(df_filtered)} × 2 files into {output_dir}/")

# 调用示例
export_dafny_files(r"C:\Users\Lenovo\Desktop\000论文\RAG\brittle-dafnybench\brittle_dafny_bench.csv")

