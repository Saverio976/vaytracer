const target = "vaytracer"
const target_dev = "${target}-dev"

fn make_target() {
    cmd := (
        @VEXE
        + ' .'
        + ' -o "${target}"'
        + ' -d pool_y'
        + ' -prod'
        + ' -gc none'
        + ' -d no_segfault_handler'
        + ' -cflags "-march=native -O3"'
    )
    println('> ${cmd}')
    res := execute_or_exit(cmd)
    print(res.output)
}

fn make_target_dev() {
    cmd := (
        @VEXE
        + ' .'
        + ' -o "${target_dev}"'
        + ' -d pool_y'
    )
    println('> ${cmd}')
    res := execute_or_exit(cmd)
    print(res.output)
}

fn clean() {
    rm(target) or { }
    rm(target_dev) or { }
}

make_target()
