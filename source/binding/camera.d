module binding.camera;
import binding;
import utils;

// Everything here should be C ABI compatible
extern(C) export:

struct InCamera {
    Inochi2D.Camera camera;
}

private {
InCamera* to_camera(ref Camera c) {
    return alloc!(Camera, InCamera)(c);
}

}

/**
    Gets the current camera
*/
InCamera* inCameraGetCurrent() {
    Camera camera = Inochi2D.inGetCamera();
    return to_camera(camera);
}

/**
    Sets the position of a camera
*/
void inCameraSetPosition(InCamera* camera, float x, float y) {
    camera.camera.position = vec2(x, y);
}

/**
    Sets the position of a camera
*/
void inCameraGetPosition(InCamera* camera, float* x, float* y) {
    *x = camera.camera.position.x;
    *y = camera.camera.position.y;
}


/**
    Sets the zoom of a camera
*/
void inCameraSetZoom(InCamera* camera, float zoom) {
    camera.camera.scale = vec2(zoom, zoom);
}

/**
    Gets the zoom of a camera
*/
void inCameraGetZoom(InCamera* camera, float* zoom) {
    *zoom = camera.camera.scale.x;
}

/**
    Gets the center offset of the camera
*/
void inCameraGetCenterOffset(InCamera* camera, float* x, float* y) {
    auto v = camera.camera.getCenterOffset;
    *x = v.x;
    *y = v.y;
}

/**
    Gets the "real size" from the camera
*/
void inCameraGetRealSize(InCamera* camera, float* x, float* y) {
    auto v = camera.camera.getRealSize;
    *x = v.x;
    *y = v.y;
}

/**
    Copies the values of the internal camera matrix out to mat4
*/
void inCameraGetMatrix(InCamera* camera, const(float)* mat4) {
    import core.stdc.string : memcpy;
    memcpy(cast(void*)mat4, camera.camera.matrix.ptr, float.sizeof*16);
}

/**
    Destroys a camera
*/
void inCameraDestroy(InCamera* camera) {
    free_obj(camera);
}