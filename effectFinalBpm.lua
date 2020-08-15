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

	n[#n + 1] = {
		110402,
		64 + 512 / 4 * (4 - 1) .. ",192,NaN,128,0," .. (110501) .. ":0:0:0:0:"
	}

	return n
end

local getTimings = function()
	local t = {}
	 
	-- last note at 110171, timing at 110398
	
	t[#t + 1] = "110400,0.001,4,2,0,20,1,0"
	t[#t + 1] = "110401,-1e-50,4,2,0,20,1,0"

	return table.concat(t, "\n") .. "\n"
end

return {
	getNotes = getNotes,
	getTimings = getTimings
}
