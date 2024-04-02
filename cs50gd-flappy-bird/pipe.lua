--- pipe.lua - implements the Pipe class for the Flappy Bird game (based on the
-- Pipe class from episode 01 in GD50 course by Colton Ogden)
--
-- date: 02/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

-- The Pipe Image
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- The Pipe Speed (only on the x-axis)
local PIPE_SPEED = 60

-- The Pipe class
local Pipe = Class('Pipe')

-- The Pipe constructor
function Pipe:initialize(orientation, y)
    -- The x position of the pipe, just outside the right edge of the screen
    self.x = VIRTUAL_WIDTH

    -- The y position of the pipe
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)

    -- Dimensions the pipe
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_IMAGE:getHeight()
end

-- Update the pipe
function Pipe:update(dt)
    -- Update the pipe position on the x-axis based on the speed
    self.x = self.x - PIPE_SPEED * dt
end

-- Draw the pipe
function Pipe:draw()
    -- just draw the pipe image at the x and y position
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end

return Pipe