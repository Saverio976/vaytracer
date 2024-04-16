module vtc

// https://en.wikipedia.org/wiki/Phong_reflection_model
import math
import math.vec
import gg

pub fn get_color(vay Vay, intersection vec.Vec3[f64], normal vec.Vec3[f64], material Material, lights []Light, forms []Form) gg.Color {
	mut final_r := f64(0)
	mut final_g := f64(0)
	mut final_b := f64(0)
	mut nb_lights := f64(0)
	mut max_power := f64(0)
	for light in lights {
		color := light.color
		max_power = math.max(max_power, light.power)
		if light.is_ambient {
			final_r += color.r * light.power
			final_g += color.g * light.power
			final_b += color.b * light.power
			nb_lights += light.power
			continue
		}
		light_normal := (light.center - intersection).normalize()
		vay_to_light := Vay{
			origin: intersection + light_normal
			direction: light_normal
		}
		light_distance := intersection.distance(light.center)
		mut touched := false
		for form in forms {
			impact := form.intersection(vay_to_light) or { continue }
			if intersection.distance(impact) > light_distance {
				continue
			}
			touched = true
			break
		}
		if touched {
			continue
		}
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
		to_add_r := (a_r + d_r + s_r) * light.power
		to_add_g := (a_g + d_g + s_g) * light.power
		to_add_b := (a_b + d_b + s_b) * light.power
		if to_add_r >= 0 && to_add_g >= 0 && to_add_b >= 0 {
			final_r += to_add_r
			final_g += to_add_g
			final_b += to_add_b
		}
		nb_lights += light.power
	}
	final_r /= nb_lights
	final_g /= nb_lights
	final_b /= nb_lights
	final_r = material.color.r * final_r / (max_power * 133)
	final_g = material.color.g * final_g / (max_power * 133)
	final_b = material.color.b * final_b / (max_power * 133)
	return gg.Color{u8(final_r), u8(final_g), u8(final_b), 255}
}
