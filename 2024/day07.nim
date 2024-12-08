import strutils
import sequtils
import itertools
import tables

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


type
  #Pos = tuple[sIdx, eIdx: int]
  #IntOrOpKind = enum Int, Op
  #IntOrOp = object
  #  case kind: IntOrOpKind
  #  of Int: intVal: int
  #  of Op: opVal: string

  Expression = seq[string]
  #Memo = TableRef[Expression, int]

proc solve2(ex: Expression, t: ref Table[Expression, int]): int =
    if ex in t:
        return t[ex]

    #let left = ex[0..^2]
    #t[left] = solve2(left, t)

    result = parseInt(ex[0])
    var i = 1
    while i < ex.len-1:
        let r = parseInt(ex[i+1])
        let op = ex[i]
        #echo $result & " " & op & " " & $r
        if op == "+":
            result += r
        elif op == "*":
            result *= r
        elif op == "||":
            result = parseInt($result & $r)
    t[ex] = result

    #for i in 2..<ex.len:
    #    if op == "+":
    #        result += eq.values[i]
    #    elif op[i-1] == "*":
    #        result *= eq.values[i]
    #    elif op[i-1] == "||":
    #        result = parseInt($result & $eq.values[i])

#proc solve2(eq: Equation, op: seq[string], p: Pos, t: Memo): int =
#    if p in t:
#        return t[m]

var memo = initTable[Expression, int]()

var total2 = 0
for eq in equations:
  for op in product(@["*", "+", "||"], eq.values.len-1):

    var ex: Expression = @[$eq.values[0]]
    for i in 1..<eq.values.len:
        ex.add($op[i-1])
        ex.add($eq.values[i])

    echo ex
    echo ex.solve2(memo)
    break
    #if eq.solve(op) == eq.test:
    #    total2 += eq.test
    #    break
echo total2
