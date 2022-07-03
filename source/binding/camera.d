module binding.camera;
import binding;

// Everything here should be C ABI compatible
extern(C) export:

struct InCamera {
private:
    Inochi2D.Camera camera;
}

/**
    Gets the current camera
*/
InCamera* inCameraGetCurrent() {
    auto camera = new InCamera(Inochi2D.inGetCamera());
    GC.addRoot(camera);
    return camera;
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
    Sets the position of a camera
*/
void inCameraSetZoom(InCamera* camera, float zoom) {
    camera.camera.scale = vec2(zoom, zoom);
}

/**
    Sets the position of a camera
*/
void inCameraGetZoom(InCamera* camera, float* zoom) {
    *zoom = camera.camera.position.x;
}

/**
    Destroys a camera
*/
void inCameraDestroy(InCamera* camera) {
    GC.removeRoot(camera);
    GC.collect();
}