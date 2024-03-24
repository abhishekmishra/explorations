/**
* file: ch07-dist1-fullgradient.glsl: This modifies the dist0 example which
* shows less color variation as the max distance of a pixel from the center
* of the screen is 0.5. In this example, we will calculate the distance of a
* pixel from the center, but we will scale the distance to the range of 0.0 to
* 1.0. This will give us a better color variation as the distance will be
* normalized.
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

    // a. The DISTANCE from the pixel to the center
    pct = distance(st, vec2(0.5));

    // since this value ranges from 0 to 0.5, scale it double
    pct = pct * 2;

    vec3 pixelColor = vec3(pct);

    return vec4(pixelColor, 1.0);
}
