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
local map5f = io.open("LeaF - Mopemope/LeaF - Mopemope (semyon422) [effectLast].osu", "r")
local map5s = map5f:read("*all")
map5f:close()

local map5 = TinyParser:new()
map5:import(map5s)

-- 01:49:405 (109405|3) - 01:49:630 (109630|0) -  ln
local process = function()
	n, t = {}, {}

	-- t[#t + 1] = 109405 .. ",0.001,4,2,0,20,1,0"
	-- t[#t + 1] = 109405 + 1 .. ",6000000,4,2,0,20,1,0"
	
	t[#t + 1] = 109405 - 1 .. ",1.333333,4,2,0,20,1,0"
	t[#t + 1] = 109405 .. ",6,4,2,0,20,1,0"

	local dt = 0
	for i = #map5.notes, 1, -1  do
		local note = map5.notes[i]
		n[#n + 1] = {
			109405 + dt,
			64 + 512 / 4 * (note.column - 1) .. ",192,NaN,128,0," .. (109405 + dt) .. ":0:0:0:0:"
		}
		dt = dt + 1
		-- print(time2 - backDelta + 1 + j)
	end
	-- t[#t + 1] = 109405 + 8 .. ",0.001,4,2,0,20,1,0"
	-- t[#t + 1] = 109405 + 9 .. ",6000000,4,2,0,20,1,0"
	t[#t + 1] = 109405 + 8 .. ",16,4,2,0,20,1,0"
	for i = 109405 + 9, 109630 - 2, 2 do
		t[#t + 1] = i .. "," .. map(i, 109405 + 9, 109630 - 2, 16, 8) .. ",4,2,0,20,1,0"
	end

	local c = 1
	for u = 1, #map5.notes do
		local note1 = map5.notes[u]
		local note2 = map5.notes[u + 1]

		local time1 = note1.startTime
		local time2 = note2 and note2.startTime or note1.startTime + 300 / 4
		-- print("time 1 2", time1, time2)

		t[#t + 1] = time1 .. ",0.001,4,2,0,20,1,0"
		t[#t + 1] = time1 + 1 .. ",6000000,4,2,0,20,1,0"
		
		local backDelta = 10 - c + 1
		t[#t + 1] = time2 - backDelta .. "," .. 6 / (c + 0) .. ",4,2,0,20,1,0"

		local j = 0
		for i = #map5.notes, c, -1  do
			local note = map5.notes[i]
			n[#n + 1] = {
				time2 - backDelta + 1 + j,
				64 + 512 / 4 * (note.column - 1) .. ",192,NaN,128,0," .. (time2 - backDelta + 1 + j) .. ":0:0:0:0:"
			}
			t[#t + 1] = (time2 - backDelta + 1 + j) .. "," .. 6 .. ",4,2,0,20,1,0"
			j = j + 1
			-- print(time2 - backDelta + 1 + j)
		end
		-- print(1111111111, time2 - 1)
		-- t[#t + 1] = time2 - 1 .. "," .. 300 .. ",4,2,0,20,1,0"

		-- t[#t + 1] = time + c .. ",0.001,4,2,0,20,1,0"
		-- t[#t + 1] = time + c + 1 .. ",300,4,2,0,20,1,0"
		c = c + 1
	end
	t[#t + 1] = map5.notes[#map5.notes].startTime + 300 .. "," .. 300 .. ",4,2,0,20,1,0"
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
