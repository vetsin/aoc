import strutils
import sequtils

var input: string = readAll(stdin).strip()

iterator parse(a: string, useDo: bool = false): int =
    var i = 0
    var inMul = false
    var cmd = ""
    var ddo = true
    while i < a.len:
        let c = a[i]
        if c == 'd' and i+3 < a.len:
            if a[i..i+3] == "do()":
                ddo = true
                i += 3
            elif i+6 < a.len:
                if a[i..i+6] == "don't()":
                    ddo = false
                    i += 6
        elif c == 'm' and i+6 < a.len:
            if a[i..i+3] == "mul(":
                inMul = true
                cmd = ""
                i += 3
        elif inMul:
            #echo "inMul ", c
            if c.isDigit or c == ',':
                cmd = cmd & c
            elif c == ')':
                inMul = false
                let
                    s = cmd.split(',')
                    (x, y) = (parseInt(s[0]), parseInt(s[1]))
                if useDo:
                    if ddo:
                        yield x*y
                else:
                    yield x*y
            else:
                inMul = false
        inc i

var total = 0        
for x in parse(input):
    total += x
echo total

var xtotal = 0        
for y in parse(input, true):
    xtotal += y
echo xtotal

## this is after seeing how a friend did his in perl

import nre

var ntotal = 0
var ddo = true
for m in input.findIter(re"(mul\(\d+,\d+\)|do\(\)|don't\(\))"):
    if m.match == "do()":
        ddo = true
    elif m.match == "don't()":
        ddo = false
    else:
        let 
            s: seq[int] = m.match.findAll(re"(\d+)").map(parseInt)
            (x, y) = (s[0], s[1])
        if ddo:
            ntotal += x*y
echo ntotal
