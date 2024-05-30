
local Class = require('middleclass')
local nl = require('ne0luv')

local Circle = Class('Circle', nl.Panel)

function Circle:initialize(radius, phase)
    nl.Panel.initialize(self, nl.Rect(0, 0, radius * 2, radius * 2))
    self.radius = radius
    self.phase = phase
end


function Circle:update(dt)
end


function Circle:draw()
    love.graphics.push()
    love.graphics.translate(self:getX(), self:getY())
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.radius, self.radius, self.radius)
    love.graphics.pop()
end


return Circle
