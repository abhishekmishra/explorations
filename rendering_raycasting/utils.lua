--- utils.lua - some utility functions
--
-- date: 02/05/2024
-- author: Abhishek Mishra

--- A helper function to map a function over a table
--
-- see https://en.wikipedia.org/wiki/Map_(higher-order_function)
-- see https://stackoverflow.com/a/11671820
--
-- @param tbl (table) - the table to map over
-- @param f (function) - the function to apply to each element
-- @return (table) - the new table with the function applied to each element
local function map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

--- mapRange: A helper function to map a number from one range to another.
-- This is equivalent to the map function from the p5.js library.
-- see https://p5js.org/reference/#/p5/map
--
-- @param n (number) - the number to map
-- @param start1 (number) - the start of the current range
-- @param stop1 (number) - the end of the current range
-- @param start2 (number) - the start of the new range
-- @param stop2 (number) - the end of the new range
-- @param withinBounds (boolean) - whether to clamp the value within the new range
-- @return (number) - the mapped number
local function mapRange(n, start1, stop1, start2, stop2, withinBounds)
    local newval = (n - start1) / (stop1 - start1) * (stop2 - start2) + start2
    if not withinBounds then
        return newval
    end
    if start2 < stop2 then
        return math.max(math.min(newval, stop2), start2)
    else
        return math.max(math.min(newval, start2), stop2)
    end
end

return {
    map = map,
    mapRange = mapRange
}
