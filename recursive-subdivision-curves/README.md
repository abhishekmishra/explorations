---
title: Recursive Subdivision of Curves
date: 25/11/2024
author: Abhishek Mishra
category: simulation
tags: noise, love2d, lua, curve, fractal, recursion
summary: A program to create a complex fractal curve using recursive subdivision.
---

|Version     |Date      |Comments                       |
|------------|----------|-------------------------------|
|0.1         |25/11/2024|Initial version                |

# Recursive Subdivision of Curves

This is a literate program (written in litpd [^litpd]) that demonstrates creating
fractal paths/curves starting with a simple curve with a few line segments. The
algorithm is from the classic paper on the topic of such methods [^fournier].
The paper discusses the use of recursive subdivision methods to create fractal
curves and surfaces. This method and its variations have been frequently used
as they produce decent results and the 1-D version that we use here has linear
complexity.

This article is divided into two sections:

1. *Algorithm*: We discuss the recursive subdivision algoritm and its properties
   in this section.
2. *Program*: We develop a love2d simulation to demonstrate the use of this
   algorithm in various scenarios and with varying parameters.

[^litpd]: <https://neolateral.in/litpd-literate-programming-for-pandoc-markdown>
[^fournier]: <https://doi.org/10.1145/358523.358553> "Alain Fournier, Don
    Fussell, and Loren Carpenter. 1982. Computer rendering of stochastic
    models. Commun. ACM 25, 6 (June 1982), 371–384."

## Building and Running the Program

See the `Makefile` in the current directory to see how to build and run the
program.

# `main.lua`

## Module Imports & Variables

```lua {code_id="moduleglobal"}
-- All imports and module scope variables go here.
```

## `love.load` - Initialization

```lua {code_id="loveload"}
--- love.load: Called once at the start of the simulation
function love.load()
end

```

## `love.update` - Update the Simulation

```lua {code_id="loveupdate"}
--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

```

## `love.draw` - Draw the Simulation

```lua {code_id="lovedraw"}
--- love.draw: Called every frame, draws the simulation
function love.draw()
    local text = "Recursive Subdivision of Curves"
    local tw = love.graphics.getFont():getWidth(text)
    -- write Recursive Subdivision of Curves in the middle of the screen
    love.graphics.print(text,
        love.graphics.getWidth() / 2 - tw / 2,
        love.graphics.getHeight() / 2 - 12)
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
    t.window.title = "Recursive Subdivision of Curves"

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
