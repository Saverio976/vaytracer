module main

import math.vec

pub struct Vay {
pub mut:
	origin    vec.Vec3[f64]
	direction vec.Vec3[f64]
}

pub fn (mut vay Vay) inc() {
	vay.origin = vay.origin.add(vay.direction)
}

pub fn (vay Vay) at(t f64) vec.Vec3[f64] {
	return vay.origin.add(vay.direction.mul_scalar(t))
}
