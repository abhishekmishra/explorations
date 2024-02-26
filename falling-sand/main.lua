--- main.lua: A falling sand simulation in LÖVE
-- This is heavily based on the video by The Coding Train Coding Challenge #180:
-- Falling Sand at https://www.youtube.com/watch?v=L4u7Zy_b868
--
-- Here's how this works:
-- * When the user clicks and drags the mouse, the cells under the mouse are
--  filled with sand.
-- * The sand starts falling down.
-- * If the cell below is empty, the sand falls down.
-- * If the cell below is filled, the sand falls to the left or right
--  with a 50% probability.
-- * If there is no space to fall, the sand stays in place.
--
-- date: 26/2/2024
-- author: Abhishek Mishra

-- define square grid size
local gridW = 10

-- grid and its dimensions
local grid, nextGrid, gridRows, gridCols

-- dragging flag
local dragging = false

-- colour hue value
local hue = 0

-- seed the random number generator
math.randomseed(os.time())

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
end

--- love.update: Called every frame, updates the simulation
function love.update()
    -- Create a new grid
    nextGrid = createGrid(gridCols, gridRows)

    -- If dragging, fill the cell under the mouse
    if dragging then
        local mouseCol, mouseRow = love.mouse.getPosition()
        mouseCol = math.floor(mouseCol / gridW) + 1
        mouseRow = math.floor(mouseRow / gridW) + 1

        -- lets have the mouse drag drow sand in a 5x5 matrix
        -- but each cell in the matrix has 75% chance of being filled
        local matrix = 3
        local extent = math.floor(matrix / 2)
        for x = -extent, extent do
            for y = -extent, extent do
                -- ensure the cell is within the grid
                if mouseCol + x <= gridCols and mouseRow + y <= gridRows
                    and mouseCol + x > 0 and mouseRow + x > 0 then
                    -- fill the cell with 75% probability
                    if math.random() > 0.25 then
                        nextGrid[mouseCol + x][mouseRow + y] = hue
                    end
                end
            end
        end
    end

    -- Loop through the grid
    for x = 1, gridCols do
        for y = 1, gridRows do
            local state = grid[x][y]

            -- If the cell is filled
            if state > 0 then
                local below = grid[x][y + 1]

                local belowA, belowB

                -- choose a random direction, a value either -1 or 1
                local direction = (math.random(0, 1) - 0.5) * 2

                -- we have belowA direction available only if x + direction is
                -- within the grid
                if x + direction > 0 and x + direction <= gridCols then
                    belowA = grid[x + direction][y + 1]
                end

                -- we have belowB direction available only if x - direction is
                -- within the grid
                if x - direction > 0 and x - direction <= gridCols then
                    belowB = grid[x - direction][y + 1]
                end

                -- If the cell below is empty
                if below == 0 then
                    -- Move the cell down
                    nextGrid[x][y + 1] = state
                    nextGrid[x][y] = 0
                elseif belowA == 0 then
                    -- Move the cell down and to the A direction
                    nextGrid[x + direction][y + 1] = state
                elseif belowB == 0 then
                    -- Move the cell down and to the B direction
                    nextGrid[x - direction][y + 1] = state
                else
                    nextGrid[x][y] = state
                end
            end
        end
    end

    -- Update the grid
    grid = nextGrid

    -- increment the hue value
    hue = (hue + 1) % 360
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- fill the background with black
    love.graphics.setBackgroundColor(0, 0, 0)

    -- Draw the grid
    for x = 1, gridRows do
        for y = 1, gridCols do
            if grid[x][y] > 0 then
                -- Set color to purple for filled cells
                love.graphics.setColor(HSV(grid[x][y] / 360, 1, 1))
                -- Draw a 1x1 rectangle for each cell
                love.graphics.rectangle("fill", (x - 1) * gridW,
                    (y - 1) * gridW, gridW, gridW)
            end
            -- remove draing the grid for performance
            -- -- Set stroke color to white
            -- love.graphics.setColor(255, 255, 255)
            -- -- Draw a rectangle with stroke, gridW x gridW
            -- love.graphics.rectangle("line", (x - 1) * gridW,
            --     (y - 1) * gridW, gridW, gridW)
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

--- Converts HSV to RGB. (input and output range: 0 - 1)
-- see https://love2d.org/wiki/HSV_color
function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end
