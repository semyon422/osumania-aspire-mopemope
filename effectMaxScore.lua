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

	
	local playableObjects = 365
	local currentObjects = 4586
	local trargetScore = 50000

	local addObjects = playableObjects / trargetScore * 1000000 - currentObjects

	for i = 1, addObjects do
		n[#n + 1] = {0, math.random(0, 512) .. ",192,NaN,128,0,NaN:0:0:0:0:"}
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
