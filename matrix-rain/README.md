# Matrix Rain Simulation

## Building and Running the Program

See the `Makefile` in the current directory to see how to build and run the
program.

# The RainDrop Class

```lua {code_file="raindrop.lua"}
local Class = require 'middleclass'

local RainDrop = Class('RainDrop')

@<raindropconstructor@>

@<raindropupdate@>

@<raindropdraw@>

@<raindropinframe@>

return RainDrop
```

## RainDrop Constructor

```lua {code_id="raindropconstructor"}
function RainDrop:initialize(config)
    self.x = config.x
    self.y = config.y
    self.w = config.w
    self.h = config.h
    self.vx = config.vx
    self.vy = config.vy
end
```

## RainDrop Update

```lua {code_id="raindropupdate"}
function RainDrop:update(dt)
    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)
end
```

## RainDrop Draw

```lua {code_id="raindropdraw"}
function RainDrop:draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end
```

## RainDrop Inframe?

```lua {code_id="raindropinframe"}
function RainDrop:inFrame(cw, ch)
    return self.x <= cw and self.y <= ch
end
```

# RainColumn Class

```lua {code_file="raincolumn.lua"}
local Class = require 'middleclass'
local RainDrop = require 'raindrop'

local RainColumn = Class('RainColumn')

@<raincolumnconstructor@>
@<raincolumninitdrops@>
@<raincolumnupdate@>
@<raincolumndraw@>
@<raincolumninframe@>

return RainColumn
```

## RainColumn Constructor

```lua {code_id="raincolumnconstructor"}
function RainColumn:initialize(config)
    self.x = config.x
    self.w = config.w
    self.h = config.h
    self.vy = config.vy
    self.numRows = config.numRows
    self.rowHeight = self.h/self.numRows

    self:initDrops()
end
```

## RainColumn Initialize Drops

```lua {code_id="raincolumninitdrops"}
function RainColumn:initDrops()
    self.numDrops = math.random(1, self.numRows)

    self.drops = {}
    for i = 1, self.numDrops do
        table.insert(self.drops,
            RainDrop({
                x = self.x,
                y = (i - 1) * self.rowHeight,
                w = self.w,
                h = self.rowHeight,
                vx = 0,
                vy = self.vy
            }))
    end
end
```

## RainColumn in Frame?

```lua {code_id="raincolumninframe"}
function RainColumn:inFrame()
    return self.drops[1]:inFrame(love.graphics.getDimensions())
end
```

## RainColumn Update

```lua {code_id="raincolumnupdate"}
function RainColumn:update(dt)
    if not self:inFrame() then
        self:initDrops()
    end
    for i, drop in ipairs(self.drops) do
        drop:update(dt)
    end
end
```

## RainColumn Draw

```lua {code_id="raincolumndraw"}
function RainColumn:draw()
    for i, drop in ipairs(self.drops) do
        drop:draw()
    end
end
```

# Matrix Rain Program

## Module Imports

The program uses the [`middleclass`][1] library for implementing classes.

```lua {code_id="requiredeps"}
local RainColumn = require 'raincolumn'
```

## File Globals

```lua {code_id="fileglobals"}
local cw, ch

local column
```

## Initialization

```lua {code_id="loveload"}
function love.load()
    cw, ch = love.graphics.getDimensions()
    column = RainColumn({
        x = cw/2-10,
        w = 10,
        h = ch,
        vy = 100,
        numRows = 10
    })
end

```

## Update the Simulation

```lua {code_id="loveupdate"}
function love.update(dt)
    column:update(dt)
end

```

## Draw the Simulation

```lua {code_id="lovedraw"}
function love.draw()
    column:draw()
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
