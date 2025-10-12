import strutils
import algorithm
import sets
import tables

const lines = staticRead("day13.in").splitLines()

var people: seq[string] = @[]
var h: Table[(string, string), int]

for line in lines:
  if line.strip.len == 0: continue
  let parts = line[0 .. ^2].split(' ')
  var score = parseInt(parts[3])
  if parts[2] == "lose":
    score = score * -1
  if parts[0] notin people:
    people.add(parts[0])
  h[(parts[0], parts[^1])] = score
  
proc calcScore(arrangement: seq[string]): int =
  for i in 0 ..< arrangement.len:
    let j = (i + 1) mod arrangement.len
    result += h.getOrDefault((arrangement[i], arrangement[j]), 0)
    result += h.getOrDefault((arrangement[j], arrangement[i]), 0)

iterator circlePermutations(people: seq[string]): seq[string] =
  var seen = initHashSet[seq[string]]()
  let first = @[people[0]]
  var rest = people[1..^1]
  while rest.nextPermutation():
    var t = @[
      first & rest,
      first & rest.reversed
    ]
    t.sort(proc(a, b: seq[string]): int = cmp(a.join(" "), b.join(" ")))
    if not seen.containsOrIncl(t[0]):
      yield t[0]

var highestScore = int.low
for arr in people.circlePermutations():
  highestScore = max(highestScore, calcScore(arr))
echo highestScore

# part 2
highestScore = int.low
people.add("it's britney, bitch")
for arr in people.circlePermutations():
  highestScore = max(highestScore, calcScore(arr))
echo highestScore