/**
* file: ch05-line.glsl: draw a simple line and an associated gradient
*
* date: 29/2/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// Plot a line on y using a value between 0 and 1
float plot(vec2 st) {
    return smoothstep(0.02, 0.0, abs(st.y - st.x));
}

vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    //Normalize the Screen coordinates. 
    vec2 st = screen_coords.xy / love_ScreenSize.xy;

    //This is the line where y equal to x
    float y = st.x;

    //Start with pixel color, where each channel is equal to y
    //This will give us a gradient. 
    vec3 pxlColor = vec3(y);

    //Get a percentage value indicating how close we are to the line
    float pct = plot(st);

    //The formula below produces a green color where the percentage is high 
    //qnd we are close to the line.
    //Otherwise, it will be the grayscale color of the gradient.
    pxlColor = (1.0 - pct) * pxlColor + pct * vec3(0.0, 1.0, 0.0);

    return vec4(pxlColor, 1.0);
}