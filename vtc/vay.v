module vtc

import math
import math.vec

@[noinit]
pub struct Vay {
pub:
	origin            vec.Vec3[f64]
	direction         vec.Vec3[f64]
	direction_inverse vec.Vec3[f64]
}

pub fn Vay.new(origin vec.Vec3[f64], direction vec.Vec3[f64]) Vay {
	return Vay{
		origin: origin
		direction: direction
		direction_inverse: direction.inv()
	}
}

pub fn vec3_rotate[T](p1 vec.Vec3[T], rotation vec.Vec3[T]) vec.Vec3[T] {
	roll := math.radians(rotation.x)
	pitch := math.radians(rotation.y)
	yaw := math.radians(rotation.z)
	sr, cr := math.sincos(roll)
	sp, cp := math.sincos(pitch)
	sy, cy := math.sincos(yaw)
	x := cy * cp * p1.x + (cy * sp * sr - sy * cr) * p1.y + (cy * sp * cr + sy * sr) * p1.z
	y := sy * cp * p1.x + (sy * sp * sr + cy * cr) * p1.y + (sy * sp * cr - cy * sr) * p1.z
	z := -sp * p1.x + cp * sr * p1.y + cp * cr * p1.z
	return vec.Vec3[f64]{
		x: x
		y: y
		z: z
	}
}
