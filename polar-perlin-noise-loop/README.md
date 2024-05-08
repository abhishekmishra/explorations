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
    local text = "Polar Perlin Noise Loops Simulation"
    local tw = love.graphics.getFont():getWidth(text)
    -- write empty simulation in the middle of the screen
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