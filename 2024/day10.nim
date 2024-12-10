import strutils

var input: string = readAll(stdin).strip()

type
    Map = seq[seq[int]]
    Pos = tuple[i,j:int]

const
  N: Pos = (-1,0)
  E: Pos = (0,1)
  S: Pos = (1,0)
  W: Pos = (0,-1)
  directions = @[N,E,S,W]

var m: Map
for line in input.splitLines():
    var r: seq[int] = @[]
    for c in line:
        if c == '.':
            r.add -1
        else:
            r.add parseInt($c)
    m.add(r)

proc inBounds(b: Map, p: Pos): bool =
    if p.i < 0 or p.j < 0:
        return false
    if p.i >= b.len:
        return false
    if p.j >= b[p.i].len:
        return false
    return true

proc `+`(p1, p2: Pos): Pos =
    (p1.i + p2.i, p1.j + p2.j)

proc `[]`(b: Map, p: Pos): int =
    b[p.i][p.j]

iterator trailhead(m: Map): Pos =
    for i, row in m:
        for j, c in row:
            if c == 0:
                yield (i,j)

iterator adjacent(p: Pos): Pos =
    for d in directions:
        yield p+d

proc score(m: var Map, th: Pos, total, trails: var int) =
    var temp: seq[Pos] = @[]
    var result: seq[seq[Pos]] = @[]
    proc search(m: var Map, p: Pos) =
        if m[p] == 9:
            result.add temp[0..^1]
            return
        for adj in p.adjacent:
            if m.inBounds(adj) and m[adj] == m[p]+1 and not temp.contains(adj):
                temp.add(adj)
                search(m, adj)
                discard temp.pop()
    search(m, th)
    var endings: seq[Pos] = @[]
    for r in result:
        #echo r
        if not (r[^1] in endings):
            endings.add r[^1]
    #echo "Total paths: ", result.len
    #echo "Score: ", endings.len
    total += endings.len
    trails += result.len

var totalScore:int = 0
var trails = 0
for th in m.trailhead:
    m.score(th, totalScore, trails)
    
echo "Total score: ", totalScore
echo "Total trails: ", trails