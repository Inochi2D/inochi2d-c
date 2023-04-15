/*
    Copyright © 2022, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifndef H_INOCHI2D
#define H_INOCHI2D

#ifdef __cplusplus
extern "C" {
#endif
    typedef uint32_t uint;

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
    void inViewportSet(uint width, uint height);
    void inViewportGet(uint* width, uint* height);
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

    // Inochi2D Puppet Parameters
    typedef struct InParameter InParameter;
    void inPuppetGetParameters(InPuppet* puppet, InParameter*** array_ptr, size_t* length);
    char* inParameterGetName(InParameter* param);
    void inParameterGetValue(InParameter* param, float* x, float* y);
    void inParameterSetValue(InParameter* param, float x, float y);
    uint inParameterGetUUID(InParameter* param);
    bool inParameterIsVec2(InParameter* param);
    void inParameterGetMin(InParameter* param, float* xmin, float* ymin);
    void inParameterGetMax(InParameter* param, float* xmax, float* ymax);
    void inParameterGetAxes(InParameter* param, float*** axes, size_t* xLength, size_t* yLength);
    void inParameterFindClosestKeypoint(InParameter* param, float x, float y, uint* index_x, uint* index_y);
    void inParameterFindClosestKeypointAtCurrent(InParameter* param, uint* index_x, uint* index_y);
    void inParameterDestroy(InParameter* param);
    void inParameterReset(InParameter* param);

    // Inochi2D Puppet Parameter Bindings
    typedef struct InNode InNode;
    typedef struct InParameterBinding InParameterBinding;
    InParameterBinding* inParameterGetBinding(InParameter* param, InNode* node, char* bindingName);
    InParameterBinding* inParameterCreateBinding(InParameter* param, InNode* node, char* bindingName);
    InParameterBinding* inParameterGetOrAddBinding(InParameter* param, InNode* node, char* bindingName);
    void inParameterAddBinding(InParameter* param, InParameterBinding* binding);
    void inParameterRemoveBinding(InParameter* param, InParameterBinding* binding);

#ifdef __cplusplus
}
#endif


#endif