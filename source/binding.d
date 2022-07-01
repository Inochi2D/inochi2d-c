module binding;
import std.string : fromStringz;
import Inochi2D = inochi2d;
import core.runtime;

// Everything here should be C ABI compatible
extern(C):

alias i2DTimingFuncSignature = extern(C) double function();

/**
    Initializes Inochi2D
*/
void inInit(i2DTimingFuncSignature func) {
    Runtime.initialize();
    Inochi2D.inInit((double) { return func(); });
}

/**
    Uninitializes Inochi2D and cleans up everything
*/
void inCleanup() {
    Runtime.terminate();
}


struct InPuppet {
private:
    Inochi2D.Puppet puppet;
}

/**
    Loads a puppet from 
*/
InPuppet* inLoadPuppet(const(char)* path) {
    return new InPuppet(Inochi2D.inLoadPuppet(cast(string)path.fromStringz));
}

/**
    Destroys a puppet and unloads its
*/
void inDestroyPuppet(InPuppet* puppet) {
    destroy(puppet);
}