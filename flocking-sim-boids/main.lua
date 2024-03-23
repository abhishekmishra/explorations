--- main.lua: Flocking Simulation in LÖVE using boids. Based on a video by 
-- Daniel Shiffman on the Coding Train youtube channel.
--
-- date: 23/3/2024
-- author: Abhishek Mishra

local Boid = require('boid')

local flock = {}

--- love.load: Called once at the start of the simulation
function love.load()
    for i = 1, 100 do
        table.insert(flock, Boid())
    end
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    for _, boid in ipairs(flock) do
        boid:update()
    end
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    for _, boid in ipairs(flock) do
        boid:show()
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
