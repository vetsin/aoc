import strutils
import sequtils

let input: string = readAll(stdin).strip()


type
    Rule = tuple[left: int, right: int]
    Update = seq[int]


proc newRule(s: string): Rule =
    let p = s.split("|")
    result = (parseInt(p[0]), parseInt(p[1]))

proc newUpdate(s: string): Update =
    return s.split(",").map(parseInt)


var 
    parts = input.split("\n\n")
    rules = parts[0].splitWhitespace().map(newRule)
    updates = parts[1].splitLines().map(newUpdate)

proc findLeft(update: Update, index: int, item: int): int =
    result = 0
    for i in 0..index-1:
        if update[i] == item: return
        inc result
    result = -1
    
proc findRight(update: Update, index: int, item: int): int =
    result = 0
    for i in index+1..update.len-1:
        if update[i] == item: return
        inc result
    result = -1

proc checkRule(update: Update, rule: Rule, i: int): int =
    if rule.left == update[i]:
        let n = update.findLeft(i, rule.right)
        if n > -1:
            return n
    elif rule.right == update[i]:
        let n = update.findRight(i, rule.left)
        if n > -1:
            return n
    return -1

proc isSorted(update: Update): bool =
    for i in 0..<update.len:
        for rule in rules:
            if update.checkRule(rule, i) > -1:
                return false
    return true


proc sort(update: var Update) =
    while not isSorted(update):
        for index in 0..<update.len:
            for rule in rules:
                #let n = update.checkRule(rule, index)
                #if n > -1:
                #    swap(update[index], update[n])
                if (let n = update.checkRule(rule, index); n) > -1:
                    swap(update[index], update[n])


var total = 0
var total2 = 0
for u in updates.mitems:
    if u.isSorted():
        total += u[u.len div 2]
    else:
        u.sort()
        total2 += u[u.len div 2]
echo total
echo total2