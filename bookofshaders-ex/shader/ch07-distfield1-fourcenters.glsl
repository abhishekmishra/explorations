/**
* file: ch07-distfield0.glsl: Explore a simple distance field. To build this
* into future examples.
*
* date: 24/04/2024
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
    // Normalize the Screen coordinates. 
    vec2 st = screen_coords.xy / love_ScreenSize.xy;
    st.x *= love_ScreenSize.x / love_ScreenSize.y;
    
    vec3 col = vec3(0.0);
    float d = 0.0;

    // Remap the space to -1, 1
    st = (st * 2.0) - 1.0;

    // Distance field
    d = length( abs(st) - 0.3 );

    // Visualize the distance field
    return vec4(vec3(fract(d * 10.0)), 1.0);
}