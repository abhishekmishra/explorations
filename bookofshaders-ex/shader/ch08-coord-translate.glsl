/**
* file: ch08-coord-tranlate - Move an object by translating the coordinate
* system, which in-turn is done by adding a vector to the st vector.
*
* date: 15/05/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

// time since start
uniform float uTime;

float box(in vec2 _st, in vec2 _size)
{
    _size = vec2(0.5) - _size * 0.5;
    vec2 uv = smoothstep(_size, _size + vec2(0.001), _st);
    uv *= smoothstep(_size, _size + vec2(0.001), vec2(1.0) - _st);
    return uv.x * uv.y;
}

float cross(in vec2 _st, float _size)
{
    return box(_st, vec2(_size, _size / 4.0)) 
    + box(_st, vec2(_size / 4.0, _size));
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

    vec3 pixelColor = vec3(0.0);

    //Move the coordinate system by adding a vector to the st vector.
    vec2 translate = vec2(cos(uTime), sin(uTime));
    st += translate * 0.35;

    // show coordinates as colour
    pixelColor = vec3(st.x, st.y, 0.0);

    // moving shape in the foreground
    pixelColor += vec3(cross(st, 0.35));

    return vec4(pixelColor, 1.0);
}