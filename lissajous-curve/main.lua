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
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

