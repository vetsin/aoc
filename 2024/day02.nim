import strutils
import sequtils
import math

import sugar

var input: string = readAll(stdin).strip()

proc isSafe(levels: seq[int]): bool =
    var dir: int = 0
    for i in 1..<len(levels):
        var diff = levels[i] - levels[i - 1]
        if i == 1:
            dir = sgn(diff)
        if sgn(diff) != dir:
            return false
        var adiff = abs(diff)
        if adiff < 1 or adiff > 3:
            return false
    return true

var allLevels: seq[seq[int]] = @[]
for line in splitLines(input):
    allLevels.add line.splitWhitespace().mapIt(parseInt(it))

var safeReports: int = 0
for levels in allLevels:
    if isSafe(levels):
        inc safeReports

echo safeReports
#echo allLevels.filter(isSafe).len


func canBeMadeSafe(levels: seq[int]): bool =
    for i in 0..<len(levels):
        let modifiedLevels = collect:
            for j in 0..<len(levels):
                if j != i:
                    levels[j]
        if isSafe(modifiedLevels):
            return true 
    return false


var safeReportsDamp: int = 0
for levels in allLevels:
    if isSafe(levels) or canBeMadeSafe(levels):
        inc safeReportsDamp

echo safeReportsDamp