module binding.deform;

import inochi2d;
import binding.binding;
import utils;
import core.stdc.stdlib;
import core.stdc.string;

bool inParameterBindingGetFloat(InParameterBinding* binding, uint x, uint y, float* value) {
    auto floatBinding = cast(ValueParameterBinding)binding;
    if (floatBinding is null)
        return false;
    
    *value = floatBinding.values[x][y];
    return true;
}

bool inParameterBindingSetFloat(InParameterBinding* binding, uint x, uint y, float value) {
    auto floatBinding = cast(ValueParameterBinding)binding;
    if (floatBinding is null)
        return false;
    
    floatBinding.values[x][y] = value;
    return true;
}

bool inParameterBindingGetDeformation(InParameterBinding* binding, uint x, uint y, float** values, size_t* length) {
    auto deformBinding = cast(DeformationParameterBinding)binding;
    if (deformBinding is null)
        return false;

    vec2array2farray(deformBinding.values[x][y].vertexOffsets, *values, *length);
    return true;
}

bool inParameterBindingSetDeformation(InParameterBinding* binding, uint x, uint y, float* values, size_t length) {
    auto deformBinding = cast(DeformationParameterBinding)binding;
    if (deformBinding is null)
        return false;

    deformBinding.values[x][y].vertexOffsets.length = length / 2;
    memcpy(deformBinding.values[x][y].vertexOffsets.ptr, values, length * float.sizeof);
    return true;
}