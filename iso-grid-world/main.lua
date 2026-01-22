--- main.lua: Isometric Grid World Simulation in LÖVE
-- date: 4/3/2024
-- author: Abhishek Mishra

-- Pixel art for isometric grids relies on diagonal lines which go 2 pixels
-- across and 1 pixel down for clarity and crisp lines. This gives us an angle
-- at the bottom of the isometric cube which is not the ideal 30 degrees used
-- in isometric grids.
--
--      /\
--     /  \
--    |    |
--    |    |
--     \  /
--      \/ ) theta
-- ---------------
--
-- tan(theta) = 1/2
-- theta = arctan(1/2) ~= 26.565 degrees
-- interior bottom angle of the hexagon = 180 - 2*theta ~= 126.87 degrees

-- isometric theta constant in degrees and radians
local ISO_THETA = 26.565
local T = math.rad(ISO_THETA)

-- our isometric grid unit vectors
-- x is top-left to bottom-right
-- y is bottom-left to top-right
local UNIT_VX = { x = math.cos(T), y = math.sin(T) }
local UNIT_VY = { x = -math.cos(T), y = math.sin(T) }

local function vec2_scale(v, c)
    return {
        x = v.x * c,
        y = v.y * c
    }
end

local function vec2_add(v1, v2)
    return {
        x = v1.x + v2.x,
        y = v1.y + v2.y
    }
end

local function draw_isometric_grid(sprite_width_px, pw_px)
    -- the height of a cube in a NxN sprite is N/2
    -- 2 * gap_px * cos(theta) = sprite_width_px
    local gap_px = math.floor(sprite_width_px / (2 * math.cos(T)))
    local pw_px = pw_px or 8
    -- local orig = {x = love.graphics.getWidth(), y = love.graphics.getHeight()}
    local orig = {x = 0, y = 0}
    local vx = vec2_scale(UNIT_VX, gap_px)
    local vy = vec2_scale(UNIT_VY, gap_px)

    local max_lines = math.max(love.graphics.getWidth()/gap_px, love.graphics.getHeight()/gap_px)

    -- lets draw grid lines which connect intersection points with the formula
    -- Pij = orig + (vx * i) + (vy * j)
    -- for one set of grid lines we go from imin to imax
    -- and for another we go from jmin to jmax
    for i = 1, 2 * max_lines do
        local jmin = -100
        local jmax = 100
        local pmin = vec2_add(
                        orig,
                        vec2_add(vec2_scale(vx, i), vec2_scale(vy, jmin))
                        )
        local pmax = vec2_add(
                        orig,
                        vec2_add(vec2_scale(vx, i), vec2_scale(vy, jmax))
                        )
        love.graphics.line(pmin.x, pmin.y, pmax.x, pmax.y)
    end
    for j = -max_lines, max_lines do
        local imin = -100
        local imax = 100
        local pmin = vec2_add(
                        orig,
                        vec2_add(vec2_scale(vx, imin), vec2_scale(vy, j))
                        )
        local pmax = vec2_add(
                        orig,
                        vec2_add(vec2_scale(vx, imax), vec2_scale(vy, j))
                        )
        love.graphics.line(pmin.x, pmin.y, pmax.x, pmax.y)
    end

    -- now lets draw the intersection points themselves which are
    -- Pij = orig + (vx * i) + (vy * j)
    local fh = love.graphics.getFont():getHeight()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(r, g, b, 1.0)
    for i = 1, 2 * max_lines do
        for j = -max_lines, max_lines do
            local p = vec2_add(orig,
                                vec2_add(vec2_scale(vx, i),
                                        vec2_scale(vy, j)))
            love.graphics.rectangle('fill', p.x - pw_px/2, p.y - pw_px/2, pw_px, pw_px)
            love.graphics.print(tostring(i * gap_px) .. ', ' .. tostring(j * gap_px), p.x + pw_px, p.y - fh/2)
        end
    end
end

--- love.load: Called once at the start of the simulation
function love.load()
    local label_font = love.graphics.newFont(8)
    love.graphics.setFont(label_font)
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    love.graphics.clear(0.1, 0.1, 0.15)
    love.graphics.setColor(1, 0, 0, 0.25)
    draw_isometric_grid(128)
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
