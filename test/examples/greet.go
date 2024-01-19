package main

import "fmt"

// Greet type
type Greet struct {
	Message string
}

// NewGreet function to create a new Greet
func NewGreet(message string) *Greet {
	return &Greet{
		Message: message,
	}
}

// SayHello method for Greet
func (g *Greet) SayHello() {
	fmt.Println(g.Message)
}

func main() {
	greet := NewGreet("Hello, World!")
	greet.SayHello()
}
