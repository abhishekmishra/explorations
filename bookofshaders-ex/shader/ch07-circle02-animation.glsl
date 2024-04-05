/**
* file: ch07-circle02-animation.glsl - Draw a circle at the position of the 
* mouse cursor, with a radius that changes over time, and colour which also
* changes with time.
*
* date: 5/4/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// mouse position
uniform vec2 uMouse;

// time since start
uniform float uTime;

// constant time multipliers
uniform float radiusMult = 5;
uniform float rMult = 1.0;
uniform float gMult = 2.0;
uniform float bMult = 3.0;

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

    // Center of the circle is at the mouse cursor
    vec2 center = uMouse.xy / love_ScreenSize.xy;

    // Radius of the circle changes with time
    float radius = 0.25 + 0.1 * sin(uTime * radiusMult);

    // Colour of the circle changes with time
    vec3 colour = vec3(
        0.5 + 0.5 * sin(uTime * rMult),
        0.5 + 0.5 * sin(uTime * gMult),
        0.5 + 0.5 * sin(uTime * bMult));

    // Call the circle function and return the result
    return circle(center, radius, colour, st);
}