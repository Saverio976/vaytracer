module vtc

import toml
import math.vec
import gg

pub fn parse_doc_vec3(doc map[string]toml.Any) !vec.Vec3[f64] {
	if 'x' !in doc {
		return error('Error Parse ${doc}: x not found')
	}
	if 'y' !in doc {
		return error('Error Parse ${doc}: y not found')
	}
	if 'z' !in doc {
		return error('Error Parse ${doc}: z not found')
	}
	return vec.Vec3[f64]{
		x: doc.value('x').f64()
		y: doc.value('y').f64()
		z: doc.value('z').f64()
	}
}

pub fn parse_doc_color(doc map[string]toml.Any) !gg.Color {
	if 'r' !in doc {
		return error('Error Parse ${doc}: r not found')
	}
	if 'g' !in doc {
		return error('Error Parse ${doc}: g not found')
	}
	if 'b' !in doc {
		return error('Error Parse ${doc}: b not found')
	}
	return gg.Color{
		r: u8(doc.value('r').int())
		g: u8(doc.value('g').int())
		b: u8(doc.value('b').int())
		a: 255
	}
}

pub fn parse_doc_material(_type string, doc map[string]toml.Any) !Material {
	match _type {
		'Plain' {
			mut plain := Plain{}
			if 'shininess' in doc {
				plain.shininess = doc.value('shininess').f64()
			}
			if 'ambient' in doc {
				plain.ambient = parse_doc_vec3(doc.value('ambient').as_map())!
			}
			if 'diffuse' in doc {
				plain.diffuse = parse_doc_vec3(doc.value('diffuse').as_map())!
			}
			if 'specular' in doc {
				plain.specular = parse_doc_vec3(doc.value('specular').as_map())!
			}
			plain.color = parse_doc_color(doc.value('color').as_map())!
			return plain
		}
		else {
			return error('Invalid material: ${_type}')
		}
	}
}

pub fn parse_doc_forms(doc map[string]toml.Any) ![]Form {
	mut forms := []Form{}
	for key, values in doc {
		match key {
			'Sphere' {
				for value in values.array() {
					sphere := Sphere{
						center: parse_doc_vec3(value.value('center').as_map())!
						radius: value.value('radius').f64()
						material: parse_doc_material('Plain', value.value('material').as_map())!
					}
					forms << sphere
				}
			}
			'Plane' {
				for value in values.array() {
					plane := Plane{
						point: parse_doc_vec3(value.value('point').as_map())!
						normal_point: parse_doc_vec3(value.value('normal_point').as_map())!
						material: parse_doc_material('Plain', value.value('material').as_map())!
					}
					forms << plane
				}
			}
			//'Cube' {
			//	for value in values.array() {
			//		cube := Cube.new(
			//			parse_doc_vec3(value.value('center').as_map())!,
			//			value.value('radius').f64(),
			//			parse_doc_material('Plain', value.value('material').as_map())!
			//		)
			//		forms << cube
			//	}
			//}
			else {
				return error('Invalid form: ${key}')
			}
		}
	}
	return forms
}

pub fn parse_doc_light(doc map[string]toml.Any) ![]Light {
	mut lights := []Light{}
	for key, values in doc {
		match key {
			'Ambient' {
				for value in values.array() {
					ambient := Ambient{
						color: parse_doc_color(value.value('color').as_map())!
						power: value.value('power').f64()
					}
					lights << ambient
				}
			}
			'Point' {
				for value in values.array() {
					point := Point{
						color: parse_doc_color(value.value('color').as_map())!
						power: value.value('power').f64()
						center: parse_doc_vec3(value.value('center').as_map())!
					}
					lights << point
				}
			}
			else {
				return error('Invalid light: ${key}')
			}
		}
	}
	return lights
}

pub fn parse_doc_vamera(doc map[string]toml.Any) !Vamera {
	aspect_ratio := doc.value('aspect_ratio').f64()
	fov := doc.value('fov').f64()
	focal_length := doc.value('focal_length').f64()
	origin := parse_doc_vec3(doc.value('origin').as_map())!
	return Vamera.new_simple(aspect_ratio, fov, focal_length, origin)
}
