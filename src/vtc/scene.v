module vtc

import gg
import toml
import math
import math.vec

pub struct Scene {
pub:
	lights     []Light
	forms      []Form
	camera     Vamera
	width      int
	height     int
	background gg.Color
}

pub fn Scene.new(config_file string) !Scene {
	doc := toml.parse_file(config_file)!
	scene := Scene{
		lights: parse_doc_light(doc.value('lights').as_map())!
		forms: parse_doc_forms(doc.value('forms').as_map())!
		camera: parse_doc_vamera(doc.value('scene.camera').as_map())!
		width: doc.value('scene.camera.width').int()
		height: doc.value('scene.camera.height').int()
		background: parse_doc_color(doc.value('scene.camera.background').as_map())!
	}
	return scene
}

@[direct_array_access]
pub fn (scene Scene) calculate_pixel(x int, y int) gg.Color {
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
	normal_material := form.material.bounce(form_most_next_impact, normal, vay)
	return get_color(vay, form_most_next_impact, normal_material, form.material,
		scene.lights, scene.forms)
}
