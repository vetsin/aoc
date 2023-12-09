package main

import (
	"fmt"
	"os"
	"strings"
)

type Node struct {
	L string
	R string
}

func gcd(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}

func lcm(args ...int) int {
	a := args[0]
	for i := 1; i < len(args); i++ {
		b := args[i]
		a = int(float64(a*b) / float64(gcd(a, b)))
	}
	return a
}

func main() {
	b, _ := os.ReadFile("input")
	input := strings.TrimSpace(string(b))

	parts := strings.Split(input, "\n\n")
	commands := parts[0]
	//fmt.Println(commands)

	m := make(map[string]*Node)

	for _, line := range strings.Split(parts[1], "\n") {
		v := line[:3]
		l := line[7:10]
		r := line[12:15]
		n := Node{L: l, R: r}
		m[v] = &n
	}

	cnk := []string{}
	for k := range m {
		if k[2] == 'A' {
			cnk = append(cnk, k)
		}
	}

	fmt.Println("start", cnk)

	times := []int{}
	for _, k := range cnk {

		x := 0
		for j := 0; j < 80; j++ {
			for _, c := range commands {
				if c == 'L' {
					k = m[k].L
				} else {
					k = m[k].R
				}
				x += 1
				if k[2] == 'Z' {
					times = append(times, x)
					goto end
				}
			}
		}
	end:
	}
	fmt.Println(times)
	fmt.Println(lcm(times...))
}
