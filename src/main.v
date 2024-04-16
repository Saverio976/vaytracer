module main

import vtc

fn main() {
	args := parse_args()!
	scene := vtc.Scene.new(args.scene_file)!
	println('${scene}')
	if args.is_gui {
		gui_main(scene)
	} else {
		render_main(args.output_file, scene)!
	}
}
