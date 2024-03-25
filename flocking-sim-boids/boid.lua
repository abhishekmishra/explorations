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
function Boid:initialize(panel, x, y)
    self.panel = panel
    -- position is random if not provided
    x = x or math.random(self.panel:getX(), self.panel:getWidth())
    y = y or math.random(self.panel:getY(), self.panel:getHeight())
    self.position = Vector(x, y)
    self.velocity = Vector.random2D()
    -- get random value in range 0.5 to 1.5
    local m = math.random(5, 15)/10
    self.velocity:setMag(m)
    self.acceleration = Vector(0, 0)
    self.maxForce = 4
    self.maxSpeed = 2
    self.perceptionRadius = 100
    self.boidWidth = 5
end

--- check if the boid is within the screen
-- and wrap around if it goes out of bounds
function Boid:edges()
    if self.position.x + self.boidWidth > self.panel:getWidth() then
        self.position.x = self.panel:getX() + self.boidWidth
    elseif self.position.x - self.boidWidth < self.panel:getX() then
        self.position.x = self.panel:getWidth() - self.boidWidth
    end
    if self.position.y + self.boidWidth > self.panel:getHeight() then
        self.position.y = self.panel:getY() + self.boidWidth
    elseif self.position.y - self.boidWidth < self.panel:getY() then
        self.position.y = self.panel:getHeight() - self.boidWidth
    end
end

--- flock the boid with the other boids
-- @param boids the list of boids
function Boid:flock(boids)
    local alignment = self:align(boids)
    local cohesion = self:cohesion(boids)
    local separation = self:separation(boids)
    self.acceleration = separation
    self.acceleration = self.acceleration + alignment
    self.acceleration = self.acceleration + cohesion
end

--- align the boid with the other boids
-- @param boids the list of boids
-- @return the alignment force
function Boid:align(boids)
    local steering = Vector(0, 0)
    local total = 0
    for _, boid in ipairs(boids) do
        local distance = self.position:dist(boid.position)
        if distance > 0 and distance < self.perceptionRadius then
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

--- cohesion of the boid with the other boids
-- @param boids the list of boids
-- @return the cohesion force
function Boid:cohesion(boids)
    local steering = Vector(0, 0)
    local total = 0
    for _, boid in ipairs(boids) do
        local distance = self.position:dist(boid.position)
        if distance > 0 and distance < self.perceptionRadius then
            steering = steering + boid.position
            total = total + 1
        end
    end
    if total > 0 then
        steering = steering / total
        steering = steering - self.position
        steering:setMag(self.maxSpeed)
        steering = steering - self.velocity
        steering:limit(self.maxForce)
    end
    return steering
end

--- separation of the boid with the other boids
-- @param boids the list of boids
-- @return the separation force
function Boid:separation(boids)
    local steering = Vector(0, 0)
    local total = 0
    for _, boid in ipairs(boids) do
        local distance = self.position:dist(boid.position)
        if distance > 0 and distance < self.perceptionRadius then
            local diff = self.position - boid.position
            diff = diff / distance
            steering = steering + diff
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
    self.velocity:limit(self.maxSpeed)
    self.position = self.position + self.velocity
    self.velocity = self.velocity + self.acceleration
    self.acceleration = self.acceleration * 0
end

--- show the boid on the screen
function Boid:show()
    -- only draw the boid if it is within the panel
    local inside = self.panel.rect:contains(self.position.x, self.position.y)
    if not inside then
        return
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', self.position.x, self.position.y, self.boidWidth-2)
end

return Boid