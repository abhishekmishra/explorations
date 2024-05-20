local Class = require 'middleclass'

--- copied from https://love2d.org/wiki/HSV_color
-- Converts HSV to RGB. (input and output range: 0 - 1)
local function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end


-- fonts for the raindrop
local NORMAL_FONT
local GLOW_FONT

local GREEN_HSV = {1/3, 1, 1}

local RainDrop = Class('RainDrop')

function RainDrop:initialize(config)
    self.config = config
    self.x = config.x
    self.y = config.y
    self.w = config.w
    self.h = config.h
    self.vx = config.vx
    self.vy = config.vy
    self.color = config.color or GREEN_HSV
    self.glowColor = self.color
    self.alphabet = string.char(string.byte('a') + math.random(0, 25))

    if not NORMAL_FONT then
        NORMAL_FONT = love.graphics.newFont(math.min(self.w, self.h))
        GLOW_FONT = love.graphics.newFont(0.95 * math.min(self.w, self.h))
    end

    -- create love2d text for the alphabet
    self.text = love.graphics.newText(NORMAL_FONT, self.alphabet)
    self.glowText = love.graphics.newText(GLOW_FONT, self.alphabet)

    self.timer = 0
end


function RainDrop:update(dt)
    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)

    local timeSlot = self.timer
    local ySlot = self.y % 50
    local xSlot = self.x % 100
    self.color[3] = love.math.noise(timeSlot, ySlot, xSlot)
    self.glowColor[3] = love.math.noise(timeSlot, ySlot, xSlot)

    self.timer = self.timer + dt
    if self.timer > 100 then
        self.timer = 0
    end
end


function RainDrop:draw()
    local color_rgb = {HSV(unpack(self.color))}
    color_rgb[4] = 1
    local glowColor_rgb = {HSV(unpack(self.glowColor))}
    glowColor_rgb[4] = 0.8

    love.graphics.setColor(color_rgb)
    love.graphics.draw(self.text, self.x + self.w/2 - self.text:getWidth()/2, self.y + self.h/2 - self.text:getHeight()/2)
    love.graphics.setColor(glowColor_rgb)
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
