--- main.lua: Lissajous Curves Simulation in LÖVE
-- date: 29/5/2024
-- author: Abhishek Mishra

local nl = require('ne0luv')


local cw, ch
local layout


function love.load()
    cw, ch = love.graphics.getDimensions()
    layout = nl.Layout(nl.Rect(0, 0, cw, ch), {
        layout = 'column',
    })

    local topRow = nl.Layout(nl.Rect(0, 0, cw, ch/8), {
        layout = 'row',
        bgColor = {0, 1, 0, 1}
    })

    local rowCirclesPanel = nl.Layout(nl.Rect(0, 0, 7 * cw/8, ch/8), {
        layout = 'row',
        bgColor = {0, 0, 1, 1}
    })

    topRow:addChild(nl.Layout(nl.Rect(0, 0, cw/8, ch/8), {
        bgColor = {0, 0, 0, 0.1}
    }))

    topRow:addChild(rowCirclesPanel)

    local bottomRow = nl.Layout(nl.Rect(0, ch/8, cw, 7 * ch/8), {
        layout = 'row',
        bgColor = {1, 0, 1, 1}
    })

    local colCirclesPanel = nl.Layout(nl.Rect(0, 0, cw/8, 7 * ch/8), {
        layout = 'column',
        bgColor = {1, 1, 1, 0.8}
    })

    local curvesPanel = nl.Layout(nl.Rect(0, 0, 7 * cw/8, 7 * ch/8), {
        layout = 'column',
        bgColor = {1, 0, 0, 0.4}
    })

    bottomRow:addChild(colCirclesPanel)
    bottomRow:addChild(curvesPanel)

    layout:addChild(topRow)
    layout:addChild(bottomRow)
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

