--The state where we're actually playing the game, keeeping track of score, etc

PlayState = Class{__includes = BaseState}


function PlayState:init()
    self.score = 0

    self.highlightX = 4
    self.highlightY = 4

    self.orbSelected = false

    

end

function PlayState:enter(params)
    self.level = params.level
    self.levelLabelY = -50
    self.board = Board(VIRTUAL_WIDTH / 2 - 256, 16)
    self.superOrbs = {}
    self:updateMatches(false)

    self.transitionAlpha = 1

    self.canInput = false

    
    self.goal = 3000 + (self.level * 1000)

    self.timeLeft = 60
    

    Timer.tween(0.5, {[self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 25}}):finish( --tween level label to mid screen
        function()
            Timer.after(1, 
            function() --wait 1 second then
                Timer.tween(0.5, {[self] = {levelLabelY = VIRTUAL_HEIGHT}}):finish( --tween label offscreen
            
                function() Timer.tween(0.5, {[self] = {transitionAlpha = 0}}):finish(function() self.canInput = true self.levelLabelY = -50
                    self.roundTimer = Timer.every(1, function() self.timeLeft = self.timeLeft - 1
                    if self.timeLeft <= 5 then
                        gSounds['clock']:stop()
                        gSounds['clock']:play()
                    end end)
                 end)--fade in and allow input
            end)
        end)
    end)



    

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if self.canInput then
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
                    local tempX = orb1.gridX
                    local tempY = orb1.gridY

                    orb1.gridX = orb2.gridX
                    orb1.gridY = orb2.gridY

                    orb2.gridX = tempX
                    orb2.gridY = tempY
                    self.board.orbs[orb1.gridY][orb1.gridX] = orb1

                    self.board.orbs[orb2.gridY][orb2.gridX] = orb2

                    self.canInput = false

                    Timer.tween(0.2, {
                        [orb1] = {x = orb2.x, y = orb2.y},
                        [orb2] = {x = orb1.x, y = orb1.y}
                    }):finish(function()
                        if self.board:calculateMatches() then
                            self:updateMatches(true)
                            
                        else
                            gSounds['error']:stop()
                            gSounds['error']:play()
                            local tempX, tempY = orb1.gridX, orb1.gridY

                            orb1.gridX, orb1.gridY = orb2.gridX, orb2.gridY

                            orb2.gridX, orb2.gridY = tempX, tempY

                            self.board.orbs[orb1.gridY][orb1.gridX] = orb1
                            self.board.orbs[orb2.gridY][orb2.gridX] = orb2
                            Timer.tween(0.2, {
                                [orb1] = {x = orb2.x, y = orb2.y},
                                [orb2] = {x = orb1.x, y = orb1.y}
                            }):finish(function() self.canInput = true end)
                        end
                    
                    end)
                    
                else
                    gSounds['error']:stop()
                    gSounds['error']:play()
                    
                end




                --deselect
                self.orbSelected = false
                self.selectedX = nil
                self.selectedY = nil


            end

        end
    
    end


    if self.timeLeft <= 0 then
        self.roundTimer:remove()
        if self.score < self.goal then
            gStateMachine:change('game-over', {score = self.score, goal = self.goal, level = self.level})

        else
            Timer.tween(0.5, {[self] = {transitionAlpha = 1}}):finish(function()
            gStateMachine:change('level-transition', {level = self.level, score = self.score})

            end)
        end
        
    end

    Timer.update(dt)

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
        self.canInput = false
        
        for k, match in pairs(matches) do
            
            if #match > 3 then --if it's a big match, get an orb that blows up in a special way
                local toOrbify = table.randomChoice(match) 
                local color = match[1].color
                local level = math.min(#match - 3, 3)
                local type = table.randomChoice(gSuperOrbNames)

                local orb = SuperOrb(toOrbify.gridX, toOrbify.gridY, color, level, type)

                table.insert(self.superOrbs, orb)
                

            end
            
        end

        --remove the orbs involved in a match
        
        --self.orbsToFade = self.board:getFadingOrbs()

        --Timer.tween(0.3, orbsToFade):finish(function()
        
        
        self.score = self.score + self.board:removeMatches(scoreFlag)

        if scoreFlag then
            gSounds['pop1']:stop()
            gSounds['pop1']:play() 
        end     
        
        for k, orb in pairs(self.superOrbs) do
            
            self.board.orbs[orb.gridY][orb.gridX] = orb
            self.board.orbs[orb.gridY][orb.gridX].x = (orb.gridX - 1) * 64
            self.board.orbs[orb.gridY][orb.gridX].y = (orb.gridY - 1) * 64
        end

        for i = 1, #self.superOrbs do
            self.superOrbs[i] = nil
        end

        
        
        self.orbsToFall = self.board:getFallingOrbs() --returns a table for tweening
        self.newOrbs = self.board:refill()
        

        
        

        --when the tween is done, check for the matches we just created
        
        
        
           
        Timer.tween(0.3, self.orbsToFall):finish(
            function() 
                Timer.tween(0.3, self.newOrbs):finish(
                    function() 
                        self:updateMatches(scoreFlag)
                        
                    end)
            end)

        --end)
        
    else
        self.canInput = true
        
    end
    
end

function PlayState:render()
    self.board:render()
    self:drawHighlight(self.highlightX, self.highlightY)
    if self.orbSelected then
        self:drawSelected(self.selectedX, self.selectedY)
    end
    love.graphics.setColor(LIGHT_BLUE)
    love.graphics.rectangle('fill', 0, 0, 200, 50) --a little background for our score display
    love.graphics.setFont(gFonts['ui'])
    love.graphics.setColor(WHITE)
    love.graphics.print('Score: '..tostring(self.score), 4, 4)

    love.graphics.setColor(RED)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 50, 0, 50, 50)
    love.graphics.setColor(WHITE)
    love.graphics.print(self.timeLeft, VIRTUAL_WIDTH - 46, 4)

    love.graphics.setColor(DARK_BLUE)
    love.graphics.rectangle('fill', 0, 75, 200, 50)
    love.graphics.setColor(WHITE)
    love.graphics.print('Goal: '..tostring(self.goal), 4, 79)

    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(LIGHT_BLUE)
    love.graphics.rectangle('fill', 0, self.levelLabelY, VIRTUAL_WIDTH, 50)
    love.graphics.setColor(WHITE)
    love.graphics.printf('Level '..tostring(self.level), 0, self.levelLabelY + 4, VIRTUAL_WIDTH, 'center')



    --[[love.graphics.setColor(GREEN)
    love.graphics.print('Highlighted: ('..self.highlightX..','..self.highlightY..')', 4, VIRTUAL_HEIGHT - 128)
    if self.orbSelected then
        love.graphics.print('Selected: ('..self.selectedX..','..self.selectedY..')', 4, VIRTUAL_HEIGHT - 64)
    end
    ]]
end


function PlayState:containsSuperOrb(tbl)
    for k, element in pairs(tbl) do
        if element.type then
            return true

    
        end
    end
    
    return false
end
