#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// time since start
uniform float uTime;

// constant time multiplier
uniform float uTimeMultiplier = 2.0;

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    // return a color based on the time where the red channel is a sine wave
    // This time we make it faster by multipliying a constant to uTime.
    // When we say faster we are basically increasing the frequency of the sine
    // wave.    
    return vec4(abs(sin(uTime * uTimeMultiplier)), 0.0, 0.0, 1.0);
}