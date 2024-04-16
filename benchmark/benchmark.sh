#!/bin/bash -x

# Need hyperfine

programs="vaytracer-clang,vaytracer-gcc,vaytracer-dev"

scenes=(
    "../scenes/basic1.toml"
)

rm -f "benchmark.md"

cat > "benchmark.md" <<EOF
# Benchmarks

*this file is created by [benchmark.sh](./benchmark.sh)*

*it use hyperfine*

*you will have different output, but I hope the mean difference between the programs will not change*

## Programs

- vaytracer
  The raytracer in this directory. Builded with \`make vaytracer\`
- vaytracer-dev
  The raytracer in this directory. Builded with \`make vaytracer-dev\`

EOF


for scene in "${scenes[@]}"; do
    sleep 10
    benchmark_file="benchmark-$(basename ${scene}).md"
    rm -f "${benchmark_file}"
    output_file="output_{program}_$(basename ${scene}).ppm"
    command_bench='./{program}'
    command_bench="${command_bench} --scene-file '${scene}'"
    command_bench="${command_bench} --output-file '${output_file}'"
    hyperfine \
        --shell none \
        --min-runs 100 \
        --warmup 50 \
        --sort mean-time \
        --cleanup 'sleep 10' \
        --export-markdown "${benchmark_file}" \
        --parameter-list program "${programs}" \
        --prepare "rm -f ${output_file}" \
        "${command_bench}"
    errors="0"
    for file in output_*_*.ppm; do
        if ! magick convert "${file}" test.png; then
            echo "Bad format: ${file}"
            errors="1"
        else
            echo "Ok format: ${file}"
            rm "${file}"
            rm "test.png"
        fi
    done
    if [[ "${errors}" == "0" ]]; then
        echo "### [${scene}](${scene})" >> "benchmark.md"
        echo "" >> "benchmark.md"
        cat "${benchmark_file}" >> "benchmark.md"
        rm "${benchmark_file}"
    fi
done
