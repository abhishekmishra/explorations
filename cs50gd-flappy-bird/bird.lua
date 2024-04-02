--- bird.lua - implements the Bird class for the Flappy Bird game (based on
-- the Bird class from episode 01 in GD50 course by Colton Ogden)
--
-- date: 02/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

-- Set the gravity to an arbitrary value of 20
local GRAVITY = 20

--- The Bird class
local Bird = Class('Bird')

--- The Bird constructor
function Bird:initialize()
    -- Load the bird image
    self.image = love.graphics.newImage('bird.png')

    -- Set the width and height of the bird based on the image
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Locate the bird at the center of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Set the velocity of the bird to 0
    self.dy = 0
end

--- Update the bird
function Bird:update(dt)
    -- update the velocity (dy) using the gravity
    self.dy = self.dy + GRAVITY * dt

    -- add the velocity to position to move the bird
    self.y = self.y + self.dy
end

--- Draw the bird
function Bird:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return Bird