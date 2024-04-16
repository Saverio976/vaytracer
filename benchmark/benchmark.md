# Benchmarks

*this file is created by [benchmark.sh](./benchmark.sh)*

*it use hyperfine*

*you will have different output, but I hope the mean difference between the programs will not change*

## Programs

- vaytracer
  The raytracer in this directory. Builded with `make vaytracer`
- vaytracer-dev
  The raytracer in this directory. Builded with `make vaytracer-dev`

### [../scenes/basic1.toml](../scenes/basic1.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-gcc --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer-gcc_basic1.toml.ppm'` | 74.2 ± 4.1 | 70.8 | 97.7 | 1.00 |
| `./vaytracer-clang-pgo --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer-clang-pgo_basic1.toml.ppm'` | 76.5 ± 2.6 | 72.8 | 88.0 | 1.03 ± 0.07 |
| `./vaytracer-clang --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer-clang_basic1.toml.ppm'` | 76.7 ± 2.3 | 73.4 | 87.2 | 1.03 ± 0.07 |
| `./vaytracer-dev --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer-dev_basic1.toml.ppm'` | 703.7 ± 3.2 | 697.2 | 716.2 | 9.48 ± 0.53 |
