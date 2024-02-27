#pragma language glsl3

//NOTE: "texture" is reserved in GLSL3, so we use "tex" instead

/**
* In this example, we will create a simple shader that will use the width
* of the window to create three vertical bands filtered by colour . The left 
* band will be red, the middle band will be green, and the right band will be 
* blue.
*/
vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    //see https://www.love2d.org/wiki/Shader_Variables
    vec2 resolution = love_ScreenSize.xy;
    float third = resolution.x / 3.0;

    vec4 pixel = Texel(tex, texture_coords);

    // if the x coordinate of the pixel is less than a third of the screen width
    // then we will return a red pixel
    // if the x coordinate of the pixel is less than two thirds of the screen 
    // width then we will return a green pixel
    // otherwise we will return a blue pixel
    if(screen_coords.x < third) {
        return vec4(pixel.r, 0, 0, 1.0);
    } else if(screen_coords.x < third * 2.0) {
        return vec4(0, pixel.g, 0, 1.0);
    } else {
        return vec4(0, 0, pixel.b, 1.0);
    }
}
