module vtc

import math.vec
import gg

pub interface Material {
	color        gg.Color
	transparency f64
	ambient  vec.Vec3[f64]
	diffuse  vec.Vec3[f64]
	specular vec.Vec3[f64]
	shininess f64
	bounce(vec.Vec3[f64], vec.Vec3[f64], Vay) []vec.Vec3[f64]
}
