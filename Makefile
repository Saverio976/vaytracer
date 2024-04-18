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
		-d no_segfault_handler \
		-cflags '-march=native' \
		-prealloc

_phony-$(TARGET)-dev:
	v . \
		-o $(TARGET)-dev

.PHONY: _phony-$(TARGET)-gcc _phony-$(TARGET)-clang _phony-$(TARGET)-dev

fclean:
	$(RM) -f $(TARGET)-dev $(TARGET) $(TARGET)-gcc $(TARGET)-clang

format:
	v fmt -w .

benchmark: _phony-$(TARGET)-clang _phony-$(TARGET)-gcc
	cp \
		$(TARGET)-gcc \
		$(TARGET)-clang \
		./benchmark/
	cd ./benchmark/ && ./benchmark.sh

profile:
	v \
		-profile profile.txt \
		run . \
		--scene-file './scenes/basic1.toml' --quiet
	sort -n -k2 profile.txt --reverse -o tmp.txt
	mv tmp.txt profile.txt
