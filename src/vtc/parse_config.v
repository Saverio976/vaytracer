module vtc

import toml

fn parse_camera(doc toml.Doc, name string) Camera {
	aspect_ratio := doc.value('cameras-definition.${name}.aspect_ratio').f64()
	fov := doc.value('cameras-definition.${name}.fov').f64()
	focal_length := doc.value('cameras-definition.${name}.fov').f64()
	origin := parse_vec3(doc.value('cameras-definition.${name}.origin').as_map())!
	width := doc.value('cameras-definition.${name}.width').int()
	height := doc.value('cameras-definition.${name}.height').int()
	return Camera{
		aspect_ratio: aspect_ratio
		fov: fov
		focal_length: focal_length
		origin: origin
		width: width
		height: height
	}
}

pub fn parse_config(config_file string) !Scene {
	doc := toml.parse_file(config_file)!
	cameras := map[string]Vamera{}
	for camera_visible in doc.value('scene.cameras').array() {
		if camera_visible.value('definition').string() in cameras {
			continue
		}
		cameras << parse_camera(doc, camera_visible.value('definition').string())!
	}
	if cameras.len == 0 {
		return error('Need at least 1 camera!')
	}
	lights := map[string]Light{}
	materials := map[string]Material{}
	for light_visible in doc.value('scene.lights').array() {
		if light_visible.string() in lights {
			continue
		}
		lights << parse_light(doc, light_visible.string())!
	}
	forms := map[string]Form{}
	for form_visible in doc.value('scene.forms').array() {
		if form_visible.string() in forms {
			continue
		}
		forms << parse_form(doc, form_visble.string())!
	}
}
