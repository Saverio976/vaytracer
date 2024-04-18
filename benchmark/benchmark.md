# Benchmarks

*this file is created by [benchmark.sh](./benchmark.sh)*

*it use hyperfine*

*you will have different output, but I hope the mean difference between the programs will not change*

## Programs

- vaytracer
  The raytracer in this directory. Builded with `make vaytracer`
- vaytracer-dev
  The raytracer in this directory. Builded with `make vaytracer-dev`

### [./basic1.toml](./basic1.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-gcc --scene-file './basic1.toml'` | 167.1 ± 5.2 | 155.6 | 184.7 | 1.00 |
| `./vaytracer-clang --scene-file './basic1.toml'` | 179.0 ± 20.7 | 161.5 | 305.4 | 1.07 ± 0.13 |
| `./vaytracer-dev --scene-file './basic1.toml'` | 1642.0 ± 71.5 | 1600.4 | 2048.5 | 9.83 ± 0.53 |
