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
| `./vaytracer-clang-pool-y --quiet --scene-file './basic1.toml'` | 232.4 ± 4.3 | 225.8 | 256.9 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic1.toml'` | 260.8 ± 2.2 | 254.0 | 271.6 | 1.12 ± 0.02 |
### [./basic2.toml](./basic2.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-clang-pool-y --quiet --scene-file './basic2.toml'` | 234.5 ± 5.3 | 229.3 | 295.0 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic2.toml'` | 266.5 ± 4.5 | 258.0 | 316.3 | 1.14 ± 0.03 |
