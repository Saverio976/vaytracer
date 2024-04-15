module vtc

import math
import math.vec

@[noinit]
pub struct Vamera {
pub:
	origin            vec.Vec3[f64]
	lower_left_corner vec.Vec3[f64]
	horizontal        vec.Vec3[f64]
	vertical          vec.Vec3[f64]
}

pub fn Vamera.new(origin vec.Vec3[f64], lower_left_corner vec.Vec3[f64], horizontal vec.Vec3[f64], vertical vec.Vec3[f64]) Vamera {
	return Vamera{
		origin: origin
		lower_left_corner: lower_left_corner
		horizontal: horizontal
		vertical: vertical
	}
}

pub fn Vamera.new_simple(aspect_ratio f64, fov f64, focal_length f64, origin vec.Vec3[f64]) Vamera {
	theta := math.radians(fov)
	h := math.tan(theta / 2.0)
	viewport_height := 2 * h
	viewport_width := aspect_ratio * viewport_height
	horizontal := vec.vec3[f64](viewport_width, 0, 0)
	vertical := vec.vec3[f64](0, viewport_height, 0)
	lower_left_corner := origin - (horizontal.div_scalar(2.0)) - (vertical.div_scalar(2.0)) - vec.vec3[f64](0,
		0, focal_length)
	return Vamera{
		origin: origin
		horizontal: horizontal
		vertical: vertical
		lower_left_corner: lower_left_corner
	}
}

pub fn (vamera Vamera) vay(u f64, v f64) Vay {
	new_horizontal := vamera.horizontal.mul_scalar(u)
	new_vertical := vamera.vertical.mul_scalar(v)
	mut direction := vamera.lower_left_corner.add(new_horizontal)
	direction = direction.add(new_vertical)
	direction = direction.sub(vamera.origin)
	return Vay{
		origin: vamera.origin
		direction: direction.normalize()
	}
}
