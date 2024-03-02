/**
* file: ch05-color-mix.glsl: create mixtures of two colors
* (based on the code from the book)
*
* date: 2/3/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// time since start
uniform float uTime;

vec3 colorA = vec3(0.149,0.141,0.912);
vec3 colorB = vec3(1.000,0.833,0.224);

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
)
{
    vec3 pxlColor = vec3(0.0);

    float pct = abs(sin(uTime));

    // Mix uses pct (a value from 0-1) to
    // mix the two colors
    pxlColor = mix(colorA, colorB, pct);

    return vec4(pxlColor, 1.0);
}