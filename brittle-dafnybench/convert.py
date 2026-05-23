import os
import pandas as pd

def export_dafny_files(csv_path, output_dir="dafnybench", id_start=636, id_end=692):
    # Read CSV
    df = pd.read_csv(csv_path, encoding="latin1")
    
    # Filter by id range
    df_filtered = df[(df["id"] >= id_start) & (df["id"] <= id_end)]
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    # Iterate over each row and save files
    for _, row in df_filtered.iterrows():
        id_val = int(row["id"])

        # Get content
        code_content = row["code"] if isinstance(row["code"], str) else ""
        gt_content = row["ground_truth"] if isinstance(row["ground_truth"], str) else ""

        # Build file names
        code_file = os.path.join(output_dir, f"{id_val}_code.dfy")
        gt_file = os.path.join(output_dir, f"{id_val}_gt.dfy")

        # Write code file
        with open(code_file, "w", encoding="utf-8") as f:
            f.write(code_content)

        # Write ground_truth file
        with open(gt_file, "w", encoding="utf-8") as f:
            f.write(gt_content)

    print(f"Done! Exported {len(df_filtered)} x 2 files into {output_dir}/")

if __name__ == "__main__":
    csv_path = os.path.join(os.path.dirname(__file__), "brittle_dafny_bench.csv")
    export_dafny_files(csv_path)
