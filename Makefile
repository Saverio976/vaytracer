TARGET					=	vaytracer

SRC						=	$(wildcard src/*.v src/vtc/*.v)

all:						$(TARGET)-dev

$(TARGET):					$(SRC)
	@$(MAKE) _phony-$(TARGET)-gcc-pool-y
	cp $(TARGET)-gcc-pool-y $(TARGET)
	rm $(TARGET)-gcc-pool-y

$(TARGET)-dev:				$(SRC)
	@$(MAKE) _phony-$(TARGET)-dev

_phony-$(TARGET)-clang-pool-y:
	v . \
		-o $(TARGET)-clang-pool-y \
		-d pool_y \
		-cc clang \
		-prod \
		-gc none \
		-skip-unused \
		-d no_segfault_handler \
		-cflags '-march=native'

_phony-$(TARGET)-gcc-pool-y:
	v . \
		-o $(TARGET)-gcc-pool-y \
		-d pool_y \
		-cc gcc \
		-prod \
		-gc none \
		-skip-unused \
		-d no_segfault_handler \
		-cflags '-march=native'

_phony-$(TARGET)-dev:
	v . \
		-o $(TARGET)-dev \
		-d pool_y

.PHONY: _phony-$(TARGET)-gcc-pool-y
.PHONY: _phony-$(TARGET)-clang-pool-y
.PHONY: _phony-$(TARGET)-dev

fclean:
	$(RM) -- \
		$(TARGET)-dev \
		$(TARGET) \
		$(TARGET)-gcc-pool-y \
		$(TARGET)-clang-pool-y \
		benchmark/$(TARGET)-gcc-pool-y \
		benchmark/$(TARGET)-clang-pool-y

format:
	v fmt -w .

benchmark: _phony-$(TARGET)-clang-pool-y
benchmark: _phony-$(TARGET)-gcc-pool-y
	cp \
		$(TARGET)-gcc-pool-y \
		$(TARGET)-clang-pool-y \
		./benchmark/
	cd ./benchmark/ && ./benchmark.sh

profile:
	v \
		-profile profile.txt \
		run . \
		--scene-file './scenes/basic1.toml' --quiet
	sort -n -k2 profile.txt --reverse -o tmp.txt
	mv tmp.txt profile.txt
