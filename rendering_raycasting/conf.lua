--- conf.lua: Config for the love2d game.
--
-- date: 28/4/2024
-- author: Abhishek Mishra

-- canvas size
local canvasWidth = 800
local canvasHeight = 800

function love.conf(t)
    -- set the window title
    t.window.title = "Raycasting Simulation"

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
