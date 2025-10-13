import strutils
import math
import sequtils

#const lines = @["Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.", "Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds."]
const lines = staticRead("day14.in").splitLines()

type 
  Deer* = object
    name: string
    kms, burst, rest: int
    traveled: int
    points: int = 0

var deers: seq[Deer] = @[]
for line in lines:
  if line.len == 0: continue
  let parts = line.split(" ")
  deers.add(Deer(name: parts[0],
                 kms: parseInt(parts[3]),
                 burst: parseInt(parts[6]),
                 rest: parseInt(parts[13])))

proc setDistance(deer: var Deer, seconds: int) = 
  let cycleTime = deer.burst + deer.rest
  let burstCount = seconds div cycleTime
  let remaining = seconds mod cycleTime
  let extraTime = min(remaining, deer.burst)
  deer.traveled = (burstCount * deer.kms * deer.burst) + (extraTime * deer.kms)

var fastest = deers[0]
for d in deers.mitems:
  d.setDistance(2503)
  if d.traveled > fastest.traveled:
    fastest = d
echo $fastest

# part2
for i in 1 .. 2503:
  var h = int.low
  for d in deers.mitems:
    d.setDistance(i)
    if d.traveled > h:
      h = d.traveled
  for d in deers.mitems:
    if d.traveled >= h:
      inc d.points

for d in deers:
  if d.points > fastest.points:
    fastest = d
echo $fastest