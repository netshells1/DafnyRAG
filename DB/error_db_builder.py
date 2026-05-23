"""
PDF document vector database builder for Dafny error references.
"""

import argparse
import os
import time
from pathlib import Path
from typing import List

from langchain_community.document_loaders import PyPDFLoader
from langchain_community.vectorstores import Chroma
from langchain_core.documents import Document
from langchain_openai import OpenAIEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter
from tqdm import tqdm


REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_PDF_FILE = REPO_ROOT / "source" / "Dafny_Error.pdf"
DEFAULT_PERSIST_DIRECTORY = REPO_ROOT / "chroma_db_error"
DEFAULT_COLLECTION_NAME = "error_documents"


def get_api_config(args: argparse.Namespace) -> tuple[str, str]:
    api_key = args.api_key or os.getenv("OPENAI_API_KEY")
    base_url = args.base_url or os.getenv("OPENAI_BASE_URL", "https://api.openai.com/v1")

    if not api_key:
        raise ValueError(
            "Missing API key. Set OPENAI_API_KEY or pass --api-key."
        )

    return api_key, base_url


class PDFDocumentLoader:
    """Load and process PDF documents."""

    def __init__(self, api_key: str, base_url: str):
        self.embeddings = OpenAIEmbeddings(
            model="text-embedding-3-small",
            openai_api_key=api_key,
            openai_api_base=base_url,
        )

        self.text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=1000,
            chunk_overlap=200,
            length_function=len,
            separators=["\n\n", "\n", ".", "!", "?", ";", " ", ""],
        )

    def load_pdf(self, pdf_path: str) -> List[Document]:
        """Load a single PDF file."""
        try:
            print(f"Loading: {pdf_path}")
            loader = PyPDFLoader(pdf_path)
            documents = loader.load()
            print(f"Successfully loaded {len(documents)} pages")
            return documents
        except Exception as e:
            print(f"Failed to load PDF: {e}")
            return []

    def load_pdf_directory(self, directory: str) -> List[Document]:
        """Load all PDF files from a directory."""
        all_documents = []
        pdf_files = list(Path(directory).glob("*.pdf"))

        print(f"\nFound {len(pdf_files)} PDF files\n")

        for pdf_file in pdf_files:
            documents = self.load_pdf(str(pdf_file))

            for doc in documents:
                doc.metadata["source_file"] = pdf_file.name

            all_documents.extend(documents)

        return all_documents

    def split_documents(self, documents: List[Document]) -> List[Document]:
        """Split documents into smaller chunks."""
        print("\nSplitting documents...")
        print(f"- Original document count: {len(documents)}")
        print(f"- Chunk size: {self.text_splitter._chunk_size}")
        print(f"- Chunk overlap: {self.text_splitter._chunk_overlap}")

        split_docs = self.text_splitter.split_documents(documents)

        print(f"Splitting complete, generated {len(split_docs)} document chunks")
        return split_docs

    def create_vectorstore(
        self,
        documents: List[Document],
        persist_directory: str = str(DEFAULT_PERSIST_DIRECTORY),
        collection_name: str = DEFAULT_COLLECTION_NAME,
        batch_size: int = 50,
    ) -> Chroma:
        """Create a Chroma vector store with progress display."""
        print("\nCreating vector store...")
        print(f"- Number of document chunks: {len(documents)}")
        print(f"- Persist directory: {persist_directory}")
        print(f"- Collection name: {collection_name}")
        print(f"- Batch size: {batch_size}")
        print(f"- Estimated batches: {(len(documents) + batch_size - 1) // batch_size}")

        print("\nProcessing vector embeddings...")

        total_batches = (len(documents) + batch_size - 1) // batch_size
        start_time = time.time()
        vectorstore = None

        with tqdm(total=len(documents), desc="Generating vector embeddings", unit="chunk") as pbar:
            for i in range(0, len(documents), batch_size):
                batch = documents[i:i + batch_size]
                batch_num = i // batch_size + 1

                try:
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

                    elapsed = time.time() - start_time
                    avg_time_per_doc = elapsed / (i + len(batch))
                    remaining_docs = len(documents) - (i + len(batch))
                    eta = avg_time_per_doc * remaining_docs

                    pbar.set_postfix({
                        "batch": f"{batch_num}/{total_batches}",
                        "ETA": f"{eta / 60:.1f} min",
                    })

                except Exception as e:
                    print(f"\nBatch {batch_num} failed: {e}")
                    print("Retrying...")
                    time.sleep(2)

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

        print("\nVector store created successfully")
        return vectorstore


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build the Dafny error PDF vector database."
    )
    parser.add_argument("--api-key", help="API key. Defaults to OPENAI_API_KEY.")
    parser.add_argument(
        "--base-url",
        help="API base URL. Defaults to OPENAI_BASE_URL or OpenAI's public API URL.",
    )
    parser.add_argument(
        "--pdf-file",
        default=str(DEFAULT_PDF_FILE),
        help="PDF file to load.",
    )
    parser.add_argument(
        "--pdf-directory",
        help="Directory of PDF files. If set, this is used instead of --pdf-file.",
    )
    parser.add_argument(
        "--persist-directory",
        default=str(DEFAULT_PERSIST_DIRECTORY),
        help="Directory where Chroma data is saved.",
    )
    parser.add_argument(
        "--collection-name",
        default=DEFAULT_COLLECTION_NAME,
        help="Chroma collection name.",
    )
    parser.add_argument(
        "--batch-size",
        type=int,
        default=50,
        help="Number of chunks to embed per batch.",
    )
    parser.add_argument(
        "--no-split",
        action="store_true",
        help="Disable document splitting.",
    )
    return parser.parse_args()


def main():
    """Build the PDF vector database."""
    args = parse_args()
    api_key, base_url = get_api_config(args)

    print("=" * 60)
    print("Dafny Error PDF Vector Database Builder")
    print("=" * 60)

    loader = PDFDocumentLoader(api_key=api_key, base_url=base_url)

    print("\nLoading PDF files...\n")
    if args.pdf_directory:
        documents = loader.load_pdf_directory(args.pdf_directory)
    else:
        documents = loader.load_pdf(args.pdf_file)

    if len(documents) == 0:
        print("\nNo documents found. Please check the input path.")
        return

    print(f"\nTotal pages/documents loaded: {len(documents)}")

    if not args.no_split:
        documents = loader.split_documents(documents)

    loader.create_vectorstore(
        documents=documents,
        persist_directory=args.persist_directory,
        collection_name=args.collection_name,
        batch_size=args.batch_size,
    )

    print("\n" + "=" * 60)
    print("Database build complete")
    print("=" * 60)
    print(f"Database location: {args.persist_directory}")
    print(f"Collection name: {args.collection_name}")
    print(f"Number of document chunks: {len(documents)}")


if __name__ == "__main__":
    main()
