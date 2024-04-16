TARGET					=	vaytracer

SRC						=	$(wildcard src/*.v src/vtc/*.v)

all:						$(TARGET)-dev

$(TARGET):					$(SRC)
	v . \
		-o $(TARGET) \
		-prod \
		-gc none \
		-skip-unused \
		-fast-math \
		-d no_segfault_handler \
		-cflags '-march=native'

.PHONY: $(TARGET)

$(TARGET)-dev:				$(SRC)
	v . \
		-o $(TARGET)-dev

fclean:
	$(RM) -f $(TARGET)-dev $(TARGET)

format:
	v fmt -w .

benchmark: $(TARGET) $(TARGET)-dev
	cp $(TARGET) $(TARGET)-dev ./benchmark/
	cd ./benchmark/ && ./benchmark.sh
