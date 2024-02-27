#pragma language glsl3

//NOTE: "texture" is reserved in GLSL3, so we use "tex" instead

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    vec4 pixel = Texel(tex, texture_coords);
    // return a pixel with the red channel set to the red channel of the 
    // original pixel
    return vec4(pixel.r, 0, 0, 1.0);
}
