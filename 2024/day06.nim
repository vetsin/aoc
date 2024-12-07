import strutils
import sequtils
import tables

let input: string = readAll(stdin).strip()

type
  Matrix = seq[seq[char]]
  Pos = tuple[i:int,j:int]

const
  N: Pos = (-1,0)
  E: Pos = (0,1)
  S: Pos = (1,0)
  W: Pos = (0,-1)
  directions = @[N,E,S,W]

proc newMatrix(s: string): Matrix =
    for line in s.splitLines():
        result.add(cast[seq[char]](line))

var m = newMatrix(input)

proc inBounds(b: Matrix, p: Pos): bool =
    if p.i < 0 or p.j < 0:
        return false
    if p.i >= b.len:
        return false
    if p.j >= b[p.i].len:
        return false
    return true

proc `[]=`(b: var Matrix, p: Pos, x: char) = 
    b[p.i][p.j] = x

proc `[]`(b: Matrix, p: Pos): char =
    b[p.i][p.j]

proc `$`(b: Matrix): string =
    result = ""
    for row in b:
        result = result & $row.join & "\n"

proc start(b: Matrix): Pos =
    for i, row in b:
        for j, c in row:
            if c == '^':
                return (i, j)

proc `+`(p1, p2: Pos): Pos =
    (p1.i + p2.i, p1.j + p2.j)

proc count(m: Matrix, c: char): int =
    result = 0
    for row in m:
        for col in row:
            if col == c:
                inc result

proc walk(m: Matrix): Matrix = 
    var dir:int = 0
    var pos:Pos = m.start

    for i in 0..<m.len:
        result.add(newSeqWith(m[0].len, '.'))

    result[pos] = '#'
    var next = pos+directions[dir]
    while m.inBounds(pos) and m.inBounds(next):
        if m[next] == '#':
            dir = (dir + 1) mod 4
            #next = pos+directions[dir]
        else:
            pos = next
            result[pos] = '#'
        next = pos+directions[dir]

var res = walk(m)
echo count(res, '#')

type
    HistoryEntry = tuple[p:Pos,d:int]
    HistoryT = TableRef[HistoryEntry, int]

proc isLoop(m: Matrix, artifical: Pos): bool = 
    var dir:int = 0
    var pos:Pos = m.start
    var thistory = HistoryT()

    var next = pos+directions[dir]
    while m.inBounds(next):
        if thistory.hasKey((next,dir)):
            return true
        if next == artifical or m[next] == '#':
            dir = (dir + 1) mod 4
        else:
            pos = next
            thistory[(pos,dir)] = 0
        next = pos+directions[dir]
    return false

var obs = 0
var spos = m.start
for i in 0..<m.len:
    for j in 0..<m[0].len:
        if res[(i,j)] == '#' and m[(i,j)] != '#' and (i,j) != spos:
            if m.isLoop((i,j)):
                inc obs
echo obs