import strutils
import sequtils
import math

#var input = "2333133121414131402"
var input: string = readAll(stdin).strip()
if input.len mod 2 != 0:
    input &= "0"

type
  Block = ref object
    id: int
    size: int
    originalSize: int
    freeMax: int
    free: seq[Block]

proc freeCount(b: Block): int =
  result = b.freeMax
  for f in b.free:
    result -= f.size

proc checksum(b: Block, i: var int): int =
  result = 0
  for _ in 0..<b.size:
    result += i * b.id
    inc i
  i += b.originalSize - b.size
  for f in b.free:
    for _ in 0..<f.size:
        result += i * f.id
        inc i
  i += b.freeCount()

proc checksum(blocks: seq[Block]): int = 
  result = 0
  var i = 0
  for b in blocks:
    result += b.checksum(i)


proc hasFree(b: Block): bool =
  return b.freeCount() > 0

proc `$`(b: Block): string = 
  result = repeat($b.id, b.size)
  for _ in 0..<(b.originalSize-b.size):
    result &= "."
  var i = 0
  for f in b.free:
      result &= $f
      i += f.size
  for j in i..<b.freeMax:
      result &= "."

iterator parse(s: string): Block = 
  var id = 0
  for i in countup(0, s.len-1, 2):
      var b = new Block
      b.id = id
      b.size = parseInt($s[i])
      b.originalSize = b.size
      b.freeMax = parseInt($s[i+1])
      yield b
      inc id

var blocks = parse(input).toSeq
#echo $blocks

proc compact(blocks: seq[Block]): int =
  var i = 0
  var j = blocks.len-1
  while i < j:
    if blocks[i].freeCount() > 0:
      var nb = new Block
      nb.id = blocks[j].id
      nb.size = min(blocks[i].freeCount(), blocks[j].size)
      blocks[i].free.add(nb)
      blocks[j].size -= nb.size
    if blocks[i].freeCount() == 0:
      inc i
    if blocks[j].size == 0:
      dec j
  return blocks.checksum()

echo "Part1 ", blocks.compact()

proc compactNoFrag(blocks: seq[Block]): int = 
  var j = blocks.len-1
  while j > 0:
    for i in 0..<j:
      if blocks[i].freeCount() >= blocks[j].size:
        var nb = new Block
        nb.id = blocks[j].id
        nb.size = blocks[j].size
        blocks[i].free.add(nb)
        blocks[j].size = 0
        break
    dec j
  return blocks.checksum()

blocks = parse(input).toSeq
echo "Part2 ", blocks.compactNoFrag()