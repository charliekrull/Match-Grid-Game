--[[
    A Bejeweled/Candy Crush style match game
]]

require 'src/Dependencies'

love.graphics.setDefaultFilter('linear', 'linear')




function love.load()
    love.window.setTitle("Marble Match")

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    gStateMachine = StateMachine{
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
        
    }
    gStateMachine:change('start')

    gSounds['music']:play()

    gCurrentFontColor = table.randomChoice(gColors)

    love.keyboard.keysPressed = {}    
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    --add to table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    --returns true or false, whether the key was pressed this frame
    return love.keyboard.keysPressed[key]
end


function love.update(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    

end


function love.draw()
    push:start() --start drawing at virtual resolution

    for k, pair in ipairs(gBackgroundImages) do
        love.graphics.draw(pair, 0, 0, 0, 4.71, 4.5)
    end

    gStateMachine:render()
    push:finish()
end