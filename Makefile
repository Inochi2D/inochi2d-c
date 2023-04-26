out/libinochi2d-c.so:
	dub build --compiler=ldc --config=yesgl

bootstrap: bootstrap.c inochi2d.h out/libinochi2d-c.so
	gcc $< $(shell pkg-config --libs glfw3 gl) -Lout/ -Wl,-rpath=out -linochi2d-c -o bootstrap

clean:
	rm -rf out
	rm -f bootstrap