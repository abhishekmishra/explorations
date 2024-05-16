# Matrix Rain Simulation

## Building and Running the Program

See the `Makefile` in the current directory to see how to build and run the
program.

# Matrix Rain Program

## Module Imports & Variables

The program uses the [`middleclass`][1] library for implementing classes.

```lua {code_id="requiredeps"}
local Class = require 'middleclass'

```

```lua {code_id="moduleglobal"}

@<requiredeps@>

local cw, ch
local numColumns = 40
local numRows = 20
local charW, charH
local chars
local columnRange

local moveRate = 2
local timeSinceLastMove = 0
```

## Initialization

```lua {code_id="loveload"}
--- love.load: Called once at the start of the simulation
function love.load()
    cw, ch = love.graphics.getDimensions()
    charW = cw / numColumns
    charH = ch / numRows
    chars = {}

    for i = 1, numRows do
        chars[i] = {}
        for j = 1, numColumns do
            chars[i][j] = {
                char = string.char(65 + i)
            }
        end
    end

    columnRange = {}
    for i = 1, numColumns do
        local colStart = math.random(1, numRows)
        local colEnd = math.random(colStart, numRows)
        columnRange[i] = {
            colStart = colStart,
            colEnd = colEnd
        }
    end
end

```

## Update the Simulation

```lua {code_id="loveupdate"}
--- love.update: Called every frame, updates the simulation
function love.update(dt)
    -- move the characters in the columns downwards by the moveRate
    -- the moveRate is the number of characters to move down in one second

    timeSinceLastMove = timeSinceLastMove + dt
    if timeSinceLastMove > 1 / moveRate then
        timeSinceLastMove = 0
        -- store the last row in a temporary variable
        local temp = {}
        for j = 1, numColumns do
            temp[j] = chars[numRows][j]
        end
        -- move all rows forward, except the last which wraps back to the first
        for i = numRows, 2, -1 do
            for j = 1, numColumns do
                chars[i][j] = chars[i - 1][j]
            end
        end
        -- for row 1, copy the values from temp
        for j = 1, numColumns do
            chars[1][j] = temp[j]
        end

        -- move the column ranges down by 1
        for i = 1, numColumns do
            columnRange[i].colStart = columnRange[i].colStart + 1
            columnRange[i].colEnd = columnRange[i].colEnd + 1
            if columnRange[i].colEnd > numRows then
                columnRange[i].colEnd = columnRange[i].colEnd - numRows
            end
            if columnRange[i].colStart > numRows then
                columnRange[i].colStart = columnRange[i].colStart - numRows
            end
        end
    end
end

```

## Draw the Simulation

```lua {code_id="lovedraw"}
--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- draw the characters
    for i = 1, numRows do
        for j = 1, numColumns do
            if i >= columnRange[j].colStart and i <= columnRange[j].colEnd then
                love.graphics.print(chars[i][j].char, (j - 1) * charW, (i - 1) * charH)
            end
        end
    end
end

```

## Handle Keyboard Events

```lua {code_id="lovekeypressed"}
-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
```


```lua {code_file="main.lua"}
--- main.lua: <Empty> Simulation in LÖVE
-- date: 4/3/2024
-- author: Abhishek Mishra

@<moduleglobal@>

@<loveload@>

@<loveupdate@>

@<lovedraw@>

@<lovekeypressed@>
```

# `conf.lua`

```lua { code_file="conf.lua" }
--- conf.lua: Config for the love2d game.
--
-- date: 4/3/2024
-- author: Abhishek Mishra

-- canvas size
local canvasWidth = 400
local canvasHeight = 400

function love.conf(t)
    -- set the window title
    t.window.title = "Matrix Rain"

    -- set the window size
    t.window.width = canvasWidth
    t.window.height = canvasHeight

    -- disable unused modules for performance
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = false

    -- enable console
    -- TODO: turning on console crashes Love2D on Windows,
    -- so it's disabled for now
    -- t.console = true
end

```
