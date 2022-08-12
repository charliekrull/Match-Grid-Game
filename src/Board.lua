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
                --new color to count matches for
                colorToMatch = self.orbs[y][x].color

                --if we have a match of 3 or 4 up til then:
                if matchNum >= 3 then
                    local match = {}
                    --add each orb to the table that is the match
                    for x2 = x-1, x - matchNum, -1 do
                        table.insert(match, self.orbs[y][x2])
                    end

                    --add this match to the table of matches
                    table.insert(matches, match)
                end

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
                colorToMatch = self.orbs[y][x].color
                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, - 1 do
                        table.insert(match, self.orbs[y2][x])
                    end

                    table.insert(matches, match)
                end

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

function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for l, orb in pairs(match) do
            self.orbs[orb.gridY][orb.gridX] = nil
        end
    end

    self.matches = nil


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
                    self.tiles[y][x] = nil

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

    --create replacement orbs from the top of the screen
    for x = 1, 8 do --column by column
        for y = 8, 1, -1 do
            local orb = self.orbs[y][x]

            if not orb then

                --new orb with random color
                local orb = Orb(x, y, math.random(6))
                orb.y = -32 -- put it somewhat off screen so it falls on
                self.orbs[y][x] = orb
                
                --create a new tween to return for this orb to fall
                tweens[orb] = {
                    y = (orb.GridY - 1) * 64
                }
            end
            
        end
    end

    return tweens
end