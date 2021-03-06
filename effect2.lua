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

	n[#n + 1] = {55921, 64 + 512 / 4 * (2 - 1) .. ",192,NaN,128,0," .. 55921 .. ":0:0:0:0:"}
	n[#n + 1] = {55923, 64 + 512 / 4 * (1 - 1) .. ",192,NaN,128,0," .. 55923 .. ":0:0:0:0:"}
	n[#n + 1] = {55925, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 55925 .. ":0:0:0:0:"}
	n[#n + 1] = {55927, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 55927 .. ":0:0:0:0:"}
	n[#n + 1] = {55928, 64 + 512 / 4 * (4 - 1) .. ",192,NaN,128,0," .. 55928 .. ":0:0:0:0:"}
	n[#n + 1] = {55929, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 55929 .. ":0:0:0:0:"}

	n[#n + 1] = {56370, 64 + 512 / 4 * (1 - 1) .. ",192,NaN,128,0," .. 56370 .. ":0:0:0:0:"}

	n[#n + 1] = {56372, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 56372 .. ":0:0:0:0:"}
	n[#n + 1] = {56374, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 56374 .. ":0:0:0:0:"}
	n[#n + 1] = {56375, 64 + 512 / 4 * (4 - 1) .. ",192,NaN,128,0," .. 56375 .. ":0:0:0:0:"}
	n[#n + 1] = {56376, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 56376 .. ":0:0:0:0:"}
	n[#n + 1] = {56377, 64 + 512 / 4 * (2 - 1) .. ",192,NaN,128,0," .. 56377 .. ":0:0:0:0:"}

	n[#n + 1] = {56521, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 56521 .. ":0:0:0:0:"}
	n[#n + 1] = {56523, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 56523 .. ":0:0:0:0:"}
	n[#n + 1] = {56524, 64 + 512 / 4 * (4 - 1) .. ",192,NaN,128,0," .. 56524 .. ":0:0:0:0:"}
	n[#n + 1] = {56525, 64 + 512 / 4 * (3 - 1) .. ",192,NaN,128,0," .. 56525 .. ":0:0:0:0:"}
	n[#n + 1] = {56526, 64 + 512 / 4 * (2 - 1) .. ",192,NaN,128,0," .. 56526 .. ":0:0:0:0:"}



	return n
end


local getTimings = function()
	local t = {}

	-- 2 is a half of beat
	t[#t + 1] = "55920,2,4,2,0,20,1,0"
	t[#t + 1] = "55930,0.001,4,2,0,20,1,0" -- 00:55:930 (55930|2) - 
	t[#t + 1] = "55931,300,4,2,0,20,1,0"


	t[#t + 1] = "56370,2,4,2,0,20,1,0"
	t[#t + 1] = "56380,0.001,4,2,0,20,1,0" -- 00:56:380 (56380|0) - 
	t[#t + 1] = "56381,300,4,2,0,20,1,0"


	t[#t + 1] = "56520,0.2,2,2,0,20,1,0"
	t[#t + 1] = "56520,-1000,4,2,0,20,0,0"
	t[#t + 1] = "56530,0.001,4,2,0,20,1,0" -- 00:56:530 (56530|0) - 
	t[#t + 1] = "56531,300,4,2,0,20,1,0"

	return table.concat(t, "\n") .. "\n"
end

return {
	getNotes = getNotes,
	getTimings = getTimings
}
