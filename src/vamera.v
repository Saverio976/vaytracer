module main

pub struct Vamera {
pub:
	origin            Vector3
	lower_left_corner Vector3
	horizontal        Vector3
	vertical          Vector3
}

pub fn (vamera Vamera) vay(u f64, v f64) Vay {
	new_horizontal := vamera.horizontal.mul_scalar(u)
	new_vertical := vamera.vertical.mul_scalar(v)
	mut direction := vamera.lower_left_corner.add(new_horizontal)
	direction = direction.add(new_vertical)
	direction = direction.sub(vamera.origin)
	return Vay{
		origin: vamera.origin
		direction: direction
	}
}
