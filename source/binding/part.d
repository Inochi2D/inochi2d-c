/*
    Inochi2D C ABI

    Copyright © 2023, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen, seagetch
*/
module binding.part;

import binding;
import binding.err;
import binding.texture;
import binding.nodes: InNode;
import inochi2d;
import core.stdc.string;
import utils;

// Everything here should be C ABI compatible
extern(C) export:

bool inPartGetTextures(InNode* node, InTexture*** array_ptr, size_t* length) {
    auto part = cast(Part)node.node;
    if (part is null)
        return false;
    
    array2carray!(Texture, InTexture*, to_texture)(part.textures, array_ptr, length);
    return true;
}