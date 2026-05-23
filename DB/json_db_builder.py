"""
Vector database builder for Dafny error repair case JSON files.
"""

import argparse
import json
import os
from pathlib import Path
from typing import Dict, List

from langchain_community.vectorstores import Chroma
from langchain_core.documents import Document
from langchain_openai import OpenAIEmbeddings


REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_JSON_DIRECTORY = REPO_ROOT / "source"
DEFAULT_PERSIST_DIRECTORY = REPO_ROOT / "chroma_db"
DEFAULT_COLLECTION_NAME = "dafny_error_cases"


def get_api_config(args: argparse.Namespace) -> tuple[str, str]:
    api_key = args.api_key or os.getenv("OPENAI_API_KEY")
    base_url = args.base_url or os.getenv("OPENAI_BASE_URL", "https://api.openai.com/v1")

    if not api_key:
        raise ValueError(
            "Missing API key. Set OPENAI_API_KEY or pass --api-key."
        )

    return api_key, base_url


class DafnyErrorCaseLoader:
    """Load and process Dafny error repair cases."""

    def __init__(self, api_key: str, base_url: str):
        self.embeddings = OpenAIEmbeddings(
            model="text-embedding-3-small",
            openai_api_key=api_key,
            openai_api_base=base_url,
        )

    def load_json_files(self, directory: str) -> List[Document]:
        """Load all JSON files from a directory."""
        documents = []
        json_files = Path(directory).glob("*.json")

        for json_file in json_files:
            try:
                with open(json_file, "r", encoding="utf-8") as f:
                    data = json.load(f)
                doc = self._create_document(data, str(json_file))
                documents.append(doc)
                print(f"Successfully loaded: {json_file.name}")
            except Exception as e:
                print(f"Failed to load {json_file.name}: {e}")

        return documents

    def _create_document(self, data: Dict, source: str) -> Document:
        """Convert JSON data into a Document object."""
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
        persist_directory: str = str(DEFAULT_PERSIST_DIRECTORY),
        collection_name: str = DEFAULT_COLLECTION_NAME,
    ) -> Chroma:
        """Create a Chroma vector store."""
        print("\nCreating vector store...")
        print(f"- Number of documents: {len(documents)}")
        print(f"- Persist directory: {persist_directory}")
        print(f"- Collection name: {collection_name}")

        vectorstore = Chroma.from_documents(
            documents=documents,
            embedding=self.embeddings,
            persist_directory=persist_directory,
            collection_name=collection_name,
        )

        print("Vector store created successfully")
        return vectorstore


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build the Dafny error case JSON vector database."
    )
    parser.add_argument("--api-key", help="API key. Defaults to OPENAI_API_KEY.")
    parser.add_argument(
        "--base-url",
        help="API base URL. Defaults to OPENAI_BASE_URL or OpenAI's public API URL.",
    )
    parser.add_argument(
        "--json-directory",
        default=str(DEFAULT_JSON_DIRECTORY),
        help="Directory containing JSON case files.",
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
    return parser.parse_args()


def main():
    """Build the vector database."""
    args = parse_args()
    api_key, base_url = get_api_config(args)

    print("=" * 60)
    print("Dafny Error Cases Vector Database Builder")
    print("=" * 60)

    loader = DafnyErrorCaseLoader(api_key=api_key, base_url=base_url)

    print(f"\nLoading JSON files from {args.json_directory}...\n")
    documents = loader.load_json_files(args.json_directory)
    print(f"\nTotal documents loaded: {len(documents)}")

    if len(documents) == 0:
        print("\nNo documents found. Please check the directory path.")
        return

    loader.create_vectorstore(
        documents=documents,
        persist_directory=args.persist_directory,
        collection_name=args.collection_name,
    )

    print("\n" + "=" * 60)
    print("Database build complete")
    print("=" * 60)
    print(f"Database location: {args.persist_directory}")
    print(f"Collection name: {args.collection_name}")
    print(f"Number of documents: {len(documents)}")
    print("\nYou can now run search_database.py to test similarity search.")


if __name__ == "__main__":
    main()
