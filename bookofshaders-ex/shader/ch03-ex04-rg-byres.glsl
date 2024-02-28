#pragma language glsl3

#ifdef GL_ES
precision mediump float;
#endif


vec4 effect(
    vec4 color,
    Image tex,
    vec2 texture_coords,
    vec2 screen_coords
) {
    // screen_coords is the position of the pixel in the screen
    // in pixels, with the origin at the top-left corner.
    // normalize it to the range 0.0 - 1.0
    vec2 st = screen_coords.xy/love_ScreenSize.xy;

    // in love2d the origin is at the top left, so
    // the bottom left will appear greenest,
    // the top right will appear reddest,
    // the bottom right will appear yellowest.
    return vec4(st.x, st.y, 0.0, 1.0);
}