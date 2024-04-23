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
| `./vaytracer-clang-pool-y --quiet --scene-file './basic1.toml'` | 214.5 ± 2.4 | 209.2 | 221.7 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic1.toml'` | 234.3 ± 1.8 | 231.1 | 239.8 | 1.09 ± 0.01 |
### [./basic2.toml](./basic2.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-clang-pool-y --quiet --scene-file './basic2.toml'` | 215.7 ± 3.3 | 209.8 | 239.2 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic2.toml'` | 235.7 ± 2.2 | 231.0 | 245.0 | 1.09 ± 0.02 |
