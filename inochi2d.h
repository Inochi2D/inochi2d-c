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

// Handle calling convention on Windows.
// This will ensure MSVC does not try to use stdcall
// when the D library uses cdecl.
#ifdef _WIN32
    #ifdef _MSC_VER
        #define EXPORT_I2D __cdecl
    #else
        #define EXPORT_I2D
    #endif
#else
    #define EXPORT_I2D
#endif

#ifdef __cplusplus
extern "C" {
#endif
    typedef uint32_t uint;

    struct InError {
        size_t len;
        const char* msg;
    };
    typedef struct InError InError;
    EXPORT_I2D InError* inErrorGet();

    typedef struct InPuppet InPuppet;
    typedef struct InCamera InCamera;
    typedef struct InRenderable InRenderable;

    // Inochi2D runtime functionality
    EXPORT_I2D void inInit(double (*timingFunc)());
    EXPORT_I2D void inCleanup();
    EXPORT_I2D void inUpdate();
    EXPORT_I2D void inBlockProtected(void (*func)());
    EXPORT_I2D void inViewportSet(uint width, uint height);
    EXPORT_I2D void inViewportGet(uint* width, uint* height);
    #ifdef INOCHI2D_GLYES
        EXPORT_I2D void inSceneBegin();
        EXPORT_I2D void inSceneEnd();
        EXPORT_I2D void inSceneDraw(float x, float y, float width, float height);
    #endif

    // Inochi2D Cameras
    EXPORT_I2D InCamera* inCameraGetCurrent();
    EXPORT_I2D void inCameraDestroy(InCamera* camera);
    EXPORT_I2D void inCameraGetPosition(InCamera* camera, float* x, float* y);
    EXPORT_I2D void inCameraSetPosition(InCamera* camera, float x, float y);
    EXPORT_I2D void inCameraGetZoom(InCamera* camera, float* zoom);
    EXPORT_I2D void inCameraSetZoom(InCamera* camera, float zoom);
    EXPORT_I2D void inCameraGetCenterOffset(InCamera* camera, float* x, float* y);
    EXPORT_I2D void inCameraGetRealSize(InCamera* camera, float* x, float* y);
    EXPORT_I2D void inCameraGetMatrix(InCamera* camera, float* mat4); // NOTE: mat4 array needs to be 16 elements long.

    // Inochi2D Puppets
    EXPORT_I2D InPuppet* inPuppetLoad(const char *path);
    EXPORT_I2D InPuppet* inPuppetLoadEx(const char *path, size_t length);
    EXPORT_I2D InPuppet* inPuppetLoadFromMemory(uint8_t* data, size_t length);
    EXPORT_I2D void inPuppetDestroy(InPuppet* puppet);
    EXPORT_I2D void inPuppetGetName(InPuppet* puppet, const char *text, size_t *len);
    EXPORT_I2D void inPuppetUpdate(InPuppet* puppet);
    #ifdef INOCHI2D_GLYES
        EXPORT_I2D void inPuppetDraw(InPuppet* puppet);
    #endif

    // Inochi2D Puppet Parameters
    typedef struct InParameter InParameter;
    EXPORT_I2D void inPuppetGetParameters(InPuppet* puppet, InParameter*** array_ptr, size_t* length);
    EXPORT_I2D char* inParameterGetName(InParameter* param);
    EXPORT_I2D void inParameterGetValue(InParameter* param, float* x, float* y);
    EXPORT_I2D void inParameterSetValue(InParameter* param, float x, float y);
    EXPORT_I2D uint inParameterGetUUID(InParameter* param);
    EXPORT_I2D bool inParameterIsVec2(InParameter* param);
    EXPORT_I2D void inParameterGetMin(InParameter* param, float* xmin, float* ymin);
    EXPORT_I2D void inParameterGetMax(InParameter* param, float* xmax, float* ymax);
    EXPORT_I2D void inParameterGetAxes(InParameter* param, float*** axes, size_t* xLength, size_t* yLength);
    EXPORT_I2D void inParameterFindClosestKeypoint(InParameter* param, float x, float y, uint* index_x, uint* index_y);
    EXPORT_I2D void inParameterFindClosestKeypointAtCurrent(InParameter* param, uint* index_x, uint* index_y);
    EXPORT_I2D void inParameterDestroy(InParameter* param);
    EXPORT_I2D void inParameterReset(InParameter* param);

    // Inochi2D Puppet Parameter Bindings
    typedef struct InNode InNode;
    typedef struct InParameterBinding InParameterBinding;
    EXPORT_I2D InParameterBinding* inParameterGetBinding(InParameter* param, InNode* node, char* bindingName);
    EXPORT_I2D InParameterBinding* inParameterCreateBinding(InParameter* param, InNode* node, char* bindingName);
    EXPORT_I2D InParameterBinding* inParameterGetOrAddBinding(InParameter* param, InNode* node, char* bindingName);
    EXPORT_I2D void inParameterAddBinding(InParameter* param, InParameterBinding* binding);
    EXPORT_I2D void inParameterRemoveBinding(InParameter* param, InParameterBinding* binding);

#ifdef __cplusplus
}
#endif


#endif