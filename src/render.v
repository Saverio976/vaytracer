module main

import os
import strings
import vtc

fn render_one_camera(camera_index int, scene vtc.Scene, camera vtc.Camera) ! {
	header := 'P3 ${camera.width} ${camera.height} 255\n'
	mut output_string := strings.new_builder(header.len + (camera.height * camera.width))
	output_string.write_string(header)
	for y in 0 .. camera.height {
		for x in 0 .. camera.width {
			color := scene.calculate_pixel(camera_index, x, y)
			output_string.write_string('${color.r} ${color.g} ${color.b}\n')
		}
	}
	os.write_file(camera.output, output_string.str())!
}

fn render_main(scene vtc.Scene) ! {
	for i, camera in scene.cameras {
		render_one_camera(i, scene, camera)!
	}
}
