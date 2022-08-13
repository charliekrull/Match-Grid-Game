--The state where we're actually playing the game, keeeping track of score, etc

PlayState = Class{__includes = BaseState}


function PlayState:init()

    self.score = 0
    self.timer = 60

    self.highlightX = 4
    self.highlightY = 4

    self.orbSelected = false

    

end

function PlayState:enter(params)
    self.level = params.level
    self.board = params.board or Board(VIRTUAL_WIDTH / 2 - 256, 16)
    self.superOrbs = {}
    self:updateMatches(false)

    self.score = params.score or 0

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('left') then
        self.highlightX = math.max(1, self.highlightX - 1)
    end

    if love.keyboard.wasPressed('right') then
        self.highlightX = math.min(8, self.highlightX + 1)
        
    end

    if love.keyboard.wasPressed('up') then
        self.highlightY = math.max(1, self.highlightY - 1)
    end

    if love.keyboard.wasPressed('down') then
        self.highlightY = math.min(8, self.highlightY + 1)
    end

    if love.keyboard.wasPressed('space') then
        if not self.orbSelected then --if we have not selected an orb, space will select one
            self.selectedX, self.selectedY = self.highlightX, self.highlightY
            self.orbSelected = true

        else
            local orb1 = self.board.orbs[self.selectedY][self.selectedX]
            local orb2 = self.board.orbs[self.highlightY][self.highlightX]

            local adj = math.abs((orb1.gridX - orb2.gridX) + (orb1.gridY - orb2.gridY)) --will be 1 if orthogonally adjacent
            if adj == 1 then
                self:swap(orb1, orb2)
                self:updateMatches(true)

                
            end


            --deselect
            self.orbSelected = false
            self.selectedX = nil
            self.selectedY = nil


        end

    end

    Timer.update(dt)

end

function PlayState:swap(Orb1, Orb2)
    --Swaps two orbs with a temp variable

    local tempX, tempY = Orb1.x, Orb1.y
    local tempGridX, tempGridY = Orb1.gridX, Orb1.gridY
    local tempOrb = Orb1

    self.board.orbs[Orb1.gridY][Orb1.gridX] = Orb2
    self.board.orbs[Orb2.gridY][Orb2.gridX] = tempOrb

    Timer.tween(0.2, {
        [Orb1] = {x = Orb2.x, y = Orb2.y},
        [Orb2] = {x = tempX, y = tempY} 
    })

    --instantly swap the grid coordinates, no need to tween those
    Orb1.gridX, Orb1.gridY = Orb2.gridX, Orb2.gridY
    Orb2.gridX, Orb2.gridY = tempGridX, tempGridY
    
    
end

function PlayState:drawHighlight(gridX, gridY)
    love.graphics.setLineWidth(4)
    love.graphics.setColor(YELLOW)
    love.graphics.circle('line', ((gridX -1) * 64) + BOARD_OFFSET_X + 45, 
        ((gridY - 1) * 64) + BOARD_OFFSET_Y + 45, 32)
end

function PlayState:drawSelected(gridX, gridY)
    love.graphics.setColor({1, 1, 1, 0.5}) --white
    love.graphics.circle('fill', ((gridX - 1) * 64) + BOARD_OFFSET_X + 45,
    ((gridY - 1) * 64) + BOARD_OFFSET_Y + 44, 32)
end

function PlayState:updateMatches(scoreFlag)
    self.selectedX = nil
    self.selectedY = nil
    self.orbSelected = false

    local matches = self.board:calculateMatches()

    if matches then
        --scoring logic here
        if scoreFlag then
            for k, match in pairs(matches) do
                self.score = self.score + #match * 50
            end
        end
        for k, match in pairs(matches) do
            if #match > 3 then --if it's a big match, get an orb that blows up in a special way
                local toOrbify = table.randomChoice(match) 
                local color = match[1].color
                local level = math.min(#matches - 3, 6)
                local type = table.randomChoice(gSuperOrbNames)

                local orb = SuperOrb(toOrbify.gridX, toOrbify.gridY, color, level, type)
                table.insert(self.superOrbs, orb)

            end
        end

        --remove the orbs involved in a match
        self.board:removeMatches()
        --insert the supers in their place before refilling the board
        for k, superOrb in pairs(self.superOrbs) do
            if superOrb then
                
                self.board.orbs[superOrb.gridY][superOrb.gridX] = self.superOrbs[k]
            end
            
        end

        for i = 1, #self.superOrbs do
            self.superOrbs[i] = nil
        end



        local orbsToFall = self.board:getFallingOrbs() --returns a table for tweening
        local newOrbs = self.board:refill()

        --when the tween is done, check for the matches we just created
        Timer.tween(0.3, orbsToFall):finish(
            function() 
                Timer.tween(0.3, newOrbs):finish(
                    function() 
                        self:updateMatches(scoreFlag)
                        
                    end)
            end)
        
         
    end
end

function PlayState:render()
    self.board:render()
    self:drawHighlight(self.highlightX, self.highlightY)
    if self.orbSelected then
        self:drawSelected(self.selectedX, self.selectedY)
    end

    love.graphics.setFont(gFonts['ui'])
    love.graphics.setColor(WHITE)
    love.graphics.print('Score: '..tostring(self.score), 4, 4)

    --[[love.graphics.setColor(GREEN)
    love.graphics.print('Highlighted: ('..self.highlightX..','..self.highlightY..')', 4, VIRTUAL_HEIGHT - 128)
    if self.orbSelected then
        love.graphics.print('Selected: ('..self.selectedX..','..self.selectedY..')', 4, VIRTUAL_HEIGHT - 64)
    end
    ]]
end

