/*
    Copyright © 2022, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
#include <stddef.h>
#include <stdint.h>

#ifndef H_INOCHI2D
#define H_INOCHI2D

    struct InPuppet;
    struct InRenderable;

    // Inochi2D runtime functionality
    void inInit(double (*timingFunc)());
    void inCleanup();
    #ifdef INOCHI2D_GLYES
        void inBeginScene();
        void inEndScene();
        void inDrawScene(float x, float y, float width, float height);
    #endif

    // Inochi2D Puppets
    InPuppet* inLoadPuppet(const char *path);
    InPuppet* inLoadPuppetEx(const char *path, size_t length);
    InPuppet* inLoadPuppetFromMemory(uint8_t* data, size_t length);
    void inDestroyPuppet(InPuppet*);
    void inPuppetUpdate(InPuppet*);
    #ifdef INOCHI2D_GLYES
        void inPuppetDraw(InPuppet*);
    #endif



#endif