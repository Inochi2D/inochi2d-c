module binding.texture;

import binding;
import binding.err;
import binding.puppet;
import inochi2d;
import utils;

import core.stdc.string;

// Everything here should be C ABI compatible
extern(C) export:
struct InTexture {
    Texture texture;
}

struct InShallowTexture {
    ShallowTexture texture;
}
private {
InTexture* to_texture(ref Texture c) {
    return alloc!(Texture, InTexture)(c);
}

InShallowTexture* to_stexture(ref ShallowTexture c) {
    return alloc!(ShallowTexture, InShallowTexture)(c);
}

}

InTexture* inPuppetGetTexture(InPuppet* puppet, uint id) {
    Texture texture = puppet.puppet.textureSlots[id];
    return to_texture(texture);
}

int inTextureGetWidth(InTexture* texture) {
    return texture.texture.width();
}

int inTextureGetHeight(InTexture* texture) {
    return texture.texture.height();
}

uint inTextureGetColorMode(InTexture* texture) {
    return texture.texture.colorMode();
}

int inTextureGetChannels(InTexture* texture) {
    return texture.texture.channels();
}

void inTextureGetCenter(InTexture* texture, int* x, int* y) {
    auto center = texture.texture.center();
    *x = center.x;
    *y = center.y;
}

void inTextureGetSize(InTexture* texture, int* x, int* y) {
    auto center = texture.texture.size();
    *x = center.x;
    *y = center.y;
}

void inTextureBind(InTexture* texture, uint unit) {
    texture.texture.bind(unit);
}

uint inTextureGetTextureId(InTexture* texture) {
    return texture.texture.getTextureId();
}

void inTextureDispose(InTexture* texture) {
    texture.texture.dispose();
}

void inTextureSetData(InTexture* texture, ubyte* buffer, size_t length) {
    ubyte[] data;
    data.length = length;
    memcpy(data.ptr, buffer, length * ubyte.sizeof);
    texture.texture.setData(data);
}

void inTextureGetTextureData(InTexture* texture, bool unmultiply, ubyte** buffer, size_t* length) {
    auto data = texture.texture.getTextureData(unmultiply);
    array2carray!(ubyte, ubyte)(data, buffer, length);
}

void inTextureDestroy(InTexture* texture) {
    free_obj(texture);
}