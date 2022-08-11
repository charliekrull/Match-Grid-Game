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
            self:swap(self.board.orbs[self.selectedY][self.selectedX], self.board.orbs[self.highlightY][self.highlightX])

            --deselect
            self.orbSelected = false
            self.selectedX = nil
            self.selectedY = nil

        end

    end

end

function PlayState:swap(Orb1, Orb2)
    local tempX, tempY = Orb1.x, Orb1.y
    local tempGridX, tempGridY = Orb1.gridX, Orb1.gridY
    local tempOrb = Orb1

    self.board.orbs[Orb1.gridY][Orb1.gridX] = Orb2
    self.board.orbs[Orb2.gridY][Orb2.gridX] = tempOrb

    Orb1.gridX, Orb1.gridY = Orb2.gridX, Orb2.gridY
    Orb1.x, Orb1.y = Orb2.x, Orb2.y

    --now we have 2 copys of Orb2, so use temp to restore Orb1
    Orb2.gridX, Orb2.gridY = tempGridX, tempGridY
    Orb2.x, Orb2.y = tempX, tempY
    
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


function PlayState:render()
    self.board:render()
    self:drawHighlight(self.highlightX, self.highlightY)
    if self.orbSelected then
        self:drawSelected(self.selectedX, self.selectedY)
    end

    love.graphics.setFont(gFonts['ui'])
    love.graphics.setColor(WHITE)
    love.graphics.print('Score: '..tostring(self.score), 4, 4)

   --[[ love.graphics.setColor(GREEN)
    love.graphics.print('Highlighted: ('..self.highlightX..','..self.highlightY..')', 4, VIRTUAL_HEIGHT - 128)
    if self.orbSelected then
        love.graphics.print('Selected: ('..self.selectedX..','..self.selectedY..')', 4, VIRTUAL_HEIGHT - 64)
    end]]
    
end