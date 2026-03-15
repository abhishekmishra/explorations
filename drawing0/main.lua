local Pointer = require 'Pointer'

local pointer
local canvas
local cw, ch
local inStroke
local sx, sy

function love.load()
    cw, ch = love.graphics.getDimensions()
    canvas = love.graphics.newCanvas(cw, ch)

    love.mouse.setVisible(false)
    pointer = Pointer()

    -- init the canvas
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setCanvas()

    -- not drawing a stroke
    inStroke = false
end

function love.update(dt)
    if love.mouse.isDown(1) then
        local x, y = love.mouse.getPosition()
        love.graphics.setCanvas(canvas)
        if inStroke then
            love.graphics.line(sx, sy, x, y)
        else
            love.graphics.points(x, y)
        end
        love.graphics.setCanvas()
        inStroke = true
        sx, sy = x, y
    else
        inStroke = false
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

function love.mousepressed(x, y, button, istouch, presses)
end
