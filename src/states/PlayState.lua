--The state where we're actually playing the game, keeeping track of score, etc

PlayState = Class{__includes = BaseState}


function PlayState:init()

    self.score = 0
    self.timer = 60

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


end

function PlayState:render()
    self.board:render()
end