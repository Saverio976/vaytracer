module main

import vtc
import gg
import math.vec

fn main() {
	args := parse_args()!
	scene := vtc.Scene.new(args.scene_file)!
	if args.is_gui {
		gui_main(scene)
	} else {
		render_main(args.output_file, scene)!
	}
}
