module vtc

import math
import math.vec

pub struct Sphere {
pub:
	center vec.Vec3[f64]
	radius f64
	material Material
}

pub fn (sphere Sphere) intersection(vay Vay) ?vec.Vec3[f64] {
	oc := vay.origin - sphere.center
	a := vay.direction.dot(vay.direction)
	b := oc.dot(vay.direction) * 2
	c := oc.dot(oc) - math.pow(sphere.radius, 2)
	discriminant := math.pow(b, 2) - (4 * a * c)
	if discriminant < 0 {
		return none
	}
	t1 := (-b - math.sqrt(discriminant)) / 2 * a
	if t1 > 0 {
		return vay.origin + vay.direction.mul_scalar(t1)
	}
	t2 := (-b + math.sqrt(discriminant)) / 2 * a
	if t2 > 0 {
		return vay.origin + vay.direction.mul_scalar(t2)
	}
	return none
}

pub fn (sphere Sphere) normal(intersection vec.Vec3[f64], vay Vay) vec.Vec3[f64] {
	return (intersection - sphere.center).normalize()
}
