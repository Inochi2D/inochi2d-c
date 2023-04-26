#define INOCHI2D_GLYES
#include "inochi2d.h"

#include <GLFW/glfw3.h>
#include <stdio.h>

#define WINDOW_WIDTH 480
#define WINDOW_HEIGHT 800

double timingFunc() {
    return glfwGetTime();
}

void error_callback(int error, const char* description) {
    fprintf(stderr, "Error: %s\n", description);
}

int main() {
    glfwSetErrorCallback(error_callback);
    if (!glfwInit()) 
        return -1;

    // Inochi2D is officially targeted to OpenGL 3.1 and above
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);
    GLFWwindow* window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Inochi2D - C Binding", NULL, NULL);

    glfwMakeContextCurrent(window);
    glfwSwapInterval(1);

    // A timing function that returns the current applications runtime in seconds and milliseconds is needed
    inInit(&timingFunc);

    // viewport size, which is the size of the scene
    uint sceneWidth; 
    uint sceneHeight;

    // It is highly recommended to change the viewport with
    // inSetViewport to match the viewport you want, otherwise it'll be 640x480
    inViewportSet(WINDOW_WIDTH, WINDOW_HEIGHT);
    inViewportGet(&sceneWidth, &sceneHeight);

    // Also many vtuber textures are pretty big so let's zoom out a bit.
    InCamera* camera = inCameraGetCurrent();
    inCameraSetZoom(camera, 0.2);
    inCameraSetPosition(camera, 0, 1000);

    // You can get example models at https://github.com/Inochi2D/example-models
    InPuppet* myPuppet = inPuppetLoad("Aka.inx");

    struct {
        size_t len;
        InParameter **cont;
    } parameters;
    // let D allocate memory (see README)
    parameters.cont = NULL;
    inPuppetGetParameters(myPuppet, &parameters.cont, &parameters.len);
    for (size_t i = 0; i < parameters.len; i++) {
        char *name = inParameterGetName(parameters.cont[i]);
        bool isVec2 = inParameterIsVec2(parameters.cont[i]);
        printf("Parameter #%zu: %s is%s vec2.\n", i, name, isVec2 ? "" : " not");
    }
    // set "Head:: Roll" to -1.0
    inParameterSetValue(parameters.cont[1], -1, 0);

    while(!glfwWindowShouldClose(window)) {
        // NOTE: Inochi2D does not itself clear the main framebuffer
        // you have to do that your self.
        glClear(GL_COLOR_BUFFER_BIT);
        
        // Run inUpdate first
        // This updates various submodules and time managment for animation
        inUpdate();

        // Imagine there's a lot of rendering code here
        // Maybe even some game logic or something

        // Begins drawing in to the Inochi2D scene
        // NOTE: You *need* to do this otherwise rendering may break
        inSceneBegin();
        
            // Draw and update myPuppet.
            // Convention for using Inochi2D in D is to put everything
            // in a scene block one indent in.
            inPuppetUpdate(myPuppet);
            inPuppetDraw(myPuppet);

        // Ends drawing in to the Inochi2D scene.
        inSceneEnd();
        
        // Draw the scene, background is transparent
        inSceneDraw(0, 0, sceneWidth, sceneHeight);
        
        // Do the buffer swapping and event polling last
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    inCleanup();
    glfwTerminate();
    return 0;
}