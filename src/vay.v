module main

pub struct Vay {
pub mut:
	origin    Vector3
	direction Vector3
}

pub fn (mut vay Vay) inc() {
	vay.origin = vay.origin.add(vay.direction)
}

pub fn (vay Vay) at(t f64) Vector3 {
	return vay.origin.add(vay.direction.mul_scalar(t))
}
