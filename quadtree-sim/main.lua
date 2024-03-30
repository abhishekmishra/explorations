--- main.lua: QuadTree Simulation in LÖVE
-- date: 30/3/2024
-- author: Abhishek Mishra

local nl = require('ne0luv')
local Point = nl.Vector

-- require the QuadTree module
local q = require('quadtree')
local QuadTree = q.QuadTree
local Rectangle = q.Rectangle

--- love.load: Called once at the start of the simulation
function love.load()
    local boundary = Rectangle(200, 200, 200, 200)
    local qt = QuadTree(boundary, 4)

    for i = 1, 100 do
        local p = Point(math.random(0, love.graphics.getWidth()),
            math.random(0, love.graphics.getHeight()))
        qt:insert(p)
    end
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
