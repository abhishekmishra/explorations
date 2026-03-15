local Pointer = require 'Pointer'

local pointer
local canvas
local cw, ch

local brush = {
    size = 20,
    spacing = 0.25, -- fraction of brush size
}

local stroke = {
    drawing = false,
    last_x = 0,
    last_y = 0,
    remainder = 0
}


local function stamp(x, y)
    love.graphics.setCanvas(canvas)
    love.graphics.circle("fill", x, y, brush.size / 2)
    love.graphics.setCanvas()
end


local function draw_segment(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dist = math.sqrt(dx * dx + dy * dy)

    local spacing = brush.size * brush.spacing

    local d = stroke.remainder

    while d <= dist do
        local t = d / dist

        local x = x1 + dx * t
        local y = y1 + dy * t

        stamp(x, y)

        d = d + spacing
    end

    stroke.remainder = d - dist
end


function love.load()
    cw, ch = love.graphics.getDimensions()
    canvas = love.graphics.newCanvas(cw, ch)

    love.mouse.setVisible(false)
    pointer = Pointer()

    -- init the canvas
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setCanvas()
end

function love.update(dt)
    if stroke.drawing then
        local x, y = love.mouse.getPosition()

        draw_segment(stroke.last_x, stroke.last_y, x, y)

        stroke.last_x = x
        stroke.last_y = y
    end
end

function love.draw()
    love.graphics.draw(canvas, 0, 0)

    pointer:draw()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, b)
    if b == 1 then
        stroke.drawing = true
        stroke.last_x = x
        stroke.last_y = y
        stroke.remainder = 0

        stamp(x, y)
    end
end

function love.mousereleased(x, y, b)
    if b == 1 then
        stroke.drawing = false
    end
end
