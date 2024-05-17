--- main.lua: Matrix Rain Simulation in LÖVE
-- date: 16/05/2024
-- author: Abhishek Mishra

local RainColumn = require 'raincolumn'


local cw, ch

local column


function love.load()
    cw, ch = love.graphics.getDimensions()
    column = RainColumn({
        x = cw/2-10,
        w = 10,
        h = ch,
        vy = 50,
        numRows = 10
    })
end



function love.update(dt)
    column:update(dt)
end



function love.draw()
    column:draw()
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

