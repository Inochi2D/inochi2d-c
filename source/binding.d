module binding;
import std.string : fromStringz;
import Inochi2D = inochi2d;
import inochi2d.integration;
import core.runtime;
import core.memory;

// Everything here should be C ABI compatible
extern(C):

alias i2DTimingFuncSignature = extern(C) double function();

/**
    Initializes Inochi2D
*/
void inInit(i2DTimingFuncSignature func) {
    Runtime.initialize();
    Inochi2D.inInit(&func);
}

/**
    Uninitializes Inochi2D and cleans up everything
*/
void inCleanup() {
    Runtime.terminate();
}

struct InRenderable {
private:

}

struct InPuppet {
private:
    Inochi2D.Puppet puppet;
    TextureBlob[] blob;
}

/**
    Loads a puppet from path
*/
InPuppet* inLoadPuppet(const(char)* path) {
    auto puppet = new InPuppet(
        Inochi2D.inLoadPuppet(cast(string)path.fromStringz),
        inCurrentPuppetTextureSlots.dup
    );
    inCurrentPuppetTextureSlots.length = 0;

    GC.addRoot(puppet);
    return puppet;
}


/**
    Loads a puppet from path (length denominated string)
*/
InPuppet* inLoadPuppetEx(const(char)* path, size_t length) {
    auto puppet = new InPuppet(
        Inochi2D.inLoadPuppet(cast(string)path[0..length]),
        inCurrentPuppetTextureSlots.dup
    );
    inCurrentPuppetTextureSlots.length = 0;

    GC.addRoot(puppet);
    return puppet;
}

/**
    Loads a puppet from memory
*/
InPuppet* inLoadPuppetFromMemory(ubyte* data, size_t length) {
    auto puppet = new InPuppet(Inochi2D.inLoadINPPuppet(data[0..length]));
    GC.addRoot(puppet);
    return puppet;
}

/**
    Destroys a puppet and unloads its
*/
void inDestroyPuppet(InPuppet* puppet) {
    GC.removeRoot(puppet);
    destroy(puppet);
    GC.collect();
}