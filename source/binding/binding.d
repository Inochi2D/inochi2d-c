module binding.binding;
import binding;
import binding.err;
import binding.param;
import binding.nodes: InNode;
import std.stdio;
import std.string;
import inochi2d;
import core.stdc.stdlib;
import core.stdc.string;
import utils;

// Everything here should be C ABI compatible
extern(C) export:

struct InParameterBinding {
    ParameterBinding binding;
};

private {
InParameterBinding* to_ref(ref ParameterBinding b) {
    return alloc!(ParameterBinding, InParameterBinding)(b);
}
}

void inParameterGetBindings(InParameter* param, InParameterBinding*** arr, size_t* length) {
    array2carray!(ParameterBinding, InParameterBinding*, to_ref)(param.param.bindings, *arr, *length);
}

InParameterBinding* inParameterGetBinding(InParameter* param, InNode* node, char* bindingName) {
    string name = cstr2str(bindingName);
    auto binding = param.param.getBinding(node.node, name);
    return to_ref(binding);
}


/**
    Apply a binding to the model at the given parameter value
*/
void inParameterBindingApply(InParameterBinding* binding, uint leftKeyPointX, uint leftKeyPointY, float offsetX, float offsetY) {
    auto leftKeyPoint = vec2u(leftKeyPointX, leftKeyPointY);
    auto offset       = vec2(offsetX, offsetY);
    binding.binding.apply(leftKeyPoint, offset);
}

/**
    Clear all keypoint data
*/
void inParameterBindingClear(InParameterBinding* binding) {
    binding.binding.clear();
}

/**
    Sets value at specified keypoint to the current value
*/
void inParameterBindingSetCurrent(InParameterBinding* binding, int x, int y) {
    auto key = vec2u(x, y);
    binding.binding.setCurrent(key);
}

/**
    Unsets value at specified keypoint
*/
void inParameterBindingUnset(InParameterBinding* binding, int x, int y) {
    auto key = vec2u(x, y);
    binding.binding.unset(key);
}

/**
    Resets value at specified keypoint to default
*/
void inParameterBindingReset(InParameterBinding* binding, int x, int y) {
    auto key = vec2u(x, y);
    binding.binding.reset(key);
}

/**
    Returns whether the specified keypoint is set
*/
bool inParameterBindingIsSet(InParameterBinding* binding, int x, int y) {
    auto key = vec2u(x, y);
    return binding.binding.isSet(key);
}

/**
    Scales the value, optionally with axis awareness
*/
void inParameterBindingScaleValueAt(InParameterBinding* binding, int x, int y, int axis, float scale) {
    auto key = vec2u(x, y);
    binding.binding.scaleValueAt(key, axis, scale);
}

/**
    Extrapolates the value across an axis
*/
void inParameterBindingExtrapolateValueAt(InParameterBinding* binding, int x, int y, int axis) {
    auto key = vec2u(x, y);
    binding.binding.extrapolateValueAt(key, axis);
}

/**
    Copies the value to a point on another compatible binding
*/
void inParameterBindingCopyKeypointToBinding(InParameterBinding* binding, uint srcX, uint srcY, InParameterBinding* other, uint destX, uint destY) {
    auto src = vec2u(srcX, srcY);
    auto dest = vec2u(destX, destY);
    binding.binding.copyKeypointToBinding(src, other.binding, dest);
}

/**
    Swaps the value to a point on another compatible binding
*/
void inParameterBindingSwapKeypointWithBinding(InParameterBinding* binding, uint srcX, uint srcY, InParameterBinding* other, uint destX, uint destY) {
    auto src = vec2u(srcX, srcY);
    auto dest = vec2u(destX, destY);
    binding.binding.swapKeypointWithBinding(src, other.binding, dest);
}

/**
    Flip the keypoints on an axis
*/
void inParameterBindingReverseAxis(InParameterBinding* binding, uint axis) {
    binding.binding.reverseAxis(axis);
}

/**
    Update keypoint interpolation
*/
void inParameterBindingReInterpolate(InParameterBinding* binding) {
    binding.binding.reInterpolate();
}

/**
    Move keypoints to a new axis point
*/
void inParameterBindingMoveKeypoints(InParameterBinding* binding, uint axis, uint oldindex, uint index) {
    binding.binding.moveKeypoints(axis, oldindex, index);
}

/**
    Add keypoints along a new axis point
*/
void inParameterBindingInsertKeypoints(InParameterBinding* binding, uint axis, uint index) {
    binding.binding.insertKeypoints(axis, index);
}

/**
    Remove keypoints along an axis point
*/
void inParameterBindingDeleteKeypoints(InParameterBinding* binding, uint axis, uint index) {
    binding.binding.deleteKeypoints(axis, index);
}

/**
    Gets name of binding
*/
char* inParameterBindingGetName(InParameterBinding* binding) {
    return str2cstr(binding.binding.getName());
}

/**
    Gets the node of the binding
*/
InNode* inParameterBindingGetNode(InParameterBinding* binding) {
    return alloc!(Node, InNode)(binding.binding.getNode());
}

/**
    Gets the uuid of the node of the binding
*/
uint inParameterBindingGetNodeUUID(InParameterBinding* binding) {
    return binding.binding.getNodeUUID();
}

/**
    Checks whether a binding is compatible with another node
*/
bool inParameterBindingIsCompatibleWithNode(InParameterBinding* binding, InNode* other) {
    return binding.binding.isCompatibleWithNode(other.node);
}

/**
    Gets the interpolation mode
*/
uint inParameterBindingGetInterpolateMode(InParameterBinding* binding) {
    return cast(uint)binding.binding.interpolateMode();
}

/**
    Sets the interpolation mode
*/
void inParameterBindingSetInterpolateMode(InParameterBinding* binding, uint mode) {
    binding.binding.interpolateMode(cast(InterpolateMode)mode);
}