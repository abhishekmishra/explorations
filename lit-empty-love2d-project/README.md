# EMPTY Simulation

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

```lua {code_file="main.lua"}
--- main.lua: <Empty> Simulation in LÖVE
-- date: 4/3/2024
-- author: Abhishek Mishra

--- love.load: Called once at the start of the simulation
function love.load()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
end

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
    t.window.title = "<Empty> Simulation"

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