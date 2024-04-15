module main

import os
import strings
import vtc

fn render_main(output_file string, scene vtc.Scene) ! {
	header := "P3 ${scene.width} ${scene.height} 255\n"
	mut output_string := strings.new_builder(header.len + (scene.height * scene.width))
	output_string.write_string(header)
	for y in 0..scene.height {
		for x in 0..scene.width {
			color := scene.calculate_pixel(x, y)
			output_string.write_string("${color.r} ${color.g} ${color.b}\n")
		}
	}
	os.write_file(output_file, output_string.str())!
}
