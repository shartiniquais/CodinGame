from dataclasses import dataclass, field
from typing import List


# =========================
# Base classes
# =========================

class Node:
    pass

# Instruction, par exemple x = 5, if x > 0: print(x), etc.
class Statement(Node):
    pass

# Expression, quelque chose qui produit une valeur, par exemple 5, 'Hello', x + 1, input(), etc.
class Expression(Node):
    pass

# Exemple :
# x = a + b
# Ici, "x = a + b" est un Statement (Assign), tandis que "a + b" est une expression (BinaryOp) qui produit une valeur.


# =========================
# Program
# =========================

# Le programme entier, qui contient une liste d'instructions (statements).
@dataclass
class Program(Node):
    body: List[Statement] = field(default_factory=list)
# Exemple :
# x = 1
# print(x)
# Devient :
# Program(body=[
#     Assign(target='x', value=IntLiteral(value=1)),
#     Print(value=Var(name='x'))
# ])
# Donc, le programme est le conteneur principal


# =========================
# Statements
# =========================

# Assign designe une instruction d'affectation, par exemple x = 5
# x = 5 devient Assign(target='x', value=IntLiteral(value=5))
# On doit aussi préciser le type de la variable, si il est déclaré. Par exemple :
# x: int = 5
# Devient :
# Assign(target='x', value=IntLiteral(value=5), declared_type='int')
# Si le type n'est pas déclaré, ça veux dire que c'est une réaffectation.
@dataclass
class Assign(Statement):
    target: str
    value: Expression
    declared_type: str | None = None


# If designe une instruction conditionnelle, par exemple if x > 0: print(x) else: print(-x)
# par exemple :
# if a < b:
#     x = a
# else:
#     x = b
# Devient :
# If(
#     condition=BinaryOp(Var("a"), "<", Var("b")),
#     then_body=[
#         Assign("x", Var("a"))
#     ],
#     else_body=[
#         Assign("x", Var("b"))
#     ]
# )
@dataclass
class If(Statement):
    condition: Expression
    then_body: List[Statement] = field(default_factory=list)
    else_body: List[Statement] = field(default_factory=list)


# While designe une instruction de boucle
# Exemple :
# while True:
#     print("hello")
# Devient :
# While(
#     condition=BoolLiteral(True),
#     body=[
#         Print(value=StringLiteral("hello"))
#     ]
# )
@dataclass
class While(Statement):
    condition: Expression
    body: List[Statement] = field(default_factory=list)

# ForRange designe une instruction de boucle for avec une plage de valeurs
# Exemple :
# for i in range(0, 10, 1):
#     print(i)
# Devient :
# ForRange(
#     var_name="i",
#     start=IntLiteral(0),
#     end=IntLiteral(10),
#     step=IntLiteral(1),
#     body=[
#         Print(Var("i"))
#     ]
# )
@dataclass
class ForRange(Statement):
    var_name: str
    start: Expression
    end: Expression
    step: Expression
    body: List[Statement] = field(default_factory=list)

# ExprStmt représente une expression utilisée comme instruction.
# Exemple :
# foo()
# Ce n'est pas une affectation, ni un if, ni un print.
# C'est juste un appel de fonction utilisé seul.
# Il serra représenté comme :
# ExprStmt(
#     expr=Call("foo", [])
# )
@dataclass
class ExprStmt(Statement):
    expr: Expression

# Cette classe représente le print d'une expression
# Exemple :
# print(target)
# Devient :
# Print(
#     value=Var("target")
# )
@dataclass
class Print(Statement):
    value: Expression

# Cette classe représente le return d'une expression
# Exemple :
# return x + 1
# Devient :
# Return(
#     value=BinaryOp(
#         left=Var("x"),
#         op="+",
#         right=IntLiteral(1)
#     ) 
# )
@dataclass
class Return(Statement):
    value: Expression | None = None


# Représente le paramètre d'une fonction, par exemple x: int
@dataclass
class Param(Node):
    name: str
    param_type: str

# Représente la définition d'une fonction, par exemple :
# def foo(x: int) -> int:
#     return x + 1
# Devient :
# FunctionDef(
#     name="foo",
#     params=[Param(name="x", param_type="int")],
#     return_type="int",
#     body=[
#         Return(   
#             value=BinaryOp(
#                 left=Var("x"),
#                 op="+",
#                 right=IntLiteral(1)
#             )
#         )
#     ]
# )
@dataclass
class FunctionDef(Statement):
    name: str
    params: List[Param] = field(default_factory=list)
    return_type: str | None = None
    body: List[Statement] = field(default_factory=list)

# Représente une instruction de break, pour sortir d'une boucle
@dataclass
class Break(Statement):
    pass

# Représente une instruction de continue, pour passer à l'itération suivante d'une boucle
@dataclass
class Continue(Statement):
    pass

# Représente une instruction de pass, qui ne fait rien
@dataclass
class Pass(Statement):
    pass

# Représente une affectation à un index d'une collection, par exemple :
# arr[i] = x
# Devient :
# AssignIndex(
#     collection=Var("arr"),
#     index=Var("i"),
#     value=Var("x")
# )
@dataclass
class AssignIndex(Statement):
    collection: Expression
    index: Expression
    value: Expression


# =========================
# Expressions
# =========================

# Représente l'usage d'une variable, par exemple x, y, etc.
# Exemple :
# x
# Devient :
# Var("x")
@dataclass
class Var(Expression):
    name: str

# Représente un nombre entier constant.
@dataclass
class IntLiteral(Expression):
    value: int

# Représente une chaîne de caractères constante.
@dataclass
class StringLiteral(Expression):
    value: str

# Représente un booléen constant.
@dataclass
class BoolLiteral(Expression):
    value: bool

# Représente un nombre à virgule flottante constant.
@dataclass
class FloatLiteral(Expression):
    value: float

# Représente la valeur None.
# Utile lorsqu'on veut représenter x: str | None = None par exemple.
@dataclass
class NoneLiteral(Expression):
    value: None = None

# Représente une liste littérale.
# Par exemple [1, 2, 3]
# Devient :
# ListLiteral(elements=[IntLiteral(1), IntLiteral(2), IntLiteral(3)])
@dataclass
class ListLiteral(Expression):
    elements: List[Expression] = field(default_factory=list)

# Représente un dictionnaire littéral.
@dataclass
class DictLiteral(Expression):
    items: List[tuple[Expression, Expression]] = field(default_factory=list)

# Représente une opération entre deux expressions.
# Exemple :
# dist_1 < dist_2
# Devient :
# BinaryOp(
#     left=Var("dist_1"),
#     op="<",
#     right=Var("dist_2")
# )
@dataclass
class BinaryOp(Expression):
    left: Expression
    op: str
    right: Expression

# Représente une opération à un seul opérande.
# Exemple :
# -x
# Devient :
# UnaryOp(
#     op="-",
#     operand=Var("x")
# )
# Ou alors :
# not is_valid
# Devient :
# UnaryOp(
#     op="not",
#     operand=Var("is_valid")   
# )
@dataclass
class UnaryOp(Expression):
    op: str
    operand: Expression

# Représente un appel de fonction.
# Exemple :
# input()
# Devient :
# Call(
#     func_name="input",
#     args=[]
# )
# Exemple imbriqué :
# int(input())
# Devient :
# Call(
#     func_name="int",
#     args=[
#         Call("input", [])
#     ]
# )
@dataclass
class Call(Expression):
    func_name: str
    args: List[Expression] = field(default_factory=list)

# Représente l'accès à un index d'une collection, par exemple :
# arr[i]
# Devient :
# IndexAccess(
#     collection=Var("arr"),
#     index=Var("i")
# )
@dataclass
class IndexAccess(Expression):
    collection: Expression
    index: Expression

# Représente un appel de méthode sur un objet, par exemple :
# arr.append(x)
# Devient :
# MethodCall(
#     receiver=Var("arr"),
#     method_name="append",
#     args=[Var("x")]
# )
@dataclass
class MethodCall(Expression):
    receiver: Expression
    method_name: str
    args: List[Expression] = field(default_factory=list)
