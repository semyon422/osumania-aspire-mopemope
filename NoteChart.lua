local NoteChart = {}

local NoteChart_metatable = {}
NoteChart_metatable.__index = NoteChart

NoteChart.new = function(self)
	local noteChart = {}

	noteChart.baseBPM = nil
	
	setmetatable(noteChart, NoteChart_metatable)
	
	return noteChart
end

local get_paths = function(path)
	local lineTable = path:gsub("\\", "/"):split("/")
	local mapFileName = lineTable[#lineTable]
	table.remove(lineTable, #lineTable)
	local folderPath = table.concat(lineTable, "/")
	
	return folderPath, mapFileName
end

NoteChart.appendOffset = 0

NoteChart.parse = function(self, filePath)
	self.filePath = filePath
	-- local file, err = io.open(filePath, "r")
	local file = love.filesystem.newFile(filePath)
	file:open("r")
	-- local content = file:read()
	-- file:close()
	if err then print(err) end
	self.noteData = {}
	self.timingData = {}
	self.eventData = {}

	self.currentBlockName = ""
	for line in file:lines() do
		if line:find("^%[") then
			self.currentBlockName = line:match("^%[(.+)%]")
		else
			if line:find("^%a+:.*$") then
				local key, value = line:match("^(%a+):%s?(.*)")
				if key == "CircleSize" then
					self.columnCount = tonumber(value)
				elseif key == "Version" then
					self.baseVersion = value
				elseif key == "AudioFilename" then
					self.audioFileName = value
				elseif key == "Title" then
					self.title = value
				end
			elseif self.currentBlockName == "Events" then
				if line:find("^%d-,%d-,\".+\"") then
					self.bgName = line:match("^.-,.-,\"(.+)\"")
				elseif line:find("^Sample,%d+,%d+,\".+\",%d+$") then
					local sample = {}
					sample.data = line:split(",")
					sample.startTime = tonumber(sample.data[2])
				
					table.insert(self.eventData, sample)
				end
			elseif self.currentBlockName == "TimingPoints" and line ~= "" then
				local timingPoint = {}
				
				local data = line:split(",")
				timingPoint.data = data
				timingPoint.line = line
				timingPoint.startTime = tonumber(data[1])
				
				table.insert(self.timingData, timingPoint)
			elseif self.currentBlockName == "HitObjects" and line ~= "" then
				local note = {}
				note.data = line:split(",")
				note.columnIndex = math.min(math.max(math.ceil(tonumber(note.data[1]) / 512 * self.columnCount), 1), self.columnCount)
				note.baseColumnIndex = note.columnIndex
				
				note.startTime = tonumber(note.data[3])
				note.endTime = note.startTime
				if bit.band(tonumber(note.data[4]), 128) == 128 then
					note.addition = note.data[6]:split(":")
					note.endTime = tonumber(note.addition[1])
					table.remove(note.addition, 1)
					note.addition = table.concat(note.addition, ":")
				end
				
				if note.startTime ~= note.endTime then
					self.long = true
				end
				
				table.insert(self.noteData, note)
			end
		end
	end
	file:close()
	
	table.sort(self.noteData, function(a, b) return a.startTime < b.startTime end)
	table.sort(self.timingData, function(a, b) return a.startTime < b.startTime end)
	self.noteCount = #self.noteData
	
	return self
end

NoteChart.export = function(self, filePath, audioName, data)
	local file = io.open(self.filePath, "r")
	
	local output = {}
	for line in file:lines() do
		if line:find("[TimingPoints]", 1, true) or line:find("[HitObjects]", 1, true) or line:find("//Storyboard Sound Samples", 1, true) then
			break
		elseif line:find("Version:", 1, true) then
			table.insert(output, "Version:" .. self.version)
		elseif line:find("AudioFilename:", 1, true) then
			table.insert(output, "AudioFilename: " .. audioName)
		else
			table.insert(output, line)
		end
	end
	file:close()
	
	for _, sample in ipairs(self.eventData) do
		table.insert(output, table.concat(sample.data, ","))
	end
	
	table.insert(output, "\n")
	table.insert(output, "[TimingPoints]")
	for _, timingPoint in ipairs(self.timingData) do
		if tonumber(timingPoint.data[7]) == 1 then
			timingPoint.data[1] = timingPoint.data[1] + self.offset
			table.insert(output, table.concat(timingPoint.data, ","))
			
			-- if self.baseBPM then
			-- 	timingPoint.data[7] = 0
			-- 	timingPoint.data[2] = -100 / (timingPoint.data[2] / 60000 * self.baseBPM)
			-- 	table.insert(output, table.concat(timingPoint.data, ","))
			-- end
		end
	end
	
	table.insert(output, "\n")
	table.insert(output, "[HitObjects]")
	local addition = "0:0:0:0:"
	for _, note in ipairs(self.noteData) do
		local x = math.floor((note.columnIndex - 0.5) * (512 / self.columnCount))
		
		note.startTime = note.startTime + self.offset
		note.endTime = note.endTime + self.offset
		if note.startTime ~= note.endTime then
			local data = note.data or {0, 0, 0, 128, 0, addition}
			local addition = note.addition or addition
			table.insert(output, table.concat({
				x, 192, math.floor(note.startTime), data[4], data[5], math.floor(note.endTime) .. ":" .. addition
			}, ","))
		else
			local data = note.data or {0, 0, 0, 1, 0, addition}
			table.insert(output, table.concat({
				x, 192, math.floor(note.startTime), data[4], data[5], data[6]
			}, ","))
		end
	end
	
	local file, err = io.open(filePath, "w")
	if err then print(err) end

	local chartString = table.concat(output, "\n")

	if not self.baseBPM then
		local NoteChartImporter = require("osu.NoteChartImporter")
		local nci = NoteChartImporter:new()
		local nc = nci:import(chartString)
		self.baseBPM = nci.primaryBPM
		assert(self.baseBPM)
		file:close()

		return self:export(filePath, audioName, data)
	end

	file:write(chartString)
	file:close()
	
	if self.writeAudio then
		local writer = wav.create_context("audio.wav", "w")
		writer.init(2, 44100, 16)
		writer.write_samples_interlaced2(self.csamples, self.n[1])
		writer.finish()
		
		local folderPath, mapFileName = get_paths(filePath)
		print("converting to ogg")
		local sox = io.popen("sox\\sox.exe \"audio.wav\" \"" .. folderPath .. "/" .. audioName .. "\"")
		while sox:read(1) ~= nil do end
	end
	
	return self
end

NoteChart.append = function(self, noteChart, data, i)
	local delay = data.delay
	local startTime = noteChart.noteData[1].startTime
	local endTime = noteChart.noteData[#noteChart.noteData].endTime
	local delayedStartTime = startTime - delay / 2 * 1000
	local delayedEndTime = endTime + delay / 2 * 1000
	self.appendOffset = self.appendOffset - delayedStartTime
	
	local offset = self.appendOffset
	
	for _, sample in ipairs(noteChart.eventData) do
		sample.data[2] = math.floor(sample.data[2] + offset)
		table.insert(self.eventData, sample)
	end
	
	for _, timingPoint in ipairs(noteChart.timingData) do
		timingPoint.data[1] = math.floor(timingPoint.data[1] + offset)
		table.insert(self.timingData, timingPoint)
	end
	
	for _, note in ipairs(noteChart.noteData) do
		note.startTime = note.startTime + offset
		note.endTime = note.endTime + offset
		table.insert(self.noteData, note)
	end
	
	self.appendOffset = self.appendOffset + (delayedEndTime - delayedStartTime)
	self.appendOffset = self.appendOffset + delayedStartTime
end

return NoteChart
