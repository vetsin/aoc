import strutils
import sequtils

type
    Map = seq[seq[char]]
    Pos = tuple[x,y: int]

proc parse(input: string): tuple[m:Map,c:string] =
    let parts = input.split("\p\p")
    let map: Map = parts[0].splitLines().mapIt(@it)
    (map, parts[1])


proc findRobot(map: Map): Pos =
    for i, r in map:
        for j, c in r: 
            if c == '@':
                return (i,j)

proc `+`(l, r: Pos): Pos =
    (l.x+r.x, l.y+r.y)

proc `$`(m: Map): string =
    result = ""
    for row in m:
        result &= row.join() & "\n"

proc move(m: var Map, p: Pos, dir: char): Pos = 
    var np = p
    if dir == '<':
        np = p+(-1,0)
    elif dir == '>':
        np = p+(1,0)
    elif dir == '^':
        np = p+(0,-1)
    elif dir == 'v':
        np = p+(0,1)
    if np.x < 0 or np.x >= m[0].len:
        return p
    if np.y < 0 or np.y >= m.len:
        return p

    let nc = m[np.y][np.x]
    #echo "move ", m[p.y][p.x], " with ", nc, " (", dir ,")"
    if nc == '.':
        swap(m[p.y][p.x], m[np.y][np.x])
        return np
    elif nc == 'O':
        discard m.move(np, dir)
        #echo "\t now ", m[np.y][np.x]
        if m[np.y][np.x] == '.':
            return m.move(p, dir)
        #np = m.move(np, dir)
        discard
    elif nc == '#':
        discard
    return p

var (map, instructions) = static(parse(slurp(".day15.txt")))
var robot = map.findRobot()

for dir in instructions:
    robot = map.move(robot, dir)
    #echo map
echo map

proc gps(m: Map): int = 
    result = 0
    for i, row in map:
        for j, c in row:
            if c == 'O':
                result += 100 * i + j

echo map.gps()






