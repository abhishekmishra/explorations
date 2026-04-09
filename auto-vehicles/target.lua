local Class = require 'middleclass'
local Vehicle = require 'vehicle'


local Target = Class("Target", Vehicle)

function Target:initialize(x, y)
    Vehicle.initialize(self, x, y)
    self.r = 10
end

function Target:draw()
    love.graphics.push()

    local angle = self.velocity:heading()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.rotate(angle)

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle("line", 0, 0, self.r)

    local extend = mapConstrain(self.velocity:mag(), 0, 100, 1.5, 2.5)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.line(-self.r, 0, self.r * extend, 0)

    love.graphics.pop()
end

return Target
