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

local mapEF5f = io.open("LeaF - Mopemope/LeaF - Mopemope (semyon422) [effect7].osu", "r")
local mapEF5s = mapEF5f:read("*all")
mapEF5f:close()

local mapEF5 = TinyParser:new()
mapEF5:import(mapEF5s)

-- 01:29:380 (89380|1) - 

local process = function()
	n, t = {}, {}

	for i = 2, #mapEF5.notes do
		local note1 = mapEF5.notes[i]
		local note0 = mapEF5.notes[i - 1]
		-- t[#t + 1] = time .. ",0.001,4,2,0,20,1,0"
		local time = note0.endTime + 16 -- !!!!!!!!!!!!!! (time + c - note1.startTime)
		-- print("time", time)

		local c = 0
		local lastTime = time
		local visualDelta = 0
		for _, note in ipairs(map5.notes) do
			if note.startTime > note1.startTime and note.startTime < note1.startTime + 149 then
				-- print("note", note.startTime)
				if note.startTime ~= lastTime then
					c = c + 1
					-- print("timing at", time + c - 1)
					t[#t + 1] = (time + c - 1) .. "," .. (300 / (note.startTime - lastTime)) .. ",4,2,0,20,1,0"
					visualDelta = visualDelta + note.startTime - lastTime
					lastTime = note.startTime
				end
				-- print("note at", time + c)
				n[#n + 1] = {
					time + c,
					64 + 512 / 4 * (note.column - 1) .. ",192,NaN,128,0," .. (time + c) .. ":0:0:0:0:"
				}
			end
		end
		t[#t + 1] = time + c .. "," .. (300 / (150 - visualDelta)) .. ",4,2,0,20,1,0"
		t[#t + 1] = time + c + 1 .. ",6000000,4,2,0,20,1,0"
		
		local time = note1.startTime
		local c = 0
		local lastTime = note1.startTime + 150
		for _, note in ipairs(map5.notes) do
			if note.startTime > note1.startTime + 151 and note.startTime < time + 150 + 302 then
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
