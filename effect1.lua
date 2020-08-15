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

local getNotes = function()
	local n = {}
	
	--first fake note
	n[#n + 1] = {45579, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 45579 .. ":0:0:0:0:"}
	n[#n + 1] = {45954, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 45954 .. ":0:0:0:0:"}

	for i = 0, 15 do
		for j = 1, 2 do
			n[#n + 1] = {45655 + i, 64 + 512 / 4 * (j - 1) .. ",192,NaN,128,0," .. 45655 + i .. ":0:0:0:0:"}
		end
	end
	for i = 0, 15 do
		for j = 3, 4 do
			n[#n + 1] = {45730 + i, 64 + 512 / 4 * (j - 1) .. ",192,NaN,128,0," .. 45730 + i .. ":0:0:0:0:"}
		end
	end
	for i = 0, 15 do
		for j = 1, 4 do
			n[#n + 1] = {46163 + i, 64 + 512 / 4 * (j - 1) .. ",192,NaN,128,0," .. 46163 + i .. ":0:0:0:0:"}
		end
	end

	local dt = 30
	-- long note 00:49:780 (49780|3) - to 00:50:680 (50680|0) - 
	local startTime = 49780
	local curTime = 49780
	while curTime <= 50680 do
		n[#n + 1] = {
			math.floor(curTime),
			64 + 512 / 4 * (4 - 1) .. ",192,NaN,128,0," .. math.floor(curTime) .. ":0:0:0:0:"
		}

		local sum = 0
		for ti = curTime, curTime + dt - 5, 5 do
			sum = sum + 5 / map(math.cos(map(ti, 49780, 50680, 0, math.pi)), 1, -1, 0.1, 2)
		end

		curTime = curTime + sum
	end

	return n
end

local getTimings = function()
	local t = {}

	-- first fake note, 2 beats later
	t[#t + 1] = "45578,0.5,4,2,0,20,1,0"

	t[#t + 1] = "45580,0.001,4,2,0,20,1,0" -- 00:45:580 (45580|0) - 
	t[#t + 1] = "45581,60000000,4,2,0,20,1,0"

	t[#t + 1] = "45655,3,4,2,0,20,1,0" -- 00:45:655 (45655|1) - 
	t[#t + 1] = "45661,0.001,4,2,0,20,1,0"
	t[#t + 1] = "45662,60000000,4,2,0,20,1,0"

	t[#t + 1] = "45730,3,4,2,0,20,1,0" -- 00:45:730 (45730|1) - 
	t[#t + 1] = "45746,0.001,4,2,0,20,1,0"
	t[#t + 1] = "45747,300,4,2,0,20,1,0"

	-- here is break, show first fake note
	-- 00:45:955 (45955|1) - 
	t[#t + 1] = "45953,1.333333,4,2,0,20,1,0"

	t[#t + 1] = "45955,0.001,4,2,0,20,1,0" -- 00:45:955 (45955|0) - 
	t[#t + 1] = "45956,60000000,4,2,0,20,1,0"

	t[#t + 1] = "46163,3,4,2,0,20,1,0" -- 00:46:180 (46180|0) - 
	t[#t + 1] = "46179,0.001,4,2,0,20,1,0"
	t[#t + 1] = "46180,300,4,2,0,20,1,0"

	-- sv 0.5
	-- t[#t + 1] = "46180,-200,4,2,0,20,0,0"

	-- 00:49:780 (49780|3) - 
	for ti = 49780, 50680 - 1, 5 do
		t[#t + 1] = ti .. "," .. -100 / map(math.cos(map(ti, 49780, 50680, 0, math.pi)), 1, -1, 0.1, 2) .. ",4,2,0,20,0,0"
	end


	-- t[#t + 1] = "50680,0.001,4,2,0,20,1,0" -- 00:50:680 (50680|0) - 
	-- t[#t + 1] = "50681,300,4,2,0,20,1,0"
	-- t[#t + 1] = "50681,-100,4,2,0,20,0,0"

	
	t[#t + 1] = "50680,0.1,2,2,0,20,1,0"
	t[#t + 1] = "50680,-1000,4,2,0,20,0,0"
	t[#t + 1] = "50685,300,4,2,0,20,1,0"
	t[#t + 1] = "50685,-100,4,2,0,20,0,0"


	return table.concat(t, "\n") .. "\n"
end

return {
	getNotes = getNotes,
	getTimings = getTimings
}
