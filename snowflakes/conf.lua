--- conf.lua: Config for the love2d game.
--
-- date: 4/3/2024
-- author: Abhishek Mishra

-- canvas size
local canvasWidth = 400
local canvasHeight = 400

function love.conf(t)
    -- set the window title
    t.window.title = "Snowflakes Simulation"

    -- set the window size
    -- t.window.width = canvasWidth
    -- t.window.height = canvasHeight

    -- run fullscreen
    t.window.fullscreen = true

    -- disable unused modules for performance
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = false
end
