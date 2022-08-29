--libraries used
Class = require 'lib/class'

push = require 'lib/push'

Timer = require 'lib/knife.timer'


require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/GameOverState'
require 'src/states/LevelTransitionState'

require 'src/StateMachine'
require 'src/Util'
require 'src/Orb'
require 'src/Board'
require 'src/constants'
require 'src/SuperOrb'


gSounds = {
    ['music'] = love.audio.newSource('sounds/periwinkle.mp3', 'stream'), --Axton Crolley, "Periwinkle" https://opengameart.org/content/happy-go-lucky-puzzle
    ['pop1'] = love.audio.newSource('sounds/pop1.ogg', 'static'), --user cogitollc https://opengameart.org/content/pop-sounds
    ['error'] = love.audio.newSource('sounds/error-click.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static')
}

gOrbImages = {}

for i = 1, 6 do --6 basic colored orbs to start
    table.insert(gOrbImages, love.graphics.newImage('graphics/Orb_'..tostring(i)..'.png')) --https://opengameart.org/content/orbs-collection, orb images
end

gSuperOrbNames = {'vertical', 'horizontal', 'cross', 'radial'}

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