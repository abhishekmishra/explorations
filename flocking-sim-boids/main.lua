--- main.lua: Flocking Simulation in LÖVE using boids. Based on a video by 
-- Daniel Shiffman on the Coding Train youtube channel.
--
-- date: 23/3/2024
-- author: Abhishek Mishra

--- love.load: Called once at the start of the simulation
function love.load()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
