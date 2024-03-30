--- quadtree.lua: QuadTree Class
-- date: 30/3/2024
-- author: Abhishek Mishra

local Class = require('middleclass')

local modules = {}

-- A Rectangle class which is used to represent the boundaries of the QuadTree
-- The rectangle has a center position and a half-dimension (half-width and half-height)
local Rectangle = Class('Rectangle')

-- Constructor
function Rectangle:initialize(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

-- QuadTree Class
local QuadTree = Class('QuadTree')

-- Constructor
function QuadTree:initialize(boundary, capacity)
    self.boundary = boundary
    self.capacity = capacity
    self.points = {}
end

-- Subdivide the QuadTree into 4 sub-quadrants
function QuadTree:subdivide()
    local x = self.boundary.x
    local y = self.boundary.y
    local w = self.boundary.w
    local h = self.boundary.h

    local ne = Rectangle(x + w / 2, y - h / 2, w / 2, h / 2)
    self.northeast = QuadTree(ne, self.capacity)

    local nw = Rectangle(x - w / 2, y - h / 2, w / 2, h / 2)
    self.northwest = QuadTree(nw, self.capacity)

    local se = Rectangle(x + w / 2, y + h / 2, w / 2, h / 2)
    self.southeast = QuadTree(se, self.capacity)

    local sw = Rectangle(x - w / 2, y + h / 2, w / 2, h / 2)
    self.southwest = QuadTree(sw, self.capacity)
end

-- Insert a point into the QuadTree
function QuadTree:insert(point)
    if #self.points < self.capacity then
        table.insert(self.points, point)
    else
        self:subdivide()
    end
end

modules.Rectangle = Rectangle
modules.QuadTree = QuadTree

return modules