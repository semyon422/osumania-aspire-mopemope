round = function(x, to)
	return (x % 1 < 0.5 and math.floor(x) or math.ceil(x))
end

-- math.sign = function(x)
-- 	return x == 0 and 0 or x / abs(x)
-- end

-- math.belong = function(x, a, b)
-- 	return a <= x and x <= b
-- end

map = function(x, a, b, c, d)
	return (x - a) * (d - c) / (b - a) + c
end

local notesLine = "00:46:180 (46180|2,47380|0,48580|1,49780|2) - "
local notes = {}
for time, col in notesLine:gmatch("(%d+)|(%d+)") do
	notes[#notes + 1] = {
		startTime = time,
		column = col + 1
	}
end

local baseBeatLength = 300

local n, t

local process = function()
	n, t = {}, {}

	--[[ -- working version

	local startBpm = 30000
	local endBpm = 0.001

	local nbpm = startBpm -- counter, position
	local d2  -- slowness speed
	d2 = (startBpm - endBpm) / ((notes[#notes - 1].startTime - notes[1].startTime) * 60000 / baseBeatLength)

	for i = 1, #notes do
		local note = notes[i]
		local nextNote = notes[i + 1]

		if i ~= 1 then
			local beatLength = 60000 / nbpm
			t[#t + 1] = note.startTime - 1 .. "," .. beatLength .. ",4,2,0,20,1,0"

			if nextNote then
				local dt = nextNote.startTime - note.startTime
				nbpm = nbpm - d2 * dt * 60000 / baseBeatLength
			end
		end

		t[#t + 1] = note.startTime .. "," .. 0.001 .. ",4,2,0,20,1,0"
		if nextNote then
			t[#t + 1] = (note.startTime + 1) .. "," .. baseBeatLength / d2 .. ",4,2,0,20,1,0"
		else
			t[#t + 1] = (note.startTime + 1) .. "," .. baseBeatLength .. ",4,2,0,20,1,0"
		end
	end
	]]

	local startBpm = 60000
	local endBpm = 0.001

	local nbpm = startBpm -- counter, position
	local d2  -- slowness speed
	d2 = (startBpm - endBpm) / ((notes[#notes - 1].startTime - notes[1].startTime) * 60000 / baseBeatLength)

	for i = 1, #notes do
		local note = notes[i]
		local nextNote = notes[i + 1]

		if i ~= 1 then
			local beatLength = 60000 / nbpm

			-- some barlines
			t[#t + 1] = note.startTime - 10 .. "," .. baseBeatLength .. ",4,2,0,20,1,0"
			t[#t + 1] = note.startTime - 8 .. "," .. baseBeatLength .. ",4,2,0,20,1,0"
			t[#t + 1] = note.startTime - 6 .. "," .. baseBeatLength .. ",4,2,0,20,1,0"
			t[#t + 1] = note.startTime - 4 .. "," .. baseBeatLength .. ",4,2,0,20,1,0"

			t[#t + 1] = note.startTime - 2 .. "," .. beatLength .. ",4,2,0,20,1,0"

			if nextNote then
				local dt = nextNote.startTime - note.startTime
				nbpm = nbpm - d2 * dt * 60000 / baseBeatLength
			end
		end

		t[#t + 1] = note.startTime - 1 .. "," .. 0.001 .. ",4,2,0,20,1,0"
		if nextNote then
			t[#t + 1] = (note.startTime + 1) .. "," .. baseBeatLength / d2 .. ",4,2,0,20,1,0"
		else
			t[#t + 1] = (note.startTime + 1) .. "," .. baseBeatLength .. ",4,2,0,20,1,0"
		end

		for j = 1, 4 do
			if note.column ~= j then
				n[#n + 1] = {
					note.startTime - 1,
					64 + 512 / 4 * (j - 1) .. ",192,NaN,128,0," .. note.startTime - 1 .. ":0:0:0:0:"
				}
			end
		end
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
