--- main.lua: Lissajous Curves Simulation in LÖVE
-- date: 29/5/2024
-- author: Abhishek Mishra

local nl = require('ne0luv')
local Circle = require('Circle')


local cw, ch


function love.load()
    cw, ch = love.graphics.getDimensions()
end



function love.update(dt)
end



function love.draw()
    -- draw a sine curve
    local x0, y0 = 0, ch/2
    local x1, y1 = cw, ch/2
    love.graphics.line(x0, y0, x1, y1)
    local amp = 100
    local freq = 1
    local phase = 0
    local y = 0
    for x = 0, cw do
        y = y0 + amp * math.sin(2 * math.pi * freq * x / cw + phase)
        love.graphics.points(x, y)
    end
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

