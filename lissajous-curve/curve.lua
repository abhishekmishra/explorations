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
    for i = self.NUM, 1, -1 do
        local t = i * 0.03
        local x = self.A * math.sin(self.a * t + self.delta)
        local y = self.B * math.sin(self.b * t)
        table.insert(self.points, x)
        table.insert(self.points, y)
    end
    self.totalTime = 0
    self.speed = .01
    self.currentIndex = 1
    self.currentPoint = {self.points[1], self.points[2]}
end

function Curve:update(dt)
    self.totalTime = self.totalTime + dt
    if self.totalTime > self.speed then
        self.totalTime = 0
        self.currentIndex = self.currentIndex + 2
        if self.currentIndex > #self.points/2 then
            self.currentIndex = 1
        end
        self.currentPoint = {self.points[self.currentIndex], self.points[self.currentIndex + 1]}
    end

    -- self.points = {}
    -- for i = self.NUM, 1, -1 do
    --     local t = self.totalTime + (i * 0.03)
    --     local x = self.A * math.sin(self.a * t + self.delta)
    --     local y = self.B * math.sin(self.b * t)
    --     table.insert(self.points, x)
    --     table.insert(self.points, y)
    -- end
end

function Curve:draw()
    love.graphics.push()
    love.graphics.translate(
        self:getX() + self:getWidth() / 2,
        self:getY() + self:getHeight() / 2
    )
    -- draw a curve using the points as argument to love.graphics.points function
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(self.points)

    -- draw a point at the current point
    love.graphics.setColor(1, 0, 1, 0.9)
    love.graphics.circle('fill', self.currentPoint[1], self.currentPoint[2], 4)
    love.graphics.pop()
end

return Curve
