--- main.lua: Lissajous Curves Simulation in LÖVE
-- date: 29/5/2024
-- author: Abhishek Mishra

local nl = require('ne0luv')
local Circle = require('Circle')
local Curve = require('Curve')

local cw, ch

local layout

-- see https://resources.pcb.cadence.com/blog/how-to-read-lissajous-curves-on-oscilloscopes
-- for decision on number of rows and columns
local NUM_ROWS = 8
local NUM_COLS = 5

function love.load()
    cw, ch = love.graphics.getDimensions()

    layout = nl.Layout(nl.Rect(0, 0, cw, ch),{
        layout = "column",
        bgColor = {1, 0, 0, 1}
    })

    for i = 1, NUM_ROWS do
        local row = nl.Layout(nl.Rect(0, 0, cw, ch/NUM_ROWS), {
            layout = "row",
            bgColor = {0, 0.1, 0, 1}
        })

        for j = 1, NUM_COLS do
            local c = Curve({
                w = cw/NUM_COLS,
                h = ch/NUM_ROWS,
                A = cw/20,
                B = ch/20,
                a = i,
                b = j,
                delta = j * (math.pi / 4),
                NUM = 500
            })
            row:addChild(c)
        end

        layout:addChild(row)
    end
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
