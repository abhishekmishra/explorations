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

    self.numDrops = math.random(1, self.numRows)

    self.drops = {}
    for i = 1, self.numDrops do
        table.insert(self.drops,
            RainDrop({
                x = self.x,
                y = (i - 1) * self.rowHeight,
                w = self.w,
                h = self.rowHeight,
                vx = 0,
                vy = self.vy
            }))
    end
end

function RainColumn:update(dt)
    for i, drop in ipairs(self.drops) do
        drop:update(dt)
    end
end

function RainColumn:draw()
    for i, drop in ipairs(self.drops) do
        drop:draw()
    end
end


return RainColumn
