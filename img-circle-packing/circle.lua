--- circle.lua: Circle class for the circle packing simulation
--
-- date: 12/3/2024
-- author: Abhishek Mishra

local class = require 'lib.middleclass'

Circle = class('Circle')

local DEFAULT_COLOR = { r = 0, g = 0, b = 0, a = 1.0 }

--- Circle:initialize: Constructor for the Circle class
-- @param x: x-coordinate of the center of the circle
-- @param y: y-coordinate of the center of the circle
-- @param r: radius of the circle
-- @param cr: (optional) red component of the color of the circle
-- @param cg: (optional) green component of the color of the circle
-- @param cb: (optional) blue component of the color of the circle
-- @param ca: (optional) alpha component of the color of the circle
function Circle:initialize(x, y, r, cr, cg, cb, ca)
    self.x = x
    self.y = y
    self.r = r
    if cr and cg and cb and ca then
        self.color = { r = cr, g = cg, b = cb, a = ca }
    else
        self.color = DEFAULT_COLOR
    end

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
end

--- Circle:draw: Draw the circle
function Circle:draw()
    love.graphics.setColor(self.color.r, self.color.g,
        self.color.b, self.color.a)
    love.graphics.circle("fill", self.x, self.y, self.r)
end

return Circle
