# Transforme l'AST central en code C.
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


class CTypeEnv:
    def __init__(self):
        self.scopes = [{}]

    def push(self):
        self.scopes.append({})

    def pop(self):
        if len(self.scopes) == 1:
            raise RuntimeError("Cannot pop global scope")
        self.scopes.pop()

    def declare(self, name: str, type_name: str):
        self.scopes[-1][name] = type_name

    def lookup(self, name: str) -> str | None:
        for scope in reversed(self.scopes):
            if name in scope:
                return scope[name]
        return None


class CEmitter:
    STRING_BUFFER_SIZE = 1024

    def __init__(self):
        self.lines = []
        self.indent_level = 0
        self.type_env = CTypeEnv()

    # =========================
    # Public entry point
    # =========================

    def emit_program(self, program: Program) -> str:
        self.lines = []
        self.indent_level = 0
        self.type_env = CTypeEnv()

        functions = []
        top_level_statements = []

        for stmt in program.body:
            if isinstance(stmt, FunctionDef):
                functions.append(stmt)
            else:
                top_level_statements.append(stmt)

        self.emit_headers()
        self.emit_helpers()

        for function in functions:
            self.emit_function_def(function)
            self.emit_line()

        self.emit_main(top_level_statements)

        return "\n".join(self.lines)

    # =========================
    # Boilerplate
    # =========================

    def emit_headers(self):
        self.lines.append("#include <stdio.h>")
        self.lines.append("#include <stdlib.h>")
        self.lines.append("#include <string.h>")
        self.lines.append("")
        self.lines.append(f"#define STRING_BUFFER_SIZE {self.STRING_BUFFER_SIZE}")
        self.lines.append("")

    def emit_helpers(self):
        self.lines.append("void read_line(char *buffer, int size) {")
        self.lines.append("    if (fgets(buffer, size, stdin) == NULL) {")
        self.lines.append("        buffer[0] = '\\0';")
        self.lines.append("        return;")
        self.lines.append("    }")
        self.lines.append("")
        self.lines.append("    size_t len = strlen(buffer);")
        self.lines.append("    if (len > 0 && buffer[len - 1] == '\\n') {")
        self.lines.append("        buffer[len - 1] = '\\0';")
        self.lines.append("    }")
        self.lines.append("}")
        self.lines.append("")
        self.lines.append("int read_int(void) {")
        self.lines.append(f"    char buffer[STRING_BUFFER_SIZE];")
        self.lines.append("    read_line(buffer, STRING_BUFFER_SIZE);")
        self.lines.append("    return atoi(buffer);")
        self.lines.append("}")
        self.lines.append("")

    def emit_main(self, statements):
        self.lines.append("int main(void) {")
        self.indent_level += 1
        self.type_env.push()

        for stmt in statements:
            self.emit_statement(stmt)

        self.emit_line("return 0;")

        self.type_env.pop()
        self.indent_level -= 1
        self.lines.append("}")

    # =========================
    # Helpers
    # =========================

    def emit_line(self, line: str = ""):
        self.lines.append("    " * self.indent_level + line)

    def map_type(self, type_name: str) -> str:
        if type_name == "int":
            return "int"
        if type_name == "bool":
            return "int"
        if type_name == "str":
            return "char"
        raise NotImplementedError(f"C type mapping not supported for: {type_name}")

    def infer_expr_type(self, expr) -> str:
        if isinstance(expr, IntLiteral):
            return "int"

        if isinstance(expr, StringLiteral):
            return "str"

        if isinstance(expr, BoolLiteral):
            return "bool"

        if isinstance(expr, Var):
            var_type = self.type_env.lookup(expr.name)
            if var_type is None:
                raise ValueError(f"Unknown variable type for '{expr.name}'")
            return var_type

        if isinstance(expr, BinaryOp):
            if expr.op in {"<", "<=", ">", ">=", "==", "!=", "and", "or"}:
                return "bool"
            return "int"

        if isinstance(expr, UnaryOp):
            if expr.op == "not":
                return "bool"
            return self.infer_expr_type(expr.operand)

        if isinstance(expr, Call):
            if expr.func_name == "input":
                return "str"
            if expr.func_name == "int":
                return "int"
            if expr.func_name == "bool":
                return "bool"
            if expr.func_name == "str":
                return "str"

            func_type = self.type_env.lookup(expr.func_name)
            if func_type == "function":
                # Pas assez d'info ici pour connaître le vrai type de retour.
                raise NotImplementedError(
                    f"Return type lookup for function '{expr.func_name}' is not implemented yet"
                )

        raise NotImplementedError(
            f"C type inference not supported for expression: {type(expr).__name__}"
        )

    def emit_string_literal(self, value: str) -> str:
        escaped = (
            value
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\t", "\\t")
        )
        return f"\"{escaped}\""

    # =========================
    # Statements
    # =========================

    def emit_statement(self, stmt):
        if isinstance(stmt, Assign):
            self.emit_assign(stmt)
            return

        if isinstance(stmt, AssignIndex):
            raise NotImplementedError("AssignIndex is not supported yet in C emitter")

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
            self.emit_print(stmt)
            return

        if isinstance(stmt, Return):
            self.emit_return(stmt)
            return

        if isinstance(stmt, Break):
            self.emit_line("break;")
            return

        if isinstance(stmt, Continue):
            self.emit_line("continue;")
            return

        if isinstance(stmt, Pass):
            self.emit_line("/* pass */")
            return

        if isinstance(stmt, FunctionDef):
            raise RuntimeError("FunctionDef should be emitted separately")

        raise NotImplementedError(
            f"C emitter does not support statement: {type(stmt).__name__}"
        )

    def emit_assign(self, stmt: Assign):
        if stmt.declared_type is not None:
            self.type_env.declare(stmt.target, stmt.declared_type)

            if stmt.declared_type == "str":
                self.emit_line(f"char {stmt.target}[STRING_BUFFER_SIZE];")
                self.emit_assign_to_existing_string(stmt.target, stmt.value)
                return

            c_type = self.map_type(stmt.declared_type)
            value_code = self.emit_expression(stmt.value)
            self.emit_line(f"{c_type} {stmt.target} = {value_code};")
            return

        existing_type = self.type_env.lookup(stmt.target)
        if existing_type is None:
            raise ValueError(f"Variable '{stmt.target}' used without declaration")

        if existing_type == "str":
            self.emit_assign_to_existing_string(stmt.target, stmt.value)
            return

        value_code = self.emit_expression(stmt.value)
        self.emit_line(f"{stmt.target} = {value_code};")

    def emit_assign_to_existing_string(self, target_name: str, value_expr):
        if isinstance(value_expr, Call) and value_expr.func_name == "input":
            self.emit_line(f"read_line({target_name}, STRING_BUFFER_SIZE);")
            return

        if isinstance(value_expr, StringLiteral):
            literal_code = self.emit_string_literal(value_expr.value)
            self.emit_line(f"strcpy({target_name}, {literal_code});")
            return

        value_code = self.emit_expression(value_expr)
        self.emit_line(f"strcpy({target_name}, {value_code});")

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

    def emit_print(self, stmt: Print):
        value_type = self.infer_expr_type(stmt.value)
        value_code = self.emit_expression(stmt.value)

        if value_type == "int" or value_type == "bool":
            self.emit_line(f'printf("%d\\n", {value_code});')
            return

        if value_type == "str":
            self.emit_line(f'printf("%s\\n", {value_code});')
            return

        raise NotImplementedError(f"Print not supported for type: {value_type}")

    def emit_return(self, stmt: Return):
        if stmt.value is None:
            self.emit_line("return;")
            return

        value_code = self.emit_expression(stmt.value)
        self.emit_line(f"return {value_code};")

    def emit_function_def(self, stmt: FunctionDef):
        if stmt.return_type == "str":
            raise NotImplementedError(
                "C emitter does not support functions returning str yet"
            )

        return_type = self.map_type(stmt.return_type) # pyright: ignore[reportArgumentType]

        params_code_parts = []
        for param in stmt.params:
            if param.param_type == "str":
                params_code_parts.append(f"char {param.name}[STRING_BUFFER_SIZE]")
            else:
                params_code_parts.append(f"{self.map_type(param.param_type)} {param.name}")

        params_code = ", ".join(params_code_parts)
        self.lines.append(f"{return_type} {stmt.name}({params_code}) {{")

        self.indent_level += 1
        self.type_env.push()
        self.type_env.declare(stmt.name, "function")

        for param in stmt.params:
            self.type_env.declare(param.name, param.param_type)

        for inner_stmt in stmt.body:
            self.emit_statement(inner_stmt)

        self.type_env.pop()
        self.indent_level -= 1
        self.lines.append("}")

    # =========================
    # Expressions
    # =========================

    def emit_expression(self, expr):
        if isinstance(expr, Var):
            if expr.name == "True":
                return "1"
            if expr.name == "False":
                return "0"
            return expr.name

        if isinstance(expr, IntLiteral):
            return str(expr.value)

        if isinstance(expr, StringLiteral):
            return self.emit_string_literal(expr.value)

        if isinstance(expr, BoolLiteral):
            return "1" if expr.value else "0"

        if isinstance(expr, ListLiteral):
            raise NotImplementedError("ListLiteral is not supported yet in C emitter")

        if isinstance(expr, IndexAccess):
            raise NotImplementedError("IndexAccess is not supported yet in C emitter")

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
            raise NotImplementedError("MethodCall is not supported yet in C emitter")

        raise NotImplementedError(
            f"C emitter does not support expression: {type(expr).__name__}"
        )

    def emit_call(self, expr: Call):
        if expr.func_name == "input":
            raise NotImplementedError(
                "input() cannot be emitted as a plain expression in C. "
                "Use it only in typed string assignments for now."
            )

        if expr.func_name == "int":
            if len(expr.args) != 1:
                raise NotImplementedError("int(...) expects exactly one argument")

            inner = expr.args[0]
            if isinstance(inner, Call) and inner.func_name == "input":
                return "read_int()"

            arg_code = self.emit_expression(inner)
            return f"atoi({arg_code})"

        if expr.func_name == "str":
            raise NotImplementedError("str(...) is not supported yet in C emitter")

        if expr.func_name == "bool":
            raise NotImplementedError("bool(...) is not supported yet in C emitter")

        if expr.func_name == "len":
            raise NotImplementedError("len(...) is not supported yet in C emitter")

        args_code = ", ".join(self.emit_expression(arg) for arg in expr.args)
        return f"{expr.func_name}({args_code})"