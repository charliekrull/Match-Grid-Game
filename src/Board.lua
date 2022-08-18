--The arrangement of Orbs with which we must try to find matching sets of 3,
--vertically or horizontally

Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = y
    self.matches = {}

    self:initializeOrbs()
    

    self.highlightedOrb = self.orbs[1][1]
end

function Board:initializeOrbs()
    self.orbs = {}

    for orbY = 1, 8 do
    
        self.orbs[#self.orbs + 1] = {}

        for orbX = 1, 8 do
            --create a new orb at X, Y with random color and shape
            table.insert(self.orbs[orbY], Orb(orbX, orbY, math.random(6)))
        end
    end
end



function Board:render()
    for y = 1, #self.orbs do
        for x = 1, #self.orbs[1] do
            if self.orbs[y][x] ~= nil then
                self.orbs[y][x]:render(self.x, self.y)
            end
        end
    end
end

function Board:calculateMatches()
    local matches = {}
    --to count how many of the same block we've seen
    local matchNum = 1

    
    --horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.orbs[y][1].color 
        
            
        
        matchNum = 1

        for x = 2, 8 do
            if self.orbs[y][x].color == colorToMatch then
            
                matchNum = matchNum + 1

            else
                if matchNum >= 3 then
                    local match = {}
                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.orbs[y][x2])
                    end
                    table.insert(matches, match)


                
                end
                colorToMatch = self.orbs[y][x].color
                matchNum = 1
            end

            
        end
        --account for end of row matches
        if matchNum >= 3 then
            local match = {}

            --go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.orbs[y][x])
                
            end
            

            table.insert(matches, match)
        end
    end

    --Onto the vertical matches

    for x = 1, 8 do
        local colorToMatch = self.orbs[1][x].color

        

        matchNum = 1

        for y = 2, 8 do
            if self.orbs[y][x].color == colorToMatch then
                matchNum = matchNum + 1

            else
                
                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, - 1 do
                        table.insert(match, self.orbs[y2][x])
                    end
                    

                    table.insert(matches, match)
                end
                colorToMatch = self.orbs[y][x].color
                matchNum = 1
            end
        end
        
        if matchNum >= 3 then
            local match = {}

            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.orbs[y][x])
            end
        

            table.insert(matches, match)
        end
    end


    
    
    --store matches for future reference
    self.matches = matches

    return #self.matches > 0 and self.matches or false

end

function Board:removeMatches(scoreFlag)
    local points = 0
    local tweens = {}
    for k, match in pairs(self.matches) do
        for l, orb in pairs(match) do
            if orb.type then
                points = points + self:fireSuper(orb.gridX, orb.gridY, orb.level, orb.type)
            end
            
            
            
            
               
            
            points = points + 50
            
            self.orbs[orb.gridY][orb.gridX] = nil

            
            
        end

    end
    self.matches = nil

    

    if not scoreFlag then
        points = 0
    end

    
    return points
end

--[[
    get tweening information for all the orbs that need to fall
]]
function Board:getFallingOrbs()
    local tweens = {}
    
    -- for each column, go up orb by orb till we hit a space
    for x = 1, 8 do
        local space = false --the 'space found' flag 
        local spaceY = 0

        local y = 8
        while y >= 1 do
            local orb = self.orbs[y][x]

            if space then --space found, check for orbs above spaces
                if orb then
                    --put the orb in the correct spot in the board (the space's spot) and fix grid positions
                    self.orbs[spaceY][x] = orb
                    orb.gridY = spaceY

                    --reset old coordinates
                    self.orbs[y][x] = nil

                    --tween Y position to grid position * 64
                    tweens[orb] = {
                        y = (orb.gridY - 1) * 64
                    }

                    --set Y to SpaceY so we start again
                    space = false
                    y = spaceY
                    spaceY = 0
        
                end
            elseif orb == nil then
                space = true

                --if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
                    
                
            end

            y = y - 1
        end
    end

   

    return tweens
end

function Board:refill()
    local orbsOffscreen = {}
    local tweens = {}
    --create replacement orbs at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local counter = 0
            local orb = self.orbs[y][x]
            if not orb then
                
                orb = Orb(x, y, math.random(6))
                orb.y = -128 - (counter * 64)
                self.orbs[y][x] = orb
                
                
                table.insert(orbsOffscreen, orb)

                counter = counter + 1
            end
        end
    end
    --set up tween table
    for k, orb in pairs(orbsOffscreen) do
        tweens[orb] = {y = (orb.gridY - 1)*64}
    end
    
    return tweens
end

function Board:fireSuper(x, y, level, type)
    local points = 0
    
    local match = {}
    if type == 'vertical' then
        for k, tbl in pairs(self.orbs) do
            for l, orb in pairs(tbl) do
                if (orb.gridX == x) or ((orb.gridX == x + 1) and level >= 2) or ((orb.gridX == x - 1) and level == 3) then
                    table.insert(match, self.orbs[orb.gridY][orb.gridX])
                    
                    

                
                end
            end
        end

    elseif type == 'horizontal' then
        local targetArea = {y}
        if level >= 2 then
            targetArea[#targetArea + 1] = y + 1

        end

        if level == 3 then
            targetArea[#targetArea + 1] = y - 1
        end
        
        for i, row in pairs(targetArea) do
            for j, orb in pairs(self.orbs[row]) do
                table.insert(match, self.orbs[orb.gridY][orb.gridX])
                
                
            end
        end

    elseif type == 'cross' then

        for k, tbl in pairs(self.orbs) do
            for l, orb in pairs(tbl) do
                if (orb.gridX == x) or ((orb.gridX == x + 1) and level >= 2) or ((orb.gridX == x - 1) and level == 3)
                    or (orb.gridY == y) or ((orb.gridY == y + 1) and level >= 2) or (( orb.gridY == y - 1) and level == 3) then
                        table.insert(match, self.orbs[orb.gridY][orb.gridX])
                        
                end

                
            end
        end   
    
    elseif type == 'radial' then
        
        for k, tbl in pairs(self.orbs) do
            for l, orb in pairs(tbl) do
                
                if not(self.orbs[y][x] == orb) and self:distance(orb, self.orbs[y][x]) <= level then
                    
                    table.insert(match, self.orbs[orb.gridY][orb.gridX])
                    
                    
                end
            end
        end
        
    end
    table.insert(self.matches, match)
    return points
end

function Board:getFadingOrbs()
    local tweens = {}

    for m, match in pairs(self.matches) do
        for o, orb in pairs(match) do
            tweens[orb] = {alpha = 0}
        end
    end

    return tweens
end

function Board:distance(orb1, orb2) --using our good olf friend Pythagoras

    local xDist = math.abs(orb1.gridX - orb2.gridX)
    local yDist = math.abs(orb1.gridY - orb2.gridY)

    local totalDist = math.sqrt(xDist ^ 2 + yDist ^ 2)

    return totalDist

end