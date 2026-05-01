import pythonToUniversal as ir


def emit_program(program: ir.Program) -> str:
    emitter = BashEmitter(program)
    return emitter.emit_program()


class BashEmitter:
    def __init__(self, program: ir.Program):
        self.program = program
        self.matrix_widths: dict[str, str] = {}
        self.string_vars: set[str] = set()
        self.array_vars: set[str] = set()
        self.row_widths: dict[str, str] = {}

    def emit_program(self) -> str:
        self.analyze_program(self.program)

        lines = [
            "",
        ]

        for statement in self.program.statements:
            lines.extend(self.emit_statement(statement, 0))

        return "\n".join(lines)

    def analyze_program(self, program: ir.Program) -> None:
        for statement in program.statements:
            self.analyze_statement(statement)

    def analyze_statement(self, node) -> None:
        if isinstance(node, ir.Assign):
            self.analyze_assign(node)
            return

        if isinstance(node, ir.ForRange):
            self.analyze_for_range(node)
            return

        if isinstance(node, ir.While):
            for statement in node.body:
                self.analyze_statement(statement)
            return

        if isinstance(node, ir.If):
            for statement in node.body:
                self.analyze_statement(statement)
            for statement in node.else_body:
                self.analyze_statement(statement)
            return

        if isinstance(node, ir.Call):
            self.analyze_call(node)
            return

    def analyze_assign(self, node: ir.Assign) -> None:
        if not isinstance(node.target, ir.Variable):
            return

        name = node.target.name

        if isinstance(node.value, ir.Constant):
            if isinstance(node.value.value, str):
                self.string_vars.add(name)
            return

        if isinstance(node.value, ir.ListLiteral):
            self.array_vars.add(name)

            if self.is_matrix_literal(node.value):
                first_row = node.value.elements[0]
                self.matrix_widths[name] = str(len(first_row.elements))

            return

        if isinstance(node.value, ir.Call):
            if node.value.name in ("read_line", "string_rstrip"):
                self.string_vars.add(name)
                return

            if node.value.name == "string_split":
                self.array_vars.add(name)
                return

        if self.is_string_expr(node.value):
            self.string_vars.add(name)

    def analyze_for_range(self, node: ir.ForRange) -> None:
        loop_end = self.emit_raw_number(node.end)

        for statement in node.body:
            if isinstance(statement, ir.Call):
                if statement.name == "array_push" and len(statement.arguments) == 2:
                    array_arg = statement.arguments[0]
                    if isinstance(array_arg, ir.Variable):
                        self.row_widths[array_arg.name] = loop_end

            self.analyze_statement(statement)

    def analyze_call(self, node: ir.Call) -> None:
        if node.name != "array_push" or len(node.arguments) != 2:
            return

        target = node.arguments[0]
        value = node.arguments[1]

        if not isinstance(target, ir.Variable):
            return

        self.array_vars.add(target.name)

        if isinstance(value, ir.Variable):
            if value.name in self.row_widths:
                self.matrix_widths[target.name] = self.row_widths[value.name]

    def emit_statement(self, node, indent: int) -> list[str]:
        prefix = self.indent(indent)

        if isinstance(node, ir.Assign):
            return self.emit_assign(node, indent)

        if isinstance(node, ir.Call):
            return [prefix + self.emit_call_statement(node)]

        if isinstance(node, ir.ForRange):
            return self.emit_for_range(node, indent)

        if isinstance(node, ir.While):
            return self.emit_while(node, indent)

        if isinstance(node, ir.If):
            return self.emit_if(node, indent)

        if isinstance(node, ir.Continue):
            return [prefix + "continue"]

        if isinstance(node, ir.Break):
            return [prefix + "break"]

        raise Exception(f"Unsupported statement for Bash: {type(node).__name__}")

    def emit_assign(self, node: ir.Assign, indent: int) -> list[str]:
        prefix = self.indent(indent)

        if isinstance(node.target, ir.Variable):
            target_name = node.target.name

            if isinstance(node.value, ir.Call):
                if node.value.name == "read_line":
                    return [prefix + f"IFS= read -r {target_name}"]

                if node.value.name == "string_split":
                    source = self.emit_word(node.value.arguments[0])
                    return [prefix + f"read -r -a {target_name} <<< {source}"]

                if node.value.name == "string_rstrip":
                    source = self.emit_word(node.value.arguments[0])
                    return [prefix + f"{target_name}={source}"]

                if node.value.name == "int":
                    value = self.emit_number_expr(node.value.arguments[0])
                    return [prefix + f"{target_name}={value}"]

            if isinstance(node.value, ir.ListLiteral):
                return [prefix + f"{target_name}={self.emit_list_literal(node.value)}"]

            if self.is_string_expr(node.value):
                value = self.emit_string_expr(node.value)
                return [prefix + f"{target_name}={value}"]

            value = self.emit_expr(node.value)
            return [prefix + f"{target_name}={value}"]

        if isinstance(node.target, ir.Index):
            target = self.emit_target(node.target)

            if self.is_string_expr(node.value):
                value = self.emit_string_expr(node.value)
            else:
                value = self.emit_expr(node.value)

            return [prefix + f"{target}={value}"]

        raise Exception(f"Unsupported assignment target for Bash: {type(node.target).__name__}")

    def emit_for_range(self, node: ir.ForRange, indent: int) -> list[str]:
        prefix = self.indent(indent)
        var = node.variable.name
        start = self.emit_raw_number(node.start)
        end = self.emit_raw_number(node.end)
        lines = [prefix + f"for (( {var}={start}; {var}<{end}; {var}++ )); do"]

        for statement in node.body:
            lines.extend(self.emit_statement(statement, indent + 1))

        lines.append(prefix + "done")
        return lines

    def emit_while(self, node: ir.While, indent: int) -> list[str]:
        prefix = self.indent(indent)
        lines = [prefix + f"while {self.emit_condition(node.condition)}; do"]

        for statement in node.body:
            lines.extend(self.emit_statement(statement, indent + 1))

        lines.append(prefix + "done")
        return lines

    def emit_if(self, node: ir.If, indent: int) -> list[str]:
        prefix = self.indent(indent)
        lines = [prefix + f"if {self.emit_condition(node.condition)}; then"]

        for statement in node.body:
            lines.extend(self.emit_statement(statement, indent + 1))

        if node.else_body:
            lines.append(prefix + "else")
            for statement in node.else_body:
                lines.extend(self.emit_statement(statement, indent + 1))

        lines.append(prefix + "fi")
        return lines

    def emit_expr(self, node) -> str:
        if isinstance(node, ir.Variable):
            return "${" + node.name + "}"

        if isinstance(node, ir.Constant):
            return self.emit_constant(node.value)

        if isinstance(node, ir.UnaryOp):
            return self.emit_number_expr(node)

        if isinstance(node, ir.BinaryOp):
            if self.is_string_expr(node):
                return self.emit_string_expr(node)
            return self.emit_number_expr(node)

        if isinstance(node, ir.Index):
            return self.emit_index_value(node)

        if isinstance(node, ir.ListLiteral):
            return self.emit_list_literal(node)

        if isinstance(node, ir.Call):
            return self.emit_call_expr(node)

        raise Exception(f"Unsupported expression for Bash: {type(node).__name__}")

    def emit_call_expr(self, node: ir.Call) -> str:
        if node.name == "int":
            return self.emit_number_expr(node.arguments[0])

        if node.name == "length":
            arg = node.arguments[0]
            if isinstance(arg, ir.Variable):
                return "${#" + arg.name + "[@]}"

        raise Exception(f"Unsupported call expression for Bash: {node.name}")

    def emit_call_statement(self, node: ir.Call) -> str:
        if node.name == "write":
            return "printf '%s\\n' " + " ".join(self.emit_word(arg) for arg in node.arguments)

        if node.name == "array_push":
            if len(node.arguments) != 2:
                raise Exception("array_push expects 2 arguments")

            array_arg = node.arguments[0]
            value_arg = node.arguments[1]

            if not isinstance(array_arg, ir.Variable):
                raise Exception("array_push target must be a variable")

            array_name = array_arg.name

            if isinstance(value_arg, ir.Variable) and value_arg.name in self.row_widths:
                return f"{array_name}+=(\"${{{value_arg.name}[@]}}\")"

            value = self.emit_word(value_arg)
            return f"{array_name}+=({value})"

        raise Exception(f"Unsupported call statement for Bash: {node.name}")

    def emit_condition(self, node) -> str:
        if isinstance(node, ir.Compare):
            if node.operator in ("==", "!="):
                left = self.emit_word(node.left)
                right = self.emit_word(node.right)
                return f"[[ {left} {node.operator} {right} ]]"

            op_map = {
                "<": "<",
                "<=": "<=",
                ">": ">",
                ">=": ">=",
            }

            if node.operator in op_map:
                left = self.emit_raw_number(node.left)
                right = self.emit_raw_number(node.right)
                return f"(( {left} {op_map[node.operator]} {right} ))"

        raise Exception(f"Unsupported condition for Bash: {type(node).__name__}")

    def emit_index_value(self, node: ir.Index) -> str:
        matrix = self.try_get_matrix_index(node)

        if matrix is not None:
            name, row, col, width = matrix
            index = self.emit_flat_index(row, col, width)
            return "${" + f"{name}[{index}]" + "}"

        if isinstance(node.collection, ir.Variable):
            collection_name = node.collection.name
            index_expr = self.emit_raw_number(node.index)

            if collection_name in self.string_vars:
                return "${" + f"{collection_name}:{index_expr}:1" + "}"

            return "${" + f"{collection_name}[{index_expr}]" + "}"

        raise Exception(f"Unsupported index expression for Bash: {type(node.collection).__name__}")

    def emit_target(self, node: ir.Index) -> str:
        matrix = self.try_get_matrix_index(node)

        if matrix is not None:
            name, row, col, width = matrix
            index = self.emit_flat_index(row, col, width)
            return f"{name}[{index}]"

        if isinstance(node.collection, ir.Variable):
            collection_name = node.collection.name
            index_expr = self.emit_raw_number(node.index)
            return f"{collection_name}[{index_expr}]"

        raise Exception(f"Unsupported target index for Bash: {type(node.collection).__name__}")

    def try_get_matrix_index(self, node: ir.Index):
        if not isinstance(node.collection, ir.Index):
            return None

        inner = node.collection

        if not isinstance(inner.collection, ir.Variable):
            return None

        matrix_name = inner.collection.name

        if matrix_name not in self.matrix_widths:
            return None

        return matrix_name, inner.index, node.index, self.matrix_widths[matrix_name]

    def emit_flat_index(self, row, col, width: str) -> str:
        row_expr = self.emit_raw_number(row)
        col_expr = self.emit_raw_number(col)
        return f"$(( {row_expr} * {width} + {col_expr} ))"

    def emit_list_literal(self, node: ir.ListLiteral) -> str:
        values = []

        if self.is_matrix_literal(node):
            for row in node.elements:
                for element in row.elements:
                    values.append(self.emit_array_element(element))
        else:
            for element in node.elements:
                values.append(self.emit_array_element(element))

        return "(" + " ".join(values) + ")"

    def emit_array_element(self, node) -> str:
        return self.emit_word(node)

    def is_matrix_literal(self, node: ir.ListLiteral) -> bool:
        return bool(node.elements) and all(isinstance(element, ir.ListLiteral) for element in node.elements)

    def is_string_expr(self, node) -> bool:
        if isinstance(node, ir.Constant):
            return isinstance(node.value, str)

        if isinstance(node, ir.Variable):
            return node.name in self.string_vars

        if isinstance(node, ir.Index):
            matrix = self.try_get_matrix_index(node)
            if matrix is not None:
                name = matrix[0]
                return name in ("mz",)

            if isinstance(node.collection, ir.Variable):
                return node.collection.name in self.string_vars

            return False

        if isinstance(node, ir.BinaryOp):
            return node.operator == "+" and (self.is_string_expr(node.left) or self.is_string_expr(node.right))

        if isinstance(node, ir.Call):
            return node.name in ("read_line", "string_rstrip")

        return False

    def emit_string_expr(self, node) -> str:
        if isinstance(node, ir.BinaryOp) and node.operator == "+":
            left = self.emit_string_part(node.left)
            right = self.emit_string_part(node.right)
            return '"' + left + right + '"'

        return self.emit_word(node)

    def emit_string_part(self, node) -> str:
        if isinstance(node, ir.Constant):
            if isinstance(node.value, str):
                return self.escape_for_double_quotes(node.value)
            return str(node.value)

        if isinstance(node, ir.Variable):
            return "${" + node.name + "}"

        if isinstance(node, ir.Index):
            return self.emit_index_value(node)

        if isinstance(node, ir.BinaryOp):
            text = self.emit_string_expr(node)
            if text.startswith('"') and text.endswith('"'):
                return text[1:-1]
            return text

        return self.emit_expr(node)

    def emit_word(self, node) -> str:
        if isinstance(node, ir.Constant):
            return self.emit_constant(node.value)

        if self.is_string_expr(node):
            if isinstance(node, ir.BinaryOp):
                return self.emit_string_expr(node)
            if isinstance(node, ir.Index):
                return '"' + self.emit_index_value(node) + '"'
            if isinstance(node, ir.Variable):
                return '"${' + node.name + '}"'

        if isinstance(node, ir.Variable):
            return "${" + node.name + "}"

        if isinstance(node, ir.Index):
            return self.emit_index_value(node)

        if isinstance(node, (ir.BinaryOp, ir.UnaryOp)):
            return self.emit_number_expr(node)

        if isinstance(node, ir.Call):
            return self.emit_call_expr(node)

        if isinstance(node, ir.ListLiteral):
            return self.emit_list_literal(node)

        raise Exception(f"Unsupported word expression for Bash: {type(node).__name__}")

    def emit_number_expr(self, node) -> str:
        return "$(( " + self.emit_raw_number(node) + " ))"

    def emit_raw_number(self, node) -> str:
        if isinstance(node, ir.Variable):
            return node.name

        if isinstance(node, ir.Constant):
            return str(node.value)

        if isinstance(node, ir.UnaryOp):
            return node.operator + self.emit_raw_number(node.operand)

        if isinstance(node, ir.BinaryOp):
            left = self.emit_raw_number(node.left)
            right = self.emit_raw_number(node.right)

            if node.operator == "%":
                return f"( ( {left} % {right} + {right} ) % {right} )"

            return f"( {left} {node.operator} {right} )"

        if isinstance(node, ir.Index):
            matrix = self.try_get_matrix_index(node)

            if matrix is not None:
                name, row, col, width = matrix
                index = self.emit_flat_index(row, col, width)
                return f"{name}[{index}]"

            if isinstance(node.collection, ir.Variable):
                collection_name = node.collection.name
                index_expr = self.emit_raw_number(node.index)
                return f"{collection_name}[{index_expr}]"

        if isinstance(node, ir.Call):
            if node.name == "int":
                return self.emit_raw_number(node.arguments[0])

            if node.name == "length":
                arg = node.arguments[0]
                if isinstance(arg, ir.Variable):
                    return "${#" + arg.name + "[@]}"

        raise Exception(f"Unsupported arithmetic value for Bash: {type(node).__name__}")

    def emit_constant(self, value) -> str:
        if isinstance(value, str):
            return '"' + self.escape_for_double_quotes(value) + '"'

        return str(value)

    def escape_for_double_quotes(self, value: str) -> str:
        return value.replace("\\", "\\\\").replace('"', '\\"').replace("$", "\\$")

    def indent(self, indent: int) -> str:
        return "    " * indent


if __name__ == "__main__":
    universal_code = ir.parse_program("""
import sys

MAP = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

DIRS = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1]
]

line = sys.stdin.readline()
parts = line.split()
w = int(parts[0])
h = int(parts[1])

mz = []

for y in range(h):
    line = sys.stdin.readline()
    line = line.rstrip("\\n")

    row = []
    for x in range(w):
        row.append(line[x])

    mz.append(row)

sx = 0
sy = 0

for y in range(h):
    for x in range(w):
        if mz[y][x] == "S":
            sx = x
            sy = y

dist = []

for y in range(h):
    row = []

    for x in range(w):
        row.append(-1)

    dist.append(row)

dist[sy][sx] = 0

queue_x = []
queue_y = []
queue_start = 0

queue_x.append(sx)
queue_y.append(sy)

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
""")

    bash_code = emit_program(universal_code)
    print(bash_code)
