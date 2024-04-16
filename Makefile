TARGET					=	vaytracer

SRC						=	$(wildcard src/*.v src/vtc/*.v)

all:						$(TARGET)

$(TARGET)-prod:				$(SRC)
	v . \
		-o $(TARGET) \
		-prod \
		-gc none

.PHONY: $(TARGET)

$(TARGET):					$(SRC)
	v . \
		-o $(TARGET)-dev

fclean:
	$(RM) -f $(TARGET)-dev $(TARGET)

format:
	v fmt -w .
