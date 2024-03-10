/**
* file: ch07-dist0.glsl: Show distance from a point to the 
* center of the screen. This is based on the example in the book, just
* converted to love2d shader format.
*
* date: 10/03/2024
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

    // a. The DISTANCE from the pixel to the center
    pct = distance(st,vec2(0.5));

    // b. The LENGTH of the vector
    //    from the pixel to the center
    // vec2 toCenter = vec2(0.5)-st;
    // pct = length(toCenter);

    // c. The SQUARE ROOT of the vector
    //    from the pixel to the center
    // vec2 tC = vec2(0.5)-st;
    // pct = sqrt(tC.x*tC.x+tC.y*tC.y);

    vec3 pixelColor = vec3(pct);

    return vec4(pixelColor, 1.0);
}