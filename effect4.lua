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

local process = function()
	n, t = {}, {}

	-- 00:59:980 (59980|0,60580|3) - 
	-- effect3 ends at 59986 !!!

	-- notes: 00:59:980 (59980|0,60180|1,60380|2,60580|3) - 2/3 of beat
	local startTime = 59990
	local endTime = 60580
	local dt = 10

	local bo = 5
	for ti = startTime, startTime + (endTime - startTime) / 3 - dt, dt do
		t[#t + 1] = ti .. ",0.001,4,2,0,20,1,0"
		t[#t + 1] = ti + 1 .. ",6000000,4,2,0,20,1,0"

		local bl = 60000 / map(ti, startTime, startTime + (endTime - startTime) / 3, 0.001, 40000)
		local time11 = ti + dt - bo
		local time12 = time11 + 1
		t[#t + 1] = time11 .. "," .. bl .. ",4,2,0,20,1,0"
		t[#t + 1] = time12 .. ",1.5,4,2,0,20,1,0"
		n[#n + 1] = {
			time12,
			64 + 512 / 4 * (1 - 1) .. ",192,NaN,128,0," .. time12 .. ":0:0:0:0:"
		}
	end

	for ti = startTime + (endTime - startTime) / 3, startTime + 2 * (endTime - startTime) / 3 - dt, dt do
		t[#t + 1] = ti .. ",0.001,4,2,0,20,1,0"
		t[#t + 1] = ti + 1 .. ",6000000,4,2,0,20,1,0"

		local bl = 60000 / map(ti, startTime + (endTime - startTime) / 3, startTime + 2 * (endTime - startTime) / 3, 0.001, 40000)
		local time11 = ti + dt - bo
		local time12 = time11 + 1
		t[#t + 1] = time11 .. "," .. bl .. ",4,2,0,20,1,0"
		t[#t + 1] = time12 .. ",1.5,4,2,0,20,1,0"
		n[#n + 1] = {
			time12,
			64 + 512 / 4 * (2 - 1) .. ",192,NaN,128,0," .. time12 .. ":0:0:0:0:"
		}
		n[#n + 1] = {
			time12 + 1,
			64 + 512 / 4 * (1 - 1) .. ",192,NaN,128,0," .. time12 + 1 .. ":0:0:0:0:"
		}
	end

	for ti = startTime + 2 * (endTime - startTime) / 3, endTime - dt, dt do
		t[#t + 1] = ti .. ",0.001,4,2,0,20,1,0"
		t[#t + 1] = ti + 1 .. ",6000000,4,2,0,20,1,0"

		local bl = 60000 / map(ti, startTime + 2 * (endTime - startTime) / 3, endTime, 0.001, 40000)
		local time11 = ti + dt - bo
		local time12 = time11 + 1
		t[#t + 1] = time11 .. "," .. bl .. ",4,2,0,20,1,0"
		t[#t + 1] = time12 .. ",1.5,4,2,0,20,1,0"
		n[#n + 1] = {
			time12,
			64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. time12 .. ":0:0:0:0:"
		}
		n[#n + 1] = {
			time12 + 1,
			64 + 512 / 4 * (2 - 1) .. ",192,NaN,128,0," .. time12 + 1 .. ":0:0:0:0:"
		}
		n[#n + 1] = {
			time12 + 2,
			64 + 512 / 4 * (1 - 1) .. ",192,NaN,128,0," .. time12 + 2 .. ":0:0:0:0:"
		}
	end

	t[#t + 1] = endTime .. ",300,4,2,0,20,1,0"
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
