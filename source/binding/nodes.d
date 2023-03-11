module binding.nodes;

import binding;
import binding.err;
import binding.puppet;
import std.stdio;
import std.string;
import inochi2d;
import core.stdc.stdlib;
import core.stdc.string;

// Everything here should be C ABI compatible
extern(C) export:

struct InNode {
    Node node;
}

InNode* inPuppetGetRootNode(InPuppet* puppet) {
    Node root = puppet.puppet.root;
    InNode* result = cast(InNode*)malloc(InNode.sizeof);
    result.node = root;
    return result;
}

void inNodeGetChildren(InNode* node, void** array_ptr, size_t* length) {
    InNode* dummy;
    InNode** result = cast(InNode**)malloc((*node).node.children.length * dummy.sizeof);
    foreach (i; 0..node.node.children.length) {
        InNode* ptr = cast(InNode*)malloc(InNode.sizeof);
        ptr.node = node.node.children[i];
        result[i] = ptr;
    }
    *array_ptr = cast(void**)result;
    *length    = node.node.children.length;
}

char* inNodeGetName(InNode* node) {
    char* name = cast(char*)malloc(node.node.name.length + 1);
    memcpy(name, node.node.name.ptr, char.sizeof * node.node.name.length);
    name[node.node.name.length] = 0;
    return name;
}

uint inNodeGetUUID(InNode* node) {
    return node.node.uuid;
}

InNode* inNodeGetParent(InNode* node) {
    InNode* result = cast(InNode*)malloc((*node).sizeof);
    result.node = node.node.parent;
    return result;
}

float inNodeGetZSort(InNode* node) {
    return node.node.zSort;
}

bool inNodeGetLockToRoot(InNode* node) {
    return node.node.lockToRoot;
}

char* inNodeGetPath(InNode* node) {
    string path = node.node.getNodePath;
    char* name = cast(char*)malloc(path.length + 1);
    memcpy(name, path.ptr, char.sizeof * path.length);
    name[path.length] = 0;
    return name;
}

bool inNodeGetEnabled(InNode* node) {
    return node.node.enabled;
}

char* inNodeGetTypeId(InNode* node) {
    string type = node.node.typeId;
    char* name = cast(char*)malloc(type.length + 1);
    memcpy(name, type.ptr, char.sizeof * type.length);
    name[type.length] = 0;
    return name;
}

bool inNodeHasParam(InNode* node, char* name) {
    auto len = strlen(name);
    string dName = cast(string)name[0..len];
    return node.node.hasParam(dName);
}

float inNodeGetValue(InNode* node, char* name) {
    auto len = strlen(name);
    string dName = cast(string)name[0..len];
    return node.node.getValue(dName);
}

void inNodeSetValue(InNode* node, char* name, float value) {
    auto len = strlen(name);
    string dName = cast(string)name[0..len];
    node.node.setValue(dName, value);
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