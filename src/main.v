module main

import gg
import gx
import math
import math.vec

struct App {
	width  int
	height int
	forms  []Form
mut:
	gg          &gg.Context = unsafe { nil }
	j           int
	i           int
	vamera      Vamera
	image_id    int
	pixels_data &u32
}

fn main() {
	width := 400
	height := 200
	mut app := &App{
		width: width
		height: height
		forms: [
			Sphere{
				center: vec.vec3[f64](0, 0, -1)
				radius: 0.5
				color: Volor{255, 0, 0, 255}
			},
		]
		vamera: Vamera.new(2 / 1, 60, 1, vec.vec3[f64](0, 0, 1))
		pixels_data: unsafe { vcalloc(width * height * sizeof(u32)) }
	}
	app.gg = gg.new_context(
		bg_color: gx.rgb(255, 255, 255)
		width: app.width
		height: app.height
		window_title: 'Vaytracer'
		frame_fn: frame
		init_fn: frame_init
		user_data: app
	)
	app.gg.run()
}

fn frame_init(mut app App) {
	app.image_id = app.gg.new_streaming_image(app.width, app.height, 4, pixel_format: .rgba8)
}

fn draw_pixel(mut app App) {
	if app.j >= app.height {
		return
	}
	v := f64(app.height - app.j) / f64(app.height)
	u := f64(app.i) / f64(app.width)
	vay := app.vamera.vay(u, v)
	mut form_most_next_distance := math.maxof[f64]()
	mut form_most_next := []Form{cap: 1}
	for form in app.forms {
		impact := form.intersection(vay) or { continue }
		distance := impact.distance(vay.origin)
		if form_most_next.len == 0 {
			form_most_next << form
			form_most_next_distance = distance
		}
		if distance < form_most_next_distance {
			form_most_next_distance = distance
			form_most_next[0] = form
		}
	}
	if form_most_next.len != 0 {
		unsafe {
			app.pixels_data[(app.j * app.width) + app.i] = u32(gx.rgba(form_most_next[0].color.r,
				form_most_next[0].color.g, form_most_next[0].color.b, form_most_next[0].color.a).abgr8())
		}
	}
	app.i += 1
	if app.i >= app.width {
		app.i = 0
		app.j += 1
	}
}

fn frame(mut app App) {
	app.gg.begin()
	for _ in 0 .. 10000 {
		draw_pixel(mut app)
	}
	mut istream_image := app.gg.get_cached_image_by_idx(app.image_id)
	istream_image.update_pixel_data(unsafe { &u8(app.pixels_data) })
	app.gg.draw_image(0, 0, app.width, app.height, istream_image)
	app.gg.show_fps()
	app.gg.end()
}
