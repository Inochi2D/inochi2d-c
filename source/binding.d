module binding;
import std.string : fromStringz;
import Inochi2D = inochi2d;
import inochi2d.integration;
import core.runtime;
import core.memory;
import core.sys.windows.windows;
import core.sys.windows.dll;
import bindbc.opengl;

// This needs to be here for Windows to link properly
version(Windows) {
    mixin SimpleDllMain;
} else {
    version = NotWindows;
}

alias i2DTimingFuncSignature = double function();

// Everything here should be C ABI compatible
extern(C):

/**
    Initializes Inochi2D
*/
export
void inInit(i2DTimingFuncSignature func) {
    version(NotWindows) Runtime.initialize();
    version(yesgl) {
        loadOpenGL();
    }
    Inochi2D.inInit(func);
}

/**
    Uninitializes Inochi2D and cleans up everything
*/
export
void inCleanup() {
    version(yesgl) {
        unloadOpenGL();
    }
    version(NotWindows) Runtime.terminate();
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
export
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
export
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
export
InPuppet* inLoadPuppetFromMemory(ubyte* data, size_t length) {
    auto puppet = new InPuppet(Inochi2D.inLoadINPPuppet(data[0..length]));
    GC.addRoot(puppet);
    return puppet;
}

/**
    Destroys a puppet and unloads its
*/
export
void inDestroyPuppet(InPuppet* puppet) {
    GC.removeRoot(puppet);
    destroy(puppet);
    GC.collect();
}

/**
    Update puppet
*/
export
void inPuppetUpdate(InPuppet* puppet) {
    puppet.puppet.update();
}