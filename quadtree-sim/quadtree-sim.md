---
title: QuadTree Simulation
---

[QuadTree Coding Train - Part I][1]
[QuadTree Wikipedia][2]

[1]: https://www.youtube.com/watch?v=OJxEcs0w_kE
[2]: https://en.wikipedia.org/wiki/Quadtree

```lua { code_file="conf.lua" }
--- conf.lua: Config for the love2d game.
--
-- date: 30/3/2024
-- author: Abhishek Mishra

-- canvas size
local canvasWidth = 400
local canvasHeight = 400

function love.conf(t)
    -- set the window title
    t.window.title = "QuadTree Simulation"

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

<!-- ```lua { code_file="main.lua" }
--- main.lua: QuadTree Simulation in LÖVE
-- date: 30/3/2024
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
``` -->