module main

import nerve
import math

fn main() {

	mut nerve := nerve.new( [4, 8, 6, 1] )

	for _ in 0 .. 10000 {

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