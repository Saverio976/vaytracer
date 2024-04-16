module vtc

import math.vec

@[noinit; minify]
pub struct Vay {
pub:
	origin    vec.Vec3[f64]
	direction vec.Vec3[f64]
	direction_inverse vec.Vec3[f64]
}

pub fn Vay.new(origin vec.Vec3[f64], direction vec.Vec3[f64]) Vay {
	return Vay{
		origin: origin
		direction: direction
		direction_inverse: direction.inv()
	}
}
