--- renderingpanel.lua - The Rendering Panel for the raycasting simulation.
-- It will render the scene in 3D based on the raycasting system.
--
-- date: 1/5/2024
-- author: Abhishek Mishra

local Class = require('middleclass')

local nl = require('ne0luv')
local utils = require('utils')

--- A Rendering panel class
local RenderingPanel = Class('RenderingPanel', nl.Panel)

--- Constructor for the Rendering panel
function RenderingPanel:initialize(raycastingSystem, x, y, w, h)
    -- call the parent class constructor
    nl.Panel.initialize(self, nl.Rect(x, y, w, h))

    -- create the raycasting system
    self.raycastingSystem = raycastingSystem
end

--- Override the draw method to draw the 3D scene
function RenderingPanel:draw()
    -- -- fill background with red
    -- love.graphics.setColor(1, 0, 0)
    -- love.graphics.rectangle('fill', self:getX(), self:getY(), self:getWidth(), self:getHeight())

    local scene = self.raycastingSystem.particle.scene
    local w = self:getWidth() / #scene

    -- find the maximum distance in the scene
    local maxDistance = 0
    for _, d in ipairs(scene) do
        if d > maxDistance then
            maxDistance = d
        end
    end

    love.graphics.push()

    -- for each distance in the scene draw a vertical rectangle, with the
    -- colour of the rectangle based on the distance. the further the distance
    -- the darker the colour
    for i, d in ipairs(scene) do
        local c = 1.0 - utils.mapRange(d, 0, maxDistance, 0, 1.0)
        love.graphics.setColor(c, c, c)
        love.graphics.rectangle('fill', self:getX() + i * w, self:getY() + self:getHeight() / 2 - d / 2, w, d)
    end

    love.graphics.pop()
end

return RenderingPanel