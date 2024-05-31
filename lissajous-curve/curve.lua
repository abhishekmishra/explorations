local Class = require('middleclass')
local nl = require('ne0luv')

local Curve = Class('Curve', nl.Panel)

function Curve:initialize(config)
    nl.Panel.initialize(self, nl.Rect(0, 0, config.w, config.h))
    self.A = config.A
    self.B = config.B
    self.a = config.a
    self.b = config.b
    self.delta = config.delta
    self.NUM = config.NUM
    self.points = {}
    self.totalTime = 0
end

function Curve:update(dt)
    self.totalTime = self.totalTime + dt
    if self.totalTime > 2 * math.pi then
        self.totalTime = 0
    end
    self.points = {}
    for i = self.NUM, 1, -1 do
        local t = self.totalTime + (i * 0.03)
        local x = self.A * math.sin(self.a * t + self.delta) + self:getWidth() / 2
        local y = self.B * math.sin(self.b * t) + self:getHeight() / 2
        table.insert(self.points, x)
        table.insert(self.points, y)
    end
end

function Curve:draw()
    love.graphics.push()
    love.graphics.translate(self:getX(), self:getY())
    -- draw a curve using the points as argument to love.graphics.points function
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(self.points)
    love.graphics.pop()
end

return Curve