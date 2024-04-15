TARGET					=	vaytracer

SRC						=	$(wildcard src/*.v src/vtc/*.v)

all:						$(TARGET)

$(TARGET)-prod:				$(SRC)
	v . \
		-o $(TARGET)-prod \
		-prod

$(TARGET):					$(SRC)
	v . \
		-o $(TARGET)

fclean:
	$(RM) -f $(TARGET) $(TARGET)-prod

format:
	v fmt -w .
