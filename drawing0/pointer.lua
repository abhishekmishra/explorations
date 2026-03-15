local Class = require 'lib.middleclass'

local Pointer = Class('Pointer')

function Pointer:initialize(size, color, type)
    self.size = size or 8
    self.color = color or { r = 1, g = 0, b = 0, a = 1 }
    self.type = type or 'crosshair'
end

function Pointer:update(dt)
end

function Pointer:draw()
    local x, y = love.mouse.getPosition()
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.setLineWidth(1)
    love.graphics.line(self.size / 2, 0, self.size / 2, self.size)
    love.graphics.line(0, self.size / 2, self.size, self.size / 2)
    love.graphics.pop()
end

return Pointer
