module binding.dbg;

import inochi2d = inochi2d.core.dbg;
import binding;
import binding.err;
import utils;
import core.stdc.stdlib;
import core.stdc.string;

// Everything here should be C ABI compatible
extern(C) export:

bool inGetDbgDrawMeshOutlines() {
    return inochi2d.inDbgDrawMeshOutlines;
}
void inSetDbgDrawMeshOutlines(bool value) {
    inochi2d.inDbgDrawMeshOutlines = value;
}

bool inGetDbgDrawMeshVertexPoints() {
    return inochi2d.inDbgDrawMeshVertexPoints;
}
void inSetDbgDrawMeshVertexPoints(bool value) {
    inochi2d.inDbgDrawMeshVertexPoints = value;
}

bool inGetDbgDrawMeshOrientation() {
    return inochi2d.inDbgDrawMeshOrientation;
}
void inSetDbgDrawMeshOrientation(bool value) {
    inochi2d.inDbgDrawMeshOrientation = value;
}

/**
    Size of debug points
*/
void inDbgPointsSize(float size) {
    inochi2d.inDbgPointsSize(size);
}

/**
    Size of debug points
*/
void inDbgLineWidth(float size) {
    inochi2d.inDbgLineWidth(size);
}

/**
    Draws points with specified color
*/
void inDbgSetBuffer(float* _points, size_t length) {
    vec3[] points;
    points.length = length / 3;
    memcpy(points.ptr, _points, length * float.sizeof);
    inochi2d.inDbgSetBuffer(points);
}

/**
    Draws points with specified color
*/
void inDbgSetBufferWithIndices(float* _points, size_t point_length, ushort* _indices, size_t ind_len) {
    vec3[] points;
    points.length = point_length / 3;
    memcpy(cast(float*)points.ptr, _points, point_length * float.sizeof);
    ushort[] indices;
    indices.length = ind_len;
    memcpy(cast(ushort*)indices.ptr, _indices, ind_len * ushort.sizeof);
    inochi2d.inDbgSetBuffer(points, indices);
}

/**
    Draws current stored vertices as points with specified color
*/
void inDbgDrawPoints(float* _color, float* _mat4) {
    vec4 color;
    color = *cast(vec4*)_color;
    mat4 matrix = *cast(mat4*)_mat4;
    inochi2d.inDbgDrawPoints(color, matrix);
}

/**
    Draws current stored vertices as lines with specified color
*/
void inDbgDrawLines(float* _color, float* _mat4) {
    vec4 color;
    color = *cast(vec4*)_color;
    mat4 matrix = *cast(mat4*)_mat4;
    inochi2d.inDbgDrawLines(color, matrix);
}