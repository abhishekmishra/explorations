--- main.lua: Raycasting Simulation in LÖVE
-- date: 28/4/2024
-- author: Abhishek Mishra

-- require the ne0luv library
local nl = require('ne0luv')
-- require the Boundary and Ray class
local Boundary = require('boundary')
local Ray = require('ray')
local Particle = require('particle')

-- walls
local walls

local particle

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

    -- create a particle
    particle = Particle(nl.Vector(200, 200))
end

--- love.update: Called every frame, updates the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
    -- move the particle to the mouse position
    particle:move(love.mouse.getX(), love.mouse.getY())

    -- cast the rays from the particle
    particle:look(walls)
end

--- love.draw: Called every frame, draws the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
    -- draw the boundaries
    for _, wall in ipairs(walls) do
        wall:draw()
    end

    -- draw the particle
    particle:draw()

    -- -- cast the ray against the walls
    -- for _, wall in ipairs(walls) do
    --     local pt = ray:cast(wall)
    --     if pt then
    --         love.graphics.setColor(255, 0, 0)
    --         love.graphics.circle('fill', pt.x, pt.y, 5)
    --     end
    -- end
end

-- escape to exit
---@diagnostic disable-next-line: duplicate-set-field
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

-- -- mouse movement to change ray angle
-- ---@diagnostic disable-next-line: duplicate-set-field
-- function love.mousemoved(x, y, dx, dy)
--     ray:lookAt(x, y)
-- end
