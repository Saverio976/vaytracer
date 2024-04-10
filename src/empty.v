module main

pub struct Empty {
	color Volor
}

pub fn (empty Empty) hit(vay Vay) ?Vector3 {
	return vay.origin
}
