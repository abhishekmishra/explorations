local Class = require 'middleclass'
local RainDrop = require 'raindrop'

local RainColumn = Class('RainColumn')

function RainColumn:initialize(config)
    self.x = config.x
    self.w = config.w
    self.h = config.h
    self.vy = config.vy
    self.numRows = config.numRows
    self.rowHeight = self.h/self.numRows

    self:initDrops()
end

function RainColumn:initDrops()
    self.numDrops = math.random(1, 2 * self.numRows)
    local colHeight = self.numDrops * self.rowHeight

    self.drops = {}
    for i = 1, self.numDrops do
        local dropConfig = {
                x = self.x,
                y = colHeight/2 - ((i - 1) * self.rowHeight),
                w = self.w,
                h = self.rowHeight,
                vx = 0,
                vy = self.vy
            }
        if i == 1 then
            dropConfig.color = {1, 1, 1, 1}
        end
        table.insert(self.drops,
            RainDrop(dropConfig))
    end
end

function RainColumn:update(dt)
    if not self:inFrame() then
        self:initDrops()
    end
    for i, drop in ipairs(self.drops) do
        drop:update(dt)
    end
end

function RainColumn:draw()
    for i, drop in ipairs(self.drops) do
        drop:draw()
    end
end

function RainColumn:inFrame()
    return self.drops[1]:inFrame(love.graphics.getDimensions())
end


return RainColumn
