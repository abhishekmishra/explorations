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
function RaycastingPanel:initialize(raycastingSystem, x, y, w, h)
    -- call the parent class constructor
    nl.Panel.initialize(self, nl.Rect(x, y, w, h))

    -- create the raycasting system
    self.raycastingSystem = raycastingSystem
end

--- Override the draw method to draw the rays
function RaycastingPanel:draw()
    -- draw the boundaries
    for _, wall in ipairs(self.raycastingSystem.walls) do
        wall:draw()
    end

    -- draw the particle
    self.raycastingSystem.particle:draw()
end

return RaycastingPanel
