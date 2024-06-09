--- main.lua: Lissajous Curves Simulation in LÖVE
-- date: 29/5/2024
-- author: Abhishek Mishra

local nl = require('ne0luv')
local Class = require('middleclass')
local Curve = require('Curve')

local TextPanel = Class('TextPanel', nl.Panel)

function TextPanel:initialize(config)
    nl.Panel.initialize(self, nl.Rect(0, 0, config.w, config.h))
    self.text = config.text
    -- create love2d text object
    self.textObj = love.graphics.newText(love.graphics.getFont(), self.text)
end

function TextPanel:draw()
    love.graphics.setColor(1, 1, 1)
    -- draw the text in the center
    love.graphics.draw(
        self.textObj,
        self:getX() + self:getWidth() / 2 - self.textObj:getWidth() / 2,
        self:getY() + self:getHeight() / 2 - self.textObj:getHeight() / 2
    )
end


local cw, ch

local layout

-- see https://resources.pcb.cadence.com/blog/how-to-read-lissajous-curves-on-oscilloscopes
-- for decision on number of rows and columns
local NUM_ROWS = 8
local NUM_COLS = 5



function love.load()
    cw, ch = love.graphics.getDimensions()

    -- set a large font size
    love.graphics.setFont(love.graphics.newFont(14))

    layout = nl.Layout(nl.Rect(0, 0, cw, ch), {
        layout = "row",
        bgColor = { 1, 0, 0, 1 }
    })

    local leftColumn = nl.Layout(nl.Rect(0, 0, cw / (NUM_COLS + 1), ch), {
        layout = "column",
        bgColor = { 0, 0, 0, 1 }
    })

    local mainContent = nl.Layout(nl.Rect(0, 0, cw - cw / (NUM_COLS + 1), ch), {
        layout = "column",
        bgColor = { 0, 1, 0, 1 }
    })

    local rowHeight = ch / (NUM_ROWS + 1)
    local colWidth = NUM_COLS * (cw / (NUM_COLS + 1))

    local topRow = nl.Layout(nl.Rect(0, 0, colWidth, rowHeight), {
        layout = "row",
        bgColor = { 0, 0, 0, 1 }
    })

    mainContent:addChild(topRow)

    for i = 1, NUM_COLS do
        local tp = TextPanel({
            w = topRow:getWidth() / NUM_COLS,
            h = topRow:getHeight(),
            text = "      b = " .. tostring(i) .. "\ndelta = " .. tostring(i) .. " * pi/4"
        })
        topRow:addChild(tp)
    end

    leftColumn:addChild(TextPanel({
        w = leftColumn:getWidth(),
        h = leftColumn:getHeight() / (NUM_ROWS + 1),
        text = "A = " .. tostring(cw / 20) .. "\nB = " .. tostring(ch / 20)
    }))

    for i = 1, NUM_ROWS do
        local tp = TextPanel({
            w = leftColumn:getWidth(),
            h = leftColumn:getHeight() / (NUM_ROWS + 1),
            text = "a = " .. tostring(i)
        })
        leftColumn:addChild(tp)
    end

    for i = 1, NUM_ROWS do
        local row = nl.Layout(nl.Rect(0, 0, colWidth, rowHeight), {
            layout = "row",
            bgColor = { 0, 0.1, 0, 1 }
        })

        for j = 1, NUM_COLS do
            local c = Curve({
                w = row:getWidth() / NUM_COLS,
                h = row:getHeight(),
                A = cw / 20,
                B = ch / 20,
                a = i,
                b = j,
                delta = j * (math.pi / 4),
                NUM = 500
            })
            row:addChild(c)
        end

        mainContent:addChild(row)
    end

    layout:addChild(leftColumn)
    layout:addChild(mainContent)
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

