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

    vec2 tl = step(vec2(0.1),st);       // top-left
    vec2 br = step(vec2(0.1),1.0-st);   // bottom-right
    pixelColor = vec3(tl.x * tl.y * br.x * br.y);

    return vec4(pixelColor, 1.0);
}