import strutils
import tables
import math

var input = "125 17"
input = "3279 998884 1832781 517 8 18864 28 0"

type
    Stone = int
    Row = OrderedTable[Stone, int]

var r: Row = initOrderedTable[Stone,int]()
for c in input.splitWhitespace():
    r[parseInt(c)] = 1
#echo r

proc transform(s: Stone): seq[Stone] = 
    if s == 0:
        return @[1]
    let stonelen = floor(log10(s.float)) + 1
    if stonelen mod 2 == 0:
        let half = stonelen / 2
        let divisor = pow(10, (stonelen - half)).int
        return @[s div divisor, s mod divisor]
    return @[s*2024]

proc blink(row: Row): Row = 
    for stone, count in row:
        for s in stone.transform():
            result[s] = result.getOrDefault(s, 0) + count
    
proc len(row: Row): int = 
    for _, i in row:
        result += i

for _ in 0..<75:
    r = r.blink()
    #echo r
echo "Len ", r.len