--- main.lua: Lissajous Curves Simulation in LÖVE
-- date: 29/5/2024
-- author: Abhishek Mishra

local nl = require('ne0luv')
local Circle = require('Circle')
local Curve = require('Curve')


local cw, ch

-- -- parameters for a lissajous curve
-- local A = 100
-- local B = 100
-- local a = 3
-- local b = 4
-- local delta = 1

-- local NUM = 100
-- -- stores NUM points of the curve
-- local points

-- local totalTime = 0

local layout

function love.load()
    cw, ch = love.graphics.getDimensions()

    layout = nl.Layout(nl.Rect(0, 0, cw, ch),{
        layout = "column",
        bgColor = {1, 0, 0, 1}
    })

    local c = Curve({
        w = cw,
        h = ch,
        A = cw/4,
        B = ch/4,
        a = 3,
        b = 4,
        delta = 1,
        NUM = 100
    })

    layout:addChild(c)
end

function love.update(dt)
    layout:update(dt)
end

function love.draw()
    layout:draw()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
