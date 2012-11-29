CC := clang
CFLAGS := $(CFLAGS) $$(gnustep-config --objc-flags) -ObjC -fobjc-abi-version=2 -fobjc-arc -I. -I.. -c -Wall
LFLAGS := $(LFLAGS) $$(gnustep-config --base-libs)
OBJS := main.o help.o NSMutableArray+Stack.o enum.o
EXEC := genum

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -o $(EXEC) -lGraphKit

main.o: main.m
	$(CC) $(CFLAGS) main.m

help.o: help.m help.h
	$(CC) $(CFLAGS) help.m

enum.o: enum.m enum.h
	$(CC) $(CFLAGS) enum.m

NSMutableArray+Stack.o: NSMutableArray+Stack.m NSMutableArray+Stack.h
	$(CC) $(CFLAGS) NSMutableArray+Stack.m

install: $(EXEC)
	cp -t /usr/bin $(EXEC)

uninstall:
	-rm /usr/bin/$(EXEC)

clean:
	-rm $(OBJS)
	-rm $(EXEC)
	-rm *.d
