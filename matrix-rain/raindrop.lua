local Class = require 'middleclass'

local RainDrop = Class('RainDrop')

function RainDrop:initialize(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end


function RainDrop:update(dt)
end


function RainDrop:draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', self.x, self.h, self.w, self.h)
end


return RainDrop
