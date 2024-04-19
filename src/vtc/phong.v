module vtc

// https://en.wikipedia.org/wiki/Phong_reflection_model
import math.vec
import gg
import math

fn is_light_blocked(light Light, intersection vec.Vec3[f64], forms []Form) ?Vay {
	light_normal := (light.point - intersection).normalize()
	vay_to_light := Vay.new(intersection + light_normal, light_normal)
	light_distance := intersection.distance(light.point)
	mut touched := false
	for form in forms {
		impact := form.intersection(vay_to_light) or { continue }
		if intersection.distance(impact) > light_distance {
			continue
		}
		touched = true
		break
	}
	if !touched {
		return vay_to_light
	}
	return none
}

pub fn get_color(vay Vay, intersection vec.Vec3[f64], normal vec.Vec3[f64], material Material, lights []Light, forms []Form) gg.Color {
	mut i_a := vec.vec3[f64](0, 0, 0)
	k_a := material.ambient
	mut final_coef := vec.vec3[f64](0, 0, 0)
	for light in lights {
		i_a += light.ambient
		vay_to_light := is_light_blocked(light, intersection, forms) or { continue }
		l_m := vay_to_light.direction
		k_d := material.diffuse
		n := normal
		i_md := light.diffuse
		final_coef += i_md.mul_scalar(k_d * l_m.dot(n))
		k_s := material.specular
		r_m := n.mul_scalar(2 * l_m.dot(n)) - l_m
		v := vay.direction_inverse
		i_ms := light.specular
		alpha := material.shininess
		final_coef += i_ms.mul_scalar(k_s * math.pow(r_m.dot(v), alpha))
	}
	final_coef += i_a.mul_scalar(k_a)
	return gg.Color{
		r: u8(material.color.r * final_coef.x)
		g: u8(material.color.g * final_coef.y)
		b: u8(material.color.b * final_coef.z)
		a: 255
	}
}
