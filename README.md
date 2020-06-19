# NerVe

A simple Neural Network in V

![](https://i.imgur.com/MbxyHFV.jpg)

# Doc

```v
// Creates a new NeuralNetwork instance following the layer scheme
fn new(layer []int) &NeuralNetwork

// Creates a new NeuralNetwork instance of 4 layers, with 4 input neurons and 1 output neurons
n := nerve.new( [4, 8, 6, 1] )


// Teaches the NeuralNetwork instance
fn (n &NeuralNetwork) teach(inputs, excepted []f64)

// Teaches the NeuralNetwork instance to output [2] when inputs are [2, 4, -1, 3]
n.teach( [2, 4, -1, 3], [2] )

// Returns the output of the NeuralNetwork instance when inputs are [inputs]
fn (n &NeuralNetwork) feed(inputs []f64) []f64
```

# Example

```v
module main

import nerve
import math

fn main() {

  // new NeuralNetwork with 4 inputs and 1 output
	mut nerve := nerve.new( [4, 8, 6, 1] )

	for _ in 0 .. 100 {
  
                /*             teaching simple logic table      */
		/*             A && B || C && D   =  E          */

		nerve.teach( [1.0, 1.0, 1.0, 1.0], [1.0] )
		nerve.teach( [1.0, 1.0, 1.0, 0.0], [1.0] )
		nerve.teach( [1.0, 1.0, 0.0, 1.0], [1.0] )
		nerve.teach( [1.0, 1.0, 0.0, 0.0], [1.0] )

		nerve.teach( [1.0, 0.0, 1.0, 1.0], [1.0] )
		nerve.teach( [1.0, 0.0, 1.0, 0.0], [0.0] )
		nerve.teach( [1.0, 0.0, 0.0, 1.0], [0.0] )
		nerve.teach( [1.0, 0.0, 0.0, 0.0], [0.0] )

		nerve.teach( [0.0, 1.0, 1.0, 1.0], [1.0] )
		nerve.teach( [0.0, 1.0, 1.0, 0.0], [0.0] )
		nerve.teach( [0.0, 1.0, 0.0, 1.0], [0.0] )
		nerve.teach( [0.0, 1.0, 0.0, 0.0], [0.0] )

		nerve.teach( [0.0, 0.0, 1.0, 1.0], [1.0] )
		nerve.teach( [0.0, 0.0, 1.0, 0.0], [0.0] )
		nerve.teach( [0.0, 0.0, 0.0, 1.0], [0.0] )
		nerve.teach( [0.0, 0.0, 0.0, 0.0], [0.0] )
	}

	o1 := nerve.feed( [1.0, 0.0, 1.0, 0.0] ).map(math.round(it))
	o2 := nerve.feed( [1.0, 0.0, 1.0, 1.0] ).map(math.round(it))

	println( o1 ) // excepted : [0.0]
	println( o2 ) // excepted : [1.0]
}
```

![](https://i.imgur.com/wFJkBMX.png)
