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

local cw = love.graphics.getWidth()
local ch = love.graphics.getHeight()

local function createWalls()
    walls = {}

    -- create some random boundaries
    for _ = 1, 5 do
        local x1 = math.random(0, cw)
        local y1 = math.random(0, ch)
        local x2 = math.random(0, cw)
        local y2 = math.random(0, ch)
        table.insert(walls, Boundary(x1, y1, x2, y2))
    end

    -- add walls which form a box the size of the canvas
    table.insert(walls, Boundary(0, 0, cw, 0))
    table.insert(walls, Boundary(cw, 0,
        cw, ch))
    table.insert(walls, Boundary(cw, ch, 0, ch))
    table.insert(walls, Boundary(0, ch, 0, 0))
end

--- love.load: Called once at the start of the simulation
function love.load()
    -- create the walls
    createWalls()

    -- create a particle
    particle = Particle(nl.Vector(cw/2, ch/2))
end

--- love.update: Called every frame, updates the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
    -- move the particle with noise
    local x = love.math.noise(xOffset) * cw
    local y = love.math.noise(yOffset) * ch
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
end

-- escape to exit
---@diagnostic disable-next-line: duplicate-set-field
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    -- key is 'r' to create new walls
    if key == "r" then
        createWalls()
    end
end