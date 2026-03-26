# DafnyRAG

**Automated Repair of Dafny Code via Retrieval-Augmented Generation and Iterative Verification**

> A system that iteratively repairs Dafny code by leveraging formal verification feedback and retrieval-augmented generation to improve formal specification accuracy.

---

## Overview

DafnyRAG is a novel framework that enhances LLM-based formal code generation through retrieval-augmented generation (RAG). It addresses the challenge of automatically generating and repairing formal specifications (loop invariants, pre/postconditions) in Dafny — a verification-aware programming language built on the Z3 SMT solver.

### Key Idea

Unlike standard generation methods, DafnyRAG employs a two-fold strategy:

1. **Heterogeneous Domain Knowledge Base** — A specialized knowledge base comprising static syntax rules, error theories, and dynamic repair cases to bridge the domain knowledge gap of general-purpose LLMs.
2. **Verification-Driven Iterative Repair Loop** — An error-aware retrieval routing mechanism coupled with a structured Chain-of-Thought protocol that not only fixes errors but also feeds successful repairs back into the knowledge base for continuous self-improvement.

### Framework

![framework_01](C:\Users\Lenovo\Desktop\framework_01.png)

## Results

Evaluated on the **MBPP-DFY-178** benchmark across three representative LLMs:

![image-20260326192742752](C:\Users\Lenovo\AppData\Roaming\Typora\typora-user-images\image-20260326192742752.png)

*verify@5 metric — percentage of programs successfully verified within 5 attempts.*

### Ablation Study Highlights

- **Self-Repair (No RAG):** 58.43% → External knowledge is critical for formal verification.
- **RAG-Only (No Repair Loop):** 65.17% → Iterative feedback loop is essential for complex logic.
- **Static-RAG (No Case Library):** 75.28% → Dynamic knowledge evolution provides +8.43%.
- **Uniform-RAG vs Error-Aware Routing:** 61.24% vs 71.35% → Error-aware routing avoids knowledge pollution (+10.11%).

## Project Structure

```
DafnyRAG/
├── DB/                      # Domain knowledge base
│   ├── syntax_rules/        # Static Syntax Rule Library
│   ├── error_theory/        # Static Error Theory Library
│   └── repair_cases/        # Dynamic Repair Case Library (JSON)
├── DafnyRAG/                # Core framework implementation
│   ├── retrieval/           # Error-aware retrieval routing
│   ├── repair/              # Verification-driven iterative repair
│   └── prompt/              # Structured CoT prompt templates
├── brittle-dafnybench/      # Benchmark data (MBPP-DFY-178)
├── source/                  # Source utilities and helpers
├── test_case/               # Test cases for evaluation
└── README.md
```

## Getting Started

### Prerequisites

- **Python** 3.8+
- **Dafny** 4.11.0
- **Ubuntu** 20.04 (recommended)
- API keys for at least one of: OpenAI (GPT-4o), Anthropic (Claude-4.5-Sonnet), or DeepSeek (DeepSeek-V3)

### Installation

```bash
# Clone the repository
git clone https://github.com/netshells1/DafnyRAG.git
cd DafnyRAG

# Install Python dependencies
pip install -r requirements.txt

# Install Dafny 4.11.0
# See https://github.com/dafny-lang/dafny/releases/tag/v4.11.0
```

### Configuration

Set your LLM API key as an environment variable:

```bash
export OPENAI_API_KEY="your-key-here"
# or
export ANTHROPIC_API_KEY="your-key-here"
# or
export DEEPSEEK_API_KEY="your-key-here"
```

### Usage

```bash
# Run DafnyRAG on the MBPP-DFY-178 benchmark
python main.py --model gpt-4o --max_iterations 5 --temperature 0.5

# Run with a specific task
python main.py --model gpt-4o --task_id 1 --max_iterations 5
```

## Repair Case Schema

Each successful repair is stored as a structured JSON record in the Repair Case Library:

```json
{
  "task_id": "...",
  "task_description": "...",
  "method_signature": "...",
  "test_cases": { "test_1": "...", "test_2": "...", "test_3": "..." },
  "buggy_code": "...",
  "verifier_error": ["..."],
  "error_categories": ["..."],
  "primary_error": {
    "message": "...",
    "line": "...",
    "context": "..."
  },
  "repair_strategy": {
    "problem_summary": "...",
    "problem_details": {
      "what": "...",
      "why": "...",
      "how": "..."
    }
  },
  "fixed_code": "..."
}
```

## Citation

If you use DafnyRAG in your research, please cite:

```bibtex
@inproceedings{dafnyrag2026,
  title     = {Automated Repair of Dafny Code via Retrieval-Augmented Generation and Iterative Verification},
  author    = {Anonymous},
  booktitle = {Proceedings of the 41st IEEE/ACM International Conference on Automated Software Engineering (ASE)},
  year      = {2026}
}
```

## License

This project is for research purposes. Please see the repository for license details.
