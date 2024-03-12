--- main.lua: Circle Packing Simulation in LÖVE
-- date: 12/3/2024
-- author: Abhishek Mishra

-- require the Circle class
local Circle = require 'circle'

-- canvas dimensions
local cw, ch

-- list of circles
local circles = {}
local numCircles = 100

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the canvas size
    cw, ch = love.graphics.getDimensions()

    -- create some circles with random radius and center
    for i = 1, numCircles do
        local r = math.random(50)
        circles[i] = Circle:new(math.random(r, cw - r), math.random(r, ch - r), r)
    end
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- set the background color
    love.graphics.setBackgroundColor(0, 0, 0)

    -- draw the circle
    for i = 1, numCircles do
        circles[i]:draw()
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
