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

    love.graphics.translate(self:getX(), self:getY())

    -- for each distance in the scene draw a vertical rectangle, with the
    -- colour of the rectangle based on the distance. the further the distance
    -- the darker the colour
    for i, d in ipairs(scene) do
        -- calculate the colour based on the distance
        local c = 1.0 - utils.mapRange(d, 0, maxDistance, 0, 1.0)

        -- calculate the height of the rectangle based on the distance
        local rectHeight = utils.mapRange(d, 0, maxDistance, self:getHeight(), 0)

        -- set the colour and draw the rectangle
        love.graphics.setColor(c, c, c)
        love.graphics.rectangle('fill', i * w, self:getHeight()/2 - rectHeight/2, w, rectHeight)
    end

    love.graphics.pop()
end

return RenderingPanel