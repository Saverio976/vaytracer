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
| `./vaytracer-clang-pool-y --quiet --scene-file './basic1.toml'` | 678.6 ± 69.5 | 644.5 | 1300.5 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic1.toml'` | 688.5 ± 61.7 | 651.8 | 1167.6 | 1.01 ± 0.14 |
| `./vaytracer-clang-pool-y-x --quiet --scene-file './basic1.toml'` | 870.2 ± 62.8 | 826.3 | 1432.9 | 1.28 ± 0.16 |
| `./vaytracer-gcc-pool-y-x --quiet --scene-file './basic1.toml'` | 899.6 ± 72.9 | 850.7 | 1494.3 | 1.33 ± 0.17 |
### [./basic2.toml](./basic2.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-clang-pool-y --quiet --scene-file './basic2.toml'` | 675.2 ± 67.4 | 641.0 | 1304.5 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic2.toml'` | 691.5 ± 95.0 | 650.4 | 1349.5 | 1.02 ± 0.17 |
| `./vaytracer-clang-pool-y-x --quiet --scene-file './basic2.toml'` | 881.5 ± 100.5 | 827.6 | 1580.5 | 1.31 ± 0.20 |
| `./vaytracer-gcc-pool-y-x --quiet --scene-file './basic2.toml'` | 908.3 ± 81.6 | 854.1 | 1636.5 | 1.35 ± 0.18 |
