module vtc

import gg
import math.vec

pub struct Plain {
pub mut:
	color     gg.Color
	ambient   vec.Vec3[f64] = vec.vec3[f64](1, 1, 1)
	diffuse   vec.Vec3[f64] = vec.vec3[f64](1, 1, 1)
	specular  vec.Vec3[f64] = vec.vec3[f64](1, 1, 1)
	shininess f64 = 1.0
}

pub fn (plain Plain) bounce(intersection vec.Vec3[f64], normal vec.Vec3[f64], vay Vay) vec.Vec3[f64] {
	return normal
}
