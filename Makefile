TARGET					=	vaytracer

SRC						=	$(wildcard src/*.v src/vtc/*.v)

all:						$(TARGET)-dev

$(TARGET):					$(SRC)
	@$(MAKE) _phony-$(TARGET)

$(TARGET)-dev:				$(SRC)
	@$(MAKE) _phony-$(TARGET)

_phony-$(TARGET):
	v . \
		-o $(TARGET) \
		-prod \
		-gc none \
		-skip-unused \
		-fast-math \
		-d no_segfault_handler \
		-cflags '-march=native' \
		-prealloc

_phony-$(TARGET)-dev:
	v . \
		-o $(TARGET)-dev

.PHONY: _phony-$(TARGET) _phony-$(TARGET)-dev

fclean:
	$(RM) -f $(TARGET)-dev $(TARGET)

format:
	v fmt -w .

benchmark: _phony-$(TARGET) _phony-$(TARGET)-dev
	cp $(TARGET) $(TARGET)-dev ./benchmark/
	cd ./benchmark/ && ./benchmark.sh

profile:
	v \
		-profile profile.txt \
		run . \
		--scene-file './scenes/basic1.toml' --output-file './test.ppm'
	sort -n -k2 profile.txt --reverse -o tmp.txt
	mv tmp.txt profile.txt
