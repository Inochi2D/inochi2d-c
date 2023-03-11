module utils;
import inochi2d;
import core.stdc.stdlib;
import core.stdc.string;

char* str2cstr(string str) {
    char* result = cast(char*)malloc(str.length * char.sizeof + 1);
    memcpy(result, str.ptr, str.length * char.sizeof);
    result[str.length] = 0;
    return result;
}

string cstr2str(char* cstr) {
    size_t len = strlen(cstr);
    return cast(string)cstr[0..len];
}

T2 id(T1, T2)(ref T1 src) {
    return cast(T2)src;
}

void array2carray(T1, T2, alias Convert = id!(T1, T2))(T1[] in_arr, out T2* arr, out size_t length) {
    T2* result = cast(T2*)malloc(in_arr.length * T2.sizeof);
    length = in_arr.length;
    arr = result;
    foreach (i, a; in_arr) {
        result[i] = Convert(a);
    }
}

void vec2array2farray(vec2[] in_arr, out float* arr, out size_t length) {
    vec2* varr;
    size_t vlen;
    array2carray!(vec2, vec2)(in_arr, varr, vlen);
    arr = cast(float*)varr;
    length = vlen * 2;
}

T2* alloc(T1, T2)(T1 obj) {
    T2* result = cast(T2*)malloc(T2.sizeof);
    *result = T2(obj);
    return result;
}