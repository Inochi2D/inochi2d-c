/*
    Inochi2D C ABI

    Copyright © 2023, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen, seagetch
*/
module binding.nodes;

import binding;
import binding.err;
import binding.puppet;
import inochi2d;
import utils;
import fghj;

import std.array : appender, Appender;
import std.range.primitives : put;


// Everything here should be C ABI compatible
extern(C) export:

struct InNode {
    Node node;
}
private {
InNode* to_node(ref Node b) {
    return alloc!(Node, InNode)(b);
}

}

InNode* inPuppetGetRootNode(InPuppet* puppet) {
    return to_node(puppet.puppet.root);
}

void inNodeGetChildren(InNode* node, InNode*** array_ptr, size_t* length) {
    array2carray!(Node, InNode*, to_node)(node.node.children, array_ptr, length);
}

char* inNodeGetName(InNode* node) {
    return str2cstr(node.node.name);
}

uint inNodeGetUUID(InNode* node) {
    return node.node.uuid;
}

InNode* inNodeGetParent(InNode* node) {
    return to_node(node.node.parent);
}

float inNodeGetZSort(InNode* node) {
    return node.node.zSort;
}

bool inNodeGetLockToRoot(InNode* node) {
    return node.node.lockToRoot;
}

char* inNodeGetPath(InNode* node) {
    return str2cstr(node.node.getNodePath);
}

bool inNodeGetEnabled(InNode* node) {
    return node.node.enabled;
}

char* inNodeGetTypeId(InNode* node) {
    return str2cstr(node.node.typeId);
}

bool inNodeHasParam(InNode* node, char* name) {
    auto dName = cstr2str(name);
    return node.node.hasParam(dName);
}

float inNodeGetValue(InNode* node, char* name) {
    return node.node.getValue(cstr2str(name));
}

void inNodeSetValue(InNode* node, char* name, float value) {
    node.node.setValue(cstr2str(name), value);
}

void inNodeGetTranslation(InNode* node, float*x, float* y, float *z) {
    auto tran = node.node.localTransform.translation;
    *x = tran.x;
    *y = tran.y;
    *z = tran.z;
}

void inNodeGetRotation(InNode* node, float*x, float* y, float* z) {
    auto rot = node.node.localTransform.rotation;
    *x = rot.x;
    *y = rot.y;
    *z = rot.z;
}

void inNodeGetScale(InNode* node, float*x, float* y, float* z) {
    auto scale = node.node.localTransform.scale;
    *x = scale.x;
    *y = scale.y;
}

void inNodeSetTranslation(InNode* node, float x, float y, float z) {
    node.node.localTransform.translation = vec3(x, y, z);
}

void inNodeSetRotation(InNode* node, float x, float y, float z) {
    node.node.localTransform.rotation = vec3(x, y, z);
}

void inNodeSetScale(InNode* node, float x, float y) {
    node.node.localTransform.scale = vec2(x, y);
}

version (yesgl) {

    /**
        Draw node
    */
    void inNodeDraw(InNode* node) {
        node.node.draw();
    }

    void inNodeDrawOne(InNode* node) {
        node.node.drawOne();
    }
}

void inNodeUpdate(InNode* node) {
    node.node.update();
}

void inNodeBeginUpdate(InNode* node) {
    node.node.beginUpdate();
}

void inNodeTransformChanged(InNode* node) {
    node.node.transformChanged();
}

void inNodeGetCombinedBounds(InNode* node, float* x, float* y, float* z, float* w) {
    vec4 result = node.node.getCombinedBounds();
    *x = result.x;
    *y = result.y;
    *z = result.z;
    *w = result.w;
}

void inNodeGetCombinedBoundsWithUpdate(InNode* node, float* x, float* y, float* z, float* w) {
    vec4 result = node.node.getCombinedBounds!true();
    *x = result.x;
    *y = result.y;
    *z = result.z;
    *w = result.w;
}

void inNodeLoadJson(InNode* node, char* text) {
    auto jsonText = cstr2str(text);
    Fghj data = parseJson(jsonText);
    node.node.deserializeFromFghj(data);
}

char* inNodeDumpJson(InNode* node, bool recursive) {
    auto app = appender!(char[]);
    auto serializer = inCreateSerializer(app);
//    serializer.serializeValue(node.node);
    uint state = serializer.objectBegin();
    node.node.serializePartial(serializer, recursive);
    serializer.objectEnd(state);
    serializer.flush();
    return str2cstr(cast(string)app.data);
}

void inNodeAddChild(InNode* node, InNode* child) {
    node.node.addChild(child.node);
}

void inNodeInsertInto(InNode* node, InNode* other, size_t offset) {
    node.node.insertInto(other.node, offset);
}

void inNodeRemoveChild(InNode* node, InNode* child) {
    if (child.node.parent == node.node) {
        child.node.parent = null;
    }
}

void inNodeGetTransformMatrix(InNode* node, float* mat4) {
    import core.stdc.string : memcpy;
    auto matrix = node.node.transform.matrix;
    memcpy(cast(void*)mat4, matrix.ptr, float.sizeof*16);
}

void inNodeGetLocalTransformMatrix(InNode* node, float* mat4) {
    import core.stdc.string : memcpy;
    auto matrix = node.node.localTransform.matrix;
    memcpy(cast(void*)mat4, matrix.ptr, float.sizeof*16);
}

void inNodeDestroy(InNode* node) {
    free_obj(node);
}