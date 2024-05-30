# Lissajous Curves Simulation

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
```

## Module Variables

```lua {code_id="varmodule"}
local cw, ch
local layout
```

## `love.load` - Initialization

```lua {code_id="loveload"}
function love.load()
    cw, ch = love.graphics.getDimensions()
    layout = nl.Layout(nl.Rect(0, 0, cw, ch), {
        layout = 'column',
    })

    local topRow = nl.Layout(nl.Rect(0, 0, cw, ch/8), {
        layout = 'row',
        bgColor = {0, 1, 0, 1}
    })

    local rowCirclesPanel = nl.Layout(nl.Rect(0, 0, 7 * cw/8, ch/8), {
        layout = 'row',
        bgColor = {0, 0, 1, 1}
    })

    topRow:addChild(nl.Layout(nl.Rect(0, 0, cw/8, ch/8), {
        bgColor = {0, 0, 0, 0.1}
    }))

    topRow:addChild(rowCirclesPanel)

    local bottomRow = nl.Layout(nl.Rect(0, ch/8, cw, 7 * ch/8), {
        layout = 'row',
        bgColor = {1, 0, 1, 1}
    })

    local colCirclesPanel = nl.Layout(nl.Rect(0, 0, cw/8, 7 * ch/8), {
        layout = 'column',
        bgColor = {1, 1, 1, 0.8}
    })

    local curvesPanel = nl.Layout(nl.Rect(0, 0, 7 * cw/8, 7 * ch/8), {
        layout = 'column',
        bgColor = {1, 0, 0, 0.4}
    })

    bottomRow:addChild(colCirclesPanel)
    bottomRow:addChild(curvesPanel)

    layout:addChild(topRow)
    layout:addChild(bottomRow)
end

```

## `love.update` - Update the Simulation

```lua {code_id="loveupdate"}
function love.update(dt)
    layout:update(dt)
end

```

## `love.draw` - Draw the Simulation

```lua {code_id="lovedraw"}
function love.draw()
    layout:draw()
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
