#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// time since start
uniform float uTime;

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    // return a color based on the time where the red channel is a sine wave    
    return vec4(abs(sin(uTime)), 0.0, 0.0, 1.0);
}