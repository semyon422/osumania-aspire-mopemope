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

map = function(x, a, b, c, d)
	return (x - a) * (d - c) / (b - a) + c
end

local n, t

local TinyParser = require("TinyParser")
local map5f = io.open("LeaF - Mopemope/LeaF - Mopemope (semyon422) [bg].osu", "r")
local map5s = map5f:read("*all")
map5f:close()

local map5 = TinyParser:new()
map5:import(map5s)

local mapEF5f = io.open("LeaF - Mopemope/LeaF - Mopemope (semyon422) [effect5].osu", "r")
local mapEF5s = mapEF5f:read("*all")
mapEF5f:close()

local mapEF5 = TinyParser:new()
mapEF5:import(mapEF5s)

-- 01:29:380 (89380|1) - 

local process = function()
	n, t = {}, {}

	for _, note1 in ipairs(mapEF5.notes) do
		-- t[#t + 1] = time .. ",0.001,4,2,0,20,1,0"
		local time = note1.startTime
		-- print("time", time)

		local c = 0
		local lastTime = time
		for _, note in ipairs(map5.notes) do
			if note.startTime > time and note.startTime < time + 302 then
				-- print("note", note.startTime)
				if note.startTime ~= lastTime then
					c = c + 1
					-- print("timing at", time + c - 1)
					t[#t + 1] = (time + c - 1) .. "," .. (300 / (note.startTime - lastTime)) .. ",4,2,0,20,1,0"
					lastTime = note.startTime
				end
				-- print("note at", time + c)
				n[#n + 1] = {
					time + c,
					64 + 512 / 4 * (note.column - 1) .. ",192,NaN,128,0," .. (time + c) .. ":0:0:0:0:"
				}
			end
		end

		t[#t + 1] = time + c .. ",0.001,4,2,0,20,1,0"
		t[#t + 1] = time + c + 1 .. ",300,4,2,0,20,1,0"
	end

	t[#t + 1] = 98680 .. ",30,2,2,0,20,1,0" -- 01:38:680 (98680|0) - 
	t[#t + 1] = 98680 .. ",-1000,4,2,0,20,0,0"

	n[#n + 1] = { -- 01:38:980 (98980|3) - fake note
		98980 - 5,
		64 + 512 / 4 * (4 - 1) .. ",192,NaN,128,0," .. (98980 - 5) .. ":0:0:0:0:"
	}
	t[#t + 1] = (98980 - 5) .. ",0.1,2,2,0,20,1,0"
	t[#t + 1] = (98980 - 5) .. ",-1000,4,2,0,20,0,0"
	t[#t + 1] = (98980 - 1) .. ",0.001,4,2,0,20,1,0"
	t[#t + 1] = 98980 .. ",300,4,2,0,20,1,0"

	
end

local getNotes = function()
	if not n then process() end
	return n
end

local getTimings = function()
	if not n then process() end
	return table.concat(t, "\n") .. "\n"
end

return {
	getNotes = getNotes,
	getTimings = getTimings
}
