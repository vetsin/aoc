import strutils
import sequtils
import itertools

let input: string = readAll(stdin).strip()

type
  Equation = ref object
    test: int
    values: seq[int]

proc initEquation(s: string): Equation = 
    new result
    let parts = s.split(": ")
    result.test = parseInt(parts[0])
    result.values = parts[1].splitWhitespace().map(parseInt)

proc `$`(e: Equation): string =
    $e.test & ": " & e.values.join(" ")


var equations: seq[Equation] = @[]
for line in input.splitLines():
    equations.add(initEquation(line))

proc solve(eq: Equation, op: seq[string]): int = 
    result = eq.values[0]
    for i in 1..<eq.values.len:
        if op[i-1] == "+":
            result += eq.values[i]
        elif op[i-1] == "*":
            result *= eq.values[i]
        elif op[i-1] == "||":
            result = parseInt($result & $eq.values[i])

var total = 0
for eq in equations:
  for op in product(@["*", "+"], eq.values.len-1):
    if eq.solve(op) == eq.test:
        total += eq.test
        break
echo total

var total2 = 0
for eq in equations:
  for op in product(@["*", "+", "||"], eq.values.len-1):
    if eq.solve(op) == eq.test:
        total2 += eq.test
        break
echo total2
