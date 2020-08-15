-- math.round = function(x, to)
-- 	to = to or 1
-- 	return ((x / to) % 1 < 0.5 and floor(x / to) or ceil(x / to)) * to
-- end

-- math.sign = function(x)
-- 	return x == 0 and 0 or x / abs(x)
-- end

-- math.belong = function(x, a, b)
-- 	return a <= x and x <= b
-- end
local TinyParser = require("TinyParser")

map = function(x, a, b, c, d)
	return (x - a) * (d - c) / (b - a) + c
end

local getNotes = function()
	local n = {}

	return n
end

local timings = 
[[]]

local getTimings = function()

	local mapf = io.open("LeaF - Mopemope/LeaF - Mopemope (semyon422) [barlines].osu", "r")
	local maps = mapf:read("*all")
	mapf:close()

	local map = TinyParser:new()
	map:import(maps)

	local mapf2 = io.open("LeaF - Mopemope/LeaF - Mopemope (semyon422) [prebarlines].osu", "r")
	local maps2 = mapf2:read("*all")
	mapf2:close()

	local map2 = TinyParser:new()
	map2:import(maps2)

	local t = {}

	for _, note in ipairs(map.notes) do
		for ti = note.startTime + 1, note.startTime + 1 + 2 * 2 * 2 ^ (4 - note.column), 2 do
			t[#t + 1] = ti .. ",300,4,2,0,20,1,0"
		end
	end

	for _, note in ipairs(map2.notes) do
		for ti = note.startTime - 1, note.startTime + 1 + 2 * 2 * 2 ^ (4 - note.column), -2 do
			t[#t + 1] = ti .. ",300,4,2,0,20,1,0"
		end
	end

	return table.concat(t, "\n") .. "\n"
end

return {
	getNotes = getNotes,
	getTimings = getTimings
}
