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
| `./vaytracer-gcc --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer-gcc_basic1.toml.ppm'` | 61.8 ± 5.1 | 56.8 | 91.4 | 1.00 |
| `./vaytracer-clang --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer-clang_basic1.toml.ppm'` | 78.1 ± 3.5 | 73.9 | 93.2 | 1.26 ± 0.12 |
| `./vaytracer-dev --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer-dev_basic1.toml.ppm'` | 702.1 ± 8.2 | 692.6 | 723.1 | 11.37 ± 0.94 |
