local Class = require 'middleclass'
local Vector = require 'vector'

local Vehicle = Class('Vehicle')

function Vehicle:initialize()
    self.mass = 0
    self.position = Vector(0, 0)
    self.velocity = Vector(0, 0)
    self.maxForce = 0
    self.maxSpeed = 0
    self.orientation = 0
end

function Vehicle:draw()
    love.graphics.push()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 100, 100, 50)

    love.graphics.pop()
end

return Vehicle
