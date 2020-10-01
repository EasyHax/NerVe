module nerve

import math
import rand

struct NeuralNetwork {
mut:
	layers []Layer
}

pub fn new(layer []int) &NeuralNetwork {
	mut layers := []Layer{len: layer.len - 1}
	for i in 0 .. layers.len {
		layers[i] = new_layer(layer[i], layer[i + 1])
	}
	return &NeuralNetwork{layers}
}

/* pub fn (mut n NeuralNetwork) teach(inputs []any_int, excepted []any_int) { */
pub fn (mut n NeuralNetwork) teach(inputs []f64, excepted []f64) {

	//i := inputs.map(f64(it))
	//e := excepted.map(f64(it))
	
	n.feed(inputs)
	n.backprop(excepted)
}

pub fn (mut n NeuralNetwork) feed(inputs []f64) []f64 {

	if inputs.len != n.layers[0].inputs.len {
		panic('[!] feed forward error : inputs != neural_network.inputs')
	}

	n.layers[0].feed(inputs)
	for i in 1 .. n.layers.len {
		n.layers[i].feed(n.layers[i - 1].outputs)
	}
	
	return n.layers[n.layers.len - 1].outputs.clone()
}

fn (mut n NeuralNetwork) backprop(excepted []f64) {

	if excepted.len != n.layers[n.layers.len - 1].outputs.len {
		panic('[!] back propagation error : excepted != neural_network.outputs')
	}

	for j in 0 .. n.layers.len - 1 {
		i := n.layers.len - 1 - j

		if n.layers.len - 1 == i {
			n.layers[i].backprop_o(excepted)
		} else {
			n.layers[i].backprop_h(n.layers[i + 1].gammas, n.layers[i + 1].weights)
		}
	}
	for i in 0 .. n.layers.len {
		n.layers[i].correct_weights()
	}
}

struct Layer {
mut:
	outputs       []f64
	inputs        []f64
	gammas        []f64
	errors        []f64
	weights       [][]f64
	weights_delta [][]f64
}

fn new_layer(n_inputs, n_outputs int) Layer {
	mut layer := Layer{
		[]f64{len: n_outputs}, []f64{len: n_inputs }, 
		[]f64{len: n_outputs}, []f64{len: n_outputs},
		[][]f64{len: n_outputs, init: []f64{len: n_inputs, init: 0}}, 
		[][]f64{len: n_outputs, init: []f64{len: n_inputs, init: 0}}}
	layer.rand_weights()
	return layer
}

fn (mut l Layer) feed(inputs []f64) {
	l.inputs = inputs
	for i in 0 .. l.outputs.len {
		l.outputs[i] = 0
		for j in 0 .. l.inputs.len {
			l.outputs[i] += l.inputs[j] * l.weights[i][j]
		}
		l.outputs[i] = math.tanh(l.outputs[i])
	}
}

fn activation(value f64) f64 {
	return 1 - (value * value)
}

fn (mut l Layer) backprop_o(expected []f64) {
	for i in 0 .. l.outputs.len {
		l.errors[i] = l.outputs[i] - expected[i]
	}
	for i in 0 .. l.outputs.len {
		l.gammas[i] = l.errors[i] * activation(l.outputs[i])
	}
	for i in 0 .. l.outputs.len {
		for j in 0 .. l.inputs.len {
			l.weights_delta[i][j] = l.gammas[i] * l.inputs[j]
		}
	}
}
 
fn (mut l Layer) backprop_h(gamma_forward []f64, weights_foward [][]f64) {
	for i in 0 .. l.outputs.len {
		l.gammas[i] = 0
		for j in 0 .. gamma_forward.len {
			l.gammas[i] += gamma_forward[j] * weights_foward[j][i]
		}
		l.gammas[i] *= activation(l.outputs[i])
	}
	for i in 0 .. l.outputs.len {
		for j in 0 .. l.inputs.len {
			l.weights_delta[i][j] = l.gammas[i] * l.inputs[j]
		}
	}
}

fn (mut l Layer) rand_weights() {
	for i in 0 .. l.outputs.len {
		for j in 0 .. l.inputs.len {
			l.weights[i][j] = rand.f64_in_range(-0.5, 0.5)
		}
	}
}

fn (mut l Layer) correct_weights() {
	for i in 0 .. l.outputs.len {
		for j in 0 .. l.inputs.len {
			l.weights[i][j] -= l.weights_delta[i][j] * 0.033
		}
	}
}
