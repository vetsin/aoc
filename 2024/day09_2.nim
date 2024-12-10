import strutils
import sequtils
import math

#var input = "2333133121414131402"
#var input = "12345"
var input: string = readAll(stdin).strip()
if input.len mod 2 != 0:
    input &= "0"

type
  Disk = seq[int]

proc `$`(d: Disk): string = 
  result = newStringOfCap(len(d)+1)
  for i in d:
    add(result, (if i >= 0: $i else: "."))

proc checksum(d: Disk): int =
  result = 0
  for i, v in d:
    if v >= 0:
      result += i * v

proc parse(s: string): seq[int] =
  result = @[]
  var id = 0
  for i in countup(0, s.len-1, 2):
    for _ in 0..<parseInt($s[i]):
      result.add id
    for _ in 0..<parseInt($s[i+1]):
      result.add -1
    inc id
    
proc condense(d: var Disk) = 
  var i = 0
  var j = d.len - 1
  while i < j:
    if d[i] == -1 and d[j] != -1:
      swap(d[i], d[j])
    if d[i] != -1:
      inc i
    if d[j] == -1:
      dec j

var disk = parse(input)
#echo $disk
condense(disk)
#echo $disk
echo disk.checksum

proc search(d: var Disk, target, size: int): int =
  for i, v in d:
    if v == target and i+size < d.len:
      #echo repeat(target, size),  " - ", d[i..i+size]
      if repeat(target, size) == d[i..i+size-1]:
        return i
  return -1

proc condenseBlock(d: var Disk) =
  var j = d.len-1
  var jsize = 0
  var prevJ = -1
  while j > 0:
    if d[j] == prevJ:
      inc jsize
    else:
      if prevJ != -1:
        inc jsize
        let atIdx = d.search(-1, jsize)
        if atIdx >= 0 and atIdx < j:
          let leftIndex = atIdx
          let rightIndex = j+1
          for i in 0..<jsize:
            swap(d[leftIndex+i], d[rightIndex+i])
          #echo $d
      jsize = 0
      prevJ = d[j]
    dec j

var disk2 = parse(input)
#echo $disk2
condenseBlock(disk2)
#echo $disk2
echo disk2.checksum
