module binding.param;

import binding;
import binding.err;
import binding.puppet;
import inochi2d;
import utils;

// Everything here should be C ABI compatible
extern(C) export:

struct InParameter {
    Inochi2D.Parameter param;
}
private {
InParameter* to_param(ref Parameter b) {
    return alloc!(Parameter, InParameter)(b);
}
}

void inPuppetGetParameters(InPuppet* puppet, InParameter*** array_ptr, size_t* length) {
    array2carray!(Parameter, InParameter*, to_param)(puppet.puppet.parameters, array_ptr, length);
}

char* inParameterGetName(InParameter* param) {
    return str2cstr(param.param.name);
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
    size_t*[2] length = [xLength, yLength];
    size_t dummy;
    size_t index = 0;
    array2carray!(float[], float*, (float[] points) {
        float* result = null;
        array2carray!(float, float)(points, &result, length[index++]);
        return result;
    })(param.param.axisPoints, axes, &dummy);
}

void inParameterFindClosestKeypoint(InParameter* param, float x, float y, uint* index_x, uint* index_y) {
    vec2u result = param.param.findClosestKeypoint(vec2(x, y));
    *index_x = result.x;
    *index_y = result.y;
}

void inParameterDestroy(InParameter* param) {
    free_obj(param);
}