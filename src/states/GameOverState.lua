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

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
        gStateMachine:change('start')
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(BLACK)

    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 200, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setColor(RED)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 150, VIRTUAL_HEIGHT/2 - 50, 300, 100)

    love.graphics.setColor(WHITE)
    love.graphics.setFont(gFonts['ui'])
    love.graphics.printf('Score: '..self.score, VIRTUAL_WIDTH/2 - 145, VIRTUAL_HEIGHT/2 - 45, 290, 'center')
    love.graphics.printf('Goal: '..self.goal, VIRTUAL_WIDTH/2 - 145, VIRTUAL_HEIGHT/2, 290, 'center')
end