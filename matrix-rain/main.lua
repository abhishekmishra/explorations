--- main.lua: Matrix Rain Simulation in LÖVE
-- date: 16/05/2024
-- author: Abhishek Mishra

local RainDrop = require 'raindrop'


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

