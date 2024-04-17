module vtc

import math.vec

pub struct Light{
pub:
	specular vec.Vec3[f64]
	diffuse vec.Vec3[f64]
	ambient vec.Vec3[f64]
	point vec.Vec3[f64]
}
