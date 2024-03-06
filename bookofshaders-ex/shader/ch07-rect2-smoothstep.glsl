/**
* file: ch07-rect2-smoothstem.glsl: use smoothstep to draw a rectangle/box.
*
* date: 06/03/2024
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

    // stroke color is green
    vec3 pixelColor = vec3(0.16, 0.32, 0.24);

    vec2 tl = vec2(0.1); // top-left
    vec2 br = vec2(0.9); // bottom-right
    float strokeWidth = 0.05; // stroke width
    float borderEdge = 0.08; // border edge (change this to 0.0 to get crisp edges)

    // draw the oute stroke
    vec2 tlOuter = smoothstep(st, st + borderEdge, tl);
    vec2 brOuter = smoothstep(1.0 - st, 1.0 - st + borderEdge, 1.0 - br);
    pixelColor += vec3(tlOuter.x + tlOuter.y + brOuter.x + brOuter.y);

    // draw the inner stroke
    vec2 tlInner = smoothstep(tl + strokeWidth, tl + strokeWidth + borderEdge, st);
    vec2 brInner = smoothstep(1.0 - br + strokeWidth, 1.0 - br + strokeWidth + borderEdge, 1.0 - st);
    pixelColor += vec3(tlInner.x * tlInner.y * brInner.x * brInner.y);

    return vec4(pixelColor, 1.0);
}