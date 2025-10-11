import strutils

var input = "1321131112"

proc elveit(input: string): string =
  var i = 0
  var c: char = input[0]
  var cc = 0
  var result = ""
  while i < len(input):
    if c != input[i]:
      result &= $cc & c
      c = input[i]
      cc = 1
    else:
      inc(cc)
    inc(i)
  result &= $cc & c
  result

for i in 1..40:
  input = elveit(input)
echo len(input)

#part 2
input = "1321131112"
for i in 1..50:
  input = elveit(input)
echo len(input)