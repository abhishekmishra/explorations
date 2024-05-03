--- particle.lua - Particle class for raycasting simulation
--
-- date: 28/4/2024
-- author: Abhishek Mishra

local Class = require('middleclass')
local nl = require('ne0luv')
local Ray = require('ray')

local DEFAULT_FOV = 45

--- Particle class
local Particle = Class('Particle')

--- Constructor for Particle class
-- @param pos (Vector) - position of the particle
function Particle:initialize(pos)
    -- position of the particle
    self.pos = pos

    -- particle heading
    self.heading = -math.pi / 2

    -- set the fov of the particle
    self:setFOV(DEFAULT_FOV)

    -- empty points table
    self.points = {}
end

--- Particle:rotate - Rotate the particle by the given angle
-- @param angle (number) - angle to rotate the particle by
function Particle:rotate(angle)
    self.heading = self.heading + angle
    for idx, ray in ipairs(self.rays) do
        local i = idx - self.fov/2 - 1
        ray:setAngle(math.rad(i) + self.heading)
    end
end

--- Look at the given wall
-- @param walls (table) - walls to look at
function Particle:look(walls)
    self.points = {}
    self.scene = {}
    for _, ray in ipairs(self.rays) do
        local closest = nil
        local record = math.huge
        for _, wall in ipairs(walls) do
            local pt = ray:cast(wall)
            if pt then
                local d = nl.Vector.dist(self.pos, pt)
                if d < record then
                    record = d
                    closest = pt
                end
            end
        end

        -- add the closest point to the points table
        if closest then
            table.insert(self.points, closest)
        end

        table.insert(self.scene, record)
    end
end

--- Move the particle to the given position
-- @param x (number) - x-coordinate of the position
-- @param y (number) - y-coordinate of the position
function Particle:moveTo(x, y)
    self.pos.x = x
    self.pos.y = y
    -- set ray positions
    for _, ray in ipairs(self.rays) do
        ray.pos = self.pos
    end
end

--- Get the particle position
-- @return x, y (number, number) - x and y coordinates of the particle
function Particle:getPos()
    return self.pos.x, self.pos.y
end

--- Move the particle in the direction of its heading
-- @param amount (number) - amount to move the particle by
function Particle:move(amount)
    self.velocity = nl.Vector(math.cos(self.heading), math.sin(self.heading))
    self.velocity:setMag(amount)
    self.pos = self.pos + self.velocity
    -- set ray positions
    for _, ray in ipairs(self.rays) do
        ray.pos = self.pos
    end
end

--- Set the fov of the particle
-- @param fov (number) - field of view of the particle
function Particle:setFOV(fov)
    self.fov = fov

    -- rays emanating from the particle
    self.rays = {}
    for i = -self.fov/2, self.fov/2 do
        table.insert(self.rays, Ray(self.pos, math.rad(i) + self.heading))
    end
end

--- Draw the particle
function Particle:draw()
    -- draw lines to the points
    -- line width
    love.graphics.setLineWidth(0.1)
    -- line colour with some transparency
    love.graphics.setColor(1, 1, 1, 0.3)
    for _, pt in ipairs(self.points) do
        love.graphics.line(self.pos.x, self.pos.y, pt.x, pt.y)
    end

    -- -- draw the rays
    -- for _, ray in ipairs(self.rays) do
    --     ray:draw()
    -- end

    -- set the fill color
    love.graphics.setColor(0.5, 0.1, 0.1, 0.5)

    -- draw the particle
    love.graphics.circle('fill', self.pos.x, self.pos.y, 4)
end

return Particle
