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
| `./vaytracer --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer_basic1.toml.ppm'` | 65.8 ± 2.2 | 63.0 | 75.5 | 1.00 |
| `./vaytracer-dev --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer-dev_basic1.toml.ppm'` | 740.4 ± 14.7 | 704.9 | 796.0 | 11.26 ± 0.44 |
