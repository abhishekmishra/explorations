--- particle.lua - Particle class for raycasting simulation
--
-- date: 28/4/2024
-- author: Abhishek Mishra

local Class = require('middleclass')
local nl = require('ne0luv')
local Ray = require('ray')

local NUM_RAYS = 90

--- Particle class
local Particle = Class('Particle')

--- Constructor for Particle class
-- @param pos (Vector) - position of the particle
function Particle:initialize(pos)
    -- position of the particle
    self.pos = pos
    -- rays emanating from the particle
    self.rays = {}
    for i = 1, NUM_RAYS, 1 do
        table.insert(self.rays, Ray(pos, math.rad(i)))
    end

    self.points = {}
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
function Particle:move(x, y)
    self.pos.x = x
    self.pos.y = y
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
