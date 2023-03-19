module binding.meshdata;
import binding.nodes: InNode;
import inochi2d;
import utils;
import core.stdc.string;
import binding.nodes;

extern(C) export:

bool inDrawableGetMeshData(InNode* node, float** vertices, size_t* vertLen, 
                           float** uvs, size_t* uvLen, ushort** indices, size_t* indLen, 
                           float*** gridAxes, size_t* axesLenX, size_t* axesLenY, 
                           float* originX, float* originY) {
    auto drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;
    
    MeshData data = drawable.getMesh();
    vec2array2farray(data.vertices, vertices, vertLen);
    vec2array2farray(data.uvs, uvs, uvLen);
    array2carray!(ushort, ushort)(data.indices, indices, indLen);

    if (gridAxes) {
        size_t*[2] length = [axesLenY, axesLenX];
        size_t dummy;
        size_t index = 0;

        array2carray!(float[], float*, (float[] points) {
            float* result = null;
            array2carray!(float, float)(points, &result, length[index++]);
            return result;
        })(data.gridAxes, gridAxes, &dummy);
    }

    if (originX) *originX = data.origin.x;
    if (originY) *originY = data.origin.y;

    return true;
}


bool inDrawableSetMeshData(InNode* node, float* vertices, size_t vertLen, 
                           float* uvs, size_t uvLen, float* indices, size_t indLen, 
                           float** gridAxes, size_t axesLenX, size_t axesLenY, 
                           float* originX, float* originY) {
    auto drawable = cast(Drawable)node.node;
    if (drawable is null)
        return false;
    
    MeshData data = drawable.getMesh();
    if (vertices) {
        data.vertices.length = vertLen / 2;
        memcpy(data.vertices.ptr, vertices, vertLen * float.sizeof);
    }

    if (uvs) {
        data.uvs.length = uvLen / 2;
        memcpy(data.uvs.ptr, uvs, uvLen * float.sizeof);
    }

    if (indices) {
        data.indices.length = indLen;
        memcpy(data.indices.ptr, uvs, indLen * ushort.sizeof);
    }

    if (gridAxes) {
        data.gridAxes.length = 2;
        data.gridAxes[0].length = axesLenY;
        memcpy(data.gridAxes[0].ptr, gridAxes[0], axesLenY * float.sizeof);
        data.gridAxes[1].length = axesLenX;
        memcpy(data.gridAxes[1].ptr, gridAxes[1], axesLenX * float.sizeof);
    }

    if (originX) {
        data.origin.x = *originX;
    }

    if (originY) {
        data.origin.y = *originY;
    }

    drawable.rebuffer(data);
    return true;
}