module main

import vtc

fn main() {
	args := parse_args() or {
		eprintln('ERROR: ${err}')
		exit(2)
	}
	scene := vtc.parse_config(args.scene_file) or {
		eprintln('ERROR: ${err}')
		exit(2)
	}
	if !args.quiet {
		println('${scene}')
	}
	render_pool_y_main(scene) or {
		eprintln('ERROR: ${err}')
		exit(2)
	}
}
