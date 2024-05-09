# Polar Perlin Noise Loops Simulation

Written as a literate program using:

1. **litpd**
2. **Love2d**

The program generates code in two important files.

1. *conf.lua*: This is the program run before love2d window is started. The
   window related configurations are set here to reduce flickering.
2. *main.lua*: This is the entry point for the love2d game. All the code for the
   simulation/game should go here.

The program contains some starter boilerplate code for the two files.

## Building and Running the Program

See the `Makefile` in the current directory to see how to build and run the
program.

# `main.lua`

## Module Imports & Variables

```lua {code_id="moduleglobal"}
-- All imports and module scope variables go here.
local utils = require("utils")
local nl = require('ne0luv')

-- canvas dimensions
local cw, ch
local noiseMax = 0.5
local noiseSlider
local phase = 0
local zoff = 0

```

## `love.load` - Initialization

```lua {code_id="loveload"}
--- love.load: Called once at the start of the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.load()
    cw, ch = love.graphics.getDimensions()
    -- create slider on bottom right corner
    noiseSlider = nl.Slider(
        nl.Rect(cw - 200, ch - 50, 200, 50),
        {
            minValue = 0,
            maxValue = 10,
            currentValue = 0.5,
        }
    )

    noiseSlider:addChangeHandler(function(value)
        noiseMax = value
    end)
end

```

## `love.update` - Update the Simulation

```lua {code_id="loveupdate"}
--- love.update: Called every frame, updates the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
    noiseSlider:update()
end

```

## `love.draw` - Draw the Simulation

```lua {code_id="lovedraw"}
--- love.draw: Called every frame, draws the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.draw()
    -- draw a circle by drawing line segments
    -- at every segment turn by a small angle
    -- before drawing the next one.
    -- use this to draw a circle like a polygon
    -- using the love.graphics.polygon function
    love.graphics.push()
    love.graphics.translate(cw/2, ch/2)
    local angle_delta = 0.01
    local segments = 2 * math.pi / angle_delta
    -- generate the vertices for the circle
    local vertices = {}
    local xoff, yoff = 0, 0
    -- the vertices generated each time are no exactly on a circle
    -- but are calculated in such a way that the radius is a random value
    -- from a perlin/simplex noise space.
    -- To make sure that the last vertex connects to the first vertex
    -- in an orderly fashion, as in does not connect too far away from the first
    -- vertex, we choose the random simplex noise value in a 2-d simplex noise
    -- space by going over the space in a circular fashion.
    for i = 1, segments do
        -- set the xoff, yoff using the angle
        xoff = utils.mapRange(math.cos(i * angle_delta + phase) + 1, -1, 1, 0, noiseMax)
        yoff = utils.mapRange(math.sin(i * angle_delta) + 1, -1, 1, 0, noiseMax)

        -- get the perlin noise from xoff, yoff using love.math.noise
        -- and map it to the range of 50, 200 using utils.mapRange
        -- this will be the radius of the circle at this point
        -- in the circle.
        local radius = utils.mapRange(love.math.noise(xoff, yoff, zoff), 0, 1, 50, 200)

        local x = radius * math.cos(i * angle_delta)
        local y = radius * math.sin(i * angle_delta)
        table.insert(vertices, x)
        table.insert(vertices, y)
    end
    -- draw the circle
    love.graphics.polygon("line", vertices)
    love.graphics.pop()

    -- draw the slider
    noiseSlider:draw()

    -- increment the phase
    phase = phase + 0.05

    -- increment the zoff
    zoff = zoff + 0.05
end

```

## `love.keypressed` - Handle Keyboard Events

```lua {code_id="lovekeypressed"}
-- escape to exit
---@diagnostic disable-next-line: duplicate-set-field
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
```

## 'love.mouse<event>` - Handle Mouse Events

```lua {code_id="lovemouse"}
---@diagnostic disable-next-line: duplicate-set-field
function love.mousepressed(x, y, button)
    noiseSlider:mousepressed(x, y, button)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.mousereleased(x, y, button)
    noiseSlider:mousereleased(x, y, button)
end

---@diagnostic disable-next-line: duplicate-set-field
function love.mousemoved(x, y, dx, dy, istouch)
    noiseSlider:mousemoved(x, y, dx, dy, istouch)
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

@<lovemouse@>
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
    t.window.title = "Polar Perlin Noise Loops Simulation"

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