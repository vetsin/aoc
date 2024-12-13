import strutils
import sequtils
import algorithm

var input: string = readAll(stdin).strip()

type
    Plot = char
    Pos = tuple[i,j:int]
    Region = seq[Pos]
    Matrix = seq[seq[Plot]]

const
  N: Pos = (-1,0)
  E: Pos = (0,1)
  S: Pos = (1,0)
  W: Pos = (0,-1)
  directions = @[N,E,S,W]

proc newMatrix(s: string): Matrix =
    for line in s.splitLines():
        result.add(cast[seq[Plot]](line))

proc `[]=`(b: var Matrix, p: Pos, x: char) = 
    b[p.i][p.j] = x

proc `[]`(b: Matrix, p: Pos): char =
    b[p.i][p.j]

proc `$`(b: Matrix): string =
    result = ""
    for row in b:
        result = result & $row.join & "\n"

proc `+`(p1, p2: Pos): Pos =
    (p1.i + p2.i, p1.j + p2.j)

proc inBounds(b: Matrix, p: Pos): bool =
    if p.i < 0 or p.j < 0:
        return false
    if p.i >= b.len:
        return false
    if p.j >= b[p.i].len:
        return false
    return true

proc floodFill(m: var Matrix, start: Pos, visited: var seq[seq[bool]]): seq[Pos] =
  var stack: seq[Pos] = @[start]
  let target = m[start]
  while stack.len > 0:
    let p = stack.pop()
    #if not m.inBounds(p) or visited[p.i][p.j]:
    if not m.inBounds(p) or p in result:
        continue
    if m[p] == target:
      visited[p.i][p.j] = true
      result.add(p)
      for d in directions:
        stack.add(p+d)

proc findRegions(m: var Matrix): seq[Region] =
    var visited: seq[seq[bool]] = @[]
    for _ in 0..<m.len:
        visited.add(newSeq[bool](m[0].len))
    result = @[]
    for i, row in m:
        for j, col in row:
            if visited[i][j]:
                continue
            let ff = m.floodFill((i,j), visited)
            result.add(ff)

proc edges(r: var Region, m: var Matrix): seq[Pos] = 
    let target = m[r[0]]
    let height = m.len
    let width = m[0].len
    result = @[]
    for e in r:
        for d in directions:
            var p = e+d
            if p.i < 0 or p.i > height-1 or p.j < 0 or p.j > width-1:
                result.add e
            elif m[p] != target:
                result.add e

proc verticies(r: Region, m: var Matrix): seq[Pos] =
    result = @[]
    let outside = @[
        # different, different
        @[(0, -1), (-1, 0)],
        @[(0, -1), (1, 0)],
        @[(1, 0), (0, 1)],
        @[(-1, 0), (0, 1)]
    ]
    let inside = @[
        # siame, same, different
        @[(0, -1), (-1, 0), (-1, -1)],
        @[(0, -1), (1, 0), (1, -1)],
        @[(1, 0), (0, 1), (1, 1)],
        @[(-1, 0), (0, 1), (-1, 1)]
    ]
    for e in r:
        for oo in outside:
            let (o1, o2) = (oo[0], oo[1])
            if not (e+o1 in r) and not (e+o2 in r):
                result.add e
        for io in inside:
            let (i1, i2, i3) = (io[0], io[1], io[2])
            if (e+i1 in r) and (e+i2 in r) and not (e+i3 in r):
                result.add e

var m = newMatrix(input)
var regions = m.findRegions()
var total = 0
var total2 = 0

for region in regions.mitems:
    let area = region.len
    let edges = region.edges(m)
    let verts = region.verticies(m)
    total += area*edges.len
    total2 += area*verts.len
echo total
echo total2