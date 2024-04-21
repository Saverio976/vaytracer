module vtc

import math
import math.vec

@[noinit]
pub struct Sphere {
pub:
	center   vec.Vec3[f64]
	radius   f64
	material Material
}

pub fn Sphere.new(center vec.Vec3[f64], radius f64, material Material) Sphere {
	return Sphere{
		center: center
		radius: radius
		material: material
	}
}

pub fn Sphere.new_min_max(min vec.Vec3[f64], max vec.Vec3[f64], material Material) Sphere {
	center := min + (max - min)
	radius := center.distance(min)
	return Sphere{
		center: center
		radius: radius
		material: material
	}
}

pub fn (sphere Sphere) intersection(vay Vay) ?vec.Vec3[f64] {
	oc := vay.origin - sphere.center
	a := vay.direction.dot(vay.direction)
	b := oc.dot(vay.direction) * 2
	c := oc.dot(oc) - (sphere.radius * sphere.radius)
	discriminant := (b * b) - (4 * a * c)
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
