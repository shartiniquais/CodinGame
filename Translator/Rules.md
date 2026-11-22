# Règles pour écrire le Python "traduisible"

## 1. Une instruction par ligne

**✔️ Autorisé**
```py
a = 5
b = 6
c = a + b
```

**❌ Interdit**
```py
a = b = c = 0
```

## 2. Pas d’expression complexe dans print

**✔️ Autorisé**
```py
print(x)
```

**❌ Interdit**
```py
print(a if x < y else b)
```

**✔️ À faire à la place**
```py
if x < y:
    result = a
else:
    result = b

print(result)
```

## 3. Pas d’opérations directement dans print

**✔️ Autorisé**
```py
sum = a + b
print(sum)
```

**❌ Interdit**
```py
print(a + b)
```

## 4. Pas d’opérations dans les arguments de fonctions

**✔️ Autorisé**
```py
value = a + b
print(value)
```

**❌ Interdit**
```py
print(a + b)
```

## 5. Pas d’opérateur ternaire

**❌ Interdit**
```py
x = a if cond else b
```

**✔️ À faire**
```py
if cond:
    x = a
else:
    x = b
```

## 6. Pas de compréhension de liste

**❌ Interdit**
```py
[x * 2 for x in arr]
```

**✔️ À faire**
```py
result = []
for x in arr:
    result.append(x * 2)
```

## 7. Pas de lambda, map, filter

**❌ Interdit**
```py
list(map(int, input().split()))
```

**✔️ À faire**
```py
line = input()
parts = line.split()
x = int(parts[0])
y = int(parts[1])
```

## 8. Pas de tuple unpacking

**❌ Interdit**
```py
a, b = input().split()
```

**✔️ À faire**
```py
line = input()
parts = line.split()
a = parts[0]
b = parts[1]
```

## 9. Types explicites pour les nombres

**✔️ Toujours faire**
```py
x = int(input())
```

**❌ Éviter**
```py
x = input()
```
si c’est un nombre.

## 10. Boucles simples uniquement

**✔️ Autorisé**
```py
while True:
```

**✔️ Autorisé**
```py
for i in range(n):
```

**❌ Éviter**
```py
for a, b in pairs:

```
## 11. Pas de classes

**❌ Interdit**
```py
class Player:
```

## 12. Tableaux simples uniquement

**✔️ Autorisé**
```py
arr = []
arr.append(x)
```

**❌ Éviter**
```py
arr = [1,2,3]
```

## 13. Une seule action par instruction

**✔️ Autorisé**
```py
x = a + b
```

**❌ Interdit**
```py
print(a + b)
```

## 14. Conditions simples

**✔️ Autorisé**
```py
if a < b:
```

**✔️ Autorisé**
```py
if a < b and b < c:
```

**❌ Éviter**
```py
if (a < b) and (b < c) and (c < d) and complex_call():
```

## 15. Utiliser des variables intermédiaires

**Toujours préférer**
```py
sum = a + b
result = sum * c
```

**plutôt que**
```py
result = (a + b) * c
```

## Exemple final respectant toutes les règles
```py
while True:
    enemy_1 = input()
    dist_1 = int(input())
    enemy_2 = input()
    dist_2 = int(input())

    if dist_1 < dist_2:
        target = enemy_1
    else:
        target = enemy_2

    print(target)
```
