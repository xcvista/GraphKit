CC := clang
CFLAGS := $(CFLAGS) $$(gnustep-config --objc-flags) -ObjC -fobjc-abi-version=2 -fobjc-arc -I. -I.. -c -Wall
LFLAGS := $(LFLAGS) $$(gnustep-config --base-libs)
OBJS := main.o help.o
EXEC := deglist

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -o $(EXEC) -lGraphKit

main.o: main.m
	$(CC) $(CFLAGS) main.m

help.o: help.m help.h
	$(CC) $(CFLAGS) help.m

install: $(EXEC)
	cp -t /usr/bin $(EXEC)

uninstall:
	-rm /usr/bin/$(EXEC)

clean:
	-rm $(OBJS)
	-rm $(EXEC)
	-rm *.d
