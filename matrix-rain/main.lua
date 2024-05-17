--- main.lua: Matrix Rain Simulation in LÖVE
-- date: 16/05/2024
-- author: Abhishek Mishra

local RainDrop = require 'raindrop'


local cw, ch

local drop


function love.load()
    cw, ch = love.graphics.getDimensions()
    drop = RainDrop({
        x = cw/2-10,
        y = 0,
        w = 10,
        h = 10,
        vx = 0,
        vy = 50
    })
end



function love.update(dt)
    drop:update(dt)
end



function love.draw()
    if drop:inFrame(cw, ch) then
        drop:draw()
    end
end



-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

