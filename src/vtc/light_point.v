module vtc

import gg
import math.vec

pub struct Point {
pub:
	color gg.Color
	power f64
	is_ambient bool
	center vec.Vec3[f64]
}
