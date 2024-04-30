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
| `./vaytracer-clang-pool-y --quiet --scene-file './basic1.toml'` | 229.0 ± 4.3 | 220.0 | 273.8 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic1.toml'` | 257.9 ± 2.0 | 254.0 | 269.5 | 1.13 ± 0.02 |
### [./basic2.toml](./basic2.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-clang-pool-y --quiet --scene-file './basic2.toml'` | 229.2 ± 2.4 | 224.5 | 240.2 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic2.toml'` | 261.3 ± 3.2 | 256.1 | 283.1 | 1.14 ± 0.02 |
