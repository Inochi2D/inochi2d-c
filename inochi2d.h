/*
    Copyright © 2022, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
#include <stddef.h>
#include <stdint.h>

#ifndef H_INOCHI2D
#define H_INOCHI2D

    struct InError {
        size_t len;
        const char* msg;
    };
    typedef struct InError InError;
    InError* inErrorGet();

    typedef struct InPuppet InPuppet;
    typedef struct InCamera InCamera;
    typedef struct InRenderable InRenderable;

    // Inochi2D runtime functionality
    void inInit(double (*timingFunc)());
    void inCleanup();
    void inUpdate();
    void inBlockProtected(void (*func)());
    void inViewportSet(float width, float height);
    void inViewportGet(float* width, float* height);
    #ifdef INOCHI2D_GLYES
        void inSceneBegin();
        void inSceneEnd();
        void inSceneDraw(float x, float y, float width, float height);
    #endif

    // Inochi2D Cameras
    InCamera* inCameraGetCurrent();
    void inCameraDestroy(InCamera* camera);
    void inCameraGetPosition(InCamera* camera, float* x, float* y);
    void inCameraSetPosition(InCamera* camera, float x, float y);
    void inCameraGetZoom(InCamera* camera, float* zoom);
    void inCameraSetZoom(InCamera* camera, float zoom);
    void inCameraGetCenterOffset(InCamera* camera, float* x, float* y);
    void inCameraGetRealSize(InCamera* camera, float* x, float* y);
    void inCameraGetMatrix(InCamera* camera, float* mat4); // NOTE: mat4 array needs to be 16 elements long.

    // Inochi2D Puppets
    InPuppet* inPuppetLoad(const char *path);
    InPuppet* inPuppetLoadEx(const char *path, size_t length);
    InPuppet* inPuppetLoadFromMemory(uint8_t* data, size_t length);
    void inPuppetDestroy(InPuppet* puppet);
    void inPuppetGetName(InPuppet* puppet, const char *text, size_t *len);
    void inPuppetUpdate(InPuppet* puppet);
    #ifdef INOCHI2D_GLYES
        void inPuppetDraw(InPuppet* puppet);
    #endif



#endif