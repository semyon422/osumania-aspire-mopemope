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

local notesLine = "00:56:680 (56680|2,56980|2,57130|3,57280|2,57430|1,57580|2,57880|0,58030|2,58180|3,58480|1,58630|0,58780|1,59080|3,59380|2,59680|1,59980|0,60580|3) - "
local notes = {}
for time, col in notesLine:gmatch("(%d+)|(%d+)") do
	notes[#notes + 1] = {
		startTime = time,
		column = col + 1
	}
end

local beatLength = 300
local visability = beatLength
local minDist = beatLength / 2

local n, t

local process = function()
	n, t = {}, {}

	for i = 1, #notes - 1 do
		local note = notes[i]

		-- 2 is a half of beat
		t[#t + 1] = note.startTime .. "," .. beatLength / minDist .. ",4,2,0,20,1,0"
		t[#t + 1] = (note.startTime + 5) .. ",0.001,4,2,0,20,1,0"
		t[#t + 1] = (note.startTime + 6) .. ",300,4,2,0,20,1,0"

		for j = i + 1, #notes do
			local nextNote = notes[j]

			local dt = nextNote.startTime - note.startTime
			if dt <= visability then
				local time = note.startTime + round(dt / minDist)
				n[#n + 1] = {
					time,
					64 + 512 / 4 * (nextNote.column - 1) .. ",192,NaN,128,0," .. time .. ":0:0:0:0:"
				}
			end
		end
	end

	t[#t + 1] = 59980 + 10 .. ",30,4,2,0,20,1,0" -- 00:59:980 (59980|0) - 
	t[#t + 1] = 59980 + 10 .. ",-1000,4,2,0,20,0,0"

	t[#t + 1] = 60580 .. ",0.1,4,2,0,20,1,0" -- 01:00:580 (60580|3) -  LN
	t[#t + 1] = 60580 .. ",-1000,4,2,0,20,0,0"
	t[#t + 1] = 60585 .. ",0.001,4,2,0,20,1,0"
	t[#t + 1] = 60586 .. ",300,4,2,0,20,1,0"
	
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
