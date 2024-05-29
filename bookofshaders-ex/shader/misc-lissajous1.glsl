/**
* file: misc-lissajous0.glsl: Draw one or more lissajous curves on the screen.
*      Just to play around with the parameters of the lissajous curves.
*
* date: 29/05/2024
* author: Abhishek Mishra
*/
#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

// time since start
uniform float uTime;

float A = 0.5; // Amplitude along x-axis
float B = 0.5; // Amplitude along y-axis
float a = 3.0; // Frequency along x-axis
float b = 2.0; // Frequency along y-axis
float delta = 1.5; // Phase shift

vec4 curve(vec2 st) {
    // Calculate the Lissajous curve equation
    float t1 = asin((st.x * 2 - 1.0) / A - delta) / a; // The first possible t value
    float t2 = PI - t1; // The other possible t value

    // Adjust t values to cover the full range of the curve
    t1 = t1 < 0.0 ? t1 + 2.0 * PI : t1;
    t2 = t2 < 0.0 ? t2 + 2.0 * PI : t2;

    float x1 = A * sin(a * t1 + delta);
    float y1 = B * sin(b * t1);
    float x2 = A * sin(a * t2 + delta);
    float y2 = B * sin(b * t2);
    
    // Map the curve to the screen space
    vec2 pos1 = vec2(st.x, y1) * 0.5 + 0.5;
    vec2 pos2 = vec2(st.x, y2) * 0.5 + 0.5;

    // Calculate the distance from the current pixel to the curve
    float d1 = distance(st, pos1);
    float d2 = distance(st, pos2);

    // Choose the color based on the distance to the curve
    vec4 color;
    if (d1 < 0.01) {
        color = vec4(1.0, 0.0, 0.0, 1.0); // Red for y1
    } else if (d2 < 0.01) {
        color = vec4(0.0, 0.0, 1.0, 1.0); // Blue for y2
    } else {
        color = vec4(0.4); // Transparent for other pixels
    }

    return color;
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

    vec4 pixelColor = curve(st);

    return vec4(pixelColor);
}