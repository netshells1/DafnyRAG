"""
向量数据库构建工具
"""

import json
from pathlib import Path
from typing import List, Dict
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_core.documents import Document


class DafnyErrorCaseLoader:
    """加载和处理 Dafny 错误修复案例"""

    def __init__(self, api_key: str, base_url: str):
        """
        初始化加载器
        """
        self.embeddings = OpenAIEmbeddings(
            model="text-embedding-3-small",
            openai_api_key=api_key,
            openai_api_base=base_url,
        )

    def load_json_files(self, directory: str) -> List[Document]:
        """
        从目录加载所有 JSON 文件
        """
        documents = []
        json_files = Path(directory).glob("*.json")

        for json_file in json_files:
            try:
                with open(json_file, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    doc = self._create_document(data, str(json_file))
                    documents.append(doc)
                    print(f"✓ 成功加载: {json_file.name}")
            except Exception as e:
                print(f"✗ 加载失败 {json_file.name}: {e}")

        return documents

    def _create_document(self, data: Dict, source: str) -> Document:
        """
        将 JSON 数据转换为 Document 对象
        """
        content = f"""
        Task ID: {data['task_id']}
        Task Description: {data['task_description']}

        Method Signature:
        {data['method_signature']}

        Buggy Code:
        {data['buggy_code']}

        Primary Error:
        - Message: {data['primary_error']['message']}
        - Line: {data['primary_error']['line']}
        - Context: {data['primary_error']['context']}

        Error Categories: {', '.join(data['error_categories'])}

        Verifier Errors:
        {chr(10).join(data['verifier_error'])}

        Fixed Code:
        {data['fixed_code']}

        Repair Strategy:
        Summary: {data['repair_strategy']['problem_summary']}

        Problem Details:
        - What: {data['repair_strategy']['problem_details']['what']}
        - Why: {data['repair_strategy']['problem_details']['why']}
        - How: {data['repair_strategy']['problem_details']['how']}
        """

        metadata = {
            "task_id": data["task_id"],
            "task_description": data["task_description"],
            "error_categories": ", ".join(data["error_categories"]),
            "primary_error_type": data["primary_error"]["message"],
            "source": source,
            "method_signature": data["method_signature"],
        }

        return Document(page_content=content, metadata=metadata)

    def create_vectorstore(
        self,
        documents: List[Document],
        persist_directory: str = "./chroma_db",
        collection_name: str = "dafny_error_cases",
    ) -> Chroma:
        """
        创建 ChromaDB 向量存储
        """
        print(f"\n开始创建向量存储...")
        print(f"- 文档数量: {len(documents)}")
        print(f"- 持久化目录: {persist_directory}")
        print(f"- 集合名称: {collection_name}")

        vectorstore = Chroma.from_documents(
            documents=documents,
            embedding=self.embeddings,
            persist_directory=persist_directory,
            collection_name=collection_name,
        )

        print(f"✓ 向量存储创建成功！")
        return vectorstore


def main():
    """主函数：构建向量数据库"""
    
    # ========== 配置区域 ==========
    API_KEY = "sk-3mKCbVHEJAOiU1cW72yhmqcYKG9FIWPoIqIA00ImxZ2vwI9b"
    BASE_URL = "https://turingai.plus/v1"
    JSON_DIRECTORY = "source"  # JSON 文件目录
    PERSIST_DIRECTORY = "./chroma_db"  # 数据库保存目录
    COLLECTION_NAME = "dafny_error_cases"  # 集合名称
    # =============================

    print("=" * 60)
    print("Dafny 错误案例向量数据库构建工具")
    print("=" * 60)

    # 初始化加载器
    loader = DafnyErrorCaseLoader(api_key=API_KEY, base_url=BASE_URL)

    # 加载 JSON 文件
    print(f"\n正在从 {JSON_DIRECTORY} 加载 JSON 文件...\n")
    documents = loader.load_json_files(JSON_DIRECTORY)
    print(f"\n总共加载了 {len(documents)} 个文档")

    if len(documents) == 0:
        print("\n未找到任何文档，请检查目录路径")
        return

    # 创建向量存储
    vectorstore = loader.create_vectorstore(
        documents=documents,
        persist_directory=PERSIST_DIRECTORY,
        collection_name=COLLECTION_NAME,
    )

    print("\n" + "=" * 60)
    print("数据库构建完成！")
    print("=" * 60)
    print(f"数据库位置: {PERSIST_DIRECTORY}")
    print(f"集合名称: {COLLECTION_NAME}")
    print(f"文档数量: {len(documents)}")
    print("\n现在可以运行 search_database.py 进行相似度检索测试")


if __name__ == "__main__":
    main()