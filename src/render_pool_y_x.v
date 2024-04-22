module main

import vtc
import gg
import os
import strings
import sync.pool

pub struct ParamsPoolYX {
	x int
	y int
	cam_i int
}

fn sprocess_pool_yx(mut pp pool.PoolProcessor, idx int, wid int) &gg.Color {
    item := pp.get_item[ParamsPoolYX](idx)
	scene := unsafe { &vtc.Scene(pp.get_shared_context()) }
	color := scene.calculate_pixel(item.cam_i, item.x, item.y)
    return &gg.Color{
		r: color.r
		g: color.g
		b: color.b
		a: color.a
	}
}

fn render_pool_camera_yx(cam_i int, scene vtc.Scene) ! {
	mut pp := pool.new_pool_processor(callback: sprocess_pool_yx)
	pp.set_shared_context(scene)
	header := 'P3 ${scene.cameras[cam_i].width} ${scene.cameras[cam_i].height} 255\n'
	mut output_string := strings.new_builder(header.len + (scene.cameras[cam_i].height * scene.cameras[cam_i].width) * 4 * 3)
	output_string.write_string(header)
	mut items := []ParamsPoolYX{cap: scene.cameras[cam_i].width * scene.cameras[cam_i].height}
	for y in 0 .. scene.cameras[cam_i].height {
		for x in 0 .. scene.cameras[cam_i].width {
			items << ParamsPoolYX{
				x: x
				y: y
				cam_i: cam_i
			}
		}
	}
	pp.work_on_items(items)
	for color in pp.get_results[gg.Color]() {
		output_string.write_string(translation_color[color.r])
		output_string.write_string(' ')
		output_string.write_string(translation_color[color.g])
		output_string.write_string(' ')
		output_string.write_string(translation_color[color.b])
		output_string.write_string('\n')
	}
	os.write_file(scene.cameras[cam_i].output, output_string.str())!
}

fn render_pool_y_x_main(scene vtc.Scene) ! {
	for i in 0 .. scene.cameras.len {
		render_pool_camera_yx(i, scene)!
	}
}
