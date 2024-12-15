import strutils
import sequtils
import sugar

type
    Map = seq[seq[char]]
    Pos = tuple[x,y: int]

proc parse(input: string): tuple[m:Map,c:string] =
    let parts = input.split("\p\p")
    var map: Map = @[]
    for line in parts[0].splitLines():
        var nline = ""
        for c in line:
            if c == '#':
                nline &= "##"
            elif c == 'O':
                nline &= "[]"
            elif c == '.':
                nline &= ".."
            elif c == '@':
                nline &= "@."
        map.add @nline
    (map, parts[1])


proc findRobot(map: Map): Pos =
    for i, r in map:
        for j, c in r: 
            if c == '@':
                return (j,i)

proc `+`(l, r: Pos): Pos =
    (l.x+r.x, l.y+r.y)

proc `$`(m: Map): string =
    result = ""
    for row in m:
        result &= row.join() & "\n"

proc move(m: var Map, p: seq[Pos], dir: char): seq[Pos] = 
    var np = p
    if dir == '<':
        np = p.map(e => e+(-1,0))
    elif dir == '>':
        np = p.map(e => e+(1,0))
    elif dir == '^':
        np = p.map(e => e+(0,-1))
    elif dir == 'v':
        np = p.map(e => e+(0,1))
    for e in np:
        if e.x < 0 or e.x >= m[0].len:
            return p
        if e.y < 0 or e.y >= m.len:
            return p
        if m[e.y][e.x] == '#':
            return p

    echo "moving ", p, " to ", np
    if all(np, e => m[e.y][e.x] == '.'):
        for (e1, e2) in zip(np, p):
             swap(m[e1.y][e1.x], m[e2.y][e2.x])
        return np
    elif m[np[0].y][np[0].x] == '[':
        if m[np[1].y][np[1].y] == ']':
            discard m.move(np, dir)
            #echo "\t now ", m[np.y][np.x]
            if m[np.y][np.x] == '.':
                return m.move(p, dir)

    elif m[np[0].y][np[0].x] == ']':
        if m[np[1].y][np[1].y] == '[':
    #        canMoveAll = false
    #var canMoveAll = true
    #for e in np:
    #    if m[e.y][e.x] != '.':
    #        canMoveAll = false

    #if canMoveAll:
    #    var res: seq[Pos] = @[]
    #    for e in np:
    #        discard m.move(@[e], dir)
    #        if m[e.y][e.x] == '.':
    #            res.add m.move(@[e], dir)[0]
    #    return res
    return p


var (map, instructions) = static(parse(slurp(".day15-s.txt")))
var robot = @[map.findRobot()]

echo map
for dir in instructions[0..1]:
    robot = map.move(robot, dir)
    echo dir,  map
#echo map

proc gps(m: Map): int = 
    result = 0
    for i, row in map:
        for j, c in row:
            if c == 'O':
                result += 100 * i + j

echo map.gps()








