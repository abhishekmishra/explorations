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
        return steer
    end
}

--- CanFlee mixin adds functionality to move the vehicle
-- away from the target.
CanFlee = {
    flee = function(self, target, fleeDistance)
        local desired = target - self.position
        if desired:mag() < fleeDistance then
            desired:setMag(self.maxSpeed)
            local steer = self.velocity - desired
            steer = steer:limit(self.maxForce)
            return steer
        end
        return Vector(0, 0)
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
    v = Seeker(50, 50)
    -- v = Runner(170, 170)
    target = Vector(200, 200)
end

function love.update(dt)
    local steering = v:seek(target)
    -- local steering = v:flee(target, 100)
    v:applyForce(steering)
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
