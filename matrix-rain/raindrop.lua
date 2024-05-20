local Class = require 'middleclass'

-- fonts for the raindrop
local NORMAL_FONT
local GLOW_FONT

local RainDrop = Class('RainDrop')

function RainDrop:initialize(config)
    self.config = config
    self.x = config.x
    self.y = config.y
    self.w = config.w
    self.h = config.h
    self.vx = config.vx
    self.vy = config.vy
    self.color = config.color or {0, 1, 0, 1}
    self.glowColor = self.color
    self.glowColor[4] = 0.8
    self.alphabet = string.char(string.byte('a') + math.random(0, 25))

    if not NORMAL_FONT then
        NORMAL_FONT = love.graphics.newFont(self.w - 4)
        GLOW_FONT = love.graphics.newFont(self.w)
    end

    -- create love2d text for the alphabet
    self.text = love.graphics.newText(NORMAL_FONT, self.alphabet)
    self.glowText = love.graphics.newText(GLOW_FONT, self.alphabet)
end


function RainDrop:update(dt)
    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)

    local timeSlot = (dt * 10) % 10
    local ySlot = self.y % 10
    self.color[4] = love.math.noise(ySlot, timeSlot)
end


function RainDrop:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.draw(self.text, self.x + self.w/2 - self.text:getWidth()/2, self.y + self.h/2 - self.text:getHeight()/2)
    love.graphics.setColor(unpack(self.glowColor))
    love.graphics.draw(self.glowText, self.x + self.w/2 - self.glowText:getWidth()/2, self.y + self.h/2 - self.glowText:getHeight()/2)
end


function RainDrop:inFrame(cw, ch)
    return self.x <= cw and self.y <= ch
end


function RainDrop:resetPosition(x, y)
    self.x = self.config.x
    self.y = self.config.y
end


function RainDrop:setAlphabet(alpha)
    self.alphabet = alpha
end


return RainDrop
