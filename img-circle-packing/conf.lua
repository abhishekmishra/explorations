--- conf.lua: Config for the love2d game.
--
-- date: 14/3/2024
-- author: Abhishek Mishra

-- canvas size
local canvasWidth = 512
local canvasHeight = 512

function love.conf(t)
    -- set the window title
    t.window.title = "Image Circle Packing Simulation"

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
