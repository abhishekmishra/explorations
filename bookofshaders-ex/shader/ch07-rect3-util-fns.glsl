/**
* file: ch07-rect3-util-fns.glsl: Utility functions to create a filled rectangle
* and a rectangle with stroke (outline only).
*
* date: 06/03/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

vec4 filledRect(vec2 st, vec2 tl, vec2 br, vec3 color) {
    float borderEdge = 0.01;

    vec2 tlBorder = smoothstep(st, st + borderEdge, tl);
    vec2 brBorder = smoothstep(1.0 - st, 1.0 - st + borderEdge, 1.0 - br);
    
    float draw = tlBorder.x + tlBorder.y + brBorder.x + brBorder.y;
    draw = 1.0 - draw;

    return vec4(color, draw);
}

vec4 strokeRect(vec2 st, vec2 tl, vec2 br, float strokeWidth, vec3 color) {
    float borderEdge = 0.5 * strokeWidth;

    // outer stroke
    vec2 tlOuter = smoothstep(st, st + borderEdge, tl);
    vec2 brOuter = smoothstep(1.0 - st, 1.0 - st + borderEdge, 1.0 - br);

    // inner stroke
    vec2 tlInner = smoothstep(tl + strokeWidth, tl + strokeWidth + borderEdge, st);
    vec2 brInner = smoothstep(1.0 - br + strokeWidth, 1.0 - br + strokeWidth + borderEdge, 1.0 - st);

    float draw = tlOuter.x + tlOuter.y + brOuter.x + brOuter.y;
    draw += tlInner.x * tlInner.y * brInner.x * brInner.y;
    draw = 1.0 - draw;

    return vec4(color, draw);
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

    // stroke color is green
    vec3 fillColor = vec3(0.0, 1.0, 0.0);
    vec3 strokeColor = vec3(1.0, 0.0, 0.0);

    // draw filled rect with fillColor
    vec4 filledRectColor = filledRect(st, vec2(0.25, 0.25), vec2(0.75, 0.75), fillColor);

    // draw a smaller stroke rect with strokeColor
    vec4 strokeRectColor = strokeRect(st, vec2(0.15, 0.15), vec2(0.85, 0.85), 0.02, strokeColor);

    // vec4 outColor = filledRectColor;
    vec3 outColor = (filledRectColor.rgb * filledRectColor.a) + (strokeRectColor.rgb * strokeRectColor.a);

    return vec4(outColor, 1.0);
}