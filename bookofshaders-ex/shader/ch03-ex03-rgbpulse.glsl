#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// time since start
uniform float uTime;

// constant time multipliers
uniform float rMult = 1.0;
uniform float gMult = 2.0;
uniform float bMult = 3.0;

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    return vec4(abs(sin(uTime * rMult)), 
        abs(sin(uTime * gMult)),
        abs(sin(uTime * bMult)),
         1.0);
}