"""
增强的错误分类器 - 细化错误类型并添加更多模式
"""
from typing import List, Dict, Tuple
from enum import Enum


class ErrorType(Enum):
    """错误类型枚举"""
    # 语法类错误
    SYNTAX_ERROR = "syntax_error"
    PARSE_ERROR = "parse_error"
    TYPE_MISMATCH = "type_mismatch"
    UNDEFINED_IDENTIFIER = "undefined_identifier"
    INVALID_EXPRESSION = "invalid_expression"  # 新增
    
    # 验证类错误
    LOOP_INVARIANT = "loop_invariant"
    TERMINATION = "termination"  # decreases clause
    PRECONDITION = "precondition"
    POSTCONDITION = "postcondition"
    ASSERTION = "assertion"
    ARRAY_BOUNDS = "array_bounds"
    NULL_DEREFERENCE = "null_dereference"
    
    # 其他
    UNKNOWN = "unknown"


class ErrorClassifier:
    """增强的错误分类器"""
    
    def __init__(self):
        # 定义每种错误类型的关键词模式
        self.patterns = {
            # 语法类 - 按优先级排序(越具体的越靠前)
            ErrorType.INVALID_EXPRESSION: [
                "invalid unaryexpression",
                "invalid binaryexpression",
                "invalid expression",
                "invalid lvalue",
                "invalid statement",
            ],
            ErrorType.PARSE_ERROR: [
                "parse error",
                "unexpected token",
                "expected",
                "invalid syntax",
                "syntax error"
            ],
            ErrorType.UNDEFINED_IDENTIFIER: [
                "unresolved identifier",
                "undefined",
                "not declared",
                "undeclared identifier",
                "member does not exist"
            ],
            ErrorType.TYPE_MISMATCH: [
                "type mismatch",
                "type error",
                "cannot convert",
                "incompatible types",
                "expected type",
                "actual type"
            ],
            
            # 验证类
            ErrorType.LOOP_INVARIANT: [
                "loop invariant",
                "invariant",
                "might not be maintained",
                "might not hold on entry"
            ],
            ErrorType.TERMINATION: [
                "decreases",
                "termination",
                "might not decrease",
                "cannot prove termination"
            ],
            ErrorType.PRECONDITION: [
                "precondition",
                "requires",
                "might not hold",
                "precondition might not hold"
            ],
            ErrorType.POSTCONDITION: [
                "postcondition",
                "ensures",
                "might not be satisfied",
                "postcondition might not hold"
            ],
            ErrorType.ASSERTION: [
                "assertion",
                "assert",
                "assertion might not hold",
                "assertion violation"
            ],
            ErrorType.ARRAY_BOUNDS: [
                "index out of bounds",
                "array index",
                "sequence index"
            ],
            ErrorType.NULL_DEREFERENCE: [
                "null",
                "might be null",
                "dereference"
            ]
        }
    
    def classify_single_error(self, error_msg: str) -> ErrorType:
        """分类单个错误"""
        error_lower = error_msg.lower()
        
        # 按优先级匹配(越具体的越优先)
        # 语法错误优先级: invalid_expression > parse_error > undefined > type_mismatch
        priority_order = [
            ErrorType.INVALID_EXPRESSION,
            ErrorType.PARSE_ERROR,
            ErrorType.UNDEFINED_IDENTIFIER,
            ErrorType.TYPE_MISMATCH,
            ErrorType.LOOP_INVARIANT,
            ErrorType.TERMINATION,
            ErrorType.PRECONDITION,
            ErrorType.POSTCONDITION,
            ErrorType.ASSERTION,
            ErrorType.ARRAY_BOUNDS,
            ErrorType.NULL_DEREFERENCE,
        ]
        
        for error_type in priority_order:
            keywords = self.patterns.get(error_type, [])
            for keyword in keywords:
                if keyword in error_lower:
                    return error_type
        
        return ErrorType.UNKNOWN
    
    def classify_errors(self, verifier_errors: List[str]) -> Dict:
        """
        分类所有错误并统计
        
        Returns:
            {
                'primary_type': ErrorType,  # 主要错误类型
                'all_types': List[ErrorType],  # 所有错误类型
                'type_counts': Dict[ErrorType, int],  # 每种类型的数量
                'is_syntax_error': bool,  # 是否包含语法错误
                'is_verification_error': bool  # 是否包含验证错误
            }
        """
        if not verifier_errors:
            return {
                'primary_type': ErrorType.UNKNOWN,
                'all_types': [],
                'type_counts': {},
                'is_syntax_error': False,
                'is_verification_error': False
            }
        
        # 分类每个错误
        all_types = []
        type_counts = {}
        
        for error in verifier_errors:
            error_type = self.classify_single_error(error)
            all_types.append(error_type)
            type_counts[error_type] = type_counts.get(error_type, 0) + 1
        
        # 确定主要错误类型(出现最多的)
        primary_type = max(type_counts.items(), key=lambda x: x[1])[0]
        
        # 判断是否包含语法/验证错误
        syntax_types = {
            ErrorType.SYNTAX_ERROR,
            ErrorType.PARSE_ERROR,
            ErrorType.TYPE_MISMATCH,
            ErrorType.UNDEFINED_IDENTIFIER,
            ErrorType.INVALID_EXPRESSION,  # 新增
        }
        
        is_syntax_error = any(t in syntax_types for t in all_types)
        is_verification_error = any(t not in syntax_types for t in all_types)
        
        return {
            'primary_type': primary_type,
            'all_types': all_types,
            'type_counts': type_counts,
            'is_syntax_error': is_syntax_error,
            'is_verification_error': is_verification_error
        }
    
    def get_error_description(self, error_type: ErrorType) -> str:
        """获取错误类型的描述"""
        descriptions = {
            ErrorType.LOOP_INVARIANT: "循环不变量不成立",
            ErrorType.TERMINATION: "终止性证明失败",
            ErrorType.PRECONDITION: "前置条件不满足",
            ErrorType.POSTCONDITION: "后置条件不满足",
            ErrorType.ASSERTION: "断言失败",
            ErrorType.UNDEFINED_IDENTIFIER: "未定义的标识符",
            ErrorType.TYPE_MISMATCH: "类型不匹配",
            ErrorType.PARSE_ERROR: "解析错误",
            ErrorType.ARRAY_BOUNDS: "数组越界",
            ErrorType.NULL_DEREFERENCE: "空指针引用",
            ErrorType.INVALID_EXPRESSION: "无效的表达式",
            ErrorType.SYNTAX_ERROR: "语法错误"
        }
        return descriptions.get(error_type, "未知错误")