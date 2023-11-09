TARGET = fdseek
OBJS = fdseek.o

#DEBUG=1
CFLAGS += -Wall -Wno-main -Werror=pedantic -pedantic -std=c11
ifdef DEBUG
	CFLAGS += -g3 -ggdb -DDEBUG
endif

LDFLAGS +=

$(TARGET): $(OBJS)
	$(CC) -o $@ $(CFLAGS) $(OBJS) $(LDFLAGS)

clean:
	rm -f *~ *.o

clean-all: clean
	rm -f $(TARGET)

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $<
