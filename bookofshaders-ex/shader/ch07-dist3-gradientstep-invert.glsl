/**
* file: ch07-dist3-gradientstep-invert.glsl: We take the distance from the 
* center of the screen. Then we use this distance with a step function to 
* create a sharp* edge which defines a circle. In this example we invert the 
* circle such that all pixels inside the circle are white and all pixels outside
* the circle are black.
*
* date: 24/03/2024
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
    //Normalize the Screen coordinates. 
    vec2 st = screen_coords.xy / love_ScreenSize.xy;
    float pct = 0.0;

    // The DISTANCE from the pixel to the center
    pct = distance(st, vec2(0.5));

    // scale to [0, 1]
    pct = pct * 2.0;

    // Use the step function to create a sharp edge
    pct = step(0.5, pct);

    // Invert the circle
    pct = 1.0 - pct;

    vec3 pixelColor = vec3(pct);

    return vec4(pixelColor, 1.0);
}