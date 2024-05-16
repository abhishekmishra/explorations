# Matrix Rain Simulation

## Building and Running the Program

See the `Makefile` in the current directory to see how to build and run the
program.

# Matrix Rain Program

## Module Imports

The program uses the [`middleclass`][1] library for implementing classes.

```lua {code_id="requiredeps"}
local RainDrop = require 'raindrop'
```

## File Globals

```lua {code_id="fileglobals"}
local cw, ch
```

## The RainDrop Class

```lua {code_file="raindrop.lua"}
local Class = require 'middleclass'

local RainDrop = Class('RainDrop')

@<raindropconstructor@>

@<raindropupdate@>

@<raindropdraw@>

return RainDrop
```

### RainDrop Constructor

```lua {code_id="raindropconstructor"}
function RainDrop:initialize(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end
```

### RainDrop Update

```lua {code_id="raindropupdate"}
function RainDrop:update(dt)
end
```

### RainDrop Draw

```lua {code_id="raindropdraw"}
function RainDrop:draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', self.x, self.h, self.w, self.h)
end
```

## Initialization

```lua {code_id="loveload"}
function love.load()
    cw, ch = love.graphics.getDimensions()
end

```

## Update the Simulation

```lua {code_id="loveupdate"}
function love.update(dt)
end

```

## Draw the Simulation

```lua {code_id="lovedraw"}
function love.draw()
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
--- main.lua: Matrix Rain Simulation in LÖVE
-- date: 16/05/2024
-- author: Abhishek Mishra

@<requiredeps@>

@<fileglobals@>

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
