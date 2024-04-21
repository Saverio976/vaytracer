module vtc

import math.vec

@[noinit]
pub struct Plane {
pub:
	point        vec.Vec3[f64]
	normal_plane vec.Vec3[f64]
	material     Material
}

pub fn Plane.new(point vec.Vec3[f64], normal_plane vec.Vec3[f64], material Material) Plane {
	return Plane{
		point: point
		normal_plane: normal_plane
		material: material
	}
}

pub fn (plane Plane) intersection(vay Vay) ?vec.Vec3[f64] {
	t := (plane.point - vay.origin).dot(plane.normal_plane) / vay.direction.dot(plane.normal_plane)
	if t <= 0 {
		return none
	}
	return vay.origin + vay.direction.mul_scalar(t)
}

pub fn (plane Plane) normal(intersection vec.Vec3[f64], vay Vay) vec.Vec3[f64] {
	return plane.normal_plane
}
