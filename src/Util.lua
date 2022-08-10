--[[
    Some Helper functions
]]

function table.slice(tbl, first, last, step)
    local sliced = {}
    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

function table.randomChoice(tbl) --returns single random element in tbl
    local choice = tbl[math.random(#tbl)]
    return choice
        
    
end