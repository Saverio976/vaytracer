module main

import gg
import gx
import math

struct App {
	width  int
	height int
	forms  []Form
mut:
	gg     &gg.Context = unsafe { nil }
	j      int
	i      int
	vamera Vamera
	empty  Form
}

fn main() {
	mut app := &App{
		width: 400
		height: 200
		forms: [
			Sphere{
				origin: Vector3{
					x: 0
					y: 0
					z: -1
				}
				radius: 0.5
				color: Volor{255, 0, 0, 255}
			},
		]
		vamera: Vamera{
			origin: Vector3{0, 0, 0}
			lower_left_corner: Vector3{-2, -1, -1}
			horizontal: Vector3{4, 0, 0}
			vertical: Vector3{0, 2, 0}
		}
		empty: Empty{Volor{255, 255, 255, 255}}
	}
	app.gg = gg.new_context(
		bg_color: gx.rgb(255, 255, 255)
		width: app.width
		height: app.height
		window_title: 'Vaytracer'
		frame_fn: frame
		user_data: app
	)
	app.gg.run()
}

fn draw_pixel(mut app App) {
	if app.j >= app.height {
		println("end")
		return
	}
	v := f64(app.height - app.j) / f64(app.height)
	u := f64(app.i) / f64(app.width)
	vay := app.vamera.vay(u, v)
	println("${vay}")
	mut form_most_next_distance := math.maxof[f64]()
	mut form_most_next := app.empty
	for form in app.forms {
		impact := form.hit(vay) or {
			continue
		}
		distance := impact.distance(vay.origin)
		if distance < form_most_next_distance {
			form_most_next_distance = distance
			form_most_next = form
		}
	}
	// draw
	app.gg.draw_pixel(app.i, app.j, gx.rgba(form_most_next.color.r, form_most_next.color.g,
		form_most_next.color.b, form_most_next.color.a))
	app.i += 1
	if app.i >= app.width {
		app.i = 0
		app.j += 1
	}
}

fn frame(mut app App) {
	app.gg.begin()
	for _ in 0..10000 {
		draw_pixel(mut app)
	}
	app.gg.show_fps()
	// update next coordinates
	app.gg.end()
}
