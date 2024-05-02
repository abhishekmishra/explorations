--- raycastingsystem.lua - The Raycasting System for the raycasting simulation.
--
-- date: 1/5/2024
-- author: Abhishek Mishra

local Class = require('middleclass')

local nl = require('ne0luv')
local Boundary = require('boundary')
local Particle = require('particle')

local RaycastingSystem = Class('RaycastingSystem')

--- Constructor for the Raycasting System
function RaycastingSystem:initialize(w, h)
    self.cw = w
    self.ch = h

    -- walls
    self:createWalls()

    -- particle
    self.particle = Particle(nl.Vector(self.cw / 2,
        self.ch / 2))

    -- particle offsets to move with noise
    self.xOffset = 0
    self.yOffset = 10000

    -- auto move flag
    self.autoMove = false
end

function RaycastingSystem:createWalls()
    -- initialize the walls
    self.walls = {}

    -- create some random boundaries
    for _ = 1, 5 do
        local x1 = math.random(0, self.cw)
        local y1 = math.random(0, self.ch)
        local x2 = math.random(0, self.cw)
        local y2 = math.random(0, self.ch)
        table.insert(self.walls, Boundary(x1, y1, x2, y2))
    end

    -- add walls which form a box the size of the canvas
    table.insert(self.walls, Boundary(0, 0, self.cw, 0))
    table.insert(self.walls, Boundary(self.cw, 0,
        self.cw, self.ch))
    table.insert(self.walls, Boundary(self.cw, self.ch, 0, self.ch))
    table.insert(self.walls, Boundary(0, self.ch, 0, 0))
end

function RaycastingSystem:update(dt)
    if self.autoMove then
        -- move the particle with noise
        local x = love.math.noise(self.xOffset) * self.cw
        local y = love.math.noise(self.yOffset) * self.ch
        self.particle:moveTo(x, y)

        -- update the offsets
        self.xOffset = self.xOffset + 0.01
        self.yOffset = self.yOffset + 0.01
    else
        -- -- move with mouse
        -- local mx, my = love.mouse.getPosition()
        -- self.particle:moveTo(mx, my)

        -- if key w is pressed, move the particle up
        if love.keyboard.isDown('w') then
            self.particle:move(1)
        end

        -- if key s is pressed, move the particle down
        if love.keyboard.isDown('s') then
            self.particle:move(-1)
        end

        -- if key a is pressed, rotate the particle
        if love.keyboard.isDown('a') then
            self:rotate(-0.01)
        end

        -- if key d is pressed, rotate the particle
        if love.keyboard.isDown('d') then
            self:rotate(0.01)
        end
    end
    -- cast the rays from the particle
    self.particle:look(self.walls)
end

function RaycastingSystem:rotate(angle)
    self.particle:rotate(angle)
end

return RaycastingSystem
