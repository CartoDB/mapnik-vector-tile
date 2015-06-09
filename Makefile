MAPNIK_PLUGINDIR := $(shell mapnik-config --input-plugins)
BUILDTYPE ?= Release

all: libvtile

./deps/gyp:
	git clone https://chromium.googlesource.com/external/gyp.git ./deps/gyp && cd ./deps/gyp && git checkout 3464008

./deps/pbf:
	git clone https://github.com/mapbox/pbf.hpp.git ./deps/pbf && cd ./deps/pbf && git checkout 1df6453

./deps/clipper:
	git clone https://github.com/mapnik/clipper.git -b r493-mapnik ./deps/clipper && cd ./deps/clipper && git checkout 9b56a75 && ./cpp/fix_members.sh

build/Makefile: ./deps/gyp ./deps/clipper ./deps/pbf gyp/build.gyp test/*cpp
	deps/gyp/gyp gyp/build.gyp --depth=. -DMAPNIK_PLUGINDIR=\"$(MAPNIK_PLUGINDIR)\" -Goutput_dir=. --generator-output=./build -f make

libvtile: build/Makefile Makefile
	@$(MAKE) -C build/ BUILDTYPE=$(BUILDTYPE) V=$(V)

test: libvtile
	./build/$(BUILDTYPE)/tests

clean:
	rm -rf ./build

.PHONY: test


