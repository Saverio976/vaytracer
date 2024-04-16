TARGET					=	vaytracer

SRC						=	$(wildcard src/*.v src/vtc/*.v)

all:						$(TARGET)-dev

$(TARGET):					$(SRC)
	@$(MAKE) _phony-$(TARGET)-gcc
	cp $(TARGET)-gcc $(TARGET)
	rm $(TARGET)-gcc

$(TARGET)-dev:				$(SRC)
	@$(MAKE) _phony-$(TARGET)-dev

_phony-$(TARGET)-clang:
	v . \
		-o $(TARGET)-clang \
		-cc clang \
		-prod \
		-gc none \
		-skip-unused \
		-fast-math \
		-d no_segfault_handler \
		-cflags '-march=native' \
		-prealloc

_phony-$(TARGET)-gcc:
	v . \
		-o $(TARGET)-gcc \
		-cc gcc \
		-prod \
		-gc none \
		-skip-unused \
		-fast-math \
		-d no_segfault_handler \
		-cflags '-march=native' \
		-prealloc

_phony-$(TARGET)-clang-pgo:
	rm -f *.profraw
	rm -f default.profdata
	v . \
		-o $(TARGET)-pgo-gen \
		-cc clang \
		-prod \
		-gc none \
		-skip-unused \
		-fast-math \
		-d no_segfault_handler \
		-cflags '-march=native' \
		-cflags '-fprofile-generate' \
		-prealloc
	for i in {0..100}; do ./$(TARGET)-pgo-gen --scene-file './scenes/basic1.toml' --output-file './test.ppm'; rm -f './test.ppm'; done
	llvm-profdata merge -o default.profdata *.profraw
	v . \
		-o $(TARGET)-clang-pgo \
		-cc clang \
		-prod \
		-gc none \
		-skip-unused \
		-fast-math \
		-d no_segfault_handler \
		-cflags '-march=native' \
		-cflags "-fprofile-use=$$(pwd)/default.profdata" \
		-prealloc
	rm -f *.profraw
	rm -f default.profdata
	rm -f $(TARGET)-pgo-gen

_phony-$(TARGET)-dev:
	v . \
		-o $(TARGET)-dev

.PHONY: _phony-$(TARGET)-gcc _phony-$(TARGET)-clang _phony-$(TARGET)-dev _phony-$(TARGET)-clang-pgo

fclean:
	$(RM) -f $(TARGET)-dev $(TARGET)

format:
	v fmt -w .

benchmark: _phony-$(TARGET)-clang _phony-$(TARGET)-gcc _phony-$(TARGET)-dev _phony-$(TARGET)-clang-pgo
	cp \
		$(TARGET)-gcc \
		$(TARGET)-clang \
		$(TARGET)-dev \
		$(TARGET)-clang-pgo \
		./benchmark/
	cd ./benchmark/ && ./benchmark.sh

profile:
	v \
		-profile profile.txt \
		run . \
		--scene-file './scenes/basic1.toml' --output-file './test.ppm'
	sort -n -k2 profile.txt --reverse -o tmp.txt
	mv tmp.txt profile.txt
