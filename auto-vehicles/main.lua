local Class = require 'middleclass'
local Vehicle = require 'vehicle'
local Target = require 'target'
local Vector = require 'vector'

function mapConstrain(value, start1, stop1, start2, stop2)
    local n = start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
    return math.max(math.min(n, math.max(start2, stop2)), math.min(start2, stop2))
end

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
        fleeDistance = fleeDistance or 1000
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

--- CanPursue mixin allows the vehicle to pursue another
-- vechicle.
-- Note: needs the CanSeek mixin
CanPursue = {
    pursue = function(self, targetVehicle)
        local predictedPosition = targetVehicle.position + (targetVehicle.velocity * 5)
        return self:seek(predictedPosition)
    end
}

--- CanEvade mixin allows the vehicle to evade another
-- vechicle.
-- Note: needs the CanFlee mixin
CanEvade = {
    evade = function(self, targetVehicle)
        local predictedPosition = targetVehicle.position + (targetVehicle.velocity * 5)
        return self:flee(predictedPosition)
    end
}

CanArrive = {
    arrive = function(self, target)
        local slowRadius = 100
        local desired = target - self.position
        local distance = desired:mag()
        if distance < slowRadius then
            local desiredSpeed = mapConstrain(distance, 0, slowRadius, 0, self.maxSpeed)
            desired:setMag(desiredSpeed)
        else
            desired:setMag(self.maxSpeed)
        end
        local steer = desired - self.velocity
        steer = steer:limit(self.maxForce)
        return steer
    end
}

-- Create a simple Seeker based on the Vehicle
-- and the CanSeek mixin
local Seeker = Class("Seeker", Vehicle)
Seeker:include(CanSeek)

-- A Runner which flees from a target
local Runner = Class("Runner", Vehicle)
Runner:include(CanFlee)

local Hunter = Class("Hunter", Seeker)
Hunter:include(CanPursue)

local Prey = Class("Prey", Runner)
Prey:include(CanEvade)

local Arriver = Class("Arriver", Vehicle)
Arriver:include(CanArrive)

-- vehicle and target
local v
local target

function love.load()
    -- v = Seeker(50, 50)
    -- v = Runner(170, 170)
    -- v = Hunter(50, 50)
    -- v = Prey(50, 50)
    v = Arriver(10, 10)
    target = Target(200, 200)
    -- target.velocity = Vector(math.random(-50, 50), math.random(-50, 50))
end

function love.update(dt)
    -- local steering = v:seek(target.position)
    -- local steering = v:flee(target, 100)
    -- local steering = v:pursue(target)
    -- local steering = v:evade(target)
    local steering = v:arrive(target.position)
    v:applyForce(steering)
    v:update(dt)
    target:update(dt)
end

function love.draw()
    target:draw()
    v:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
