module vtc

// https://en.wikipedia.org/wiki/Phong_reflection_model

import math
import math.vec
import gg

pub fn get_color(vay Vay, intersection vec.Vec3[f64], normal vec.Vec3[f64], material Material, lights []Light, forms []Form) gg.Color {
	mut final_r := f64(0)
	mut final_g := f64(0)
	mut final_b := f64(0)
	mut nb_lights := 0
	for light in lights {
		color := light.color
		if light.is_ambient {
			final_r *= light.power
			final_g *= light.power
			final_b *= light.power
			nb_lights += 1
			continue
		}
		light_normal := (light.center - intersection).normalize()
		vay_to_light := Vay{
			origin: intersection
			direction: light_normal
		}
		mut touched := false
		for form in forms {
			_ := form.intersection(vay_to_light) or { continue }
			touched = true
			break
		}
		if touched {
			continue
		}
		nb_lights += 1
		camera_normal := vay.direction.normalize()
		dot_reflexion := 2 * normal.dot(light_normal)
		reflexion_normal := light_normal - normal.mul_scalar(dot_reflexion)
		a_r := material.ambient.x * color.r
		a_g := material.ambient.y * color.g
		a_b := material.ambient.z * color.b
		percentage_difuse := normal.dot(light_normal)
		d_r := material.diffuse.x * color.r * percentage_difuse
		d_g := material.diffuse.y * color.g * percentage_difuse
		d_b := material.diffuse.z * color.b * percentage_difuse
		dot := reflexion_normal.dot(camera_normal)
		s_r := material.specular.x * color.r * math.pow(dot, material.shininess)
		s_g := material.specular.y * color.g * math.pow(dot, material.shininess)
		s_b := material.specular.z * color.b * math.pow(dot, material.shininess)
		final_r += (a_r + d_r + s_r) * light.power
		final_g += (a_g + d_g + s_g) * light.power
		final_b += (a_b + d_b + s_b) * light.power
	}
	final_r /= nb_lights
	final_g /= nb_lights
	final_b /= nb_lights
	final_r = material.color.r * final_r / 255
	final_g = material.color.g * final_g / 255
	final_b = material.color.b * final_b / 255
	return gg.Color{u8(final_r), u8(final_g), u8(final_b), 255}
}
