module main

import vtc
import os
import strings
import sync.pool

pub struct ParamsPoolY {
	y     int
	cam_i int
}

pub struct ResultPoolY {
mut:
	colors []vtc.Color
}

fn sprocess_pool_y(mut pp pool.PoolProcessor, idx int, wid int) &ResultPoolY {
	item := pp.get_item[ParamsPoolY](idx)
	scene := unsafe { &vtc.Scene(pp.get_shared_context()) }
	mut result := &ResultPoolY{
		colors: []vtc.Color{cap: scene.cameras[item.cam_i].width}
	}
	for x in 0 .. scene.cameras[item.cam_i].width {
		result.colors << scene.calculate_pixel(item.cam_i, x, item.y)
	}
	return result
}

fn render_pool_camera_y(cam_i int, scene vtc.Scene) ! {
	mut pp := pool.new_pool_processor(callback: sprocess_pool_y)
	pp.set_shared_context(scene)
	header := 'P3 ${scene.cameras[cam_i].width} ${scene.cameras[cam_i].height} 255\n'
	mut output_string := strings.new_builder(header.len +
		(scene.cameras[cam_i].height * scene.cameras[cam_i].width) * 4 * 3)
	output_string.write_string(header)
	mut items := []ParamsPoolY{cap: scene.cameras[cam_i].width * scene.cameras[cam_i].height}
	for y in 0 .. scene.cameras[cam_i].height {
		items << ParamsPoolY{
			y: y
			cam_i: cam_i
		}
	}
	pp.work_on_items(items)
	for colors in pp.get_results[[]vtc.Color]() {
		for color in colors {
			output_string.write_string(translation_color[color.r])
			output_string.write_string(' ')
			output_string.write_string(translation_color[color.g])
			output_string.write_string(' ')
			output_string.write_string(translation_color[color.b])
			output_string.write_string('\n')
		}
	}
	os.write_file(scene.cameras[cam_i].output, output_string.str())!
}

fn render_pool_y_main(scene vtc.Scene) ! {
	for i in 0 .. scene.cameras.len {
		render_pool_camera_y(i, scene)!
	}
}
