/**
* file: ch03-ex05-mousepos.glsl Exercise to use the mouse position
*       on the screen, normalize it and reflect it in the output colour.
*
* date: 28/2/2024
* author: Abhishek Mishra
*/

#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 uMouse;

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    // uMouse is the position of the mouse on the screen
    // in pixels, with the origin at the top-left corner.
    // normalize it to the range 0.0 - 1.0
    vec2 st = uMouse.xy/love_ScreenSize.xy;

    // change the colour of the pixel to reflect the mouse position
    // red for the x coordinate, green for the y coordinate
    return vec4(st.x, st.y, 0.0, 1.0);
}