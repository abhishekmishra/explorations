local Class = require 'middleclass'

local RainDrop = Class('RainDrop')

function RainDrop:initialize(config)
    self.x = config.x
    self.y = config.y
    self.w = config.w
    self.h = config.h
    self.vx = config.vx
    self.vy = config.vy
    self.color = config.color or {0, 1, 0, 1}
    self.alphabet = string.char(string.byte('a') + math.random(0, 25))

    -- create love2d text for the alphabet
    self.text = love.graphics.newText(love.graphics.getFont(), self.alphabet)
end


function RainDrop:update(dt)
    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)
end


function RainDrop:draw()
    -- love.graphics.setColor(1, 0, 0, 1)
    -- love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    -- love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    -- print the text in the center of the rectangle
    love.graphics.setColor(unpack(self.color))
    love.graphics.draw(self.text, self.x + self.w/2 - self.text:getWidth()/2, self.y + self.h/2 - self.text:getHeight()/2)
end


function RainDrop:inFrame(cw, ch)
    return self.x <= cw and self.y <= ch
end


return RainDrop
