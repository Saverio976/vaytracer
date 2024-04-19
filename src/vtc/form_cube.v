module vtc

import math
import math.vec

const vec_x_positive = vec.Vec3[f64]{
	x: 1
	y: 0
	z: 0
}
const vec_x_negative = vec.Vec3[f64]{
	x: -1
	y: 0
	z: 0
}
const vec_y_positive = vec.Vec3[f64]{
	x: 0
	y: 1
	z: 0
}
const vec_y_negative = vec.Vec3[f64]{
	x: 0
	y: -1
	z: 0
}
const vec_z_positive = vec.Vec3[f64]{
	x: 0
	y: 0
	z: 1
}
const vec_z_negative = vec.Vec3[f64]{
	x: 0
	y: 0
	z: -1
}

@[noinit]
pub struct Cube {
pub:
	min      vec.Vec3[f64]
	max      vec.Vec3[f64]
	center   vec.Vec3[f64]
	radius   f64
	material Material
}

pub fn Cube.new(center vec.Vec3[f64], radius f64, material Material) Cube {
	added := vec.vec3[f64](radius, radius, radius)
	return Cube{
		min: center - added
		max: center + added
		center: center
		radius: radius
		material: material
	}
}

pub fn (cube Cube) intersection(vay Vay) ?vec.Vec3[f64] {
	t0 := (cube.min - vay.origin) * vay.direction_inverse
	t1 := (cube.max - vay.origin) * vay.direction_inverse

	mut tmin := t0.x
	mut tmax := t1.x

	if tmin > tmax {
		tmin, tmax = tmax, tmin
	}

	mut tymin := t0.y
	mut tymax := t1.y

	if tymin > tymax {
		tymin, tymax = tymax, tymin
	}

	if tmin > tymax || tymin > tmax {
		return none
	}

	if tymin > tmin {
		tmin = tymin
	}
	if tymax < tmax {
		tmax = tymax
	}

	mut tzmin := t0.z
	mut tzmax := t1.z

	if tzmin > tzmax {
		tzmin, tzmax = tzmax, tzmin
	}

	if tmin > tzmax || tzmin > tmax {
		return none
	}

	if tzmin > tmin {
		tmin = tzmin
	}
	if tzmax < tmax {
		tmax = tzmax
	}

	if tmin >= 0 {
		return vay.origin + vay.direction.mul_scalar(tmin)
	}
	if tmax >= 0 {
		return vay.origin + vay.direction.mul_scalar(tmax)
	}
	return none
}

pub fn (cube Cube) normal(intersection vec.Vec3[f64], vay Vay) vec.Vec3[f64] {
	dir := (intersection - cube.center).normalize()
	rankings := [
		dir.dot(vtc.vec_x_positive),
		dir.dot(vtc.vec_y_positive),
		dir.dot(vtc.vec_z_positive),
		dir.dot(vtc.vec_x_negative),
		dir.dot(vtc.vec_y_negative),
		dir.dot(vtc.vec_z_negative),
	]
	poss := [
		vtc.vec_x_positive,
		vtc.vec_y_positive,
		vtc.vec_z_positive,
		vtc.vec_x_negative,
		vtc.vec_y_negative,
		vtc.vec_z_negative,
	]
	for i, rank in rankings {
		mut found := true
		for cursor in (i + 1) .. rankings.len {
			if rank < rankings[cursor] {
				found = false
				break
			}
		}
		if found {
			return poss[i]
		}
	}
	return vec.vec3[f64](0, 0, 0)
}
