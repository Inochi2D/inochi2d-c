module binding.deform;

import inochi2d;
import binding.binding;
import utils;
import core.stdc.stdlib;
import core.stdc.string;

extern(C) export:

enum BindingType {
    Value, Deformation, End
}

bool inParameterBindingGetFloat(InParameterBinding* binding, uint x, uint y, float* value) {
    auto floatBinding = cast(ValueParameterBinding)binding.binding;
    if (floatBinding is null)
        return false;
    *value = floatBinding.values[x][y];
    return true;
}

bool inParameterBindingSetFloat(InParameterBinding* binding, uint x, uint y, float value) {
    auto floatBinding = cast(ValueParameterBinding)binding.binding;
    if (floatBinding is null)
        return false;
    
    floatBinding.values[x][y] = value;
    return true;
}

bool inParameterBindingGetDeformation(InParameterBinding* binding, uint x, uint y, float** values, size_t* length) {
    auto deformBinding = cast(DeformationParameterBinding)binding.binding;
    if (deformBinding is null)
        return false;

    vec2array2farray(deformBinding.values[x][y].vertexOffsets, values, length);
    return true;
}

bool inParameterBindingSetDeformation(InParameterBinding* binding, uint x, uint y, float* values, size_t length) {
    auto deformBinding = cast(DeformationParameterBinding)binding.binding;
    if (deformBinding is null)
        return false;

    deformBinding.values[x][y].vertexOffsets.length = length / 2;
    memcpy(deformBinding.values[x][y].vertexOffsets.ptr, values, length * float.sizeof);
    return true;
}

BindingType inParameterBindingGetType(InParameterBinding* binding) {
    if (cast(ValueParameterBinding)binding.binding) {
        return BindingType.Value;
    } else if (cast(DeformationParameterBinding)binding.binding) {
        return BindingType.Deformation;
    } else {
        return BindingType.End;
    }
}

BindingType inParameterBindingGetValue(InParameterBinding* binding, uint x, uint y, float** values, size_t* length) {
    BindingType result = inParameterBindingGetType(binding);
    switch (result) {
    case BindingType.Value:
        if (length)
            *length = 1;
        if (values) {
            *values = cast(float*)malloc(float.sizeof);
            inParameterBindingGetFloat(binding, x, y, *values);
        }
        break;
    case BindingType.Deformation:
        inParameterBindingGetDeformation(binding, x, y, values, length);
        break;
    default:
        break;
    }
    return result;
}

BindingType inParameterBindingSetValue(InParameterBinding* binding, uint x, uint y, float* values, size_t length) {
    BindingType result = inParameterBindingGetType(binding);
    switch (result) {
    case BindingType.Value:
        inParameterBindingSetFloat(binding, x, y, *values);
        break;
    case BindingType.Deformation:
        inParameterBindingSetDeformation(binding, x, y, values, length);
        break;
    default:
        break;
    }
    return result;
}