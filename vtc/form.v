module vtc

import math.vec

pub interface Form {
	material Material
	intersection(Vay) ?vec.Vec3[f64]
	normal(vec.Vec3[f64], Vay) vec.Vec3[f64]
}
