--- main.lua: lfs Usage Simulation in LÖVE
-- date: 4/4/2024
-- author: Abhishek Mishra

local lfs = require 'lfs'

local currentDir
local filesInDir

--- love.load: Called once at the start of the simulation
function love.load()
    -- get the current directory
    currentDir = lfs.currentdir()

    -- get the files in the current directory
    filesInDir = {}
    for f in lfs.dir(currentDir) do
        table.insert(filesInDir, f)
    end
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    -- write the current directory path at 10, 10
    -- will get concatenated if it is a long path
    love.graphics.print('Current Directory: ' .. currentDir, 10, 10)

    -- list the files in the folder
    -- again the list might get concatenated if there are too many entries
    for i, val in ipairs(filesInDir) do
        love.graphics.print('--> ' .. tostring(val), 10, 10 + (i * 20))
    end
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
