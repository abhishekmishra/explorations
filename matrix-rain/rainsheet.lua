local Class = require 'middleclass'
local RainColumn = require 'raincolumn'

local RainSheet = Class('RainSheet')

function RainSheet:initialize(config)
    self.numCols = config.numCols
    self.numRows = config.numRows
    self.maxVy = config.maxVy
    self.cw = config.cw
    self.ch = config.ch

    self.colWidth = self.cw/self.numCols

    self.columns = {}
    for i = 1, self.numCols do
        local column = RainColumn({
            x = (i - 1) * self.colWidth,
            w = self.colWidth,
            h = self.ch,
            vy = math.random(1, self.maxVy),
            numRows = self.numRows
        })
        table.insert(self.columns, column)
    end
end

function RainSheet:update(dt)
    for _, column in ipairs(self.columns) do
        column:update(dt)
    end
end

function RainSheet:draw()
    for _, column in ipairs(self.columns) do
        column:draw()
    end
end


return RainSheet
