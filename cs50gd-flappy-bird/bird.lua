--- bird.lua - implements the Bird class for the Flappy Bird game (based on
-- the Bird class from episode 01 in GD50 course by Colton Ogden)
--
-- date: 02/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

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
end

--- Draw the bird
function Bird:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

return Bird