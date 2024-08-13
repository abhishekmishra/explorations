--- main.lua: Text Editor in LÖVE
-- date: 6/4/2024
-- author: Abhishek Mishra
---@diagnostic disable: duplicate-set-field

local Class = require'middleclass'
local nl = require'ne0luv'
local Panel = nl.Panel
local Rect = nl.Rect

-- The TextEditor panel class
local TextEditor = Class('TextEditor', Panel)

--- TextEditor:initialize: Constructor for TextEditor
function TextEditor:initialize(r, text)
    Panel.initialize(self, r)
    self.text = text or ''
    self.cursor = 1

    -- the love2d text object
    self.font = love.graphics.newFont(16)
    love.graphics.setFont(self.font)
    self.textDisplay = love.graphics.newText(self.font, self.text)
end

--- TextEditor:insert: Insert text at the cursor position
function TextEditor:insert(text)
    local start = self.text:sub(1, self.cursor)
    local finish = self.text:sub(self.cursor + 1)
    self.text = start .. text .. finish
    self.cursor = self.cursor + #text
    self.textDisplay:set(self.text)
end

--- TextEditor:replace: Replace text at the cursor position
function TextEditor:replace(text)
    local start = self.text:sub(1, self.cursor)
    local finish = self.text:sub(self.cursor + 1 + #text)
    self.text = start .. text .. finish
    self.textDisplay:set(self.text)
end

--- TextEditor:delete: Delete text at the cursor position
function TextEditor:delete()
    if #self.text == 0 then
        return
    end
    if #self.text > self.cursor then
        local start = self.text:sub(1, self.cursor - 1)
        local finish = self.text:sub(self.cursor + 1)
        self.text = start .. finish
        self.textDisplay:set(self.text)
    end
end

--- TextEditor:setText: Set the text of the TextEditor
function TextEditor:setText(text)
    self.text = text
    self.cursor = 1
    self.textDisplay:set(self.text)
end

--- TextEditor:draw: Draw the TextEditor
function TextEditor:draw()
    love.graphics.setColor(1, 0, 0)
    -- get rectangle width and figure out the number of lines of text to print
    -- based on the font height and width
    local width = self.rect:getWidth()
    local height = self.font:getHeight()
    -- split the text at the point of word wrap and draw each line
    local x = self.rect.pos.x
    local y = self.rect.pos.y
    local currentLine = ""
    for word in self.text:gmatch("%S+") do
        -- if currentLine is not empty, add a space before the word
        if currentLine ~= "" then
            word = " " .. word
        end
        local testLine = currentLine .. word
        if self.font:getWidth(testLine) < width then
            currentLine = testLine
        else
            love.graphics.print(currentLine, x, y)
            y = y + height
            currentLine = word
        end
    end

    -- love.graphics.draw(self.textDisplay, self.rect.pos.x, self.rect.pos.y)

    -- print the rectangle position at the bottom right of the panel
    -- love.graphics.setColor(0, 0, 1)
    -- love.graphics.print("x = " .. self.rect.pos.x .. ", y = " .. self.rect.pos.y, self.rect.pos.x, self.rect.pos.y + 100)

    -- blink the cursor
    if math.floor(love.timer.getTime() * 2) % 2 == 0 then
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(0, 0, 0)
    end
    -- draw the cursor
    local x = self.rect.pos.x
    local y = self.rect.pos.y
    love.graphics.line(x, y, x, y + self.font:getHeight())
end

local textEditor = TextEditor(Rect(10, 10, 380, 380))

--- love.load: Called once at the start of the simulation
function love.load()
    textEditor:setText [[lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua]]
    -- textEditor:delete()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    textEditor:draw()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
