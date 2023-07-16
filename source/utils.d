/*
    Inochi2D C ABI

    Copyright © 2023, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen, seagetch
*/
module utils;
import inochi2d;

import binding;
import binding.err;

import core.stdc.stdlib;
import core.stdc.string;

char* str2cstr(string str) {
    char* result = cast(char*)malloc(str.length * char.sizeof + 1);
    memcpy(result, str.ptr, str.length * char.sizeof);
    result[str.length] = 0;
    return result;
}

string cstr2str(char* cstr) {
    char[] result;
    result.length = strlen(cstr);
    memcpy(result.ptr, cstr, result.length);
    return cast(string)result;
}

T2 id(T1, T2)(ref T1 src) {
    return cast(T2)src;
}

void array2carray(T1, T2, alias Convert = id!(T1, T2))(T1[] in_arr, T2** arr, size_t* length) {
    if (length !is null)
        *length = in_arr.length;
    if (arr !is null) {
        T2* result;
        import std.stdio;
        if (*arr is null) {
            result = cast(T2*)malloc(in_arr.length * T2.sizeof);
            *arr = result;
        } else {
            result = *arr;
        }
        foreach (i, a; in_arr) {
            result[i] = Convert(a);
        }
    }
}

void vec2array2farray(vec2[] in_arr, float** arr, size_t* length) {
    array2carray!(vec2, vec2)(in_arr, cast(vec2**)arr, length);
    if (length !is null)
        *length *= 2;
}

T2* alloc(T1, T2)(T1 obj) {
    auto result = new T2(obj);
    GC.addRoot(result);
    return result;

//    T2* result = cast(T2*)malloc(T2.sizeof);
//    *result = T2(obj);
//    return result;
}

void free_obj(T2)(T2* obj) {
    GC.removeRoot(obj);
    destroy!false(obj);

//    free(obj);
}