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

bool inDrawableGetVertices(InNode* node, float** vertices, size_t* length) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    vec2array2farray(drawable.vertices, *vertices, *length);
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

// void rebuffer(ref MeshData)
