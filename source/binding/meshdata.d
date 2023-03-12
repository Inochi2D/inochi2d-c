module binding.meshdata;
import binding.nodes: InNode;
import inochi2d;
import utils;
import binding.nodes;

bool inDrawableGetMeshData(InNode* node, float** vertices, size_t* vertLen, 
                           float** uvs, size_t* uvLen, float** indices, size_t* indLen, 
                           float** gridAxes, size_t* axesLenX, size_t* axesLenY, 
                           float* originX, float* originY) {
    auto drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;
    
    MeshData data = drawable.getMesh();
    if (vertices) {

    }

    if (uvs) {

    }

    if (indices) {

    }

    if (gridAxes) {

    }

    if (originX) {

    }

    if (originY) {

    }

    return true;
}


bool inDrawableSetMeshData(InNode* node, float* vertices, size_t vertLen, 
                           float* uvs, size_t uvLen, float* indices, size_t indLen, 
                           float* gridAxes, size_t axesLenX, size_t axesLenY, 
                           float originX, float originY) {
    auto drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;
    
    MeshData data = drawable.getMesh();
    if (vertices) {

    }

    if (uvs) {

    }

    if (indices) {

    }

    if (gridAxes) {

    }

    if (originX) {

    }

    if (originY) {
        
    }

    return true;
}