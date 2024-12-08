import strutils
import sequtils
import itertools
import math

type
  Matrix[T] = seq[seq[T]]
  Pos = tuple[i:int,j:int]

let input: string = readAll(stdin).strip()

proc newMatrix(s: string): Matrix[char] =
    result = @[]
    for line in s.splitLines():
        result.add(cast[seq[char]](line))

proc zeros(m, n: int): Matrix[int] =
    result = @[]
    for i in 0..<m:
        result.add(newSeqWith(n, 0))

proc inBounds(b: Matrix, p: Pos): bool =
    if p.i < 0 or p.j < 0:
        return false
    if p.i >= b.len:
        return false
    if p.j >= b[p.i].len:
        return false
    return true

proc `[]=`[T](b: var Matrix[T], p: Pos, x: T) = 
    b[p.i][p.j] = x

proc `[]`[T](b: Matrix[T], p: Pos): T =
    b[p.i][p.j]

proc `$`[T](b: Matrix[T]): string =
    result = ""
    for row in b:
        result = result & $row.join & "\n"

var m = newMatrix(input)

proc positions[T](m: var Matrix, target: T): seq[Pos] = 
    result = @[]
    for i, row in m:
        for j, c in row:
            if c == target:
                result.add((i,j))

iterator antennas(m: Matrix[char]): char =
    var found: seq[char] = @['.']
    for row in m:
        for c in row:
            if not found.contains(c):
                yield c
                found.add(c)

proc calculate(m: var Matrix[char], target: char, r: var Matrix[int]) =
    for c in combinations(m.positions(target), 2):
        let (A, B) = (c[0], c[1])
        let p = (2*A.i - B.i, 2*A.j - B.j) 
        let q = (2*B.i - A.i, 2*B.j - A.j)
        if r.inBounds(p):
            r[p] = r[p] + 1
        if r.inBounds(q):
            r[q] = r[q] + 1

iterator each[T](m: Matrix[T]): T = 
    for row in m:
        for c in row:
            yield c

proc fcount[T](m: Matrix[T], f: proc (i:T): bool): int =
    result = 0
    for e in m.each:
        if f(e):
            inc result

#echo m

var r = zeros(m.len, m[0].len)
for a in m.antennas:
    m.calculate(a, r)
echo "part1: ", r.fcount(proc(i:int): bool = i > 0)

proc calculateh(m: var Matrix[char], target: char, r: var Matrix[int]) =
    let positions = m.positions(target)
    for p in positions:
        r[p] = r[p] + 1
    for c in combinations(positions, 2):
        var (A, B) = (c[0], c[1])
        var p: Pos = (2*A.i - B.i, 2*A.j - B.j) 
        var q: Pos = (2*B.i - A.i, 2*B.j - A.j)
        while r.inBounds(p):
            r[p] = r[p] + 1
            p = (p.i+(A.i-B.i), p.j+(A.j-B.j))
        while r.inBounds(q):
            r[q] = r[q] + 1
            q = (q.i+(B.i-A.i), q.j+(B.j-A.j))

var rh = zeros(m.len, m[0].len)
for a in m.antennas:
    m.calculateh(a, rh)
echo "part2: ", rh.fcount(proc(i:int): bool = i > 0)