--libraries used
Class = require 'lib/class'

push = require 'lib/push'

Timer = require 'lib/knife.timer'


require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'

require 'src/StateMachine'
require 'src/Util'
require 'src/Orb'
require 'src/Board'
require 'src/constants'


gSounds = {
    ['music'] = love.audio.newSource('sounds/periwinkle.mp3', 'stream') --Axton Crolley, "Periwinkle" https://opengameart.org/content/happy-go-lucky-puzzle

}

gOrbImages = {}

for i = 1, 6 do --6 basic colored orbs to start
    table.insert(gOrbImages, love.graphics.newImage('graphics/Orb_'..tostring(i)..'.png')) --https://opengameart.org/content/orbs-collection, orb images
end

gBackgroundImages = { love.graphics.newImage('graphics/Backgrounds/desertnight.png'),
    love.graphics.newImage('graphics/Backgrounds/fortress.png'),
    love.graphics.newImage('graphics/Backgrounds/gate.png'),
    love.graphics.newImage('graphics/Backgrounds/guardtower.png'),
    love.graphics.newImage('graphics/Backgrounds/shore.png'),
}


gFonts = {
    ['title'] = love.graphics.newFont('fonts/Unround.ttf', 128),
    ['ui'] = love.graphics.newFont('fonts/Figtree-Regular.ttf', 32) --font by Erik Kennedy https://twitter.com/erikdkennedy

}