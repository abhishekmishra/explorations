/**
* file: misc-lissajous0.glsl: Draw one or more lissajous curves on the screen.
*      Just to play around with the parameters of the lissajous curves.
*
* date: 29/05/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// time since start
uniform float uTime;

// vec2 curve(vec2 st) {
//     return vec2(st.x);
// }

vec2 curve(vec2 st, float t) {
    float a = 3.0, b = 2.0;
    float x = 0.5 + 0.5 * sin(a * t + 0.0);
    float y = 0.5 + 0.5 * sin(b * t + 3.14159 / 2.0);
    return vec2(x, y);
}

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
)
{
    //Normalize the Screen coordinates. 
    vec2 st = screen_coords.xy / love_ScreenSize.xy;

    // Get the position of the current fragment
    vec2 y = curve(st, uTime);

    // Compute the distance from the current fragment to the curve
    float dist = length(st - y);

    // Use the distance to compute a color
    // This will create a line that fades out towards the edges
    vec3 pixelColor = vec3(smoothstep(0.01, 0.04, dist));

    return vec4(pixelColor, 1.0);
}