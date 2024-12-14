import strutils

const
    W = 101
    H = 103

type
  Robot = object
    p: tuple[x,y: int]
    v: tuple[x,y: int]

proc move(r: var Robot, cycles: int) =
    r.p.x = ((r.p.x + cycles * r.v.x) mod W + W) mod W
    r.p.y = ((r.p.y + cycles * r.v.y) mod H + H) mod H

proc move(robots: var seq[Robot], cycles: int) =
    for r in robots.mitems:
        r.move(cycles)

proc quad(r: Robot): int = 
    let mx = W div 2
    let my = H div 2
    if r.p.x < mx and r.p.y < my:
        return 0
    if r.p.x > mx and r.p.y < my:
        return 1
    if r.p.x < mx and r.p.y > my:
        return 2
    if r.p.x > mx and r.p.y > my:
        return 3
    return -1

#var test = Robot(p:(2,4), v:(2,-3))

let input: string = readAll(stdin).strip()

var robots: seq[Robot] = @[]
for line in input.splitLines:
    let parts = line.split(" ")
    let px = parts[0].split("=")[1].split(",")[0].parseInt()
    let py = parts[0].split("=")[1].split(",")[1].parseInt()
    let vx = parts[1].split("=")[1].split(",")[0].parseInt()
    let vy = parts[1].split("=")[1].split(",")[1].parseInt()
    robots.add Robot(p:(px,py), v:(vx,vy))

when defined(part1):
    robots.move(100)

    var qs: array[0..3, int]
    for r in robots:
        let q = r.quad()
        if q >= 0: 
            inc qs[q]

    var total = qs[0]
    for e in qs[1..^1]:
        total *= e
    echo total

proc `$`(robots: seq[Robot]): string =
    var rows: seq[seq[int]] = @[]
    for i in 0..<H:
        var row: seq[int] = @[]
        for j in 0..<W:
            row.add(0)
        rows.add(row)
    for r in robots:
        inc rows[r.p.y][r.p.x]
    result = ""
    for row in rows:
        var t = row.join("") & "\n"
        result &= t.replace("0",".")

# part2
when defined(part2):
    var count = 1 
    while true:
        robots.move(1)
        if ($robots).contains("11111111111"):
            echo robots
            echo count
            break
        inc count