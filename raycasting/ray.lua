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
    -- set the line width
    love.graphics.setLineWidth(0.1)
    love.graphics.translate(self.pos.x, self.pos.y)
    love.graphics.line(0, 0, self.dir.x * 10, self.dir.y * 10)

    love.graphics.pop()
end

--- Look at the given point
-- @param x (number) - x-coordinate of the point
-- @param y (number) - y-coordinate of the point
function Ray:lookAt(x, y)
    self.dir.x = x - self.pos.x
    self.dir.y = y - self.pos.y
    self.dir:normalize()
end

--- Cast the ray
-- @param wall (Boundary) - wall to cast the ray against
function Ray:cast(wall)
    -- points of the wall
    local x1 = wall.a.x
    local y1 = wall.a.y
    local x2 = wall.b.x
    local y2 = wall.b.y

    -- points of the ray
    local x3 = self.pos.x
    local y3 = self.pos.y
    local x4 = self.pos.x + self.dir.x
    local y4 = self.pos.y + self.dir.y

    -- calculate the denominator
    local den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

    -- if the denominator is zero, the lines are parallel
    if den == 0 then
        return false
    end

    -- calculate the numerator
    local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
    local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den

    -- if the intersection point is within the bounds of the wall
    if t > 0 and t < 1 and u > 0 then
        -- calculate the intersection point
        local x = x1 + t * (x2 - x1)
        local y = y1 + t * (y2 - y1)

        -- return the intersection point as a vector
        return nl.Vector(x, y)
    end
end

return Ray