/*
    Inochi2D C ABI

    Copyright © 2023, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen, seagetch
*/
module binding.drawable;

import binding;
import binding.err;
import binding.puppet;
import binding.nodes: InNode;
import inochi2d;
import core.stdc.string;
import utils;

// Everything here should be C ABI compatible
extern(C) export:

void inSetUpdateBounds(bool state) {
    inochi2d.inSetUpdateBounds(state);
}

bool inDrawableGetVertices(InNode* node, float** vertices, size_t* length) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    vec2array2farray(drawable.vertices, vertices, length);
    return true;
}

bool inDrawableSetVertices(InNode* node, float* vertices, size_t length) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    drawable.vertices.length = length / 2;
    memcpy(drawable.vertices.ptr, vertices, length * float.sizeof);
    return true;
}

bool inDrawableGetDeformation(InNode* node, float** deformation, size_t* length) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    vec2array2farray(drawable.deformation, deformation, length);
    return true;
}

bool inDrawableRefresh(InNode* node) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    drawable.refresh();
    return true;
}

bool inDrawableRefreshDeform(InNode* node) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    drawable.refreshDeform();
    return true;
}

bool inDrawableReset(InNode* node) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    drawable.reset();
    return true;
}

bool inDrawableDrawBounds(InNode* node) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    drawable.drawBounds();
    return true;
}

bool inDrawableDrawMeshLines(InNode* node) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    drawable.drawMeshLines();
    return true;
}

bool inDrawableDrawMeshPoints(InNode* node) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    drawable.drawMeshPoints();
    return true;
}

bool inDrawableGetDynamicMatrix(InNode* node, float* mat4) {
    import core.stdc.string : memcpy;
    Drawable drawable = cast(Drawable)node.node;
    MeshGroup group   = cast(MeshGroup)node.node;
    if (drawable is null || group !is null) {
        auto matrix = node.node.transform.matrix;
        memcpy(cast(void*)mat4, matrix.ptr, float.sizeof*16);
        return true;
    }

    auto matrix = drawable.getDynamicMatrix();
    memcpy(cast(void*)mat4, matrix.ptr, float.sizeof*16);
    return true;
}
