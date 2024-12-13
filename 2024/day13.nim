import strutils
import sequtils
import math
import itertools

let input: string = readAll(stdin).strip()

type
    Pos = tuple[x, y: int, op: char]
    Puzzle = object
        A: Pos
        B: Pos
        Prize: Pos

proc newPos(s: string): Pos = 
    for sp in s.split(", "):
        result.op = sp[1]
        if sp[0] == 'X':
            result.x = parseInt(sp[2..^1])
        elif sp[0] == 'Y':
            result.y = parseInt(sp[2..^1])
    
var puzzles: seq[Puzzle] = @[]

var puzzle = Puzzle()
for line in input.splitLines:
    if line == "":
        puzzles.add(puzzle)
        puzzle = Puzzle()
        continue
    let parts = line.split(": ")
    if parts[0] == "Button A":
        puzzle.A = newPos(parts[1])
    elif parts[0] == "Button B":
        puzzle.B = newPos(parts[1])
    elif parts[0] == "Prize":
        puzzle.Prize = newPos(parts[1])
puzzles.add puzzle

proc igcd(a, b: int, x, y: var int): int =
    if b == 0:
        x = 1
        y = 0
        return a
    var x1, y1: int
    let d = igcd(b, a mod b, x1, y1)
    x = y1
    y = x1 - y1 * (a div b)
    return d

proc bruteSolve(p: Puzzle): int =
    result = -1
    for parts in product(to_seq(1..1000), repeat=2):
        let (a_presses, b_presses) = (parts[0], parts[1])
        if (p.A.x * a_presses) + (p.B.x * b_presses) == p.Prize.x and 
           (p.A.y * a_presses) + (p.B.y * b_presses) == p.Prize.y:
            result = (3 * a_presses) + b_presses
            break

proc linearSolve(p: var Puzzle, add: int = 0): int =
    proc linear(p: var Puzzle, add: int = 0): tuple[a,b:float] =
        let prizeX = p.Prize.x + add
        let prizeY = p.Prize.y + add
        let determinant =  p.A.x*p.B.y - p.A.y*p.B.x
        let n1 = (prizeX*p.B.y - prizeY*p.B.x) / determinant
        let n2 = (prizeY*p.A.x - prizeX*p.A.y) / determinant
        (n1, n2)
    result = -1
    let n = linear(p, add)
    if n.a mod 1 == 0 and 
        n.b mod 1 == 0 and 
        n.a >= 0 and
        n.b >= 0:
       result = (3*n.a.int + n.b.int)

when defined(p1):
    var total = 0
    for p in puzzles.mitems:
        #let cost = p.bruteSolve()
        let cost = p.linearSolve()
        if cost > 0:
            total += cost
    echo total

var total2 = 0
for p in puzzles.mitems:
    #let cost = p.bruteSolve()
    let cost = p.linearSolve(10_000_000_000_000)
    if cost > 0:
        total2 += cost
echo total2