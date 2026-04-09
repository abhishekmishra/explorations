local Class = require 'middleclass'
local Vehicle = require 'vehicle'
local Vector = require 'vector'

--- CanSeek mixin adds functionality to move the
-- vehicle towards a target.
CanSeek = {
    seek = function(self, target)
        local desired = target - self.position
        desired:setMag(self.maxSpeed)
        local steer = desired - self.velocity
        steer = steer:limit(self.maxForce)
        self:applyForce(steer)
    end
}

--- CanFlee mixin adds functionality to move the vehicle
-- away from the target.
CanFlee = {
    flee = function(self, target)
        local desired = self.position - target
        desired:setMag(self.maxSpeed)
        local steer = desired - self.velocity
        steer = steer:limit(self.maxForce)
        self:applyForce(steer)
    end
}

-- Create a simple Seeker based on the Vehicle
-- and the CanSeek mixin
local Seeker = Class("Seeker", Vehicle)
Seeker:include(CanSeek)

-- A Runner which flees from a target
local Runner = Class("Runner", Vehicle)
Runner:include(CanFlee)

-- vehicle and target
local v
local target

function love.load()
    -- v = Seeker(50, 50)
    v = Runner(190, 190)
    target = Vector(200, 200)
end

function love.update(dt)
    -- v:seek(target)
    v:flee(target)
    v:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.circle("fill", target.x, target.y, 10)
    v:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
