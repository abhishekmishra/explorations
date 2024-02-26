--- main.lua: A falling sand simulation in LÖVE
-- This is heavily based on the video by The Coding Train Coding Challenge #180:
-- Falling Sand at https://www.youtube.com/watch?v=L4u7Zy_b868
--
-- date: 26/2/2024
-- author: Abhishek Mishra

-- define square grid size
local gridW = 10

-- grid and its dimensions
local grid, gridRows, gridCols

function love.load()
    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()

    -- Number of rows/cols in the grid
    gridRows = cw / gridW
    gridCols = ch / gridW

    -- Create the grid
    grid = {}
    for x = 1, gridRows do
        grid[x] = {}
        for y = 1, gridCols do
            -- Initialize each cell with a value of 0
            grid[x][y] = 0
        end
    end
end

function love.draw()
    -- Draw the grid
    for x = 1, gridRows do
        for y = 1, gridCols do
            if grid[x][y] == 0 then
                -- Set color to black for empty cells
                love.graphics.setColor(0, 0, 0)
            else
                -- Set color to purple for filled cells
                love.graphics.setColor(128, 0, 128)
            end
            -- Draw a 1x1 rectangle for each cell
            love.graphics.rectangle("fill", (x - 1) * gridW,
                (y - 1) * gridW, gridW, gridW)

            -- Set stroke color to white
            love.graphics.setColor(255, 255, 255)
            -- Draw a rectangle with stroke, gridW x gridW
            love.graphics.rectangle("line", (x - 1) * gridW,
                (y - 1) * gridW, gridW, gridW)
        end
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end