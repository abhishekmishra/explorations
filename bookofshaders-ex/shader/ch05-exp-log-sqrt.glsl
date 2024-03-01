/**
* file: ch05-curved-line.glsl: plot exp()/log()/sqrt() line and an associated 
* gradient.* (based on the code from the book)
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

    // get the time module 10 second
    float t = mod(uTime * 10, 10.0);

    float y = 0.0;
    vec3 gradColor = vec3(0.0, 0.0, 0.0);

    // Note: These if statements are probably quite inefficient on the GPU,
    // and I would like to find a better way to do this. Maybe in a later
    // exercise.
    // if t is less than 3, y=exp(x)
    // if t is between 3 and 6, y=log(x)
    // if t is greater than 6, y=sqrt(x)
    if (t < 3.0)
    {
        // subtracting one so that y comes within the range of 0 to 1
        // at least for some part of the input range
        y = exp(st.x) - 1;
        gradColor = vec3(1.0, 0.0, 0.0);
    }
    else if (t < 6.0)
    {
        // taking the abs of log so that y comes within the range of 0 to 1
        y = abs(log(st.x));
        gradColor = vec3(0.0, 1.0, 0.0);
    }
    else
    {
        y = sqrt(st.x);
        gradColor = vec3(0.0, 0.0, 1.0);
    }

    //Start with pixel color, where each channel is equal to y
    //This will give us a gradient. 
    vec3 pxlColor = vec3(y);

    //Get a percentage value indicating how close we are to the curve
    float pct = plot(st, y);

    //The formula below produces a green color where the percentage is high 
    //and we are close to the curve.
    //Otherwise, it will be the grayscale color of the gradient.
    pxlColor = (1.0 - pct) * pxlColor + pct * gradColor;

    return vec4(pxlColor, 1.0);
}