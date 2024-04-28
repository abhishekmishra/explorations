--- main.lua: Raycasting Simulation in LÖVE
-- date: 28/4/2024
-- author: Abhishek Mishra

-- require the ne0luv library
local nl = require('ne0luv')
-- require the Boundary and Ray class
local Boundary = require('boundary')
local Ray = require('ray')

-- walls
local walls

local ray

--- love.load: Called once at the start of the simulation
function love.load()
    walls = {}

    -- create on vertical wall for now
    table.insert(walls, Boundary(300, 100, 300, 300))

    -- create some random boundaries
    -- for i = 1, 5 do
    --     local x1 = math.random(0, 400)
    --     local y1 = math.random(0, 400)
    --     local x2 = math.random(0, 400)
    --     local y2 = math.random(0, 400)
    --     table.insert(walls, Boundary(x1, y1, x2, y2))
    -- end

    -- create a ray
    ray = Ray(nl.Vector(100, 200), 0)
end

--- love.update: Called every frame, updates the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
    -- draw the boundaries
    for _, wall in ipairs(walls) do
        wall:draw()
    end

    -- draw the ray
    ray:draw()
end

-- escape to exit
---@diagnostic disable-next-line: duplicate-set-field
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
