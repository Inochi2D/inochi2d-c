module binding.param;

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

struct InParameter {
    Inochi2D.Parameter param;
}

void inPuppetGetParameters(InPuppet* puppet, void*** array_ptr, size_t* length) {
    InParameter* dummy;
    InParameter** result = cast(InParameter**)malloc((*puppet).puppet.parameters.length * dummy.sizeof);
    foreach (i; 0..puppet.puppet.parameters.length) {
        InParameter* ptr = cast(InParameter*)malloc(InParameter.sizeof);
        ptr.param = puppet.puppet.parameters[i];
        result[i] = ptr;
    }
    *array_ptr = cast(void**)result;
    *length    = puppet.puppet.parameters.length;
}

char* inParameterGetName(InParameter* param) {
    char* name = cast(char*)malloc(param.param.name.length + 1);
    memcpy(name, param.param.name.ptr, char.sizeof * param.param.name.length);
    name[param.param.name.length] = 0;
    return name;
}

void inParameterGetValue(InParameter* param, float* x, float* y) {
    *x = param.param.value.x;
    *y = param.param.value.y;
}

void inParameterSetValue(InParameter* param, float x, float y) {
    param.param.value.x = x;
    param.param.value.y = y;
}

uint inParameterGetUUID(InParameter* param) {
    return param.param.uuid;
}

bool inParameterIsVec2(InParameter* param) {
    return param.param.isVec2;
}

void inParameterGetMin(InParameter* param, float* xmin, float* ymin) {
    *xmin = param.param.min.x;
    *ymin = param.param.min.y;
}

void inParameterGetMax(InParameter* param, float* xmax, float* ymax) {
    *xmax = param.param.max.x;
    *ymax = param.param.max.y;
}

void inParameterGetAxes(InParameter* param, float*** axes, size_t* xLength, size_t* yLength) {
    float* dummy;
    float** result = cast(float**)malloc(2 * dummy.sizeof);
    result[0] = cast(float*)malloc(param.param.axisPoints[0].length * float.sizeof);
    memcpy(result[0], param.param.axisPoints[0].ptr, param.param.axisPoints[0].length * float.sizeof);
    result[1] = cast(float*)malloc(param.param.axisPoints[1].length * float.sizeof);
    memcpy(result[1], param.param.axisPoints[1].ptr, param.param.axisPoints[1].length * float.sizeof);
    *axes = result;
    *xLength = param.param.axisPoints[0].length;
    *yLength = param.param.axisPoints[1].length;
}