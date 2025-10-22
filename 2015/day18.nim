import macros
import sugar
import strutils
import sequtils

type
    Grid = seq[seq[bool]]
const
    GRID_CONST: Grid = block:
        var result: seq[seq[bool]] = @[]
        for line in staticRead("day18.in").splitLines():
            if line.isEmptyOrWhitespace: continue
            result.add(line.mapIt(it == '#'))
        result

proc `$`(grid: Grid): string =
    result = ""
    for row in grid:
        result.add(row.mapIt(if it: "#" else: ".").join)
        result.add("\n")

iterator iter(grid: Grid): (int, int) =
    for x in 0 .. grid.len - 1:
        for y in 0 .. grid[0].len - 1:
            yield (x, y)

iterator neighbors(grid: Grid, x: int, y: int): bool =
    if x < 0 or x >= grid.len or y < 0 or y >= grid[0].len: 
        raise newException(ValueError, "Invalid coordinates")
    for dx in -1 .. 1:
        for dy in -1 .. 1:
            if dx == 0 and dy == 0: continue
            let nx = x + dx
            let ny = y + dy
            if nx < 0 or nx >= grid.len or ny < 0 or ny >= grid[0].len: continue
            yield grid[nx][ny]

proc countNeighbors(grid: Grid, x: int, y: int): int =
    result = 0
    for n in grid.neighbors(x, y):
        if n:
          inc result

proc toggle(grid: Grid, x: int, y: int): bool =
    let count = grid.countNeighbors(x, y)
    if grid[x][y]:
        return count in {2, 3}
    return count == 3

proc toggle_p2(grid: Grid, x: int, y: int): bool =
    if (x == 0 and y == 0) or 
       (x == 0 and y == grid[0].len - 1) or
       (x == grid.len - 1 and y == 0) or
       (x == grid.len - 1 and y == grid[0].len - 1):
        return true
    return toggle(grid, x, y)

proc sum(grid: Grid): int = 
    result = 0
    for (x, y) in grid.iter:
        if grid[x][y]:
            inc result

#echo GRID_CONST
var current_grid = GRID_CONST
for x in 1 .. 100:
    var new_grid: Grid = current_grid
    for (x, y) in current_grid.iter:
        new_grid[x][y] = current_grid.toggle_p2(x, y)
    current_grid = new_grid 
    #echo current_grid
    #echo "----"
echo current_grid.sum()