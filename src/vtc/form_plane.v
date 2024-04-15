module vtc

import math.vec

pub struct Plane {
pub:
	point        vec.Vec3[f64]
	normal_point vec.Vec3[f64]
	material     Material
}

pub fn (plane Plane) intersection(vay Vay) ?vec.Vec3[f64] {
	t := (plane.point - vay.origin).dot(plane.normal_point) / vay.direction.dot(plane.normal_point)
	if t <= 0 {
		return none
	}
	return vay.origin + vay.direction.mul_scalar(t)
}

pub fn (plane Plane) normal(intersection vec.Vec3[f64], vay Vay) vec.Vec3[f64] {
	return plane.normal_point
}
