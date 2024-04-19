module vtc

import math
import math.vec

@[noinit]
pub struct Camera {
	lower_left_corner_less_origin vec.Vec3[f64]
pub:
	origin            vec.Vec3[f64]
	lower_left_corner vec.Vec3[f64]
	horizontal        vec.Vec3[f64]
	vertical          vec.Vec3[f64]
	width             int
	height            int
	output            string
}

pub fn Camera.new(aspect_ratio f64, fov f64, focal_length f64, origin vec.Vec3[f64], width int, height int, output string) Camera {
	theta := math.radians(fov)
	h := math.tan(theta / 2.0)
	viewport_height := 2 * h
	viewport_width := aspect_ratio * viewport_height
	horizontal := vec.vec3[f64](viewport_width, 0, 0)
	vertical := vec.vec3[f64](0, viewport_height, 0)
	lower_left_corner := origin - (horizontal.div_scalar(2.0)) - (vertical.div_scalar(2.0)) +
		vec.vec3[f64](0, 0, focal_length)
	lower_left_corner_less_origin := lower_left_corner.sub(origin)
	return Camera{
		lower_left_corner_less_origin: lower_left_corner_less_origin
		origin: origin
		horizontal: horizontal
		vertical: vertical
		lower_left_corner: lower_left_corner
		width: width
		height: height
		output: output
	}
}

pub fn (camera Camera) vay(u f64, v f64) Vay {
	new_horizontal := camera.horizontal.mul_scalar(u)
	new_vertical := camera.vertical.mul_scalar(v)
	mut direction := camera.lower_left_corner_less_origin.add(new_horizontal)
	direction = direction.add(new_vertical)
	return Vay.new(camera.origin, direction.normalize())
}
