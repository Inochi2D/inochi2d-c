/*
    Copyright © 2022, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
module binding;
public import std.string : fromStringz;
public import Inochi2D = inochi2d;
public import inochi2d.integration;
public import inochi2d.math;
public import core.runtime;
public import core.memory;

import core.sys.windows.windows;
import core.sys.windows.dll;
import bindbc.opengl;
import core.stdc.stdlib;


// This needs to be here for Windows to link properly
version(Windows) {
    mixin SimpleDllMain;
} else {
    version = NotWindows;
}

alias i2DTimingFuncSignature = double function();

// Everything here should be C ABI compatible
extern(C) export:

/**
    Initializes Inochi2D
*/
void inInit(i2DTimingFuncSignature func) {
    try {
        version(NotWindows) Runtime.initialize();
        version(yesgl) {
            loadOpenGL();
        }
        Inochi2D.inInit(func);
    } catch (Exception ex) {
        import std.stdio;
        writeln(ex);
    }
}

/**
    Updates the Inochi2D timing systems
*/
void inUpdate() {
    Inochi2D.inUpdate();
}

/**
    Uninitializes Inochi2D and cleans up everything
*/
void inCleanup() {
    version(yesgl) {
        unloadOpenGL();
    }
    version(NotWindows) Runtime.terminate();
}

/**
    Sets viewport
*/
void inViewportSet(int width, int height) {
    Inochi2D.inSetViewport(width, height);
}

/**
    Gets viewport size
*/
void inViewportGet(int* width, int* height) {
    int w, h;
    Inochi2D.inGetViewport(w, h);

    *width = w;
    *height = h;
}

version (yesgl) {
    /**
        Begins a scene render
    */
    void inSceneBegin() {
        Inochi2D.inBeginScene();
    }

    /**
        Ends a scene render
    */
    void inSceneEnd() {
        Inochi2D.inEndScene();
    }

    /**
        Draws Inochi2D scene
    */
    void inSceneDraw(float x, float y, float width, float height) {
        Inochi2D.inDrawScene(vec4(x, y, width, height));
    }
}

/**
    Runs function in a protected block that catches D exceptions.
*/
void inBlockProtected(void function() func) {
    try {
        func();
    } catch(Exception ex) {
        import std.stdio : writeln;
        writeln(ex);
    }
}

void inFreeMem(void* mem) {
    free(mem);
}

void inFreeArray(void** mem, size_t length) {
    for (size_t i = 0; i < length; i ++) {
        free(mem[i]);
    }
    free(mem);
}