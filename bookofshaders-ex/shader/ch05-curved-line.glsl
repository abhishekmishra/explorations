/**
* file: ch05-curved-line.glsl: draw a curved line and an associated gradient.
* (based on the code from the book)
*
* date: 1/3/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

float plot(vec2 st, float pct)
{
    return smoothstep(pct - 0.02, pct, st.y) - smoothstep(pct, pct + 0.02, st.y);
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

    //The power of the curve
    float n = 5.0;

    //This is the curve where y equal to x^n
    float y = pow(st.x, n);

    //Start with pixel color, where each channel is equal to y
    //This will give us a gradient. 
    vec3 pxlColor = vec3(y);

    //Get a percentage value indicating how close we are to the curve
    float pct = plot(st, y);

    //The formula below produces a green color where the percentage is high 
    //and we are close to the curve.
    //Otherwise, it will be the grayscale color of the gradient.
    pxlColor = (1.0 - pct) * pxlColor + pct * vec3(0.0, 1.0, 0.0);

    return vec4(pxlColor, 1.0);
}