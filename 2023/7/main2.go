package main

import (
	"fmt"
	"os"
	"strings"
)

type Node struct {
	L string
	R string
	V string
}

type PNode struct {
	V string
	L *PNode
	R *PNode
}

type LoopMarker struct {
	V   string
	toZ int
}

func EndsWithZ(check []string) bool {
	for _, k := range check {
		if !strings.HasSuffix(k, "Z") {
			return false
		}
	}
	return true
}

func main() {
	b, _ := os.ReadFile("input")
	input := strings.TrimSpace(string(b))

	parts := strings.Split(input, "\n\n")
	commands := parts[0]
	//fmt.Println(commands)

	m := make(map[string]*Node)

	for _, line := range strings.Split(parts[1], "\n") {

		l := line[7:10]
		r := line[12:15]

		n := Node{V: line[:3], L: l, R: r}
		m[n.V] = &n
	}

	cnk := []string{}
	for k := range m {
		if strings.HasSuffix(k, "A") {
			cnk = append(cnk, k)
		}
	}

	fmt.Println("start", cnk)

	i := 0

	for !EndsWithZ(cnk) {
		for _, c := range commands {
			//fmt.Println(cn)
			for i, k := range cnk {
				var next string
				nk := m[k]
				if c == 'L' {
					next = nk.L
				} else {
					next = nk.R
				}
				cnk[i] = m[next].V
			}
			i += 1
			if (i % 100000000) == 0 {
				fmt.Println("on loop", i)
			}
			if EndsWithZ(cnk) {
				break
			}
		}
	}

	fmt.Println("end", cnk)
	fmt.Println(i)
}
