module main

import vtc

fn main() {
	args := parse_args()!
	scene := vtc.parse_config(args.scene_file)!
	if !args.quiet {
		println('${scene}')
	}
	if args.is_gui {
		gui_main(scene)
	} else {
		$if pool_y ? {
			render_pool_y_main(scene)!
		} $else {
			render_main(scene)!
		}
	}
}
