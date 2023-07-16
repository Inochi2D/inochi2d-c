/*
    Inochi2D C ABI

    Copyright © 2023, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen, seagetch
*/
module binding.err;

package(binding) {
    InError* currError_;

    void setError(Exception ex) {
        currError_ = new InError(ex.msg);
    }
}

/**
    An Inochi2D error
*/
struct InError {
    string msg;
}

extern(C) export:

InError* inErrorGet() {
    return currError_;
}