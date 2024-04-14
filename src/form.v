module main

import math.vec

pub interface Form {
	color Volor
	intersection(Vay) ?vec.Vec3[f64]
	normal(vec.Vec3[f64], Vay) vec.Vec3[f64]
}
