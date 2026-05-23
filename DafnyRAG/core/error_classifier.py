"""
Enhanced Error Classifier - Refined error types with additional patterns
"""
from typing import List, Dict, Tuple
from enum import Enum


class ErrorType(Enum):
    """Error type enumeration"""
    # Syntax errors
    SYNTAX_ERROR = "syntax_error"
    PARSE_ERROR = "parse_error"
    TYPE_MISMATCH = "type_mismatch"
    UNDEFINED_IDENTIFIER = "undefined_identifier"
    INVALID_EXPRESSION = "invalid_expression"  # New
    
    # Validation errors
    LOOP_INVARIANT = "loop_invariant"
    TERMINATION = "termination"  # decreases clause
    PRECONDITION = "precondition"
    POSTCONDITION = "postcondition"
    ASSERTION = "assertion"
    ARRAY_BOUNDS = "array_bounds"
    NULL_DEREFERENCE = "null_dereference"
    
    # Other
    UNKNOWN = "unknown"


class ErrorClassifier:
    """Enhanced error classifier"""
    
    def __init__(self):
        # Define keyword patterns for each error type
        self.patterns = {
            # Syntax errors - ordered by priority (more specific first)
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
            
            # Verification errors
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
        """Classify a single error"""
        error_lower = error_msg.lower()
        
        # Match by priority (more specific types take precedence)
        # Syntax error priority: invalid_expression > parse_error > undefined > type_mismatch
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
        Classify all errors and aggregate statistics.
        
        Returns:
            {
                'primary_type': ErrorType,        # Most frequent error type
                'all_types': List[ErrorType],     # All error types
                'type_counts': Dict[ErrorType, int],  # Count per error type
                'is_syntax_error': bool,          # Whether any syntax errors are present
                'is_verification_error': bool     # Whether any verification errors are present
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
        
        # Classify each error
        all_types = []
        type_counts = {}
        
        for error in verifier_errors:
            error_type = self.classify_single_error(error)
            all_types.append(error_type)
            type_counts[error_type] = type_counts.get(error_type, 0) + 1
        
        # Determine primary error type (most frequent)
        primary_type = max(type_counts.items(), key=lambda x: x[1])[0]
        
        # Check whether syntax or verification errors are present
        syntax_types = {
            ErrorType.SYNTAX_ERROR,
            ErrorType.PARSE_ERROR,
            ErrorType.TYPE_MISMATCH,
            ErrorType.UNDEFINED_IDENTIFIER,
            ErrorType.INVALID_EXPRESSION,  # New
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
        """Get a human-readable description for an error type"""
        descriptions = {
            ErrorType.LOOP_INVARIANT: "Loop invariant does not hold",
            ErrorType.TERMINATION: "Termination proof failed",
            ErrorType.PRECONDITION: "Precondition not satisfied",
            ErrorType.POSTCONDITION: "Postcondition not satisfied",
            ErrorType.ASSERTION: "Assertion failed",
            ErrorType.UNDEFINED_IDENTIFIER: "Undefined identifier",
            ErrorType.TYPE_MISMATCH: "Type mismatch",
            ErrorType.PARSE_ERROR: "Parse error",
            ErrorType.ARRAY_BOUNDS: "Array index out of bounds",
            ErrorType.NULL_DEREFERENCE: "Null pointer dereference",
            ErrorType.INVALID_EXPRESSION: "Invalid expression",
            ErrorType.SYNTAX_ERROR: "Syntax error"
        }
        return descriptions.get(error_type, "Unknown error")