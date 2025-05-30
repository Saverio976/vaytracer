module vtc

import toml
import math.vec

@[inline]
fn parse_vec3(doc toml.Any) !vec.Vec3[f64] {
	x := doc.value_opt('x') or {
		return error('no value for "x" when trying to parse a vec3')
	}
	y := doc.value_opt('y') or {
		return error('no value for "y" when trying to parse a vec3')
	}
	z := doc.value_opt('z') or {
		return error('no value for "z" when trying to parse a vec3')
	}
	return vec.Vec3[f64]{
		x: x.f64()
		y: y.f64()
		z: z.f64()
	}
}

@[inline]
fn parse_color(doc toml.Any) !Color {
	r := doc.value_opt('r') or {
		return error('no value for "r" when trying to parse a color')
	}
	g := doc.value_opt('g') or {
		return error('no value for "g" when trying to parse a color')
	}
	b := doc.value_opt('b') or {
		return error('no value for "b" when trying to parse a color')
	}
	return Color{
		r: u8(r.int())
		g: u8(g.int())
		b: u8(b.int())
		a: 255
	}
}

@[inline]
fn parse_camera(doc toml.Doc, name string) !Camera {
	focal_length := doc.value_opt('cameras-definition.${name}.focal_length') or {
		return error('no value for "cameras-definition.${name}.focal_length"')
	}
	origin := parse_vec3(doc.value('cameras-definition.${name}.origin')) or {
		return error('no value for "cameras-definition.${name}.origin": ${err}')
	}
	width := doc.value_opt('cameras-definition.${name}.width') or {
		return error('no value for "cameras-definition.${name}.width"')
	}
	height := doc.value_opt('cameras-definition.${name}.height') or {
		return error('no value for "cameras-definition.${name}.height"')
	}
	output := doc.value_opt('cameras-definition.${name}.output') or {
		return error('no value for "cameras-definition.${name}.output"')
	}
	return Camera.new(focal_length.f64(), origin, width.int(), height.int(), output.string())
}

fn parse_light(doc toml.Doc, name string) !Light {
	specular_color := parse_color(doc.value('lights-definition.${name}.specular'))!
	specular := vec.vec3[f64](f64(specular_color.r) / 255.0, f64(specular_color.g) / 255.0,
		f64(specular_color.b) / 255.0)
	diffuse_color := parse_color(doc.value('lights-definition.${name}.diffuse'))!
	diffuse := vec.vec3[f64](f64(diffuse_color.r) / 255.0, f64(diffuse_color.g) / 255.0,
		f64(diffuse_color.b) / 255.0)
	ambient_color := parse_color(doc.value('lights-definition.${name}.ambient'))!
	ambient := vec.vec3[f64](f64(ambient_color.r) / 255.0, f64(ambient_color.g) / 255.0,
		f64(ambient_color.b) / 255.0)
	point := parse_vec3(doc.value('lights-definition.${name}.point'))!
	return Light{
		specular: specular
		diffuse: diffuse
		ambient: ambient
		point: point
	}
}

@[inline]
fn parse_material(doc toml.Doc, name string) !Material {
	specular := doc.value('materials-definition.${name}.specular').f64()
	diffuse := doc.value('materials-definition.${name}.diffuse').f64()
	ambient := doc.value('materials-definition.${name}.ambient').f64()
	color := parse_color(doc.value('materials-definition.${name}.color'))!
	return Material{
		specular: specular
		diffuse: diffuse
		ambient: ambient
		color: color
	}
}

fn parse_form(doc toml.Doc, name string, mut materials map[string]Material) !Form {
	@type := doc.value('forms-definition.${name}.type').string()
	material_name := doc.value('forms-definition.${name}.material').string()
	if material_name !in materials {
		materials[material_name] = parse_material(doc, material_name)!
	}
	material := materials[material_name]
	match @type {
		'Sphere' {
			center := parse_vec3(doc.value('forms-definition.${name}.center'))!
			radius := doc.value('forms-definition.${name}.radius').f64()
			return Sphere.new(center, radius, material)
		}
		'Plane' {
			point := parse_vec3(doc.value('forms-definition.${name}.point'))!
			normal_plane := parse_vec3(doc.value('forms-definition.${name}.normal_plane'))!
			mut plane := Plane.new(point, normal_plane, material)
			return plane
		}
		'Cube' {
			center := parse_vec3(doc.value('forms-definition.${name}.center'))!
			radius := doc.value('forms-definition.${name}.radius').f64()
			return Cube.new(center, radius, material)
		}
		'Triangle' {
			a := parse_vec3(doc.value('forms-definition.${name}.a'))!
			b := parse_vec3(doc.value('forms-definition.${name}.b'))!
			c := parse_vec3(doc.value('forms-definition.${name}.c'))!
			return Triangle.new(a, b, c, material, true)
		}
		'Pyramid' {
			pos := parse_vec3(doc.value('forms-definition.${name}.pos'))!
			height := doc.value('forms-definition.${name}.height').f64()
			width := doc.value('forms-definition.${name}.width').f64()
			orientation := parse_vec3(doc.value('forms-definition.${name}.orientation'))!
			return Pyramid.new(pos, height, width, orientation, material)
		}
		else {
			return error('Unknow form[${name}] type[${@type}]')
		}
	}
}

pub fn parse_config(config_file string) !Scene {
	doc := toml.parse_file(config_file)!
	background_color := parse_color(doc.value('scene.background_color'))!
	mut scene := Scene{
		background_color: background_color
	}
	mut cameras := map[string]Camera{}
	for camera_visible in doc.value('scene.cameras').array() {
		camera_name := camera_visible.string()
		if camera_name !in cameras {
			cameras[camera_name] = parse_camera(doc, camera_name)!
		}
		scene.cameras << cameras[camera_name]
	}
	if cameras.len == 0 {
		return error('Need at least 1 camera!')
	}
	mut lights := map[string]Light{}
	for light_visible in doc.value('scene.lights').array() {
		light_name := light_visible.string()
		if light_name !in lights {
			lights[light_name] = parse_light(doc, light_name)!
		}
		scene.lights << lights[light_name]
	}
	mut materials := map[string]Material{}
	mut forms := map[string]Form{}
	for form_visible in doc.value('scene.forms').array() {
		form_name := form_visible.string()
		if form_name !in forms {
			forms[form_name] = parse_form(doc, form_name, mut materials)!
		}
		scene.forms << forms[form_name]
	}
	return scene
}
