module vtc

import gg
import math.vec

pub interface Material {
	color     gg.Color
	ambient   vec.Vec3[f64]
	diffuse   vec.Vec3[f64]
	specular  vec.Vec3[f64]
	shininess f64
	bounce(vec.Vec3[f64], vec.Vec3[f64], Vay) vec.Vec3[f64]
}
