module binding.drawable;

import binding;
import binding.err;
import binding.puppet;
import binding.nodes: InNode;
import std.stdio;
import std.string;
import inochi2d;
import core.stdc.stdlib;
import core.stdc.string;

// Everything here should be C ABI compatible
extern(C) export:

bool inDrawableGetVertices(InNode* node, float** vertices, size_t* length) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    *vertices = cast(float*)malloc(drawable.vertices.length * float.sizeof * 2);
    *length   = drawable.vertices.length;
    foreach (i, vertex; drawable.vertices) {
        (*vertices)[i * 2] = vertex.x;
        (*vertices)[i * 2 + 1] = vertex.y;
    }
    return true;
}

bool inDrawableSetVertices(InNode* node, float* vertices, size_t length) {
    Drawable drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;

    drawable.vertices.length = length;
    foreach (i; 0..length) {
        drawable.vertices[i].x = vertices[i * 2];
        drawable.vertices[i].y = vertices[i * 2 + 1];
    }
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
