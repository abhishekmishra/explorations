/**
* file: ch07-circle01-fn.glsl - A circle function using the distance method.
*
* date: 5/4/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// Circle function using the distance method
vec4 circle(vec2 center, float radius, vec3 colour, vec2 st)
{
    // distance between center and point st as a percentage of the radius
    float pct = distance(st, center) / radius;
    
    // smoothstep for smooth edges
    pct = smoothstep(1.0, 0.9, pct);

    // return the colour, with the percentage as the alpha value
    return vec4(colour, pct);
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

    // Circle parameters
    vec2 center = vec2(0.5, 0.5);
    float radius = 0.25;
    vec3 colour = vec3(1.0, 0.0, 0.0);

    // Call the circle function and return the result
    return circle(center, radius, colour, st);
}