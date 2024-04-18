module vtc

import math
import math.vec

const (
	vec_x_positive = vec.Vec3[f64]{
		x: 1
		y: 0
		z: 0
	}
	vec_x_negative = vec.Vec3[f64]{
		x: -1
		y: 0
		z: 0
	}
	vec_y_positive = vec.Vec3[f64]{
		x: 0
		y: 1
		z: 0
	}
	vec_y_negative = vec.Vec3[f64]{
		x: 0
		y: -1
		z: 0
	}
	vec_z_positive = vec.Vec3[f64]{
		x: 0
		y: 0
		z: 1
	}
	vec_z_negative = vec.Vec3[f64]{
		x: 0
		y: 0
		z: -1
	}
)

@[noinit]
pub struct Cube {
pub:
	min vec.Vec3[f64]
	max vec.Vec3[f64]
	center vec.Vec3[f64]
	radius f64
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
	mut tmin := math.min(t0.x, t1.x)
	tmin = math.max(tmin, math.min(t0.y, t1.y))
	tmin = math.max(tmin, math.min(t0.z, t1.z))
	mut tmax := math.max(t0.x, t1.x)
	tmax = math.min(tmax, math.max(t0.y, t1.y))
	tmax = math.min(tmax, math.max(t0.z, t1.z))
	if tmax >= tmin {
		if tmin >= 0 {
			return vay.origin + vay.direction.mul_scalar(tmin)
		}
		if tmax >= 0 {
			return vay.origin + vay.direction.mul_scalar(tmax)
		}
	}
	return none
}

pub fn (cube Cube) normal(intersection vec.Vec3[f64], vay Vay) vec.Vec3[f64] {
	dir := (intersection - cube.center).normalize()
	rankings := [
		dir.dot(vec_x_positive),
		dir.dot(vec_y_positive),
		dir.dot(vec_z_positive),
		dir.dot(vec_x_negative),
		dir.dot(vec_y_negative),
		dir.dot(vec_z_negative),
	]
	poss := [
		vec_x_positive,
		vec_y_positive,
		vec_z_positive,
		vec_x_negative,
		vec_y_negative,
		vec_z_negative,
	]
	for i, rank in rankings {
		mut found := true
		for cursor in (i+1)..rankings.len {
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
