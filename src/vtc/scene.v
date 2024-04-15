module vtc

import gg
import math
import math.vec

pub struct Scene {
	lights []Light
	forms []Form
	camera Vamera
	width int
	height int
	background gg.Color
}

pub fn (scene Scene) calculate_pixel(x int, y int) !gg.Color {
	if x < 0 || x > scene.width || y < 0 || y > scene.height {
		return error('X or Y is not in pixels available')
	}
	v := f64(scene.height - y) / f64(scene.height)
	u := f64(x) / f64(scene.width)
	vay := scene.camera.vay(u, v)
	mut form_most_next_distance := math.maxof[f64]()
	mut form_most_next_impact := vec.vec3[f64](0, 0, 0)
	mut form_most_next := []Form{cap: 1}
	for form in scene.forms {
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
		return scene.background
	}
	form := form_most_next[0]
	normal := form.normal(form_most_next_impact, vay)
	normals_material := form.material.bounce(form_most_next_impact, normal, vay)
	mut colors := []gg.Color{}
	for normal_material in normals_material {
		colors << get_color(vay, form_most_next_impact, normal_material, form.material, scene.lights, scene.forms)
	}
	mut r := 0
	mut g := 0
	mut b := 0
	for color_it in colors {
		r += color_it.r
		g += color_it.g
		b += color_it.b
	}
	return gg.Color{
		r: u8(r / colors.len)
		g: u8(g / colors.len)
		b: u8(b / colors.len)
	}
}
