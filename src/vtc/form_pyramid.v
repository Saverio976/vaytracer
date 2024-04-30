module vtc

import math
import math.vec

const max_f64 = math.maxof[f64]()
const vec_0 = vec.vec3[f64](0, 0, 0)

@[noinit]
pub struct Pyramid {
pub:
	faces       []Form
	bounded_box Form
	material    Material
}

pub fn Pyramid.new(pos vec.Vec3[f64], height f64, width f64, orientation vec.Vec3[f64], material Material) Pyramid {
	orientation_inv := vec3_rotate(vec.Vec3[f64]{0, -1, 0}, orientation)
	base_center := pos + orientation_inv.mul_scalar(height)
	dir1 := vec3_rotate(vec.Vec3[f64]{1, 0, 0}, orientation)
	dir2 := vec3_rotate(vec.Vec3[f64]{0, 0, 1}, orientation)
	corner1 := base_center + dir1.mul_scalar(width / 2) + dir2.mul_scalar(width / 2)
	corner2 := base_center - dir1.mul_scalar(width / 2) + dir2.mul_scalar(width / 2)
	corner3 := base_center - dir1.mul_scalar(width / 2) - dir2.mul_scalar(width / 2)
	corner4 := base_center + dir1.mul_scalar(width / 2) - dir2.mul_scalar(width / 2)
	mut forms := []Form{cap: 4}
	forms << Triangle.new(pos, corner1, corner2, material, false)
	forms << Triangle.new(pos, corner2, corner3, material, false)
	forms << Triangle.new(pos, corner3, corner4, material, false)
	forms << Triangle.new(pos, corner4, corner1, material, false)
	bounded_box := Cube.new_min_max(vec.Vec3[f64]{
		x: math.min(corner1.x, math.min(corner2.x, math.min(corner3.x, math.min(corner4.x,
			pos.x))))
		y: math.min(corner1.y, math.min(corner2.y, math.min(corner3.y, math.min(corner4.y,
			pos.y))))
		z: math.min(corner1.z, math.min(corner2.z, math.min(corner3.z, math.min(corner4.z,
			pos.z))))
	}, vec.Vec3[f64]{
		x: math.max(corner1.x, math.max(corner2.x, math.max(corner3.x, math.max(corner4.x,
			pos.x))))
		y: math.max(corner1.y, math.max(corner2.y, math.max(corner3.y, math.max(corner4.y,
			pos.y))))
		z: math.max(corner1.z, math.max(corner2.z, math.max(corner3.z, math.max(corner4.z,
			pos.z))))
	}, material)
	return Pyramid{
		faces: forms
		bounded_box: bounded_box
		material: material
	}
}

pub fn (pyramid Pyramid) intersection(vay Vay) ?vec.Vec3[f64] {
	_ := pyramid.bounded_box.intersection(vay) or { return none }
	mut form_most_next_distance := max_f64
	mut form_most_next_impact := vec_0
	mut form_most_next := []Form{cap: 1}
	for form in pyramid.faces {
		impact := form.intersection(vay) or { continue }
		distance := impact.distance(vay.origin)
		if form_most_next.len == 0 {
			form_most_next << form
			form_most_next_distance = distance
			form_most_next_impact = impact
		}
		if distance < form_most_next_distance {
			form_most_next_distance = distance
			form_most_next[0] = form
			form_most_next_impact = impact
		}
	}
	if form_most_next.len == 0 {
		return none
	}
	return form_most_next_impact
}

pub fn (pyramid Pyramid) normal(intersection vec.Vec3[f64], vay Vay) vec.Vec3[f64] {
	mut form_most_next_distance := max_f64
	mut form_most_next := []Form{cap: 1}
	for form in pyramid.faces {
		impact := form.intersection(vay) or { continue }
		distance := impact.distance(vay.origin)
		if form_most_next.len == 0 {
			form_most_next << form
			form_most_next_distance = distance
		}
		if distance < form_most_next_distance {
			form_most_next_distance = distance
			form_most_next[0] = form
		}
	}
	if form_most_next.len == 0 {
		panic('This should never happen')
	}
	return form_most_next[0].normal(intersection, vay)
}
