type
  Password = string

const banned = @['i','o','l']

proc inc(p: var Password, i: int = p.len() - 1): void = 
  p[i] = chr(((ord(p[i]) - 96) mod 26) + 97)
  if p[i] == 'a':
    # we looped
    p.inc(i-1)

proc isSequential(s: string): bool = 
  var last = ord(s[0])
  var i = 1
  while i < s.len():
    let next = ord(s[i])
    if next != (last+1):
      return false
    last = next
    inc i
  return true

proc isPair(s: string): bool =
  result = false
  if len(s) == 2:
    if s[0] == s[1]:
      result = true

proc isValid(p: Password): bool =
  if len(p) != 8:
    return false
  var hasInc = false
  var pairs: seq[int] = @[]

  if p[0] in banned:
    return false

  var i = 1
  while i < p.len():
    if p[i] in banned:
      return false
    if not hasInc and i > 1:
      hasInc = isSequential(p[i-2 .. i])
    if len(pairs) < 2 and i > 0:
      let pair = p[i-1 .. i]
      if pair.isPair() and i-1 notin pairs:
        pairs.add(i)
    inc(i)
  return hasInc and len(pairs) >= 2

var p: Password = "hxbxwxba"
while not p.isValid():
  inc(p)
echo p

# part2
inc(p)
while not p.isValid():
  inc(p)
echo p
