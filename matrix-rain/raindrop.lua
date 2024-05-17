local Class = require 'middleclass'

local RainDrop = Class('RainDrop')

function RainDrop:initialize(x, y, w, h, vx, vy)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.vx = vx
    self.vy = vy
end


function RainDrop:update(dt)
    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)
end


function RainDrop:draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end


function RainDrop:inFrame(cw, ch)
    return self.x <= cw and self.y <= ch
end


return RainDrop
