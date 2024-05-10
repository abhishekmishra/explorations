# Polar Perlin Noise Loops Simulation

_Note: Although the title says `Perlin Noise`, we use `Simplex Noise` as this
is readily available in the package `love.math.noise`._

This is a [literate program][7] that implements the simulation described in the
tutorial [Coding Challenge #136.1: Polar Perlin Noise Loops][1] at
[The Coding Train][2] youtube channel.

In this simulation we develop an interesting visualization of circular shapes
drawn in a distorted fashion using multi-dimensional [Perlin Noise][3].

The simulation is implemented in [Love2d][6] unlike the video above where
Dan Shiffman writes the program in javascript using the [p5.js library][8]

[1]: https://www.youtube.com/watch?v=ZI1dmHv3MeM
[2]: https://www.youtube.com/@TheCodingTrain
[3]: https://en.wikipedia.org/wiki/Perlin_noise


## Literate Programming using `litpd`

This program is written using my own literate programmin tool named [litpd][4].
`litpd` is a command-line tool that takes a [markdown document in pandoc 
format][5], and creates two outputs. The first output is a human readable
document in a format like html/pdf. The second output is the source code files
for building and running the program.

[4]: https://github.com/abhishekmishra/litpd
[5]: https://pandoc.org/MANUAL.html#pandocs-markdown


## Building and Running the Program

See the `Makefile` in the current directory to see how to build and run the
program.

# `main.lua`

The entrypoint of a `love2d` game is a `main.lua` file. We will write the bulk
of the program (excluding a few configuration items) in this file.

The `main.lua` program has the following parts. Each of the parts of the program
are developed in the later sections. (The `litpd` tool will weave it all
together into a single file.)

* *Header*: contains some standard bookkeeping remarks at the top of the file.
* *Imports*: All the dependencies of the program are imported in this section.
* *Globals*: There are several global constants and variables use in the
  program, these are listed in this section. Some of them are assigned initial
  values.
* *Love2d Methods*: The bulk of the program is implemented in the love2d 
  entry-points viz. `love.load` to initialize the program, `love.load` to update
  the state of the program every frame, and `love.draw` to draw the state of
  the program every frame. There are some other functions defined in the `love`
  namespace which will handle user input from keyboard and mouse.

```lua {code_file="main.lua"}
@<header@>

@<imports@>

@<globals@>

@<loveload@>

@<loveupdate@>

@<lovedraw@>

@<lovekeypressed@>

@<lovemouse@>
```


## Header, Imports & Global Variables

### File Header

```lua {code_id="header"}
--- main.lua: Polar Perlin Noise Loops Simulation in LÖVE
-- date: 09/05/2024
-- author: Abhishek Mishra
```

### Module Imports

The program uses the following modules:
1. `utils.mapRange`: We re-use an implementation of the p5.js [`map`][9]
   function written for another simulation. The code is available in the
   `utils.lua` file which was copied over from another project.
2. `ne0luv`: This is a library of some commonly-used utilites that I've
   developed for use in my Love2d simulations. In the current program I've only
   used a slider control to change some of the parameters of the noise
   generation. To read more about `ne0luv` see its project page at [ne0luv][10]

[9]: https://p5js.org/reference/#/p5/map
[10]: https://github.com/abhishekmishra/ne0luv

```lua {code_id="imports"}
local utils = require("utils")
local nl = require('ne0luv')
```

### Global Variables

In this section of the program we define a few global variables used across the
program. Strictly speaking these are NOT lua global variables. However they are
defined at the module/file scope for the `main.lua` file, which means that they
are available across all the methods in the file. See [PIL: Local Variables
and Scope][11] for a full discussion on the topic of lua local variables.

[11]: https://www.lua.org/pil/4.2.html

The file local variables are:
1. *`cw, ch`*: The dimensions of the love2d canvas.
2. *`noiseMax`*: The maximum input values for the x and y dimensions used when
   selecting noise from 3d noise space.
3. *`noiseSlider`*: The Slider UI control displayed on the screen to control
   the `noiseMax` value.
4. *`phase`*: We are selecting noise in the noise space in a circular path to
   give us a closed loop. If we always start from the same place in every frame
   we will end up with the same sequence of noise values. However if we add a
   changing `phase` value every frame, we get the same path but shifted by a few
   values. This gives a smooth animation to the output drawing.
5. *`zoff`*: Since we are selecting noise from a 3d space we need a z-index.
   This `zoff` value can be changed every frame to change the slice of 2d noise
   that we get from the 3d space. This provides a jarring effect to the
   output drawing.

```lua {code_id="globals"}
-- canvas dimensions
local cw, ch

-- maximum noise
local noiseMax = 0.5

-- maximum noise slider control
local noiseSlider

-- phase of the angle to select from circular path in perlin noise space
local phase = 0

-- value of 3rd-dimension while selecting from 3-d perlin noise space
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