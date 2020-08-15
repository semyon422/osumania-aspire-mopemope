require("aquastring")

local TinyParser = require("TinyParser")

local hf = io.open("header.osu", "r")
local header = hf:read("*all")
hf:close()

local tf = io.open("timing.osu", "r")
local timing = tf:read("*all")
tf:close()

local spinseqf = io.open("spinseq.txt", "r")
local spinseq = spinseqf:read("*all")
spinseqf:close()
local spinseqPos = 1
local spinseqMax = #spinseq

----------

local map1f = io.open("LeaF - Mopemope/LeaF - Mopemope (semyon422) [mope].osu", "r")
local map1s = map1f:read("*all")
map1f:close()

local map5f = io.open("LeaF - Mopemope/LeaF - Mopemope (semyon422) [bg].osu", "r")
local map5s = map5f:read("*all")
map5f:close()

----------------

local map1 = TinyParser:new()
map1:import(map1s)

local map5 = TinyParser:new()
map5:import(map5s)

-----------------

local effect1 = require("effect1")
local effect2 = require("effect2")
local effect3 = require("effect3")
local effect4 = require("effect4")
local effect5 = require("effect5")
local effect6 = require("effect6")
local effect7 = require("effect7")
local effectKyafa = require("effectKyafa")
local effectFinalBpm = require("effectFinalBpm")
local effectBarlines = require("effectBarlines")
local effectMaxScore = require("effectMaxScore")

--------------

local outf = io.open("LeaF - Mopemope/LeaF - Mopemope (semyon422) [mopemope].osu", "w")

outf:write(header)
outf:write("\n")

outf:write(require("events")())
outf:write("\n")

outf:write(timing)
outf:write("\n")

outf:write(effect1:getTimings())
outf:write(effect2:getTimings())
outf:write(effect3:getTimings())
-- outf:write(effect4:getTimings())
outf:write(effect5:getTimings())
outf:write(effect6:getTimings())
outf:write(effect7:getTimings())
outf:write(effectKyafa:getTimings())
outf:write(effectBarlines:getTimings())
outf:write(effectFinalBpm:getTimings())
-- outf:write(effectMaxScore:getTimings())
outf:write("\n")

outf:write("[HitObjects]")
outf:write("\n")

local notes = {}

for _, note in ipairs(effect1:getNotes()) do
	notes[#notes + 1] = note
end

for _, note in ipairs(effect2:getNotes()) do
	notes[#notes + 1] = note
end

for _, note in ipairs(effect3:getNotes()) do
	notes[#notes + 1] = note
end

-- for _, note in ipairs(effect4:getNotes()) do
-- 	notes[#notes + 1] = note
-- end

for _, note in ipairs(effect5:getNotes()) do
	notes[#notes + 1] = note
end

for _, note in ipairs(effect6:getNotes()) do
	notes[#notes + 1] = note
end

for _, note in ipairs(effect7:getNotes()) do
	notes[#notes + 1] = note
end

for _, note in ipairs(effectKyafa:getNotes()) do
	notes[#notes + 1] = note
end

for _, note in ipairs(effectFinalBpm:getNotes()) do
	notes[#notes + 1] = note
end

for _, note in ipairs(effectMaxScore:getNotes()) do
	notes[#notes + 1] = note
end

for _, note in ipairs(map1.notes) do
	notes[#notes + 1] = {
		note.startTime,
		table.concat(note.data, ",")
	}
end

local time16 = 300 / 16
for _, note in ipairs(map5.notes) do
	local data = note.data
	local data0 = note.data
	if false and data[5] == "8" then -- clap
		-- while true do
		-- 	local data = {data0[1], data0[2], data0[3], data0[4], data0[5], data0[6]}
		-- 	local needBreak = false
		-- 	if note.column == tonumber(spinseq:sub(spinseqPos, spinseqPos)) then
		-- 		--[[64,192,3575,12,0,NaN,0:0:0:0:]]
		-- 		-- data[4] = "12"
		-- 		data[6] = "NaN"
		-- 		data[7] = "0:0:0:0:"

		-- 		notes[#notes + 1] = {
		-- 			note.startTime,
		-- 			table.concat(data, ",")
		-- 		}
		-- 		needBreak = true
		-- 	else
		-- 		--[[64,192,NaN,12,0,4766,0:0:0:0:]]
		-- 		data[6] = data[3] - 1
		-- 		data[3] = "NaN"
		-- 		data[4] = "12"
		-- 		data[7] = "0:0:0:0:"

		-- 		notes[#notes + 1] = {
		-- 			note.startTime - 1,
		-- 			table.concat(data, ",")
		-- 		}
		-- 	end

		-- 	if spinseqPos == spinseqMax then
		-- 		error(note.startTime)
		-- 	end
		-- 	spinseqPos = spinseqPos + 1
		-- 	if needBreak then break end
		-- end
	elseif (data[5] == "0" or data[5] == "8") then
		data[6] = data[3] .. ":0:0:0:0:"
		data[3] = "NaN"
		data[4] = "128"

		local dt = time16
		if data[5] == "8" then
			dt = time16 / 4
			note.endTime = note.startTime + 8 * dt
		end

		if note.endTime then
			for t = note.startTime, note.endTime, dt do
				data[6] = math.floor(t) .. ":0:0:0:0:"
				notes[#notes + 1] = {
					note.startTime,
					table.concat(data, ",")
				}
			end
		else
			notes[#notes + 1] = {
				note.startTime,
				table.concat(data, ",")
			}
		end
	elseif data[5] == "2" then -- whistle
	end
end

table.sort(notes, function(a, b)
	return a[1] < b[1]
end)

for _, data in ipairs(notes) do
	outf:write(data[2])
	outf:write("\n")
end

outf:close()