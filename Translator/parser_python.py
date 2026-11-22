import ast

from ast_nodes import (
    Program,
    Assign,
    If,
    While,
    ForRange,
    ExprStmt,
    Print,
    Return,
    Param,
    FunctionDef,
    Break,
    Continue,
    Pass,
    ListLiteral,
    AssignIndex,
    IndexAccess,
    MethodCall,
    Var,
    IntLiteral,
    StringLiteral,
    BoolLiteral,
    BinaryOp,
    UnaryOp,
    Call,
)


class ScopeStack:
    def __init__(self):
        self.scopes: list[dict[str, str]] = [{}]

    def push(self) -> None:
        self.scopes.append({})

    def pop(self) -> None:
        if len(self.scopes) == 1:
            raise RuntimeError("Cannot pop global scope")
        self.scopes.pop()

    def declare(self, name: str, var_type: str) -> None:
        current = self.scopes[-1]
        if name in current:
            raise ValueError(f"Variable '{name}' is already declared in the current scope")
        current[name] = var_type

    def lookup(self, name: str) -> str | None:
        for scope in reversed(self.scopes):
            if name in scope:
                return scope[name]
        return None

    def exists_in_current_scope(self, name: str) -> bool:
        return name in self.scopes[-1]


class PythonToCentralParser:
    def __init__(self):
        self.scopes = ScopeStack()
        self.allowed_builtins = {
            "input",
            "int",
            "str",
            "bool",
            "len",
            "range",
            "print",
        }

    # =========================
    # Entrées principales
    # =========================

    def parse_file(self, filepath: str) -> Program:
        with open(filepath, "r", encoding="utf-8") as f:
            source = f.read()
        return self.parse_source(source)

    def parse_source(self, source: str) -> Program:
        py_tree = ast.parse(source)
        body = [self.parse_statement(stmt) for stmt in py_tree.body]
        return Program(body=body)  # pyright: ignore[reportArgumentType]

    # =========================
    # Statements
    # =========================

    def parse_statement(self, node: ast.stmt):
        if isinstance(node, ast.Assign):
            return self.parse_assign(node)

        if isinstance(node, ast.AnnAssign):
            return self.parse_ann_assign(node)

        if isinstance(node, ast.If):
            return self.parse_if(node)

        if isinstance(node, ast.While):
            return self.parse_while(node)

        if isinstance(node, ast.For):
            return self.parse_for(node)

        if isinstance(node, ast.Expr):
            return self.parse_expr_statement(node)

        if isinstance(node, ast.Return):
            return self.parse_return(node)

        if isinstance(node, ast.FunctionDef):
            return self.parse_function_def(node)

        if isinstance(node, ast.Break):
            return Break()

        if isinstance(node, ast.Continue):
            return Continue()

        if isinstance(node, ast.Pass):
            return Pass()

        raise NotImplementedError(
            f"Statement type not supported: {type(node).__name__}"
        )

    def parse_assign(self, node: ast.Assign):
        if len(node.targets) != 1:
            raise NotImplementedError(
                "Only assignments with exactly one target are supported"
            )

        target = node.targets[0]
        value = self.parse_expression(node.value)

        if isinstance(target, ast.Name):
            existing_type = self.scopes.lookup(target.id)
            if existing_type is None:
                raise ValueError(
                    f"Variable '{target.id}' assigned without prior typed declaration. "
                    f"Use '{target.id}: <type> = ...' for the first declaration."
                )

            return Assign(
                target=target.id,
                value=value,
                declared_type=None,
            )

        if isinstance(target, ast.Subscript):
            return AssignIndex(
                collection=self.parse_expression(target.value),
                index=self.parse_subscript_index(target),
                value=value,
            )

        raise NotImplementedError(
            "Only variable assignment and indexed assignment are supported"
        )

    def parse_ann_assign(self, node: ast.AnnAssign):
        if node.value is None:
            raise NotImplementedError(
                "Typed declarations without an initial value are not supported"
            )

        if not isinstance(node.target, ast.Name):
            raise NotImplementedError(
                "Only annotated variable declarations are supported"
            )

        target_name = node.target.id
        declared_type = self.parse_type_annotation(node.annotation)
        value = self.parse_expression(node.value)

        self.scopes.declare(target_name, declared_type)

        return Assign(
            target=target_name,
            value=value,
            declared_type=declared_type,
        )

    def parse_if(self, node: ast.If) -> If:
        condition = self.parse_expression(node.test)
        then_body = [self.parse_statement(stmt) for stmt in node.body]
        else_body = [self.parse_statement(stmt) for stmt in node.orelse]

        return If(
            condition=condition,
            then_body=then_body,  # pyright: ignore[reportArgumentType]
            else_body=else_body,  # pyright: ignore[reportArgumentType]
        )

    def parse_while(self, node: ast.While) -> While:
        if node.orelse:
            raise NotImplementedError("while ... else is not supported")

        condition = self.parse_expression(node.test)
        body = [self.parse_statement(stmt) for stmt in node.body]

        return While(
            condition=condition,
            body=body,  # pyright: ignore[reportArgumentType]
        )

    def parse_for(self, node: ast.For) -> ForRange:
        if node.orelse:
            raise NotImplementedError("for ... else is not supported")

        if not isinstance(node.target, ast.Name):
            raise NotImplementedError(
                "Only for loops with a simple variable target are supported"
            )

        if not isinstance(node.iter, ast.Call):
            raise NotImplementedError(
                "Only for loops over range(...) are supported"
            )

        if not isinstance(node.iter.func, ast.Name) or node.iter.func.id != "range":
            raise NotImplementedError(
                "Only for loops over range(...) are supported"
            )

        args = node.iter.args

        if len(args) == 1:
            start = IntLiteral(0)
            end = self.parse_expression(args[0])
            step = IntLiteral(1)
        elif len(args) == 2:
            start = self.parse_expression(args[0])
            end = self.parse_expression(args[1])
            step = IntLiteral(1)
        elif len(args) == 3:
            start = self.parse_expression(args[0])
            end = self.parse_expression(args[1])
            step = self.parse_expression(args[2])
        else:
            raise NotImplementedError("range() with 1, 2, or 3 arguments only")

        # En Python, la variable de boucle appartient au scope courant.
        # On impose ici qu'elle soit déjà déclarée.
        existing_type = self.scopes.lookup(node.target.id)
        if existing_type is None:
            raise ValueError(
                f"Loop variable '{node.target.id}' must be declared before the for-loop"
            )

        body = [self.parse_statement(stmt) for stmt in node.body]

        return ForRange(
            var_name=node.target.id,
            start=start,
            end=end,
            step=step,
            body=body, # pyright: ignore[reportArgumentType]
        )

    def parse_expr_statement(self, node: ast.Expr):
        expr = self.parse_expression(node.value)

        if isinstance(expr, Call) and expr.func_name == "print":
            if len(expr.args) != 1:
                raise NotImplementedError(
                    "Only print(...) with exactly one argument is supported"
                )
            return Print(expr.args[0])

        return ExprStmt(expr=expr)

    def parse_return(self, node: ast.Return) -> Return:
        if node.value is None:
            return Return(value=None)

        return Return(value=self.parse_expression(node.value))

    def parse_function_def(self, node: ast.FunctionDef) -> FunctionDef:
        if node.decorator_list:
            raise NotImplementedError("Decorators are not supported")

        if node.returns is None:
            raise ValueError(
                f"Function '{node.name}' must have an explicit return type annotation"
            )

        # Le nom de la fonction existe dans le scope courant
        # pour permettre les appels récursifs simples.
        if self.scopes.exists_in_current_scope(node.name):
            raise ValueError(
                f"Function '{node.name}' is already declared in the current scope"
            )
        self.scopes.declare(node.name, "function")

        params: list[Param] = []

        self.scopes.push()
        try:
            for arg in node.args.args:
                if arg.annotation is None:
                    raise ValueError(
                        f"Parameter '{arg.arg}' in function '{node.name}' "
                        f"must have a type annotation"
                    )

                param_type = self.parse_type_annotation(arg.annotation)
                self.scopes.declare(arg.arg, param_type)
                params.append(Param(name=arg.arg, param_type=param_type))

            body = [self.parse_statement(stmt) for stmt in node.body]
        finally:
            self.scopes.pop()

        return FunctionDef(
            name=node.name,
            params=params,
            return_type=self.parse_type_annotation(node.returns),
            body=body, # pyright: ignore[reportArgumentType]
        )

    # =========================
    # Expressions
    # =========================

    def parse_expression(self, node: ast.expr):
        if isinstance(node, ast.Name):
            return self.parse_name(node)

        if isinstance(node, ast.Constant):
            return self.parse_constant(node)

        if isinstance(node, ast.List):
            return ListLiteral(
                elements=[self.parse_expression(elt) for elt in node.elts]
            )

        if isinstance(node, ast.Subscript):
            return IndexAccess(
                collection=self.parse_expression(node.value),
                index=self.parse_subscript_index(node),
            )

        if isinstance(node, ast.BinOp):
            return BinaryOp(
                left=self.parse_expression(node.left),
                op=self.parse_binary_operator(node.op),
                right=self.parse_expression(node.right),
            )

        if isinstance(node, ast.UnaryOp):
            return UnaryOp(
                op=self.parse_unary_operator(node.op),
                operand=self.parse_expression(node.operand),
            )

        if isinstance(node, ast.Compare):
            return self.parse_compare(node)

        if isinstance(node, ast.BoolOp):
            return self.parse_bool_op(node)

        if isinstance(node, ast.Call):
            return self.parse_call(node)

        raise NotImplementedError(
            f"Expression type not supported: {type(node).__name__}"
        )

    def parse_name(self, node: ast.Name):
        if node.id in self.allowed_builtins:
            return Var(name=node.id)

        existing_type = self.scopes.lookup(node.id)
        if existing_type is None:
            raise ValueError(
                f"Variable '{node.id}' used before declaration"
            )

        return Var(name=node.id)

    def parse_constant(self, node: ast.Constant):
        if isinstance(node.value, bool):
            return BoolLiteral(node.value)

        if isinstance(node.value, int):
            return IntLiteral(node.value)

        if isinstance(node.value, str):
            return StringLiteral(node.value)

        raise NotImplementedError(
            f"Constant type not supported: {type(node.value).__name__}"
        )

    def parse_compare(self, node: ast.Compare):
        if len(node.ops) != 1 or len(node.comparators) != 1:
            raise NotImplementedError("Only simple comparisons are supported")

        left = self.parse_expression(node.left)
        op = self.parse_comparison_operator(node.ops[0])
        right = self.parse_expression(node.comparators[0])

        return BinaryOp(
            left=left,
            op=op,
            right=right,
        )

    def parse_bool_op(self, node: ast.BoolOp):
        if len(node.values) < 2:
            raise NotImplementedError(
                "Boolean operations must contain at least 2 values"
            )

        op = self.parse_boolean_operator(node.op)

        current = self.parse_expression(node.values[0])
        for value_node in node.values[1:]:
            current = BinaryOp(
                left=current,
                op=op,
                right=self.parse_expression(value_node),
            )

        return current

    def parse_call(self, node: ast.Call):
        if isinstance(node.func, ast.Name):
            func_name = node.func.id

            if func_name != "print" and func_name not in self.allowed_builtins:
                existing_type = self.scopes.lookup(func_name)
                if existing_type is None:
                    raise ValueError(
                        f"Function '{func_name}' called before declaration"
                    )

            return Call(
                func_name=func_name,
                args=[self.parse_expression(arg) for arg in node.args],
            )

        if isinstance(node.func, ast.Attribute):
            return MethodCall(
                receiver=self.parse_expression(node.func.value),
                method_name=node.func.attr,
                args=[self.parse_expression(arg) for arg in node.args],
            )

        raise NotImplementedError(
            "Only simple function calls and method calls are supported"
        )

    # =========================
    # Types
    # =========================

    def parse_type_annotation(self, node: ast.expr) -> str:
        if isinstance(node, ast.Name):
            return node.id

        if isinstance(node, ast.Subscript):
            if isinstance(node.value, ast.Name):
                base = node.value.id
                inner = self.parse_type_annotation(node.slice)
                return f"{base}[{inner}]"

        raise NotImplementedError(
            f"Type annotation not supported: {type(node).__name__}"
        )

    # =========================
    # Operators
    # =========================

    def parse_binary_operator(self, node):
        if isinstance(node, ast.Add):
            return "+"
        if isinstance(node, ast.Sub):
            return "-"
        if isinstance(node, ast.Mult):
            return "*"
        if isinstance(node, ast.Div):
            return "/"
        if isinstance(node, ast.Mod):
            return "%"
        raise NotImplementedError(
            f"Binary operator not supported: {type(node).__name__}"
        )

    def parse_unary_operator(self, node):
        if isinstance(node, ast.USub):
            return "-"
        if isinstance(node, ast.UAdd):
            return "+"
        if isinstance(node, ast.Not):
            return "not"
        raise NotImplementedError(
            f"Unary operator not supported: {type(node).__name__}"
        )

    def parse_comparison_operator(self, node):
        if isinstance(node, ast.Eq):
            return "=="
        if isinstance(node, ast.NotEq):
            return "!="
        if isinstance(node, ast.Lt):
            return "<"
        if isinstance(node, ast.LtE):
            return "<="
        if isinstance(node, ast.Gt):
            return ">"
        if isinstance(node, ast.GtE):
            return ">="
        raise NotImplementedError(
            f"Comparison operator not supported: {type(node).__name__}"
        )

    def parse_boolean_operator(self, node):
        if isinstance(node, ast.And):
            return "and"
        if isinstance(node, ast.Or):
            return "or"
        raise NotImplementedError(
            f"Boolean operator not supported: {type(node).__name__}"
        )

    # =========================
    # Utils
    # =========================

    def parse_subscript_index(self, node: ast.Subscript):
        return self.parse_expression(node.slice)