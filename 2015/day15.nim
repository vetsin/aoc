import strutils
import sequtils
import sugar
import math
import itertools
import algorithm
import strformat

import arraymancer

#const lines = @["Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8", "Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3"]
const lines = staticRead("day15.in").splitLines()

let ingredients = block:
  var temp: seq[seq[int]] = @[]
  for line in lines:
    if line.len <= 0: continue
    let mparts = line.split(": ")
    let parts = mparts[1].split(", ").map(p => parseInt(p.split(' ')[^1]))
    temp.add(@[
            parts[0],
            parts[1],
            parts[2],
            parts[3],
            parts[4]])
  temp.toTensor

var score = int.low
var score500 = int.low
for i in 0 .. 100:
  for j in 0 .. 100-i:
    for k in 0 .. 100-i-j:
      let h = 100-i-j-k
      let coeffs = @[[i,j,k,h][0..<ingredients.shape[0]]].toTensor.transpose
      let s = (ingredients[_,0..<4] *. coeffs).sum(axis=0).map(x => max(0, x)).product
      score = max(score, s)
      # part2
      let cal = (ingredients[_,4] *. coeffs).sum(axis=0).item
      if cal == 500:
        score500 = max(score500, s)
echo score
echo score500