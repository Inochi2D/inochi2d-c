/*
    Copyright © 2022, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
#include <stddef.h>
#include <stdint.h>

#ifdef H_INOCHI2D
#define H_INOCHI2D

    struct InPuppet;
    struct InRenderable;

    // Inochi2D runtime functionality
    void inInit(double (*timingFunc)());
    void inCleanup();

    // Inochi2D Puppets
    InPuppet* inLoadPuppet(const char *path);
    InPuppet* inLoadPuppetEx(const char *path, size_t length);
    InPuppet* inLoadPuppetFromMemory(uint8_t* data, size_t length);
    void inDestroyPuppet(InPuppet*);
    void inPuppetUpdate(InPuppet*);


    // For Inochi2D GL mode
    #ifdef INOCHI2D_GLYES

    #endif

#endif