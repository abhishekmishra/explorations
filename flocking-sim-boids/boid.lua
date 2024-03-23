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
    self.velocity = Vector.random2D()
    -- get random value in range 0.5 to 1.5
    local m = math.random(20, 40)/10
    self.velocity:setMag(m)
    self.acceleration = Vector(0, 0)
    self.maxSpeed = 4
    self.maxForce = 0.2
end

--- check if the boid is within the screen
-- and wrap around if it goes out of bounds
function Boid:edges()
    if self.position.x > love.graphics.getWidth() then
        self.position.x = 0
    elseif self.position.x < 0 then
        self.position.x = love.graphics.getWidth()
    end
    if self.position.y > love.graphics.getHeight() then
        self.position.y = 0
    elseif self.position.y < 0 then
        self.position.y = love.graphics.getHeight()
    end
end

--- flock the boid with the other boids
-- @param boids the list of boids
function Boid:flock(boids)
    local alignment = self:align(boids)
    local cohesion = Vector(0, 0) --self:cohesion(boids)
    local separation = Vector(0, 0) --self:separation(boids)
    self.acceleration = alignment + cohesion + separation
end

--- align the boid with the other boids
-- @param boids the list of boids
-- @return the alignment force
function Boid:align(boids)
    local perceptionRadius = 50
    local steering = Vector(0, 0)
    local total = 0
    for _, boid in ipairs(boids) do
        local distance = self.position:dist(boid.position)
        if distance > 0 and distance < perceptionRadius then
            steering = steering + boid.velocity
            total = total + 1
        end
    end
    if total > 0 then
        steering = steering / total
        steering:setMag(self.maxSpeed)
        steering = steering - self.velocity
        steering:limit(self.maxForce)
    end
    return steering
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