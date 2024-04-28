--- main.lua: Raycasting Simulation in LÖVE
-- date: 28/4/2024
-- author: Abhishek Mishra

-- set the random seed to the current time
math.randomseed(os.time())

-- require the ne0luv library
local nl = require('ne0luv')
-- require the Boundary and Ray class
local Boundary = require('boundary')
local Ray = require('ray')
local Particle = require('particle')

-- walls
local walls

-- particle
local particle

-- particle offsets to move with noise
local xOffset = 0
local yOffset = 10000

--- love.load: Called once at the start of the simulation
function love.load()
    walls = {}

    -- create on vertical wall for now
    -- table.insert(walls, Boundary(300, 100, 300, 300))

    -- create some random boundaries
    for i = 1, 5 do
        local x1 = math.random(0, 400)
        local y1 = math.random(0, 400)
        local x2 = math.random(0, 400)
        local y2 = math.random(0, 400)
        table.insert(walls, Boundary(x1, y1, x2, y2))
    end

    -- add walls which form a box the size of the canvas
    table.insert(walls, Boundary(0, 0, love.graphics.getWidth(), 0))
    table.insert(walls, Boundary(love.graphics.getWidth(), 0,
        love.graphics.getWidth(), love.graphics.getHeight()))
    table.insert(walls, Boundary(love.graphics.getWidth(),
        love.graphics.getHeight(), 0, love.graphics.getHeight()))
    table.insert(walls, Boundary(0, love.graphics.getHeight(), 0, 0))

    -- create a particle
    particle = Particle(nl.Vector(200, 200))
end

--- love.update: Called every frame, updates the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
    -- move the particle with noise
    local x = love.math.noise(xOffset) * love.graphics.getWidth()
    local y = love.math.noise(yOffset) * love.graphics.getHeight()
    particle:move(x, y)

    -- update the offsets
    xOffset = xOffset + 0.01
    yOffset = yOffset + 0.01

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
