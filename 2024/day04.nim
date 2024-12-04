import strutils

var input: string = readAll(stdin).strip()

type
  Matrix = seq[seq[char]]

var m: Matrix
for line in input.splitLines():
    m.add(cast[seq[char]](line))

proc `[]`(b: Matrix, i, j: int): char = 
    if i < 0 or j < 0:
        return
    if i >= b.len:
        return
    if j >= b[i].len:
        return
    b[i][j]

proc search(b: Matrix, i, j: int): int =
    result = 0
    if b[i,j] == 'X':
        if b[i+1,j] == 'M':
            if b[i+2,j] == 'A':
                if b[i+3,j] == 'S':
                    inc result
        if b[i-1,j] == 'M':
            if b[i-2,j] == 'A':
                if b[i-3,j] == 'S':
                    inc result
        if b[i,j+1] == 'M':
            if b[i,j+2] == 'A':
                if b[i,j+3] == 'S':
                    inc result
        if b[i,j-1] == 'M':
            if b[i,j-2] == 'A':
                if b[i,j-3] == 'S':
                    inc result
        if b[i+1,j+1] == 'M':
            if b[i+2,j+2] == 'A':
                if b[i+3,j+3] == 'S':
                    inc result
        if b[i-1,j-1] == 'M':
            if b[i-2,j-2] == 'A':
                if b[i-3,j-3] == 'S':
                    inc result
        if b[i-1,j+1] == 'M':
            if b[i-2,j+2] == 'A':
                if b[i-3,j+3] == 'S':
                    inc result
        if b[i+1,j-1] == 'M':
            if b[i+2,j-2] == 'A':
                if b[i+3,j-3] == 'S':
                    inc result


var total = 0
for i in 0..<m.len:
    for j in 0..<m[i].len:
        total += search(m, i, j)
echo total


proc searchp2(b: Matrix, i, j: int): int =
    result = 0
    if b[i,j] == 'A':
        if b[i+1,j+1] == 'S' and
            b[i-1,j+1] == 'S' and
            b[i-1,j-1] == 'M' and
            b[i+1,j-1] == 'M':
                inc result
        if b[i+1,j+1] == 'M' and
            b[i-1,j+1] == 'M' and
            b[i-1,j-1] == 'S' and
            b[i+1,j-1] == 'S':
                inc result
        if b[i+1,j+1] == 'M' and
            b[i-1,j+1] == 'S' and
            b[i-1,j-1] == 'S' and
            b[i+1,j-1] == 'M':
                inc result
        if b[i+1,j+1] == 'S' and
            b[i-1,j+1] == 'M' and
            b[i-1,j-1] == 'M' and
            b[i+1,j-1] == 'S':
                inc result

var total2 = 0
for i in 0..<m.len:
    for j in 0..<m[i].len:
        total2 += searchp2(m, i, j)
echo total2