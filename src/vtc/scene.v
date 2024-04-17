module vtc

import gg
import math
import math.vec

pub struct Scene {
pub:
	background_color gg.Color
pub mut:
	lights     []Light
	forms      []Form
	cameras    []Camera
}

@[direct_array_access]
pub fn (scene Scene) calculate_pixel(camera_index int, x int, y int) gg.Color {
	v := f64(scene.cameras[camera_index].height - y) / f64(scene.cameras[camera_index].height)
	u := f64(x) / f64(scene.cameras[camera_index].width)
	vay := scene.cameras[camera_index].vay(u, v)
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
		return scene.background_color
	}
	form := form_most_next[0]
	normal := form.normal(form_most_next_impact, vay)
	return get_color(vay, form_most_next_impact, normal, form.material,
		scene.lights, scene.forms)
}
