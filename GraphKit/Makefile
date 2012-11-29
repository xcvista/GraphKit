CC := clang
CFLAGS := $(CFLAGS) $$(gnustep-config --objc-flags) -ObjC -fobjc-abi-version=2 -fobjc-arc -I. -I.. -c -Wall
LFLAGS := $(LFLAGS) $$(gnustep-config --base-libs)
OBJS := GKBorder.o GKPoint.o GKGraph.o
LIBS := libGraphKit.a libGraphKit.so.1

all: $(LIBS)

libGraphKit.a: $(OBJS)
	ar -q libGraphKit.a $(OBJS)

libGraphKit.so.1: $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -shared -o libGraphKit.so.1

GKBorder.o: GKBorder.h GKBorder.m 
	$(CC) $(CFLAGS) GKBorder.m

GKPoint.o: GKPoint.h GKPoint.m 
	$(CC) $(CFLAGS) GKPoint.m

GKGraph.o: GKGraph.h GKGraph.m
	$(CC) $(CFLAGS) GKGraph.m

install: $(OBJS) install-headers
	cp -t /usr/lib $(LIBS)

install-headers:
	-mkdir /usr/include/GraphKit
	cp -t /usr/include/GraphKit *.h

uninstall:
	-cd /usr/lib && rm $(LIBS)
	-rm -r /usr/include/GraphKit

clean:
	-rm $(LIBS)
	-rm $(OBJS)
	-rm *.d
