# Fractal Terrain Generation

## Building and Running the Program

See the `Makefile` in the current directory to see how to build and run the
program.

# The Terrain

We start with representation of the terrain as a simple grid.

```lua { code_file="terrain.lua" }
local class = require "middleclass"

local Terrain = class("Terrain")

Terrain.static.DEFAULT_WIDTH = 128
Terrain.static.DEFAULT_HEIGHT = 128

function Terrain:initialize(width, height)
    self.width = width or Terrain.DEFAULT_WIDTH
    self.height = height or Terrain.DEFAULT_HEIGHT
    self.display = "grayscale"

    self.data = {}
    for x = 1, self.width do
        self.data[x] = {}
        for y = 1, self.height do
            self.data[x][y] = 0
        end
    end
end

function Terrain:display_grayscale()
    self.display = "grayscale"
end

function Terrain:display_colour_mapped()
    self.display = "colour_mapped"
end

function Terrain:fill()
end

function Terrain:update(dt)
end

function Terrain:draw()
    if self.display == "grayscale" then
        self:draw_grayscale()
    end

    if self.display == "colour_mapped" then
        self:draw_colour_mapped()
    end
end

function Terrain:draw_grayscale()
    -- get the max height value
    local max = 0
    for x = 1, self.width do
        for y = 1, self.height do
            if self.data[x][y] > max then
                max = self.data[x][y]
            end
        end
    end

    -- draw terrain as grayscale height map directly to screen
    for x = 1, self.width do
        for y = 1, self.height do
            -- colour normalized to range 0-1
            local color = self.data[x][y] / max
            love.graphics.setColor(color, color, color)
            love.graphics.points(x, y)
        end
    end
end

function Terrain:get_colour_of_height(value)
    if value < 0.25 then
        return {0, 0, value * 10} -- Blue for water
    elseif value < 0.75 then
        return {0, value * 2, 0} -- Green for plains
    elseif value < 0.95 then
        return {0.5 * value, 0.25 * value, 0} -- Brown for mountains
    else
        return {1, 1, 1} -- White for snow
    end
end

function Terrain:draw_colour_mapped()
    -- get the max height value
    local max = 0
    for x = 1, self.width do
        for y = 1, self.height do
            if self.data[x][y] > max then
                max = self.data[x][y]
            end
        end
    end

    -- draw terrain as grayscale height map directly to screen
    for x = 1, self.width do
        for y = 1, self.height do
            -- colour normalized to range 0-1
            local color = self:get_colour_of_height(self.data[x][y] / max)
            love.graphics.setColor(color[1], color[2], color[3])
            love.graphics.points(x, y)
        end
    end
end

return Terrain
```

# Simplex Noise Terrain
```lua {code_file="simplex_terrain.lua"}
local Terrain = require "terrain"
local class = require "middleclass"

local SimplexTerrain = class("SimplexTerrain", Terrain)

function SimplexTerrain:initialize(width, height)
    Terrain.initialize(self, width, height)

    self:fill()
end

function SimplexTerrain:fill()
    local baseX = 100 * love.math.random()
	local baseY = 100 * love.math.random()

    for x = 1, self.width do
        for y = 1, self.height do
            local nx = 0.02
            local ny = 0.02
            local value = love.math.noise(baseX + nx * x, baseY + ny * y)
            self.data[x][y] = value
        end
    end
end

return SimplexTerrain
```

# `main.lua`

## Module Imports & Variables

```lua {code_id="moduleglobal"}
-- All imports and module scope variables go here.

local Terrain = require "terrain"
local SimplexTerrain = require "simplex_terrain"

local t
```

## `love.load` - Initialization

```lua {code_id="loveload"}
--- love.load: Called once at the start of the simulation
function love.load()
    t = SimplexTerrain(512, 512)
end

```

## `love.update` - Update the Simulation

```lua {code_id="loveupdate"}
--- love.update: Called every frame, updates the simulation
function love.update(dt)
    t:update(dt)
end

```

## `love.draw` - Draw the Simulation

```lua {code_id="lovedraw"}
--- love.draw: Called every frame, draws the simulation
function love.draw()
    t:draw()
end

```

## `love.keypressed` - Handle Keyboard Events

```lua {code_id="lovekeypressed"}
-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    -- on spacebar press, generate new terrain
    if key == "space" then
        t:fill()
    end
    -- on 'g' set display to grayscale
    if key == "g" then
        t:display_grayscale()
    end
    -- on 'c' set display to grayscale
    if key == "c" then
        t:display_colour_mapped()
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
    t.window.title = "Fractal Terrain Generation"

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