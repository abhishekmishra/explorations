#pragma language glsl3

//NOTE: "texture" is reserved in GLSL3, so we use "tex" instead

/**
* the amount of red in the pixel is scaled by the position of the pixel
* on the x-coordinate.
*/
vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    //see https://www.love2d.org/wiki/Shader_Variables
    vec2 resolution = love_ScreenSize.xy;

    vec4 pixel = Texel(tex, texture_coords);

    //scale the red channel by the x-coordinate
    pixel.r *= texture_coords.x;

    return pixel;
}
