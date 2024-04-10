module main

import math

pub struct Sphere {
pub:
	origin Vector3
	radius f64
	color  Volor
}

pub fn (sphere Sphere) hit(vay Vay) ?Vector3 {
	a := vay.direction.dot(vay.direction)
	b := vay.direction.mul_scalar(2).dot(vay.origin)
	c := vay.origin.dot(vay.origin) - (sphere.radius * sphere.radius)
	discriminant := (b * b) - (4 * a * c)
	if discriminant < 0 {
		return none
	}
	sqrt := math.sqrt(discriminant)
	a2 := 2 * a
	mut t := (-b - sqrt) / a2
	if t < 0 {
		t = (-b + sqrt) / a2
		if t < 0 {
			return none
		}
	}
	return vay.origin.add(vay.direction.mul_scalar(t))
}
