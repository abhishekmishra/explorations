#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// time since start
uniform float uTime;

// constant time multiplier
// this number gets very close (not sure why)
// TODO: try to find out why we cannot get perfect no flicker, and why this
// number is so close to 60
uniform float uTimeMultiplier = 58.0;

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    // return a color based on the time where the red channel is a sine wave
    // This time we make it so fast we can't see the change
    return vec4(abs(sin(uTime * uTimeMultiplier)), 0.0, 0.0, 1.0);
}