#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    // return a purple colour for all pixels.
    return vec4(1.0, 0.0, 1.0, 1.0);
}