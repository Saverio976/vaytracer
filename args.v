module main

import os
import flag

struct Args {
	scene_file string
	quiet      bool
}

fn parse_args() !Args {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('vaytracer')
	fp.version('0.0.0')
	fp.limit_free_args(0, 0)!
	fp.description('Draw scene with raytracing')
	fp.skip_executable()
	scene_file := fp.string_opt('scene-file', `s`, 'scene config file')!
	quiet := fp.bool('quiet', `q`, false, "don't show scene config")
	return Args{
		scene_file: scene_file
		quiet: quiet
	}
}
