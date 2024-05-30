
local Class = require('middleclass')
local nl = require('ne0luv')

local Circle = Class('Circle', nl.Panel)

function Circle:initialize(radius, phase, speed)
    nl.Panel.initialize(self, nl.Rect(0, 0, radius * 2, radius * 2))
    self.radius = radius
    self.angle = phase
    self.speed = speed or 1
end


function Circle:update(dt)
    self.angle = self.angle + (self.speed * dt)
end


function Circle:draw()
    love.graphics.push()

    love.graphics.translate(self:getX(), self:getY())
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.radius, self.radius, self.radius)

    love.graphics.translate(self.radius, self.radius)
    local x = self.radius * math.cos(self.angle)
    local y = self.radius * math.sin(self.angle)
    love.graphics.setColor(1, 0, 1)
    love.graphics.circle("fill", x, y, 5)

    love.graphics.pop()
end


return Circle
