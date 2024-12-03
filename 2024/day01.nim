import strutils
import sequtils
import algorithm
import os
import math

import sugar

var input: string =  readLine(stdin)
var left: seq[int] = @[]
var right: seq[int] = @[]

for i, value in input.splitWhitespace().mapIt(parseInt(it)):
  if i mod 2 == 0:
    left.add(value)
  else:
    right.add(value)

left.sort()
right.sort()

var total: int = 0
for _, (l, r) in zip(left, right):
  total += abs(l-r)

echo total

# part two
var total2: int = 0

for _, l in left:
  var c = count(right, l)
  total2 += l * c

echo total2