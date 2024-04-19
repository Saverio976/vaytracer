# Benchmarks

*this file is created by [benchmark.sh](./benchmark.sh)*

*it use hyperfine*

*you will have different output, but I hope the mean difference between the programs will not change*

## Programs

- vaytracer-clang
  The raytracer in this directory. Builded with `make _phony-vaytracer-clang`
- vaytracer-dev
  The raytracer in this directory. Builded with `make vaytracer-dev`
- vaytracer-gcc
  The raytracer in this directory. Builded with `make _phony-vaytracer-gcc`

### [./basic1.toml](./basic1.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-clang --quiet --scene-file './basic1.toml'` | 173.1 ± 16.5 | 163.0 | 270.6 | 1.00 |
| `./vaytracer-gcc --quiet --scene-file './basic1.toml'` | 186.6 ± 8.4 | 178.1 | 242.8 | 1.08 ± 0.11 |
