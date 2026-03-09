"""
PDF文档向量数据库构建工具
"""

from pathlib import Path
from typing import List
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_core.documents import Document
from langchain_community.document_loaders import PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from tqdm import tqdm
import time


class PDFDocumentLoader:
    """加载和处理PDF文档"""

    def __init__(self, api_key: str, base_url: str):
        """
        初始化加载器
        
        Args:
            api_key: OpenAI API密钥
            base_url: API基础URL
        """
        self.embeddings = OpenAIEmbeddings(
            model="text-embedding-3-small",
            openai_api_key=api_key,
            openai_api_base=base_url,
        )
        
        # 文本分割器配置
        self.text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=1000,        # 每个文本块的大小
            chunk_overlap=200,      # 块之间的重叠部分
            length_function=len,
            separators=["\n\n", "\n", "。", "！", "？", ".", "!", "?", " ", ""]
        )

    def load_pdf(self, pdf_path: str) -> List[Document]:
        """
        加载单个PDF文件
        
        Args:
            pdf_path: PDF文件路径
            
        Returns:
            文档列表
        """
        try:
            print(f"正在加载: {pdf_path}")
            loader = PyPDFLoader(pdf_path)
            documents = loader.load()
            print(f"✓ 成功加载 {len(documents)} 页")
            return documents
        except Exception as e:
            print(f"✗ 加载失败: {e}")
            return []

    def load_pdf_directory(self, directory: str) -> List[Document]:
        """
        从目录加载所有PDF文件
        
        Args:
            directory: PDF文件目录
            
        Returns:
            所有文档的列表
        """
        all_documents = []
        pdf_files = list(Path(directory).glob("*.pdf"))
        
        print(f"\n找到 {len(pdf_files)} 个PDF文件\n")
        
        for pdf_file in pdf_files:
            documents = self.load_pdf(str(pdf_file))
            
            # 为每个文档添加源文件信息
            for doc in documents:
                doc.metadata["source_file"] = pdf_file.name
                
            all_documents.extend(documents)
            
        return all_documents

    def split_documents(self, documents: List[Document]) -> List[Document]:
        """
        分割文档为更小的块
        
        Args:
            documents: 原始文档列表
            
        Returns:
            分割后的文档列表
        """
        print(f"\n正在分割文档...")
        print(f"- 原始文档数: {len(documents)}")
        print(f"- 块大小: {self.text_splitter._chunk_size}")
        print(f"- 块重叠: {self.text_splitter._chunk_overlap}")
        
        split_docs = self.text_splitter.split_documents(documents)
        
        print(f"✓ 分割完成，生成 {len(split_docs)} 个文档块")
        return split_docs

    def create_vectorstore(
        self,
        documents: List[Document],
        persist_directory: str = "./chroma_db_error",
        collection_name: str = "error_documents",
        batch_size: int = 50,  # 批次大小
    ) -> Chroma:
        """
        创建 ChromaDB 向量存储（带进度显示）
        
        Args:
            documents: 文档列表
            persist_directory: 持久化目录
            collection_name: 集合名称
            batch_size: 每批处理的文档数量
            
        Returns:
            Chroma向量存储对象
        """
        print(f"\n开始创建向量存储...")
        print(f"- 文档块数量: {len(documents)}")
        print(f"- 持久化目录: {persist_directory}")
        print(f"- 集合名称: {collection_name}")
        print(f"- 批次大小: {batch_size}")
        print(f"- 预计批次数: {(len(documents) + batch_size - 1) // batch_size}")

        # 初始化向量存储（使用第一批文档）
        print(f"\n正在处理向量嵌入...")
        
        # 分批处理
        total_batches = (len(documents) + batch_size - 1) // batch_size
        start_time = time.time()
        
        vectorstore = None
        
        with tqdm(total=len(documents), desc="生成向量嵌入", unit="块") as pbar:
            for i in range(0, len(documents), batch_size):
                batch = documents[i:i+batch_size]
                batch_num = i // batch_size + 1
                
                try:
                    if vectorstore is None:
                        # 创建初始向量存储
                        vectorstore = Chroma.from_documents(
                            documents=batch,
                            embedding=self.embeddings,
                            persist_directory=persist_directory,
                            collection_name=collection_name,
                        )
                    else:
                        # 添加到现有向量存储
                        vectorstore.add_documents(batch)
                    
                    pbar.update(len(batch))
                    
                    # 显示当前进度和预计剩余时间
                    elapsed = time.time() - start_time
                    avg_time_per_doc = elapsed / (i + len(batch))
                    remaining_docs = len(documents) - (i + len(batch))
                    eta = avg_time_per_doc * remaining_docs
                    
                    pbar.set_postfix({
                        '批次': f'{batch_num}/{total_batches}',
                        '预计剩余': f'{eta/60:.1f}分钟'
                    })
                    
                except Exception as e:
                    print(f"\n✗ 批次 {batch_num} 处理失败: {e}")
                    print(f"正在重试...")
                    time.sleep(2)  # 等待后重试
                    
                    if vectorstore is None:
                        vectorstore = Chroma.from_documents(
                            documents=batch,
                            embedding=self.embeddings,
                            persist_directory=persist_directory,
                            collection_name=collection_name,
                        )
                    else:
                        vectorstore.add_documents(batch)
                    
                    pbar.update(len(batch))

        total_time = time.time() - start_time
        print(f"\n✓ 向量存储创建成功！")
        
        return vectorstore


def main():
    """主函数：构建PDF向量数据库"""
    
    # ========== 配置区域 ==========
    API_KEY = "sk-3mKCbVHEJAOiU1cW72yhmqcYKG9FIWPoIqIA00ImxZ2vwI9b"
    BASE_URL = "https://turingai.plus/v1"
    
    # 选项1: 加载单个PDF文件
    PDF_FILE = "D:\RAG\source\Dafny_Error.pdf"  # PDF文件路径
    
    # 选项2: 加载目录中的所有PDF文件
    # PDF_DIRECTORY = "pdf_files"  # 取消注释并修改为你的PDF目录
    
    PERSIST_DIRECTORY = "./chroma_db_error"  # 数据库保存目录
    COLLECTION_NAME = "error_documents"      # 集合名称
    
    # 是否进行文档分割（推荐开启，特别是对于大文档）
    SPLIT_DOCUMENTS = True
    
    # 批处理大小（调小可以更频繁看到进度，但可能稍慢）
    BATCH_SIZE = 50
    # =============================

    print("=" * 60)
    print("PDF文档向量数据库构建工具")
    print("=" * 60)

    # 初始化加载器
    loader = PDFDocumentLoader(api_key=API_KEY, base_url=BASE_URL)

    # 加载PDF文件
    print(f"\n正在加载PDF文件...\n")
    
    # 选项1: 加载单个文件
    documents = loader.load_pdf(PDF_FILE)
    
    # 选项2: 加载目录（取消下面两行的注释）
    # documents = loader.load_pdf_directory(PDF_DIRECTORY)
    
    if len(documents) == 0:
        print("\n未找到任何文档，请检查文件路径")
        return

    print(f"\n总共加载了 {len(documents)} 个页面/文档")

    # 分割文档
    if SPLIT_DOCUMENTS:
        documents = loader.split_documents(documents)

    # 创建向量存储
    vectorstore = loader.create_vectorstore(
        documents=documents,
        persist_directory=PERSIST_DIRECTORY,
        collection_name=COLLECTION_NAME,
        batch_size=BATCH_SIZE,
    )

    print("\n" + "=" * 60)
    print("数据库构建完成！")
    print("=" * 60)
    print(f"数据库位置: {PERSIST_DIRECTORY}")
    print(f"集合名称: {COLLECTION_NAME}")
    print(f"文档块数量: {len(documents)}")

if __name__ == "__main__":
    main()