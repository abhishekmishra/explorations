--- boid.lua - Boid class for the flocking simulation
--
-- date: 23/3/2024
-- author: Abhishek Mishra

local class = require('middleclass')
local Vector = require('vector')

--- Boid class
local Boid = class('Boid')

--- constructor of the Boid class with a given position
-- if no position is provided, it is random
--@param x the x position of the boid
--@param y the y position of the boid
function Boid:initialize(x, y)
    -- position is random if not provided
    x = x or math.random(0, love.graphics.getWidth())
    y = y or math.random(0, love.graphics.getHeight())
    self.position = Vector(x, y)
    self.velocity = Vector(math.random(-1, 1), math.random(-1, 1))
    self.acceleration = Vector(0, 0)
    self.maxSpeed = 2
    self.maxForce = 0.03
end

--- update the boid
function Boid:update()
    self.position = self.position + self.velocity
    self.velocity = self.velocity + self.acceleration
end

--- show the boid on the screen
function Boid:show()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', self.position.x, self.position.y, 5)
end

return Boid