--[[
    The state right before we transition to the play state, where it will eventually do all sorts of
        pretty jiggery pokery but we'll get there
]]

StartState = Class{__includes = BaseState}


function StartState:init()
    self.currentMenuItem = 1
    self.fontColor = table.randomChoice(gOrbColors) --choose a random color to display the title

end



function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {level = 1})
    end
end


function StartState:render()

    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(self.fontColor) 
    love.graphics.printf('Marble Match', 0, VIRTUAL_HEIGHT/2 - 32, VIRTUAL_WIDTH, 'center')
end
