--- main.lua: A falling sand simulation in LÖVE
-- This is heavily based on the video by The Coding Train Coding Challenge #180:
-- Falling Sand at https://www.youtube.com/watch?v=L4u7Zy_b868
--
-- date: 26/2/2024
-- author: Abhishek Mishra

-- define square grid size
local gridW = 10

-- grid and its dimensions
local grid, nextGrid, gridRows, gridCols

-- dragging flag
local dragging = false

--- create a 2d grid, with all the cells set to 0
--
-- @param cols: number of columns
-- @param rows: number of rows
-- @return: a 2d grid
local function createGrid(cols, rows)
    local g = {}
    for x = 1, cols do
        g[x] = {}
        for y = 1, rows do
            g[x][y] = 0
        end
    end
    return g
end

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the canvas size
    local cw = love.graphics.getWidth()
    local ch = love.graphics.getHeight()

    -- Number of rows/cols in the grid
    gridRows = cw / gridW
    gridCols = ch / gridW

    -- Create the grid
    grid = createGrid(gridCols, gridRows)

    -- Set one cell to 1
    grid[math.floor(gridRows / 2)][1] = 1
end

--- love.update: Called every frame, updates the simulation
function love.update()
    -- Create a new grid
    nextGrid = createGrid(gridCols, gridRows)

    -- If dragging, fill the cell under the mouse
    if dragging then
        local x, y = love.mouse.getPosition()
        x = math.floor(x / gridW) + 1
        y = math.floor(y / gridW) + 1
        nextGrid[x][y] = 1
    end

    -- Loop through the grid
    for x = 1, gridCols do
        for y = 1, gridRows do
            local state = grid[x][y]

            -- If the cell is filled
            if state == 1 then
                local below = grid[x][y + 1]
                local belowRight = grid[x + 1][y + 1]
                local belowLeft = grid[x - 1][y + 1]

                -- If the cell below is empty
                if below == 0 then
                    -- Move the cell down
                    nextGrid[x][y + 1] = 1
                    nextGrid[x][y] = 0
                elseif belowRight == 0 then
                    -- Move the cell down and to the right
                    nextGrid[x + 1][y + 1] = 1
                elseif belowLeft == 0 then
                    -- Move the cell down and to the left
                    nextGrid[x - 1][y + 1] = 1
                else
                    nextGrid[x][y] = 1
                end
            end
        end
    end

    -- Update the grid
    grid = nextGrid
end

--- love.draw: Called every frame, draws the simulation
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

--- mouse drag to fill cells
function love.mousepressed(x, y, button)
    --- if mouse is pressed set dragging to true
    if button == 1 and dragging == false then
        dragging = true
    end
end

--- mouse release to stop filling cells
function love.mousereleased(x, y, button)
    --- if mouse is released set dragging to false
    if button == 1 and dragging == true then
        dragging = false
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end