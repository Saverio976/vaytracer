TARGET					=	vaytracer

SRC						=	$(wildcard src/*.v src/vtc/*.v)

V						?=	v

all: $(TARGET)

$(TARGET): $(SRC)
	@$(MAKE) _phony-$(TARGET)-gcc-pool-y
	$(V) . \
		-o "$(TARGET)" \
		-prod \
		-gc none \
		-d no_segfault_handler \
		-cflags '-march=native -O3'

$(TARGET)-dev: $(SRC)
	$(V) . \
		-o "$(TARGET)-dev" \
		-cg

fclean:
	$(RM) -- \
		"$(TARGET)-dev" \
		"$(TARGET)"

format:
	v fmt -w .

profile:
	$(V) \
		-profile profile.txt \
		run . \
		--scene-file './scenes/basic1.toml' --quiet
	sort -n -k2 profile.txt --reverse -o tmp.txt
	mv tmp.txt profile.txt
