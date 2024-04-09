--- snowflake.lua -- Snowflake class
--
-- date: 09/04/2024
-- author: Abhishek Mishra

local Class = require 'middleclass'

-- Load the sprite sheet
-- The sprite sheet contains 6 tiles in a row and 3 tiles in a column
-- Each tile is 9x9 pixels
-- The sprite sheet is available at
-- https://opengameart.org/content/pixel-art-snowflakes
-- made by https://opengameart.org/users/alxl
local spriteSheet = love.graphics.newImage("pixel_snowflakes.png")

-- Define the size of each tile
local tileWidth, tileHeight = 9, 9

-- Define the number of tiles per row and column
local tilesPerRow, tilesPerColumn = 6, 3

-- Create a table to hold the quads
local quads = {}

-- Create quads for each tile in the sprite sheet
for y = 0, tilesPerColumn - 1 do
    for x = 0, tilesPerRow - 1 do
        -- Calculate the position of the tile in the sprite sheet
        local quad = love.graphics.newQuad(x * tileWidth, y * tileHeight,
            tileWidth, tileHeight, spriteSheet:getDimensions())
        table.insert(quads, quad)
    end
end

-- Define the SnowFlake class
local SnowFlake = Class('SnowFlake')

function SnowFlake:initialize(x, y, size)
    self.origx = x
    self.origy = y
    self.x = self.origx
    self.y = self.origy
    self.size = size
    self.speed = math.random(50, 100)
    self.direction = math.random() * 2 * math.pi

    self:setParticleSystem()
end

--- SnowFlake:setParticleSystem: Set the particle system for the snowflake
function SnowFlake:setParticleSystem()
    -- use a random quad from the sprite sheet
    self.quad = quads[math.random(1, #quads)]
    self.psystem = love.graphics.newParticleSystem(spriteSheet, 32)
    self.psystem:setQuads(self.quad)

    -- particles live at least 1s and at most 5-20s
    self.psystem:setParticleLifetime(1, math.random(5, 20))

    -- set emission rate to 1 particle per second
    self.psystem:setEmissionRate(1)

    -- only emit for 1.5s which means only 1 particle will be emitted
    self.psystem:setEmitterLifetime(1.5)

    -- full size variation (1 is max)
    self.psystem:setSizeVariation(1)

    -- set linear acceleration to -20, 20 on x-axis
    -- and -10, 50 on y-axis
    -- Random movement in all directions.
    self.psystem:setLinearAcceleration(-20, -10, 20, 50)

    -- set radial acceleration to -10, 10
    -- Random acceleration towards/away the center.
    self.psystem:setRadialAcceleration(-10, 10)

    -- set spin to -2, 2
    -- Random spin.
    self.psystem:setSpin(-2, 2)

    -- set colors to white
    -- Fade to transparency.
    self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)

    -- set sizes to 1, 1.5, 1.1, 0.75, 0.25
    -- Random sizes for the snowflake.
    self.psystem:setSizes(1, 1.5, 1.1, 0.75, 0.25, 2, 3.3, 4)
end

function SnowFlake:update(dt)
    self.y = self.y + self.speed * dt
    self.x = self.x + math.sin(self.direction) * self.size * dt

    --if the x position crosses the screen boundaries, wrap it around
    if self.x < 0 then
        self.x = love.graphics.getWidth()
    elseif self.x > love.graphics.getWidth() then
        self.x = 0
    end

    -- if the snowflake is beyond the bottom of the screen, reset it to
    -- origx, origy
    if self:beyondScreen(love.graphics.getHeight()) then
        self.x = self.origx
        self.y = self.origy
        self:setParticleSystem()
    end

    self.psystem:update(dt)
end

function SnowFlake:draw()
    love.graphics.draw(self.psystem, self.x, self.y)
end

--- SnowFlake:beyondScreen: Check if the snowflake is beyond the bottom of the 
-- screen
-- @param height The height of the screen
function SnowFlake:beyondScreen(height)
    return self.y > height
end

--- SnowFlake:stop: Stop the particle system
function SnowFlake:stop()
    self.psystem:stop()
end

return SnowFlake