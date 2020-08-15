local json = require("json")

local inf = io.open("out.json", "r")
local content = inf:read("*all")
inf:close()

local jsonData = json.decode(content)

local outf = io.open("seq.txt", "w")

local offset = 0
for _, data in ipairs(jsonData.replay_data) do
	offset = offset + data.timeSinceLastAction
	if data.keysPressed["Key1"] then
		outf:write("1")
	end
	if data.keysPressed["Key2"] then
		outf:write("2")
	end
	if data.keysPressed["Key3"] then
		outf:write("3")
	end
	if data.keysPressed["Key4"] then
		outf:write("4")
	end
end
outf:close()