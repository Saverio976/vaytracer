module vtc

import gg
import math.vec

pub struct Ambient {
pub:
	color      gg.Color
	power      f64
	is_ambient bool = true
	center     vec.Vec3[f64] = vec.vec3[f64](0, 0, 0)
}
