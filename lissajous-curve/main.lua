--- main.lua: Lissajous Curves Simulation in LÖVE
-- date: 29/5/2024
-- author: Abhishek Mishra

local nl = require('ne0luv')
local Circle = require('Circle')


local cw, ch

-- parameters for a lissajous curve
local A = 100
local B = 100
local a = 3
local b = 4
local delta = 1

local NUM = 100
-- stores NUM points of the curve
local points

local totalTime = 0

function love.load()
    cw, ch = love.graphics.getDimensions()
end

function love.update(dt)
    totalTime = totalTime + dt
    if totalTime > 2 * math.pi then
        totalTime = 0
    end
    points = {}
    for i = NUM, 1, -1 do
        local t = totalTime + (i * dt)
        local x = A * math.sin(a * t + delta) + cw / 2
        local y = B * math.sin(b * t) + ch / 2
        table.insert(points, x)
        table.insert(points, y)
    end
end

function love.draw()
    -- draw a curve using the points as argument to love.graphics.points function
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(points)
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
