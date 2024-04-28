--- boundary.lua - Boundary class for raycasting simulation
--
-- date: 28/4/2024
-- author: Abhishek Mishra

local Class = require('middleclass')
local nl = require('ne0luv')
local Vector = nl.Vector

--- Boundary class
local Boundary = Class('Boundary')

--- Constructor for Boundary class
-- @param x1 (number) - x-coordinate of first point
-- @param y1 (number) - y-coordinate of first point
-- @param x2 (number) - x-coordinate of second point
-- @param y2 (number) - y-coordinate of second point
function Boundary:initialize(x1, y1, x2, y2)
    -- a and b are vectors representing the boundary
    self.a = Vector(x1, y1)
    self.b = Vector(x2, y2)
end

--- Draw the boundary
function Boundary:draw()
    -- set the line color
    love.graphics.setColor(255, 255, 255)
    love.graphics.line(self.a.x, self.a.y, self.b.x, self.b.y)
end

return Boundary