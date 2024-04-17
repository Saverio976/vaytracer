module main

import gg
import gx
import vtc

struct App {
	width  int
	height int
	scene  vtc.Scene
mut:
	gg          &gg.Context = unsafe { nil }
	j           int
	i           int
	image_id    int
	pixels_data &u32
}

fn gui_main(scene vtc.Scene) {
	mut app := &App{
		width: scene.cameras[0].width
		height: scene.cameras[0].height
		scene: scene
		pixels_data: unsafe { vcalloc(scene.cameras[0].width * scene.cameras[0].height * sizeof(u32)) }
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
	color := app.scene.calculate_pixel(0, app.i, app.j)
	unsafe {
		app.pixels_data[(app.j * app.width) + app.i] = u32(color.abgr8())
	}
}

fn frame(mut app App) {
	app.gg.begin()
	for _ in 0 .. 10000 {
		if app.j >= app.height {
			break
		}
		draw_pixel(mut app)
		app.i += 1
		if app.i >= app.width {
			app.i = 0
			app.j += 1
		}
	}
	mut istream_image := app.gg.get_cached_image_by_idx(app.image_id)
	istream_image.update_pixel_data(unsafe { &u8(app.pixels_data) })
	app.gg.draw_image(0, 0, app.width, app.height, istream_image)
	app.gg.show_fps()
	app.gg.end()
}
