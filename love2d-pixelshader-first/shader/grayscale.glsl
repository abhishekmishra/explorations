vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    //This is the current pixel color
    vec4 pixel = Texel(texture, texture_coords);
    number gray = (color.r + color.g + color.b) / 3.0;
    return pixel * vec4(gray, gray, gray, 1.0);
}
