--- terrain.lua: Implements the Terrain class.
-- 
-- date: 17/11/2024
-- author: Abhishek Mishra
--
-- The terrain class is used to represent the a two dimensional terrain
-- with a height for each point.
-- 
-- Since the terrain is progressively generated, starting with the four corners,
-- then the middle of the four sides, and then the middle of the four new
-- squares, the terrain representation allows for infinite terrain generation.
--
-- The terrain class is thus defined as a tree node which can either be a leaf
-- node, or it can have four children, each of which is a terrain node.
--
-- The four children are named ne, nw, se, and sw, for the four cardinal
-- directions.

-- Imports
local class = require "middleclass"

-- Terrain class
local Terrain = class("Terrain")

-- Constructor
function Terrain:initialize(x, y, width, height, depth)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.depth = depth
    self.ne = nil
    self.nw = nil
    self.se = nil
    self.sw = nil
end

-- is leaf
function Terrain:is_leaf()
    return self.ne == nil
end

-- add midpoint to the terrain which creates four new children
-- only if the terrain is a leaf node
function Terrain:add_midpoint()
    if self:is_leaf() then
        local x = self.x
        local y = self.y
        local w = self.width
        local h = self.height
        local d = self.depth
        local nw = Terrain:new(x, y, w/2, h/2, d+1)
        local ne = Terrain:new(x+w/2, y, w/2, h/2, d+1)
        local sw = Terrain:new(x, y+h/2, w/2, h/2, d+1)
        local se = Terrain:new(x+w/2, y+h/2, w/2, h/2, d+1)
        self.ne = ne
        self.nw = nw
        self.se = se
        self.sw = sw
    end
end