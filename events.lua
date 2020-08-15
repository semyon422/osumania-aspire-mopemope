local events1 = [[
[Events]
//Background and Video events
0,0,"background.jpg",0,0
//Break Periods]]

local events2 = [[
//Storyboard Layer 0 (Background)
//Storyboard Layer 1 (Fail)
//Storyboard Layer 2 (Pass)
//Storyboard Layer 3 (Foreground)
//Storyboard Layer 4 (Overlay)
//Storyboard Sound Samples
]]

-- 2,50879,54729

return function(map)
    local out = {}
    out[1] = events1

    
    -- for _, note in ipairs(map.notes) do
    --     out[#out + 1] = table.concat({2, note.startTime, note.endTime}, ",")
    -- end
    out[2] = "2,0,109779"

    out[#out + 1] = events2

    return table.concat(out, "\n")
end
