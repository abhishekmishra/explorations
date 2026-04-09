local Class = require 'middleclass'
local Vector = require 'vector'

local Vehicle = Class('Vehicle')

function Vehicle:initialize(x, y)
    self.mass = 1
    self.position = Vector(x or 0, y or 0)
    self.velocity = Vector(0, 0)
    self.acceleration = Vector(0, 0)
    self.maxForce = 1
    self.maxSpeed = 100
    self.orientation = 0
    self.r = 6
end

function Vehicle:edges()
    local width, height = love.graphics.getDimensions()
    if self.position.x > width + self.r then
        self.position.x = -self.r
    elseif self.position.x < -self.r then
        self.position.x = width + self.r
    end
    if self.position.y > height + self.r then
        self.position.y = -self.r
    elseif self.position.y < -self.r then
        self.position.y = height + self.r
    end
end

function Vehicle:update(dt)
    -- Update velocity
    self.velocity = self.velocity + self.acceleration
    -- limit speed
    self.velocity = self.velocity:limit(self.maxSpeed)
    self.position = self.position + (self.velocity * dt)
    -- reset acceleration
    self.acceleration.x = 0
    self.acceleration.y = 0

    -- apply edges
    self:edges()
end

function Vehicle:applyForce(f)
    self.acceleration = self.acceleration + (f / self.mass)
end

function Vehicle:draw()
    love.graphics.push()

    local angle = self.velocity:heading()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.rotate(angle)

    love.graphics.polygon("fill",
        self.r * 2, 0,
        -self.r * 2, -self.r,
        -self.r * 2, self.r
    )

    love.graphics.pop()
end

return Vehicle
