--- main.lua: Implementation of tsoding's exploration of 3D graphics formula.
-- see https://github.com/tsoding/formula/
-- date: 2025-12-29
-- author: Abhishek Mishra

-- flags
local FLAG_ENABLE_PENGER_DATASET = true
local FLAG_SHOW_POINTS = false
local FLAG_SHOW_EDGES = true

-- set background to warm dark gray
local BACKGROUND_COLOR = { 0.12, 0.1, 0.1 }
-- set foreground colour to cold off white
local FOREGROUND_COLOR = { 0.9, 0.9, 1.0 }

-- window dimensions, to be set in love.load
local game_width, game_height = nil, nil

-- depth variable for animation
local dz = 1.0

-- angle of rotation around Y-axis for animation
local angle = 0.0

-- vertices
local vs = {
    -- face in front of viewer
    { x = 0.25,  y = 0.25,  z = 0.25 },
    { x = -0.25, y = 0.25,  z = 0.25 },
    { x = -0.25, y = -0.25, z = 0.25 },
    { x = 0.25,  y = -0.25, z = 0.25 },

    -- face behind viewer
    { x = 0.25,  y = 0.25,  z = -0.25 },
    { x = -0.25, y = 0.25,  z = -0.25 },
    { x = -0.25, y = -0.25, z = -0.25 },
    { x = 0.25,  y = -0.25, z = -0.25 },
}

-- faces
local fs = {
    { 1, 2, 3, 4 }, -- front face
    { 5, 6, 7, 8 }, -- back face
    { 1, 5 },       -- top-right edge
    { 2, 6 },       -- top-left edge
    { 3, 7 },       -- bottom-left edge
    { 4, 8 },       -- bottom-right edge
}

if FLAG_ENABLE_PENGER_DATASET then
    -- replace with penger module dataset
    local penger = require("penger")
    vs = penger.vertices
    fs = penger.faces
end

--- clear: Clears the screen with a background color
local function clear()
    love.graphics.clear(BACKGROUND_COLOR)
end

--- point: Draws a square point at p(x, y) with the foreground color
-- centered at (x, y)
local function point(p)
    local size = 5
    love.graphics.setColor(FOREGROUND_COLOR)
    love.graphics.rectangle("fill", p.x - size / 2, p.y - size / 2, size, size)
end

--- screen: Transforms normalized coordinates to screen coordinates
-- normalized coordinates are in range [-1, 1]
local function screen(p)
    local x = (p.x + 1) * 0.5 * game_width
    local y = (1 - (p.y + 1) * 0.5) * game_height
    return { x = x, y = y }
end

--- project: Projects a 3D point p(x, y, z) to our 2D normalized coordinates
local function project(p)
    return {
        x = p.x / p.z,
        y = p.y / p.z
    }
end

--- translate_z: Translates a point p(x, y, z) along the z-axis by delta_z
local function translate_z(p, delta_z)
    return {
        x = p.x,
        y = p.y,
        z = p.z + delta_z
    }
end

--- rotate_xz: Rotates a point p(x, y, z) around the Y-axis by angle_r (in radians)
local function rotate_xz(p, angle_r)
    local cos_a = math.cos(angle_r)
    local sin_a = math.sin(angle_r)
    return {
        x = p.x * cos_a - p.z * sin_a,
        y = p.y,
        z = p.x * sin_a + p.z * cos_a
    }
end

--- line: Draws a line between two 2D points p1 and p2
local function line(p1, p2)
    love.graphics.setColor(FOREGROUND_COLOR)
    love.graphics.line(p1.x, p1.y, p2.x, p2.y)
end

--- love.load: Called once at the start of the simulation
function love.load()
    game_width, game_height = love.graphics.getDimensions()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    -- move forward along z-axis at 1 unit per second
    -- dz = dz + (dt * 1.0)

    -- rotate around y-axis
    angle = angle + (dt * math.pi / 2)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    clear()

    --iterate over vertices to draw the points
    if FLAG_SHOW_POINTS then
        for _, v in ipairs(vs) do
            point(screen(project(translate_z(rotate_xz(v, angle), dz))))
        end
    end

    -- iterate over faces to draw the lines
    if FLAG_SHOW_EDGES then
        for _, f in ipairs(fs) do
            -- iterate over vertices of the face to get the edges
            for i = 1, #f do
                local a = vs[f[i]]
                local b = vs[f[(i % #f) + 1]]
                line(
                    screen(project(translate_z(rotate_xz(a, angle), dz))),
                    screen(project(translate_z(rotate_xz(b, angle), dz)))
                )
            end
        end
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
