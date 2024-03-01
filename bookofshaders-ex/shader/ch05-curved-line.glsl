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

// time since start
uniform float uTime;

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

    // get the time in millis modulo 1000
    // note that uTime is in seconds, but has a precision of microseconds
    // in the fractional part
    float t = mod(uTime * 1000, 1000.0);

    // Note: These if statements are probably quite inefficient on the GPU,
    // and I would like to find a better way to do this. Maybe in a later
    // exercise.
    // if t is less than 100, then n = 0.2
    // if t is less than 200, then n = 2.0
    // if t is less than 300, then n = 5.0
    // if t is less than 400, then n = 10.0
    // if t is less than 500, then n = 20.0
    // if t is less than 600, then n = 50.0
    // if t is less than 700, then n = 100.0
    // if t is less than 800, then n = 200.0
    // if t is less than 900, then n = 500.0
    // if t is less than 1000, then n = 1000.0
    if (t < 100.0)
    {
        n = 0.2;
    }
    else if (t < 200.0)
    {
        n = 2.0;
    }
    else if (t < 300.0)
    {
        n = 5.0;
    }
    else if (t < 400.0)
    {
        n = 10.0;
    }
    else if (t < 500.0)
    {
        n = 20.0;
    }
    else if (t < 600.0)
    {
        n = 50.0;
    }
    else if (t < 700.0)
    {
        n = 100.0;
    }
    else if (t < 800.0)
    {
        n = 200.0;
    }
    else if (t < 900.0)
    {
        n = 500.0;
    }
    else if (t < 1000.0)
    {
        n = 1000.0;
    }

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