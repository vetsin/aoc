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

	var cn *Node

	cn = m["AAA"]
	//fmt.Println(cn)

	i := 0

	for cn.V != "ZZZ" {
		for _, c := range commands {
			//fmt.Println(cn)
			var next string
			if c == 'L' {
				next = cn.L
			} else {
				next = cn.R
			}
			cn = m[next]
			i += 1
			if cn.V == "ZZZ" {
				break
			}
		}
	}

	fmt.Println(cn)
	fmt.Println(i)
}
