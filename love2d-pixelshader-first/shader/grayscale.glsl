#pragma language glsl3

//NOTE: "texture" is reserved in GLSL3, so we use "texture_image" instead

vec4 effect(
    vec4 color,
    Image texture_image,
    vec2 texture_coords,
    vec2 screen_coords
) {
    //This is the current pixel color
    vec4 pixel = Texel(texture_image, texture_coords);
    number gray = (pixel.r + pixel.g + pixel.b) / 3.0;
    return vec4(gray, gray, gray, 1.0);
}
