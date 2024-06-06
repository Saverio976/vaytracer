# Benchmarks

*this file is created by [benchmark.sh](./benchmark.sh)*

*it use hyperfine*

*you will have different output, but I hope the mean difference between the programs will not change*

## Machine

- OS: **GNU/Linux - ArchLinux**
- Processor: **20 cpus, 64bit, little endian, 12th Gen Intel(R) Core(TM) i7-12700H**

## Programs

- vaytracer-clang-pool-y
    The raytracer in this repository using `make _phony-vaytracer-clang-pool-y`
- vaytracer-gcc-pool-y
    The raytracer in this repository using `make _phony-vaytracer-gcc-pool-y`

### [./basic1.toml](./basic1.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-clang-pool-y --quiet --scene-file './basic1.toml'` | 224.8 ± 1.9 | 220.8 | 232.2 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic1.toml'` | 239.8 ± 1.9 | 235.5 | 246.9 | 1.07 ± 0.01 |
### [./basic2.toml](./basic2.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-clang-pool-y --quiet --scene-file './basic2.toml'` | 226.7 ± 2.4 | 221.0 | 236.1 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic2.toml'` | 243.1 ± 2.4 | 238.5 | 251.5 | 1.07 ± 0.02 |
