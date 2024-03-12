--- main.lua: Circle Packing Simulation in LÖVE
-- date: 12/3/2024
-- author: Abhishek Mishra

-- require the Circle class
local Circle = require 'circle'

local cw, ch
local c

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the canvas size
    cw, ch = love.graphics.getDimensions()
    -- create a circle at the center of the canvas
    c = Circle:new(cw / 2, ch / 2, 50)
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- set the background color
    love.graphics.setBackgroundColor(0, 0, 0)
    
    -- draw the circle
    c:draw()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
