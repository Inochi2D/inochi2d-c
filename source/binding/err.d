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