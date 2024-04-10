module main

import math

pub struct Vector3 {
pub:
	x f64
	y f64
	z f64
}

pub fn (vec Vector3) dot(other Vector3) f64 {
	return (vec.x * other.x) + (vec.y * other.y) + (vec.z * other.z)
}

pub fn (vec Vector3) sub(other Vector3) Vector3 {
	return Vector3{
		x: vec.x - other.x
		y: vec.y - other.y
		z: vec.z - other.z
	}
}

pub fn (vec Vector3) add(other Vector3) Vector3 {
	return Vector3{
		x: vec.x + other.x
		y: vec.y + other.y
		z: vec.z + other.z
	}
}

pub fn (vec Vector3) mul(other Vector3) Vector3 {
	return Vector3{
		x: vec.x * other.x
		y: vec.y * other.y
		z: vec.z * other.z
	}
}

pub fn (vec Vector3) mul_scalar(other f64) Vector3 {
	return Vector3{
		x: vec.x * other
		y: vec.y * other
		z: vec.z * other
	}
}

pub fn (vec Vector3) div(other Vector3) Vector3 {
	return Vector3{
		x: vec.x / other.x
		y: vec.y / other.y
		z: vec.z / other.z
	}
}

pub fn (vec Vector3) div_scalar(other f64) Vector3 {
	return Vector3{
		x: vec.x / other
		y: vec.y / other
		z: vec.z / other
	}
}

pub fn (vec Vector3) distance(other Vector3) f64 {
	d := vec.sub(other)
	d2 := d.dot(d)
	return math.sqrt(math.abs(d2))
}
