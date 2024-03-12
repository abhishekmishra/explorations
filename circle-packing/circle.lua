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

    -- internal state variable _growing, which is true if the circle is growing
    self._growing = true
end

--- Circle:grow: Increase the radius of the circle
-- @param dr: (default 1) amount by which to increase the radius
function Circle:grow(dr)
    dr = dr or 1
    if self._growing then
        self.r = self.r + dr
    end
end

--- Circle:edges: Check if the circle is touching the edges of the canvas
-- @return: true if the circle is touching the edges, false otherwise
function Circle:edges()
    local cw, ch = love.graphics.getDimensions()
    return self.x - self.r < 0 or self.x + self.r > cw
        or self.y - self.r < 0 or self.y + self.r > ch
end

--- Circle:update: Update the state of the circle
-- @param dt: time since the last update
function Circle:update(dt)
    -- if the circle is touching the edges, stop growing
    if self:edges() then
        self._growing = false
    end
    self:grow()
end

--- Circle:draw: Draw the circle
function Circle:draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.circle("line", self.x, self.y, self.r)
end

return Circle
