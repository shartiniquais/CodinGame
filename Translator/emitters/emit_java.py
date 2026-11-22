# Transforme l'AST central en code Java.
from ast_nodes import (
    Program,
    Assign,
    If,
    While,
    ForRange,
    ExprStmt,
    Print,
    Return,
    FunctionDef,
    Break,
    Continue,
    Pass,
    AssignIndex,
    Var,
    IntLiteral,
    StringLiteral,
    BoolLiteral,
    ListLiteral,
    IndexAccess,
    BinaryOp,
    UnaryOp,
    Call,
    MethodCall,
)


class JavaEmitter:
    def __init__(self):
        self.lines = []
        self.indent_level = 0

    # =========================
    # Public entry point
    # =========================

    def emit_program(self, program: Program) -> str:
        self.lines = []
        self.indent_level = 0

        functions = []
        top_level_statements = []

        for stmt in program.body:
            if isinstance(stmt, FunctionDef):
                functions.append(stmt)
            else:
                top_level_statements.append(stmt)

        self.lines.append("import java.util.*;")
        self.lines.append("")
        self.lines.append("class Player {")
        self.indent_level += 1

        for function in functions:
            self.emit_function_def(function)
            self.emit_line()

        self.emit_main(top_level_statements)

        self.indent_level -= 1
        self.lines.append("}")

        return "\n".join(self.lines)

    # =========================
    # Helpers
    # =========================

    def emit_line(self, line: str = ""):
        self.lines.append("    " * self.indent_level + line)

    def map_type(self, type_name: str) -> str:
        if type_name == "int":
            return "int"
        if type_name == "str":
            return "String"
        if type_name == "bool":
            return "boolean"

        if type_name == "list[int]":
            return "ArrayList<Integer>"
        if type_name == "list[str]":
            return "ArrayList<String>"
        if type_name == "list[bool]":
            return "ArrayList<Boolean>"

        raise NotImplementedError(f"Java type mapping not supported for: {type_name}")

    def emit_main(self, statements):
        self.emit_line("public static void main(String[] args) {")
        self.indent_level += 1

        self.emit_line("Scanner in = new Scanner(System.in);")

        for stmt in statements:
            self.emit_statement(stmt)

        self.indent_level -= 1
        self.emit_line("}")

    # =========================
    # Statements
    # =========================

    def emit_statement(self, stmt):
        if isinstance(stmt, Assign):
            self.emit_assign(stmt)
            return

        if isinstance(stmt, AssignIndex):
            self.emit_assign_index(stmt)
            return

        if isinstance(stmt, If):
            self.emit_if(stmt)
            return

        if isinstance(stmt, While):
            self.emit_while(stmt)
            return

        if isinstance(stmt, ForRange):
            self.emit_for_range(stmt)
            return

        if isinstance(stmt, ExprStmt):
            expr_code = self.emit_expression(stmt.expr)
            self.emit_line(f"{expr_code};")
            return

        if isinstance(stmt, Print):
            value_code = self.emit_expression(stmt.value)
            self.emit_line(f"System.out.println({value_code});")
            return

        if isinstance(stmt, Return):
            if stmt.value is None:
                self.emit_line("return;")
            else:
                value_code = self.emit_expression(stmt.value)
                self.emit_line(f"return {value_code};")
            return

        if isinstance(stmt, Break):
            self.emit_line("break;")
            return

        if isinstance(stmt, Continue):
            self.emit_line("continue;")
            return

        if isinstance(stmt, Pass):
            self.emit_line("// pass")
            return

        if isinstance(stmt, FunctionDef):
            raise RuntimeError("FunctionDef should be emitted separately, not inside emit_statement")

        raise NotImplementedError(
            f"Java emitter does not support statement: {type(stmt).__name__}"
        )

    def emit_assign(self, stmt: Assign):
        value_code = self.emit_expression(stmt.value)

        if stmt.declared_type is not None:
            java_type = self.map_type(stmt.declared_type)
            self.emit_line(f"{java_type} {stmt.target} = {value_code};")
        else:
            self.emit_line(f"{stmt.target} = {value_code};")

    def emit_assign_index(self, stmt: AssignIndex):
        collection_code = self.emit_expression(stmt.collection)
        index_code = self.emit_expression(stmt.index)
        value_code = self.emit_expression(stmt.value)

        # On choisit ici la syntaxe List Java (.set)
        self.emit_line(f"{collection_code}.set({index_code}, {value_code});")

    def emit_if(self, stmt: If):
        condition_code = self.emit_expression(stmt.condition)
        self.emit_line(f"if ({condition_code}) {{")
        self.indent_level += 1

        for inner_stmt in stmt.then_body:
            self.emit_statement(inner_stmt)

        self.indent_level -= 1
        self.emit_line("}")

        if stmt.else_body:
            self.emit_line("else {")
            self.indent_level += 1

            for inner_stmt in stmt.else_body:
                self.emit_statement(inner_stmt)

            self.indent_level -= 1
            self.emit_line("}")

    def emit_while(self, stmt: While):
        condition_code = self.emit_expression(stmt.condition)
        self.emit_line(f"while ({condition_code}) {{")
        self.indent_level += 1

        for inner_stmt in stmt.body:
            self.emit_statement(inner_stmt)

        self.indent_level -= 1
        self.emit_line("}")

    def emit_for_range(self, stmt: ForRange):
        start_code = self.emit_expression(stmt.start)
        end_code = self.emit_expression(stmt.end)
        step_code = self.emit_expression(stmt.step)

        self.emit_line(
            f"for ({stmt.var_name} = {start_code}; {stmt.var_name} < {end_code}; {stmt.var_name} += {step_code}) {{"
        )
        self.indent_level += 1

        for inner_stmt in stmt.body:
            self.emit_statement(inner_stmt)

        self.indent_level -= 1
        self.emit_line("}")

    def emit_function_def(self, stmt: FunctionDef):
        return_type = self.map_type(stmt.return_type) # pyright: ignore[reportArgumentType]
        params_code = ", ".join(
            f"{self.map_type(param.param_type)} {param.name}"
            for param in stmt.params
        )

        self.emit_line(f"public static {return_type} {stmt.name}({params_code}) {{")
        self.indent_level += 1

        for inner_stmt in stmt.body:
            self.emit_statement(inner_stmt)

        self.indent_level -= 1
        self.emit_line("}")

    # =========================
    # Expressions
    # =========================

    def emit_expression(self, expr):
        if isinstance(expr, Var):
            if expr.name == "True":
                return "true"
            if expr.name == "False":
                return "false"
            return expr.name

        if isinstance(expr, IntLiteral):
            return str(expr.value)

        if isinstance(expr, StringLiteral):
            escaped = (
                expr.value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\t", "\\t")
            )
            return f"\"{escaped}\""

        if isinstance(expr, BoolLiteral):
            return "true" if expr.value else "false"

        if isinstance(expr, ListLiteral):
            return self.emit_list_literal(expr)

        if isinstance(expr, IndexAccess):
            collection_code = self.emit_expression(expr.collection)
            index_code = self.emit_expression(expr.index)
            return f"{collection_code}.get({index_code})"

        if isinstance(expr, BinaryOp):
            left_code = self.emit_expression(expr.left)
            right_code = self.emit_expression(expr.right)

            op = expr.op
            if op == "and":
                op = "&&"
            elif op == "or":
                op = "||"

            return f"({left_code} {op} {right_code})"

        if isinstance(expr, UnaryOp):
            operand_code = self.emit_expression(expr.operand)

            if expr.op == "not":
                return f"(!{operand_code})"

            return f"({expr.op}{operand_code})"

        if isinstance(expr, Call):
            return self.emit_call(expr)

        if isinstance(expr, MethodCall):
            return self.emit_method_call(expr)

        raise NotImplementedError(
            f"Java emitter does not support expression: {type(expr).__name__}"
        )

    def emit_list_literal(self, expr: ListLiteral) -> str:
        elements_code = ", ".join(self.emit_expression(element) for element in expr.elements)
        return f"new ArrayList<>(Arrays.asList({elements_code}))"

    def emit_call(self, expr: Call):
        if expr.func_name == "input":
            return "in.nextLine()"

        if expr.func_name == "int":
            if len(expr.args) != 1:
                raise NotImplementedError("int(...) expects exactly one argument")
            arg_code = self.emit_expression(expr.args[0])
            return f"Integer.parseInt({arg_code})"

        if expr.func_name == "str":
            if len(expr.args) != 1:
                raise NotImplementedError("str(...) expects exactly one argument")
            arg_code = self.emit_expression(expr.args[0])
            return f"String.valueOf({arg_code})"

        if expr.func_name == "bool":
            if len(expr.args) != 1:
                raise NotImplementedError("bool(...) expects exactly one argument")
            arg_code = self.emit_expression(expr.args[0])
            return f"Boolean.parseBoolean({arg_code})"

        if expr.func_name == "len":
            if len(expr.args) != 1:
                raise NotImplementedError("len(...) expects exactly one argument")
            arg_code = self.emit_expression(expr.args[0])
            return f"{arg_code}.size()"

        args_code = ", ".join(self.emit_expression(arg) for arg in expr.args)
        return f"{expr.func_name}({args_code})"

    def emit_method_call(self, expr: MethodCall):
        receiver_code = self.emit_expression(expr.receiver)
        args_code = ", ".join(self.emit_expression(arg) for arg in expr.args)

        if expr.method_name == "append":
            return f"{receiver_code}.add({args_code})"

        return f"{receiver_code}.{expr.method_name}({args_code})"