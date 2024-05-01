--- raycastingpanel.lua - The RaycastingPanel implements a panel for the
-- raycasting simulation.
--
-- date: 1/5/2024
-- author: Abhishek Mishra

local Class = require('middleclass')

local nl = require('ne0luv')
local Boundary = require('boundary')
local Particle = require('particle')

--- A Raycasting panel class
local RaycastingPanel = Class('Raycasting', nl.Panel)

--- Constructor for the Raycasting panel
function RaycastingPanel:initialize(x, y, w, h)
    -- call the parent class constructor
    nl.Panel.initialize(self, nl.Rect(x, y, w, h))

    -- walls
    self:createWalls()

    -- particle
    self.particle = Particle(nl.Vector(self:getWidth() / 2,
        self:getHeight() / 2))

    -- particle offsets to move with noise
    self.xOffset = 0
    self.yOffset = 10000
end

function RaycastingPanel:createWalls()
    local cw = self:getWidth()
    local ch = self:getHeight()

    -- initialize the walls
    self.walls = {}

    -- create some random boundaries
    for _ = 1, 5 do
        local x1 = math.random(0, cw)
        local y1 = math.random(0, ch)
        local x2 = math.random(0, cw)
        local y2 = math.random(0, ch)
        table.insert(self.walls, Boundary(x1, y1, x2, y2))
    end

    -- add walls which form a box the size of the canvas
    table.insert(self.walls, Boundary(0, 0, cw, 0))
    table.insert(self.walls, Boundary(cw, 0,
        cw, ch))
    table.insert(self.walls, Boundary(cw, ch, 0, ch))
    table.insert(self.walls, Boundary(0, ch, 0, 0))
end

-- Panel update
function RaycastingPanel:update(dt)
    -- move the particle with noise
    local x = love.math.noise(self.xOffset) * self:getWidth()
    local y = love.math.noise(self.yOffset) * self:getHeight()
    self.particle:move(x, y)

    -- update the offsets
    self.xOffset = self.xOffset + 0.01
    self.yOffset = self.yOffset + 0.01

    -- cast the rays from the particle
    self.particle:look(self.walls)
end

--- Override the draw method to draw the rays
function RaycastingPanel:draw()
    -- draw the boundaries
    for _, wall in ipairs(self.walls) do
        wall:draw()
    end

    -- draw the particle
    self.particle:draw()
end

function RaycastingPanel:keypressed(key)
    if key == "r" then
        self:createWalls()
    end
end

return RaycastingPanel