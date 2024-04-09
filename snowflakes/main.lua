--- main.lua: Snowflakes Simulation in LÖVE
-- date: 09/04/2024
-- author: Abhishek Mishra

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

for y = 0, tilesPerColumn - 1 do
    for x = 0, tilesPerRow - 1 do
        -- Calculate the position of the tile in the sprite sheet
        local quad = love.graphics.newQuad(x * tileWidth, y * tileHeight,
            tileWidth, tileHeight, spriteSheet:getDimensions())
        table.insert(quads, quad)
    end
end

-- Now you can draw a specific tile like this:
-- love.graphics.draw(spriteSheet, quads[tileIndex])

--- love.load: Called once at the start of the simulation
function love.load()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- Draw the sprite sheet
    love.graphics.draw(spriteSheet, quads[1], 0, 0)
    love.graphics.draw(spriteSheet, quads[2], 10, 0)
    love.graphics.draw(spriteSheet, quads[3], 20, 0)
    love.graphics.draw(spriteSheet, quads[4], 30, 0)
    love.graphics.draw(spriteSheet, quads[5], 40, 0)
    love.graphics.draw(spriteSheet, quads[6], 50, 0)
    love.graphics.draw(spriteSheet, quads[7], 0, 10)
    love.graphics.draw(spriteSheet, quads[8], 10, 10)
    love.graphics.draw(spriteSheet, quads[9], 20, 10)
    love.graphics.draw(spriteSheet, quads[10], 30, 10)
    love.graphics.draw(spriteSheet, quads[11], 40, 10)
    love.graphics.draw(spriteSheet, quads[12], 50, 10)
    love.graphics.draw(spriteSheet, quads[13], 0, 20)
    love.graphics.draw(spriteSheet, quads[14], 10, 20)
    love.graphics.draw(spriteSheet, quads[15], 20, 20)
    love.graphics.draw(spriteSheet, quads[16], 30, 20)
    love.graphics.draw(spriteSheet, quads[17], 40, 20)
    love.graphics.draw(spriteSheet, quads[18], 50, 20)
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
