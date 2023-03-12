/*
    Copyright © 2022, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
module binding.puppet;
import binding;
import binding.err;
import std.stdio;
import inochi2d;
import utils;

// Everything here should be C ABI compatible
extern(C) export:

struct InPuppet {
    Inochi2D.Puppet puppet;
    version(nogl) TextureBlob[] blob;
}
private {
InPuppet* to_puppet(ref Puppet c) {
    return alloc!(Puppet, InPuppet)(c);
}

}

/**
    Loads a puppet from path
*/
InPuppet* inPuppetLoad(const(char)* path) {
    try {
        auto puppet = Inochi2D.inLoadPuppet(cast(string)path.fromStringz);
        auto result = to_puppet(puppet);
        version(nogl) {
            result.blob = inCurrentPuppetTextureSlots.dup;
            inCurrentPuppetTextureSlots.length = 0;
        }
        return result;
    } catch(Exception ex) {
        writeln(ex);
        setError(ex);
        return null;
    }
}


/**
    Loads a puppet from path (length denominated string)
*/
InPuppet* inPuppetLoadEx(const(char)* path, size_t length) {
    try {
        auto puppet = Inochi2D.inLoadPuppet(cast(string)path[0..length]);
        auto result = to_puppet(puppet);
        version(nogl) {
            result.blob = inCurrentPuppetTextureSlots.dup;
            inCurrentPuppetTextureSlots.length = 0;
        }
        return result;
    } catch(Exception ex) {
        setError(ex);
        return null;
    }
}

/**
    Loads a puppet from memory
*/
InPuppet* inPuppetLoadFromMemory(ubyte* data, size_t length) {
    try {
        auto puppet = Inochi2D.inLoadINPPuppet(data[0..length]);
        auto result = to_puppet(puppet);
        version(nogl) {
            result.blob = inCurrentPuppetTextureSlots.dup;
            inCurrentPuppetTextureSlots.length = 0;
        }
        return result;
    } catch(Exception ex) {
        setError(ex);
        return null;
    }
}

/**
    Destroys a puppet and unloads its
*/
void inPuppetDestroy(InPuppet* puppet) {
    free_obj(puppet);
}

/**
    Gets the name of a puppet (as written in metadata)
*/
void inPuppetGetName(InPuppet* puppet, const(char)** ptr, size_t* len) {
    import core.stdc.string : memcpy;
    import core.stdc.stdlib : malloc;

    // Nothing to do
    if (puppet.puppet.meta.name.length == 0) return;

    const(char)* str = cast(const(char)*)malloc(puppet.puppet.meta.name.length);
    memcpy(cast(void*)str, cast(void*)puppet.puppet.meta.name.ptr, puppet.puppet.meta.name.length);
    *ptr = str;
    *len = puppet.puppet.meta.name.length;
}

/**
    Update puppet
*/
void inPuppetUpdate(InPuppet* puppet) {
    puppet.puppet.update();
}

version (yesgl) {

    /**
        Draw puppet
    */
    void inPuppetDraw(InPuppet* puppet) {
        puppet.puppet.draw();
    }
}

void inNodeResetDrivers(InPuppet* puppet) {
    puppet.puppet.resetDrivers();
}
