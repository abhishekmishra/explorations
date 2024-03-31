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

--- Check if a point is inside the rectangle
-- Accepts the point only if it is on or inside the boundary of the rectangle on 
-- the left and top sides, and inside the boundary on the right and bottom sides
--
-- @param point: The point to check
-- @return: True if the point is inside the rectangle, false otherwise
function Rectangle:contains(point)
    return point.x >= self.x - self.w and point.x < self.x + self.w and
        point.y >= self.y - self.h and point.y < self.y + self.h
end

-- QuadTree Class
local QuadTree = Class('QuadTree')

-- Constructor
function QuadTree:initialize(boundary, capacity)
    self.boundary = boundary
    self.capacity = capacity
    self.points = {}
    self.divided = false
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

    self.divided = true
end

-- Insert a point into the QuadTree
function QuadTree:insert(point)
    if not self.boundary:contains(point) then
        return
    end

    if #self.points < self.capacity then
        table.insert(self.points, point)
    else
        if not self.divided then
            self:subdivide()
        end

        self.northeast:insert(point)
        self.northwest:insert(point)
        self.southeast:insert(point)
        self.southwest:insert(point)
    end
end

-- Draw the QuadTree
function QuadTree:draw(drawPoints)
    local drawPoints = drawPoints or false

    love.graphics.rectangle('line', self.boundary.x - self.boundary.w,
        self.boundary.y - self.boundary.h, self.boundary.w * 2,
        self.boundary.h * 2)

    if self.divided then
        self.northeast:draw(drawPoints)
        self.northwest:draw(drawPoints)
        self.southeast:draw(drawPoints)
        self.southwest:draw(drawPoints)
    end

    if drawPoints then
        for _, point in ipairs(self.points) do
            love.graphics.points(point.x, point.y)
        end
    end
end

modules.Rectangle = Rectangle
modules.QuadTree = QuadTree

return modules
