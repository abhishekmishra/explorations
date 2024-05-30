# Lissajous Curves Simulation

# The Circles

```lua {code_file="circle.lua"}

local Class = require('middleclass')
local nl = require('ne0luv')

local Circle = Class('Circle', nl.Panel)

@<circleconstructor@>

@<circleupdate@>

@<circledraw@>

return Circle
```

## Constructor

```lua {code_id="circleconstructor"}
function Circle:initialize(radius, phase, speed)
    nl.Panel.initialize(self, nl.Rect(0, 0, radius * 2, radius * 2))
    self.radius = radius
    self.angle = phase
    self.speed = speed or 1
end
```

## Update

```lua {code_id="circleupdate"}
function Circle:update(dt)
    self.angle = self.angle + (self.speed * dt)
end
```

## Draw

```lua {code_id="circledraw"}
function Circle:draw()
    love.graphics.push()

    love.graphics.translate(self:getX(), self:getY())
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.radius, self.radius, self.radius)

    love.graphics.translate(self.radius, self.radius)
    local x = self.radius * math.cos(self.angle)
    local y = self.radius * math.sin(self.angle)
    love.graphics.setColor(1, 0, 1)
    love.graphics.circle("fill", x, y, 5)

    love.graphics.pop()
end
```

# `main.lua`

```lua {code_file="main.lua"}
--- main.lua: Lissajous Curves Simulation in LÖVE
-- date: 29/5/2024
-- author: Abhishek Mishra

@<moduleglobal@>

@<varmodule@>

@<loveload@>

@<loveupdate@>

@<lovedraw@>

@<lovekeypressed@>
```

## Module Imports

```lua {code_id="moduleglobal"}
local nl = require('ne0luv')
local Circle = require('Circle')
```

## Module Variables

```lua {code_id="varmodule"}
local cw, ch
```

## `love.load` - Initialization

```lua {code_id="loveload"}
function love.load()
    cw, ch = love.graphics.getDimensions()
end

```

## `love.update` - Update the Simulation

```lua {code_id="loveupdate"}
function love.update(dt)
end

```

## `love.draw` - Draw the Simulation

```lua {code_id="lovedraw"}
function love.draw()
end

```

## `love.keypressed` - Handle Keyboard Events

```lua {code_id="lovekeypressed"}
-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
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
    t.window.title = "Lissajous Curves Simulation"

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
