module main

import os
import flag

struct Args {
	scene_file string
	is_gui bool
	output_file string
}

fn parse_args() !Args {
	mut fp := flag.new_flag_parser(os.args)
	fp.application("vaytracer")
	fp.version("0.0.0")
	fp.limit_free_args(0, 0)!
	fp.description("Draw scene with raytracing")
	fp.skip_executable()
	scene_file := fp.string_opt('scene-file', `s`, 'scene config file')!
	is_gui := fp.bool('gui', `g`, false, 'show the output image')
	output_file := fp.string('output-file', `o`, '', 'output image file')
	if output_file == '' && is_gui == false {
		return error('--gui must be set if no --output-file')
	}
	return Args{
		scene_file: scene_file
		is_gui: is_gui
		output_file: output_file
	}
}
