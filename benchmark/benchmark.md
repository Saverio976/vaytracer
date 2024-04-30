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
| `./vaytracer-clang-pool-y --quiet --scene-file './basic1.toml'` | 228.9 ± 2.4 | 224.9 | 241.2 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic1.toml'` | 256.9 ± 3.1 | 251.9 | 269.1 | 1.12 ± 0.02 |
### [./basic2.toml](./basic2.toml)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./vaytracer-clang-pool-y --quiet --scene-file './basic2.toml'` | 231.4 ± 5.3 | 224.0 | 290.7 | 1.00 |
| `./vaytracer-gcc-pool-y --quiet --scene-file './basic2.toml'` | 257.2 ± 4.0 | 241.7 | 302.5 | 1.11 ± 0.03 |
