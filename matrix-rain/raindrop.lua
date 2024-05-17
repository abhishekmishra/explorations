local Class = require 'middleclass'

local RainDrop = Class('RainDrop')

function RainDrop:initialize(config)
    self.x = config.x
    self.y = config.y
    self.w = config.w
    self.h = config.h
    self.vx = config.vx
    self.vy = config.vy
end


function RainDrop:update(dt)
    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)
end


function RainDrop:draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end


function RainDrop:inFrame(cw, ch)
    return self.x <= cw and self.y <= ch
end


return RainDrop
