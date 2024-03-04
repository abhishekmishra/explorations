/**
* file: ch07-rect0.glsl: draw a rectangle/box.
*
* date: 04/03/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
)
{
    //Normalize the Screen coordinates. 
    vec2 st = screen_coords.xy / love_ScreenSize.xy;

    vec3 pixelColor = vec3(0.0);

    vec2 bl = step(vec2(0.1),st);       // bottom-left
    vec2 tr = step(vec2(0.1),1.0-st);   // top-right
    pixelColor = vec3(bl.x * bl.y * tr.x * tr.y);

    // return a purple colour for all pixels.
    return vec4(pixelColor, 1.0);
}