# Inochi2D SDK for C ABIs
This repository contains the neccesary code to use the reference Inochi2D implementation outside of DLang, as well as with non-Inochi2D renderers.


## Initializing and Closing Inochi2D
You will need to pass a function with the signature `double timingFunc()` to Inochi2D on initialization.  
 * timingFunc should return the current time of the application rendering the game in `sec.ms` format.
 * timingFunc is used for physics as well animation calculations

```c
double timingFunc() {
    return glfwGetTime();
}
```

To initialize Inochi2D itself you will need to call `inInit` passing your timing function in.  
Remember to run inCleanup when you're done using Inochi2D to unload the DLang runtime!

```c
inInit(&timingFunc);
    // Game and Inochi2D goodness happens here
inCleanup();
```

## Loading a puppet
Use `inLoadPuppet` to load a puppet, you will need to pass an UTF-8 encoded null-terminated string to this function.  
Use `inDestroyPuppet` to destroy a puppet when it no longer is needed.

```c
    InPuppet* puppet = inLoadPuppet("myPuppet.inp");
    // Do stuff

    inDestroyPuppet(puppet);
```

## Using Inochi2D with your own renderer
Inochi2D requires the following GPU accellerated features to be present:
 * Framebuffer support (Inochi2D needs 2)
 * sRGB->Linear RGB conversion support
 * Premultiplied Alpha support
 * Vertex buffers
 * Stencil buffers
 * Pixel shaders
 * ROP support or method to emulate porter-duff blending in shader
 * At least 4096x4096 texture resolution support

Optionally the following features may be present  
 * SPIR-v shader support (For per-part shaders)

