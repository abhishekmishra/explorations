--- conf.lua: Config for the love2d game.
--
-- date: 26/2/2024
-- author: Abhishek Mishra

-- canvas size
local canvasWidth = 400
local canvasHeight = 400

function love.conf(t)
    -- set the window title
    t.window.title = "Falling Sand Simulation"

    -- set the window size
    t.window.width = canvasWidth
    t.window.height = canvasHeight
end
