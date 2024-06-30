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
    love.graphics.draw(self.textDisplay, self.rect.pos.x, self.rect.pos.y)

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
    textEditor:delete()
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
