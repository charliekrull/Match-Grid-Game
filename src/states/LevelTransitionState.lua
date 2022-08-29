LevelTransitionState = Class{__includes = BaseState}

function LevelTransitionState:enter(params)

    self.level = params.level
    self.score = params.score

end

function LevelTransitionState:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
        gStateMachine:change('play', {level = self.level + 1})
    end

    Timer.update(dt)

end

function LevelTransitionState:render()
    love.graphics.setColor(WHITE)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(PURPLE)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 200, VIRTUAL_HEIGHT/2 - 100, 400, 200)

    love.graphics.setFont(gFonts['ui'])
    love.graphics.setColor(WHITE)
    love.graphics.printf('Level ' .. self.level .. ' complete!', VIRTUAL_WIDTH/2 - 200, VIRTUAL_HEIGHT/2 - 90, 400, 'center')
    love.graphics.printf('Final Score: ' .. self.score, VIRTUAL_WIDTH/2 - 200, VIRTUAL_HEIGHT/2, 400, 'center')
end