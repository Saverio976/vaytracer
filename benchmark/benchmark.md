# Benchmarks

*this file is created by [benchmark.sh](./benchmark.sh)*

*it use hyperfine*

*you will have different output, but I hope the mean difference between the programs will not change*

## Programs

- vaytracer
  The raytracer in this directory. Builded with `make vaytracer-prod`
- vaytracer-dev
  The raytracer in this directory. Builded with `make vaytracer`

### [../scenes/basic1.toml](../scenes/basic1.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer_basic1.toml.ppm'` | 90.2 ± 3.4 | 86.6 | 102.7 | 1.00 |
| `./vaytracer-dev --scene-file '../scenes/basic1.toml' --output-file 'output_vaytracer-dev_basic1.toml.ppm'` | 731.4 ± 18.4 | 709.1 | 764.3 | 8.10 ± 0.36 |
