import std/re
import std/sequtils
import std/strutils

const input = staticRead("day12.in")
# part1
echo findAll(input, re"-?\d+").mapIt(parseInt(it)).foldl(a+b)

# part2
import std/json
let jinput = parseJson(input)

proc hasRed(node: JsonNode): bool =
  if node.kind == JObject:
    for _, v in node.pairs:
      if v.kind == JString and v.getStr() == "red":
        return true
  return false

proc walk(node: JsonNode, cur: int = 0): int =
  var result = 0
  if hasRed(node):
    return cur
  case node.kind
  of JObject:
    for k, v in node.pairs:
      result += walk(v, cur)
  of JArray:
    for e in node.elems:
      result += walk(e, cur)
  of JInt, JFloat:
    result = node.getInt()
  else:
    discard
  return result + cur
  
echo walk(jinput)
