--[[
    A Bejeweled/Candy Crush style match game
]]

require 'src/Dependencies'

love.graphics.setDefaultFilter('linear', 'linear')




function love.load()
    love.window.setTitle("Orbulus")

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    gStateMachine = StateMachine{
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        ['level-transition'] = function() return LevelTransitionState() end
        
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    gBackground = table.randomChoice(gBackgroundImages)

    

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
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(gBackground,0, 0, 0, 1.28, 1.03 )

    gStateMachine:render()
    push:finish()
end