---
title: Polar Perlin Noise Loops Simulation
date: 05/05/2024
author: Abhishek Mishra
---
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
[6]: https://love2d.org/
[7]: https://en.wikipedia.org/wiki/Literate_programming
[8]: https://p5js.org/


## Literate Programming using `litpd`

This program is written using my own literate programmin tool named [litpd][4].
`litpd` is a command-line tool that takes a [markdown document in pandoc
format][5], and creates two outputs. The first output is a human readable
document in a format like html/pdf. The second output is the source code files
for building and running the program.

[4]: https://github.com/abhishekmishra/litpd
[5]: https://pandoc.org/MANUAL.html#pandocs-markdown


## Build/Run the Program

See the `Makefile` in the current directory to see how to build and run the
program.

# The Program

- *Central Idea*: The central idea of the program is to draw a distorted circle
  as a series of line segments.
- *Shape Distortion*: The distortion is created in a natural and continuous
  manner by using **Perlin/Simplex Noise**.
- *Path in Noise Space*: If we move in a loop through a 2D noise space we can
  create a sequence of noise values which will return to the starting value at
  the end of the loop. This property is utilized to ensure that when distorting
  the circle, there is no jagged transition.
- *2d Slices of 3d Noise*: If we extend our noise space to three dimensions then
  at each frame we can take a different 2d slice of 3d space by utilizing a
  slightly different z-index. This will ensure a smooth but random animation
  in the visualization.

The over-arching idea of the simulation is the creative usage of
**Perlin/Simplex Noise** to transform polygons into beautiful shapes and animate
them at each frame.

## Program Structure

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

## File Header

```lua {code_id="header"}
--- main.lua: Polar Perlin Noise Loops Simulation in LÖVE
-- date: 09/05/2024
-- author: Abhishek Mishra
```

## Module Imports

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

## Global Variables

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

## Initialization

The `love.load` function is called by love2d once when the game/simulation
starts. We initialize the simulation by querying the dimensions of the canvas,
and setting up the slider control for selecting the maximum value of the noise
range.

```lua {code_id="loveload"}
--- love.load: Called once at the start of the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.load()
    @<querydim@>
    @<initslider@>
end

```

### Querying the canvas dimensions

This is straight-forward and self-explanatory.

```lua {code_id="querydim"}
    -- query the dimensions of the canvas and store in cw, ch global vars.
    cw, ch = love.graphics.getDimensions()
```

### Setup Noise Slider

We setup the Slider control at the bottom right of the canvas. And we plug
the change handler with the control such that the `noiseMax` value is updated
when the Slider changes.

Note that the Slider control's lifecycle methods will have to be called at
appropriate love2d lifecycle functions viz. the `update`, `draw` and input event
functions.


```lua {code_id="initslider"}
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
```

#### Connect the lifecycle methods for Slider

```lua {code_id="updateslider"}
noiseSlider:update(dt)
```

```lua {code_id="mousepressedslider"}
noiseSlider:mousepressed(x, y, button)
```

```lua {code_id="mousereleasedslider"}
noiseSlider:mousereleased(x, y, button)
```

```lua {code_id="mousemovedslider"}
noiseSlider:mousemoved(x, y, dx, dy, istouch)
```

```lua {code_id="drawslider"}
noiseSlider:draw()
```

## `love.update` - Update the Simulation

There's only the one UI Control - the noise slider to update in this method.

```lua {code_id="loveupdate"}
--- love.update: Called every frame, updates the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
    @<updateslider@>
end

```

## Draw the Simulation

- The bulk of the program is implemented in this function.
- As we have discussed at the beginning of the section, the central idea is to
  draw a distorted circle.
- The circle is drawn at the center of the canvas.
- The circle is drawn as a sequence of line segments. The more the line segments
  the smoother the curve of the circle.
- The line segments are drawn using the `love.graphics.polygon` API.
- We define a variable called `angle_delta`. Then we divide 360 degrees by this
  number and get the number of segements to draw. The larger the value of
  `angle_delta` the fewer the number of segments.
- For each line segment we calculate an end-vertex which is slightly shifted
  from the ideal position on the curve of the circle. This shift creates an
  appearance of the distorted circle.
- To get the shifted vertices we use a sequence of noise values from the
  `love.math.noise` API which in turn implements simplex noise.
- We select noise values from a 3d noise space, where the z-index of the noise
  selection changes every frame. This gives rise to a continuous change to the
  distorted circle which make the simulation animated.

### Structure of Draw Function

The `love.draw` function is called by love2d every frame. We define a new
coordinate system translated to the center of the screen. Then we setup the
circle parameters, and generate the distorted line segments for the circle, and
draw it. Finally we pop the graphics coordinate transform and update our
animation variables.

```lua {code_id="lovedraw"}
--- love.draw: Called every frame, draws the simulation
---@diagnostic disable-next-line: duplicate-set-field
function love.draw()

    @<graphicssetup@>

    @<circleparams@>

    @<circledefinition@>

    @<circledraw@>

    @<graphicspop@>

    @<drawslider@>

    @<animationupdate@>

end

```

### Graphics Setup

- Push a new coordinate transformation onto the transformation stack.
- Translate the coordinate system to the center of the canvas.

```lua {code_id="graphicssetup"}
love.graphics.push()
love.graphics.translate(cw/2, ch/2)
```

### Circle Parameters

- In this section of the program we define the initial values of the parameters
  for the circle.
- We define the number of line segments to use by dividing `2*pi` by the value
  of `angle_delta` which is in turn defined as a suitably small value.
- We define an empty table of vertices called `vertices` which will be passed to
  the `love.graphics.polygon` function to draw the circle.
- We define `xoff` and `yoff` variables with initial value of 0. These variables
  provide the first two indexes into our lookup into 3d noise space.

```lua {code_id="circleparams"}
local angle_delta = 0.01
local segments = 2 * math.pi / angle_delta
local vertices = {}
local xoff, yoff = 0, 0
```

### Circle Definition

- In this part of the function we generate the vertices for the line segments.
- We get the values for `xoff` and `yoff` values.
    - `xoff` is calculated as the cosine of the angle of the segment vertex,
      plus the `phase`. Since the `phase` value is incremented every frame we
      get a slightly different value for the `xoff` every frame.
    - The resultant cosine is mapped to a range of [1, `noiseMax`]. Therefore as
      the user changes the slider, the value of noise can be restricted to a
      smaller range or its range can be increased. The greater the range of
      `xoff`, the greater the distortion.
    - The `yoff` is calculated using the sine function but without any
      application of `phase`.
- The `xoff` and `yoff` value alongwith the time dependent `zoff` values are
  used to lookup in the noise space. The resultant value is mapped to a range of
  [50, 200]. This is the value of `radius` of the circle for that iteration.
- Since the value of `radius` is slightly different for every segment of the
  circle we get a distorted circle.
- The `radius` value is used to calculate the `x` and `y` values of the vertex
  endpoint of the current segment using the cosine and sine functions.
- Finally the `x` and `y` values are appended to the `vertices` list.

```lua {code_id="circledefinition"}
for i = 1, segments do
    xoff = utils.mapRange(math.cos(i * angle_delta + phase) + 1, -1, 1, 0, noiseMax)
    yoff = utils.mapRange(math.sin(i * angle_delta) + 1, -1, 1, 0, noiseMax)

    local radius = utils.mapRange(love.math.noise(xoff, yoff, zoff), 0, 1, 50, 200)

    local x = radius * math.cos(i * angle_delta)
    local y = radius * math.sin(i * angle_delta)
    table.insert(vertices, x)
    table.insert(vertices, y)
end
```

### Draw Circle

Drawing the circle is a single call to the `love.graphics.polygon` function.

```lua {code_id="circledraw"}
love.graphics.polygon("line", vertices)
```

### Pop Coordinate System

We pop the coordinate system at the end of the graphics operations.

```lua {code_id="graphicspop"}
love.graphics.pop()
```

### Animation Update

We update the values which animate our drawing. The `phase` value is incremented
by a small amount, and the `zoff` is incremented by a small amount.

```lua {code_id="animationupdate"}
phase = phase + 0.05
zoff = zoff + 0.05
```


## Handle Keyboard Events

We define the `love.keypressed` function to handle the `escape` key and quit
the application if it is pressed.

```lua {code_id="lovekeypressed"}
-- escape to exit
---@diagnostic disable-next-line: duplicate-set-field
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
```

## Handle Mouse Events

The love2d mouse handlers are implmented to call the corresponding methods of
the noise slider control object.

```lua {code_id="lovemouse"}
---@diagnostic disable-next-line: duplicate-set-field
function love.mousepressed(x, y, button)
    @<mousepressedslider@>
end

---@diagnostic disable-next-line: duplicate-set-field
function love.mousereleased(x, y, button)
    @<mousereleasedslider@>
end

---@diagnostic disable-next-line: duplicate-set-field
function love.mousemoved(x, y, dx, dy, istouch)
    @<mousemovedslider@>
end
```

# Configuration

The `conf.lua` file is called at the startup of love2d to setup some parameters
before the window is drawn. We define the canvas size and window title here.
We also turn off some unused modules to make the program faster.

```lua { code_file="conf.lua" }
--- conf.lua: Config for the love2d game.
--
-- date: 4/3/2024
-- author: Abhishek Mishra

-- canvas size
local canvasWidth = 800
local canvasHeight = 800

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
end

```
