#!/bin/bash -x

# Need hyperfine

rm -f "benchmark.md"

cat > "benchmark.md" <<EOF
# Benchmarks

*this file is created by [benchmark.sh](./benchmark.sh)*

*it use hyperfine*

*you will have different output, but I hope the mean difference between the programs will not change*

## Machine

- OS: **GNU/Linux - ArchLinux**
- Processor: **20 cpus, 64bit, little endian, 12th Gen Intel(R) Core(TM) i7-12700H**

## Programs

- vaytracer-clang-pool-y
    The raytracer in this repository using \`make _phony-vaytracer-clang-pool-y\`
- vaytracer-gcc-pool-y
    The raytracer in this repository using \`make _phony-vaytracer-gcc-pool-y\`

EOF

programs="vaytracer-clang-pool-y,vaytracer-gcc-pool-y"

scenes=(
    "./basic1.toml"
    "./basic2.toml"
)

for scene in "${scenes[@]}"; do
    sleep 10
    benchmark_file="benchmark-$(basename ${scene}).md"
    rm -f -- "${benchmark_file}"
    output_file="$(grep "output = " ${scene} | cut -f2 -d'"')"
    command_bench='./{program} --quiet'
    command_bench="${command_bench} --scene-file '${scene}'"
    hyperfine \
        --shell none \
        --min-runs 200 \
        --warmup 200 \
        --sort mean-time \
        --cleanup "sleep 10" \
        --export-markdown "${benchmark_file}" \
        --parameter-list program "${programs}" \
        --prepare "rm -f -- ${output_file}" \
        "${command_bench}"
    errors="0"
    echo "### [${scene}](${scene})" >> "benchmark.md"
    echo "" >> "benchmark.md"
    cat "${benchmark_file}" >> "benchmark.md"
    rm -- "${benchmark_file}"
done
