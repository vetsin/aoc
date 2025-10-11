import macros
import strutils
import sequtils

# part1
const
  lines = staticRead("day8.in").splitLines()
  parsedLines = block:
    var result: seq[string] = @[]
    for line in lines:
      if line.strip.len == 0: continue
      result.add(parseExpr(line).strVal)
    result

echo lines.mapIt(it.len).foldl(a+b) - parsedLines.mapIt(it.len).foldl(a+b)

# part2
const
  encodedLines = block:
    var result: seq[string] = @[]
    for line in lines:
      if line.strip.len == 0: continue
      result.add(line.repr)
    result
    
echo encodedLines.mapIt(it.len).foldl(a+b) - lines.mapIt(it.len).foldl(a+b)
