--- circle.lua: Circle class for the circle packing simulation
--
-- date: 12/3/2024
-- author: Abhishek Mishra

local class = require 'lib.middleclass'

Circle = class('Circle')

--- Circle:initialize: Constructor for the Circle class
-- @param x: x-coordinate of the center of the circle
-- @param y: y-coordinate of the center of the circle
-- @param r: radius of the circle
function Circle:initialize(x, y, r)
    self.x = x
    self.y = y
    self.r = r
end

--- Circle:grow: Increase the radius of the circle
-- @param dr: (default 1) amount by which to increase the radius
function Circle:grow(dr)
    dr = dr or 1
    self.r = self.r + dr
end

--- Circle:draw: Draw the circle
function Circle:draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.circle("line", self.x, self.y, self.r)
end

return Circle