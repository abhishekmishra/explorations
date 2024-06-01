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
    local pointDiff = (2 * math.pi) / self.NUM
    for i = 1, self.NUM do
        local t = i * pointDiff
        local x = self.A * math.sin(self.a * t + self.delta)
        local y = self.B * math.sin(self.b * t)
        table.insert(self.points, x)
        table.insert(self.points, y)
    end
    self.totalTime = 0
    self.speed = self.NUM / 100000
    self.currentIndex = 1
    self.currentPoint = nl.Vector( self.points[1], self.points[2] )
end

function Curve:update(dt)
    self.totalTime = self.totalTime + dt
    if self.totalTime > self.speed then
        self.totalTime = 0
        self.currentIndex = self.currentIndex + 2
        if self.currentIndex > #self.points then
            self.currentIndex = 1
        end
        self.currentPoint = nl.Vector(
            self.points[self.currentIndex],
            self.points[self.currentIndex + 1]
        )
    end
end

function Curve:draw()
    love.graphics.push()
    love.graphics.translate(
        self:getX() + self:getWidth() / 2,
        self:getY() + self:getHeight() / 2
    )
    -- draw a curve using the points as argument to love.graphics.points function
    love.graphics.setColor(1, 1, 0.5, 0.8)
    love.graphics.line(self.points)

    -- draw a point at the current point
    love.graphics.setColor(1, 0, 1, 0.9)
    love.graphics.circle('fill', self.currentPoint.x, self.currentPoint.y, 4)

    -- -- print the current point index
    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.print(self.currentIndex, 0, 0)
    love.graphics.pop()
end

return Curve
