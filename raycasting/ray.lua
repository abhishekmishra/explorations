--- ray.lua - Ray class for raycasting simulation
--
-- date: 28/4/2024
-- author: Abhishek Mishra

local Class = require('middleclass')
local nl = require('ne0luv')

--- Ray class
local Ray = Class('Ray')

--- Constructor for Ray class
-- @param pos (Vector) - position of the ray
-- @param angle (number) - angle of the ray
function Ray:initialize(pos, angle)
    -- position of the ray
    self.pos = pos
    -- direction of the ray
    self.dir = nl.Vector(math.cos(angle), math.sin(angle))
end

--- Draw the ray
function Ray:draw()
    love.graphics.push()

    -- set the line color
    love.graphics.setColor(255, 255, 128)
    love.graphics.translate(self.pos.x, self.pos.y)
    love.graphics.line(0, 0, self.dir.x * 10, self.dir.y * 10)

    love.graphics.pop()
end

return Ray