from dataclasses import dataclass
from typing import Any
import ast


# ============================================================
# Universal IR - Core nodes
# ============================================================
# The goal of this file is to convert a small, controlled subset
# of Python into a universal intermediate representation.
#
# This IR should not keep Python-specific details when possible.
# For example:
#   sys.stdin.readline() -> read_line()
#   print(x)             -> write(x)
#   arr.append(x)        -> array_push(arr, x)
#
# Later, this IR can be emitted to C, Java, JavaScript, C++, etc.
# ============================================================


# ============================================================
# Program
# ============================================================

@dataclass
class Program:
    statements: list


# ============================================================
# Variables
# ============================================================

@dataclass
class Variable:
    name: str


@dataclass
class Assign:
    target: Any
    value: Any
    declared_type: str | None = None


# ============================================================
# Values
# ============================================================

@dataclass
class Constant:
    value: Any


# ============================================================
# Functions
# ============================================================

@dataclass
class Function:
    name: str
    parameters: list[str]
    body: list
    return_type: str | None = None


@dataclass
class Return:
    value: Any | None


# ============================================================
# Function calls
# ============================================================

@dataclass
class Call:
    name: str
    arguments: list


# ============================================================
# Control flow
# ============================================================

@dataclass
class If:
    condition: Any
    body: list
    else_body: list


@dataclass
class While:
    condition: Any
    body: list


@dataclass
class ForRange:
    variable: Variable
    start: Any
    end: Any
    body: list


@dataclass
class Continue:
    pass


@dataclass
class Break:
    pass


# ============================================================
# Lists / indexing
# ============================================================

@dataclass
class ListLiteral:
    elements: list


@dataclass
class Index:
    collection: Any
    index: Any


# ============================================================
# Operations
# ============================================================

@dataclass
class BinaryOp:
    left: Any
    operator: str
    right: Any


@dataclass
class Compare:
    left: Any
    operator: str
    right: Any


@dataclass
class UnaryOp:
    operator: str
    operand: Any


# ============================================================
# Parser entry points
# ============================================================

def parse_program(code: str) -> Program:
    """Parse Python source code into a universal IR Program."""
    tree = ast.parse(code)
    statements = []

    for node in tree.body:
        statement = parse_node(node)

        # Imports are ignored because they are Python-specific.
        if statement is not None:
            statements.append(statement)

    return Program(statements)


def parse_block(nodes: list) -> list:
    """Parse a list of Python AST statements into a list of IR statements."""
    statements = []

    for node in nodes:
        statement = parse_node(node)

        if statement is not None:
            statements.append(statement)

    return statements


# ============================================================
# Statement parser
# ============================================================

def parse_node(node: ast.AST) -> Any:
    """Parse a Python AST statement into an IR statement."""

    # -------------------------
    # Imports
    # -------------------------
    # Imports are not part of the universal IR.
    # Specific Python calls are normalized later instead.

    if isinstance(node, ast.Import):
        return None

    if isinstance(node, ast.ImportFrom):
        return None

    # -------------------------
    # Assignment
    # -------------------------

    if isinstance(node, ast.Assign):
        return Assign(
            target=parse_expr(node.targets[0]),
            value=parse_expr(node.value)
        )

    if isinstance(node, ast.AnnAssign):
        return Assign(
            target=parse_expr(node.target),
            value=parse_expr(node.value) if node.value else None,
            declared_type=parse_type(node.annotation)
        )

    # -------------------------
    # Functions
    # -------------------------

    if isinstance(node, ast.FunctionDef):
        parameters = []

        for arg in node.args.args:
            parameters.append(arg.arg)

        return Function(
            name=node.name,
            parameters=parameters,
            body=parse_block(node.body),
            return_type=parse_type(node.returns) if node.returns else None
        )

    if isinstance(node, ast.Return):
        return Return(parse_expr(node.value) if node.value else None)

    # -------------------------
    # Expression statement
    # -------------------------

    if isinstance(node, ast.Expr):
        return parse_expr(node.value)

    # -------------------------
    # Control flow
    # -------------------------

    if isinstance(node, ast.If):
        return If(
            condition=parse_expr(node.test),
            body=parse_block(node.body),
            else_body=parse_block(node.orelse)
        )

    if isinstance(node, ast.While):
        return While(
            condition=parse_expr(node.test),
            body=parse_block(node.body)
        )

    if isinstance(node, ast.For):
        return parse_for_range(node)

    if isinstance(node, ast.Continue):
        return Continue()

    if isinstance(node, ast.Break):
        return Break()

    raise Exception(f"Unsupported node: {type(node).__name__}")


def parse_for_range(node: ast.For) -> ForRange:
    """Parse only for-loops of the form: for i in range(...)."""

    if not isinstance(node.iter, ast.Call):
        raise Exception("Only for ... in range(...) is supported")

    if not isinstance(node.iter.func, ast.Name):
        raise Exception("Only for ... in range(...) is supported")

    if node.iter.func.id != "range":
        raise Exception("Only range(...) loops are supported")

    args = node.iter.args

    if len(args) == 1:
        start = Constant(0)
        end = parse_expr(args[0])
    elif len(args) == 2:
        start = parse_expr(args[0])
        end = parse_expr(args[1])
    else:
        raise Exception("Only range(end) and range(start, end) are supported")

    return ForRange(
        variable=parse_expr(node.target),
        start=start,
        end=end,
        body=parse_block(node.body)
    )


# ============================================================
# Expression parser
# ============================================================

def parse_expr(node: ast.AST) -> Any:
    """Parse a Python AST expression into an IR expression."""

    # -------------------------
    # Variables / constants
    # -------------------------

    if isinstance(node, ast.Name):
        return Variable(node.id)

    if isinstance(node, ast.Constant):
        return Constant(node.value)

    # -------------------------
    # List literals
    # -------------------------

    if isinstance(node, ast.List):
        return ListLiteral([parse_expr(element) for element in node.elts])

    # -------------------------
    # Indexing
    # -------------------------
    # Supports:
    #   arr[i]
    #   matrix[y][x]

    if isinstance(node, ast.Subscript):
        return Index(
            collection=parse_expr(node.value),
            index=parse_expr(node.slice)
        )

    # -------------------------
    # Function / method calls
    # -------------------------

    if isinstance(node, ast.Call):
        return parse_call(node)

    # -------------------------
    # Binary operations
    # -------------------------

    if isinstance(node, ast.BinOp):
        return BinaryOp(
            left=parse_expr(node.left),
            operator=parse_operator(node.op),
            right=parse_expr(node.right)
        )

    # -------------------------
    # Unary operations
    # -------------------------
    # Supports values like:
    #   -1
    #   +1
    #   not condition

    if isinstance(node, ast.UnaryOp):
        return UnaryOp(
            operator=parse_operator(node.op),
            operand=parse_expr(node.operand)
        )

    # -------------------------
    # Comparisons
    # -------------------------

    if isinstance(node, ast.Compare):
        if len(node.ops) != 1:
            raise Exception("Chained comparisons are not supported yet")

        return Compare(
            left=parse_expr(node.left),
            operator=parse_operator(node.ops[0]),
            right=parse_expr(node.comparators[0])
        )

    raise Exception(f"Unsupported expression: {type(node).__name__}")


def parse_call(node: ast.Call) -> Call:
    """Parse and normalize Python calls into universal IR calls."""
    full_name = parse_call_name(node.func)
    args = [parse_expr(arg) for arg in node.args]

    # -------------------------
    # Python input normalization
    # -------------------------
    # sys.stdin.readline() -> read_line()

    if full_name == "sys.stdin.readline":
        return Call(name="read_line", arguments=[])

    # -------------------------
    # Python output normalization
    # -------------------------
    # print(x) -> write(x)

    if full_name == "print":
        return Call(name="write", arguments=args)

    # -------------------------
    # String normalization
    # -------------------------
    # line.split()       -> string_split(line)
    # line.rstrip("\n") -> string_rstrip(line, "\n")

    if full_name.endswith(".split"):
        receiver_name = full_name.removesuffix(".split")
        return Call(
            name="string_split",
            arguments=[Variable(receiver_name)] + args
        )

    if full_name.endswith(".rstrip"):
        receiver_name = full_name.removesuffix(".rstrip")
        return Call(
            name="string_rstrip",
            arguments=[Variable(receiver_name)] + args
        )

    # -------------------------
    # Array normalization
    # -------------------------
    # arr.append(x) -> array_push(arr, x)

    if full_name.endswith(".append"):
        receiver_name = full_name.removesuffix(".append")
        return Call(
            name="array_push",
            arguments=[Variable(receiver_name)] + args
        )

    # -------------------------
    # Length normalization
    # -------------------------
    # len(arr) -> length(arr)

    if full_name == "len":
        return Call(name="length", arguments=args)

    return Call(name=full_name, arguments=args)


def parse_call_name(node: ast.AST) -> str:
    """Return the full dotted Python name of a call target."""

    if isinstance(node, ast.Name):
        return node.id

    if isinstance(node, ast.Attribute):
        return parse_call_name(node.value) + "." + node.attr

    raise Exception(f"Unsupported call name: {type(node).__name__}")


# ============================================================
# Type / operator helpers
# ============================================================

def parse_type(node: ast.AST) -> str:
    """Parse a type annotation into a simple string."""

    if isinstance(node, ast.Name):
        return node.id

    return "unknown"


def parse_operator(node: ast.AST) -> str:
    """Parse Python operators into universal operator strings."""

    operators = {
        ast.Add: "+",
        ast.Sub: "-",
        ast.Mult: "*",
        ast.Div: "/",
        ast.FloorDiv: "//",
        ast.Mod: "%",
        ast.Eq: "==",
        ast.NotEq: "!=",
        ast.Lt: "<",
        ast.LtE: "<=",
        ast.Gt: ">",
        ast.GtE: ">=",
        ast.USub: "-",
        ast.UAdd: "+",
        ast.Not: "not ",
    }

    operator_type = type(node)

    if operator_type in operators:
        return operators[operator_type]

    raise Exception(f"Unsupported operator: {operator_type.__name__}")


# ============================================================
# IR Pretty Printer
# ============================================================
# This part converts the IR objects into readable text.
# It is only for debugging and understanding the IR.
# Later, emitters like emit_c(), emit_java(), emit_js() will follow
# the same kind of structure, but output real code instead.
# ============================================================

def ir_to_string(node: Any, indent: int = 0) -> str:
    """Convert an IR node into a readable debug string."""
    prefix = "  " * indent

    # -------------------------
    # Program
    # -------------------------

    if isinstance(node, Program):
        lines = []

        for statement in node.statements:
            lines.append(ir_to_string(statement, indent))

        return "\n".join(lines)

    # -------------------------
    # Variables / values
    # -------------------------

    if isinstance(node, Variable):
        return node.name

    if isinstance(node, Constant):
        if isinstance(node.value, str):
            return repr(node.value)

        return str(node.value)

    # -------------------------
    # Assignment
    # -------------------------

    if isinstance(node, Assign):
        type_part = ""

        if node.declared_type is not None:
            type_part = ": " + node.declared_type

        return (
            prefix
            + "assign "
            + ir_to_string(node.target)
            + type_part
            + " = "
            + ir_to_string(node.value)
        )

    # -------------------------
    # Functions
    # -------------------------

    if isinstance(node, Function):
        params = ", ".join(node.parameters)
        return_part = ""

        if node.return_type is not None:
            return_part = " -> " + node.return_type

        lines = []
        lines.append(prefix + "function " + node.name + "(" + params + ")" + return_part)
        lines.append(prefix + "begin")

        for statement in node.body:
            lines.append(ir_to_string(statement, indent + 1))

        lines.append(prefix + "end")

        return "\n".join(lines)

    if isinstance(node, Return):
        if node.value is None:
            return prefix + "return"

        return prefix + "return " + ir_to_string(node.value)

    # -------------------------
    # Calls
    # -------------------------

    if isinstance(node, Call):
        args = []

        for argument in node.arguments:
            args.append(ir_to_string(argument))

        return prefix + node.name + "(" + ", ".join(args) + ")"

    # -------------------------
    # Control flow
    # -------------------------

    if isinstance(node, If):
        lines = []

        lines.append(prefix + "if " + ir_to_string(node.condition))
        lines.append(prefix + "then")

        for statement in node.body:
            lines.append(ir_to_string(statement, indent + 1))

        if len(node.else_body) > 0:
            lines.append(prefix + "else")

            for statement in node.else_body:
                lines.append(ir_to_string(statement, indent + 1))

        lines.append(prefix + "end_if")

        return "\n".join(lines)

    if isinstance(node, While):
        lines = []

        lines.append(prefix + "while " + ir_to_string(node.condition))
        lines.append(prefix + "do")

        for statement in node.body:
            lines.append(ir_to_string(statement, indent + 1))

        lines.append(prefix + "end_while")

        return "\n".join(lines)

    if isinstance(node, ForRange):
        lines = []

        lines.append(
            prefix
            + "for "
            + ir_to_string(node.variable)
            + " in range("
            + ir_to_string(node.start)
            + ", "
            + ir_to_string(node.end)
            + ")"
        )
        lines.append(prefix + "do")

        for statement in node.body:
            lines.append(ir_to_string(statement, indent + 1))

        lines.append(prefix + "end_for")

        return "\n".join(lines)

    if isinstance(node, Continue):
        return prefix + "continue"

    if isinstance(node, Break):
        return prefix + "break"

    # -------------------------
    # Lists / indexing
    # -------------------------

    if isinstance(node, ListLiteral):
        elements = []

        for element in node.elements:
            elements.append(ir_to_string(element))

        return "[" + ", ".join(elements) + "]"

    if isinstance(node, Index):
        return ir_to_string(node.collection) + "[" + ir_to_string(node.index) + "]"

    # -------------------------
    # Operations
    # -------------------------

    if isinstance(node, BinaryOp):
        return (
            "("
            + ir_to_string(node.left)
            + " "
            + node.operator
            + " "
            + ir_to_string(node.right)
            + ")"
        )

    if isinstance(node, Compare):
        return (
            ir_to_string(node.left)
            + " "
            + node.operator
            + " "
            + ir_to_string(node.right)
        )

    if isinstance(node, UnaryOp):
        return "(" + node.operator + ir_to_string(node.operand) + ")"

    # -------------------------
    # Fallback
    # -------------------------

    raise Exception(f"Unsupported IR node for printing: {type(node).__name__}")


# ============================================================
# Example program
# ============================================================
# This example intentionally uses a Python style that is still
# quite close to real Codingame code, but without heavy Pythonisms
# like comprehensions, generators, next(...), deque, enumerate, etc.
# ============================================================

if __name__ == "__main__":
    python_code = """
import sys

MAP = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

DIRS = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1]
]

# Read width and height
line = sys.stdin.readline()
parts = line.split()
w = int(parts[0])
h = int(parts[1])

# Read maze
mz = []

for y in range(h):
    line = sys.stdin.readline()
    line = line.rstrip("\\n")

    row = []
    for x in range(w):
        row.append(line[x])

    mz.append(row)

# Find start position
sx = 0
sy = 0

for y in range(h):
    for x in range(w):
        if mz[y][x] == "S":
            sx = x
            sy = y

# Create distance grid
dist = []

for y in range(h):
    row = []

    for x in range(w):
        row.append(-1)

    dist.append(row)

dist[sy][sx] = 0

# Queue implementation without deque
queue_x = []
queue_y = []
queue_start = 0

queue_x.append(sx)
queue_y.append(sy)

# BFS
while queue_start < len(queue_x):
    x = queue_x[queue_start]
    y = queue_y[queue_start]
    queue_start = queue_start + 1

    d = dist[y][x] + 1

    for i in range(4):
        dx = DIRS[i][0]
        dy = DIRS[i][1]

        nx = (x + dx) % w
        ny = (y + dy) % h

        if mz[ny][nx] == "#":
            continue

        if dist[ny][nx] != -1:
            continue

        dist[ny][nx] = d

        queue_x.append(nx)
        queue_y.append(ny)

# Render result
for y in range(h):
    output = ""

    for x in range(w):
        if mz[y][x] == "#":
            output = output + "#"
        else:
            if dist[y][x] == -1:
                output = output + "."
            else:
                value = dist[y][x]
                output = output + MAP[value]

    print(output)
"""

    ir = parse_program(python_code)
    print(ir_to_string(ir))
