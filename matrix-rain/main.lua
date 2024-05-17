--- main.lua: Matrix Rain Simulation in LÖVE
-- date: 16/05/2024
-- author: Abhishek Mishra

local RainSheet = require 'rainsheet'


local cw, ch

local sheet


function love.load()
    cw, ch = love.graphics.getDimensions()
    sheet = RainSheet({
        numRows = 50,
        numCols = 50,
        maxVy = 250,
        cw = cw,
        ch = ch
    })
end



function love.update(dt)
    sheet:update(dt)
end



function love.draw()
    sheet:draw()
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

