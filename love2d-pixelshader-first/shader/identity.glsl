#pragma language glsl3

//NOTE: "texture" is reserved in GLSL3, so we use "texture_image" instead

//This is the identity vertext shader
//It just passes the vertex position and texture coordinates to the fragment shader
//And returns pixel value multiplied by color
vec4 effect(
    vec4 color,
    Image texture_image,
    vec2 texture_coords,
    vec2 screen_coords
) {
    //This is the current pixel color
    vec4 pixel = Texel(texture_image, texture_coords);
    return pixel * color;
}