GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
    self.goal = params.goal
    self.level = params.level
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end 
end

function GameOverState:render()
    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(WHITE)

    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 200, VIRTUAL_WIDTH, 'center')
end