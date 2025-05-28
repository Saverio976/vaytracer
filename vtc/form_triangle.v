module vtc

import math
import math.vec

@[noinit]
pub struct Triangle {
	a_b              vec.Vec3[f64]
	b_c              vec.Vec3[f64]
	c_a              vec.Vec3[f64]
	normal           vec.Vec3[f64]
	bounded_box      Form
	with_bounded_box bool
pub:
	a        vec.Vec3[f64]
	b        vec.Vec3[f64]
	c        vec.Vec3[f64]
	material Material
}

pub fn Triangle.new(a vec.Vec3[f64], b vec.Vec3[f64], c vec.Vec3[f64], material Material, with_bounded_box bool) Triangle {
	a_b := b - a
	b_c := c - b
	c_a := a - c
	normal := a_b.cross(c - a).normalize()
	bounded_box := Cube.new_min_max(vec.Vec3[f64]{
		x: math.min(a.x, math.min(b.x, c.x))
		y: math.min(a.y, math.min(b.y, c.y))
		z: math.min(a.z, math.min(b.z, c.z))
	}, vec.Vec3[f64]{
		x: math.max(a.x, math.max(b.x, c.x))
		y: math.max(a.y, math.max(b.y, c.y))
		z: math.max(a.z, math.max(b.z, c.z))
	}, material)
	return Triangle{
		a_b: a_b
		b_c: b_c
		c_a: c_a
		normal: normal
		bounded_box: bounded_box
		with_bounded_box: with_bounded_box
		a: a
		b: b
		c: c
		material: material
	}
}

// https://www.scratchapixel.com/lessons/3d-basic-rendering/ray-tracing-rendering-a-triangle/ray-triangle-intersection-geometric-solution.html
pub fn (triangle Triangle) intersection(vay Vay) ?vec.Vec3[f64] {
	if triangle.with_bounded_box {
		_ := triangle.bounded_box.intersection(vay) or { return none }
	}
	d := -triangle.normal.dot(triangle.a)
	t := -(triangle.normal.dot(vay.origin) + d) / triangle.normal.dot(vay.direction)
	if t < 0 {
		return none
	}
	intersection := vay.origin + vay.direction.mul_scalar(t)
	c0 := intersection - triangle.a
	c1 := intersection - triangle.b
	c2 := intersection - triangle.c
	if triangle.normal.dot(triangle.a_b.cross(c0)) > 0
		&& triangle.normal.dot(triangle.b_c.cross(c1)) > 0
		&& triangle.normal.dot(triangle.c_a.cross(c2)) > 0 {
		return intersection
	}
	return none
}

pub fn (triangle Triangle) normal(intersection vec.Vec3[f64], vay Vay) vec.Vec3[f64] {
	return triangle.normal
}
