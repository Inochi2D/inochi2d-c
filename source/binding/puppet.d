/*
    Copyright © 2022, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
module binding.puppet;
import binding;

// Everything here should be C ABI compatible
extern(C) export:

struct InPuppet {
private:
    Inochi2D.Puppet puppet;
    version(nogl) TextureBlob[] blob;
}

/**
    Loads a puppet from path
*/
InPuppet* inPuppetLoad(const(char)* path) {
    version(yesgl) {
        auto puppet = new InPuppet(
            Inochi2D.inLoadPuppet(cast(string)path.fromStringz)
        );
    } else {
        auto puppet = new InPuppet(
            Inochi2D.inLoadPuppet(cast(string)path.fromStringz),
            inCurrentPuppetTextureSlots.dup
        );
        inCurrentPuppetTextureSlots.length = 0;
    }

    GC.addRoot(puppet);
    return puppet;
}


/**
    Loads a puppet from path (length denominated string)
*/
InPuppet* inPuppetLoadEx(const(char)* path, size_t length) {
    version(yesgl) {
        auto puppet = new InPuppet(
            Inochi2D.inLoadPuppet(cast(string)path[0..length])
        );
    } else {
        auto puppet = new InPuppet(
            Inochi2D.inLoadPuppet(cast(string)path[0..length]),
            inCurrentPuppetTextureSlots.dup
        );
        inCurrentPuppetTextureSlots.length = 0;
    }

    GC.addRoot(puppet);
    return puppet;
}

/**
    Loads a puppet from memory
*/
InPuppet* inPuppetLoadFromMemory(ubyte* data, size_t length) {
    version(yesgl) {
        auto puppet = new InPuppet(
            Inochi2D.inLoadINPPuppet(data[0..length])
        );
    } else {
        auto puppet = new InPuppet(
            Inochi2D.inLoadINPPuppet(data[0..length]),
            inCurrentPuppetTextureSlots.dup
        );
        inCurrentPuppetTextureSlots.length = 0;
    }
    GC.addRoot(puppet);
    return puppet;
}

/**
    Destroys a puppet and unloads its
*/
void inPuppetDestroy(InPuppet* puppet) {
    GC.removeRoot(puppet);
    destroy(puppet);
    GC.collect();
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