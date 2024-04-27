/**
* file: ch07-distfield2-wave.glsl: Move the distance field with a wave pattern.
*
* date: 27/04/2024
* author: Abhishek Mishra
*/
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
)
{
    // Normalize the Screen coordinates. 
    vec2 st = screen_coords.xy / love_ScreenSize.xy;
    st.x *= love_ScreenSize.x / love_ScreenSize.y;
    
    vec3 col = vec3(0.0);
    float d = 0.0;

    // Remap the space to -1, 1
    st = (st * 2.0) - 1.0;

    // Distance field with a wave pattern based on time
    d = length(st) - 0.5 + (0.5 * sin(uTime));

    // Create a color based on the distance
    vec3 pt = vec3(fract(d * 10.0));

    // Visualize the distance field
    return vec4(pt, 1.0);
}