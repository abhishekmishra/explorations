---
title: Recursive Subdivision Of Curves
date: 25/11/2024
author: Abhishek Mishra
category: simulation
tags: noise, love2d, lua, curve, fractal, recursion
summary: A program to create a complex fractal curve using recursive subdivision.
---

|Version     |Date      |Comments                       |
|------------|----------|-------------------------------|
|0.1         |25/11/2024|Initial version                |

# Recursive Subdivision Of Curves

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

# The Algorithm in 1-D

The paper mentioned in the introduction [^fournier] describes the algorithm we
are about to discuss as "... a recursive algorithm for generating approximations
to the sample paths of one dimensional fBm" (fBm stands for _fractional
Brownian motion_). Thus the algorithm generates in every run a sample Brownian
motion path between the input end-points.

Since this algorithm is recursive in
nature it can be repeated to any level of detail. The detail in the curve
increases with the recursive depth of the program. This recursive depth should
be used to produce a curve that retains sufficient detail at the highest zoom
level used in the graphical application.

Now, let's jump into the algorithm. In the original paper the algorithm is
written in Pascal, however here I present it informally as we will later develop
the program in lua.

- **Step 1: End-points of the Curve:** First we must established the start and
    end-point of the curve. These will serve as the starting input to the
    recursive subdivision. These points on 1-d are simple _real_ values which
    can be given as user input or assigned to random values.

- **Step 2: Establish the number of points:** The paper provides states that for
    detail level `N`, the number of points in the curve should be `2^N`. The
    maxlevel `N` can be a user input.

- **Step 3: Recursive Subdivision:** In the third step we take a segment and
    find its midpoint. Then we perturb the midpoint by a random amount. This
    gives us two new segments. We run the process till the segments are of zero
    lengths and cannot be subdivided. Each recursive step doubles the number
    of segments to be processed in the next round. The entire process is started
    with the first and last points decided in the _Step 1_.

The amound of perturbation at each level of recursion decreases as we subdivide
smaller and smaller segments. The amount of randomness added is the **Hurst
Exponent** - which is related to the shape of the fBm. The value of the Hurst
Exponent decides the roughness/smoothness of the generated curve.

## Building and Running the Program

See the `Makefile` in the current directory to see how to build and run the
program.

# The fBm Curve

The `fbmcurve.lua` file defines the `FBMCurve` class. It represents a single
curve defined using recursive subdivision.

* The class constructor accepts two optional arguments `seed` and `num_levels`.
* The `seed` argument is an input to the random number generator. The random
  number generator is used to create the perturbation in the midpoint when
  subdividing a line segment. The default value of `seed` is `1`.
* The `num_levels` argument controls how many points will be generated in the
  curve. It represents the amount of detail required in the curve. The higher
  the value, the greater the number of points in the curve. The default value
  for `num_levels` is `9`.
* The constructor uses the inputs to initialize some state for the curve.
* The number of points `num_points` in the curve is first set equal to
  `2^num_levels + 1`.
* A new table `points` is created to store the points of the curve.
* The first and last points of the curve are created using the random number
  generator.
* A default initial value is assinged to all the other points of the curve.
* The `h` value refers to the `Hurst Exponent` and is used to calculate the
  ratio of dampening of the perturbation at each recursive depth. The dampening
  increases as we descend into sub-dividing smaller and smaller line segments.
  The value of `h` affects the roughness/smoothness of the generated curve.
* The `ratio` of dampening is defined as `2^-h`.

## Class definition

```lua {code_file="fbmcurve.lua"}
local Class = require "middleclass"

local FBMCurve = Class("FBMCurve")

--- Create a new FBMCurve object
-- @param seed (number) The seed for the random number generator
-- @param num_levels (number) The number of levels of the curve
function FBMCurve:initialize(seed, num_levels)
    self.seed = seed or 1
    -- use the seed to create a new random number generator
    math.randomseed(seed)

    self.num_levels = num_levels or 9
    self.num_points = (2 ^ self.num_levels) + 1
    self.points = {}
    self.max_height = love.graphics.getHeight()

    -- random start and end points using the given seed
    -- in the range [0, num_levels]
    self.points[1] = love.math.random(1, self.max_height)
    self.points[self.num_points] = love.math.random(1, self.max_height)
    -- fill the rest of the points with 0
    for i = 2, self.num_points - 1, 1 do
        self.points[i] = 10
    end
    self.h = 0.01
    self.ratio = 2 ^ (-self.h)
    self.scale = self.num_levels
    self:generate()
end

function FBMCurve:subdivide(left, right, std)
    local mid = math.floor((left + right) / 2)
    if mid ~= left and mid ~= right then
        self.points[mid] = (self.points[left] + self.points[right]) / 2.0 + self:gauss(mid) * std
        local stdmid = std * self.ratio
        self:subdivide(left, mid, stdmid)
        self:subdivide(mid, right, stdmid)
    end
end

-- Generate a Gaussian (normal) distributed random number
function FBMCurve:gauss(index)
    -- Seed the RNG uniquely for deterministic results
    local combined_seed = self.seed + index
    math.randomseed(combined_seed)

    -- Generate two uniform random numbers (0, 1)
    local u1 = math.random()
    local u2 = math.random()

    -- Box-Muller transform
    local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2)
    -- You could also calculate z1 if you need a second Gaussian number
    -- local z1 = math.sqrt(-2.0 * math.log(u1)) * math.sin(2.0 * math.pi * u2)

    return z0 -- Return a Gaussian random number with mean 0 and standard deviation 1
end

function FBMCurve:generate()
    local std = self.ratio * self.num_levels
    self:subdivide(1, self.num_points, std)
end

function FBMCurve:update(dt)
end

function FBMCurve:draw()
    love.graphics.setColor(1.0, 1.0, 0.0)

    -- delta is window width divided number of points
    local delta = love.graphics.getWidth() / self.num_points
    for i = 1, self.num_points - 1 do
        love.graphics.line(i * delta, self.points[i], (i + 1) * delta, self.points[i + 1])
    end
end

return FBMCurve
```

# `main.lua`

## Module Imports & Variables

```lua {code_id="moduleglobal"}
local FBMCurve = require"fbmcurve"

local curve
```

## `love.load` - Initialization

```lua {code_id="loveload"}
--- love.load: Called once at the start of the simulation
function love.load()
    curve = FBMCurve(1)
end

```

## `love.update` - Update the Simulation

```lua {code_id="loveupdate"}
--- love.update: Called every frame, updates the simulation
function love.update(dt)
    curve:update(dt)
end

```

## `love.draw` - Draw the Simulation

```lua {code_id="lovedraw"}
--- love.draw: Called every frame, draws the simulation
function love.draw()
    curve:draw()
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
    t.window.title = "Recursive Subdivision Of Curves"

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
