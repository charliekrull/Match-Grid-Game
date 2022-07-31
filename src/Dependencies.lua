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


gSounds = {
    ['music'] = love.audio.newSource('sounds/periwinkle.mp3', 'stream') --Axton Crolley, "Periwinkle" https://opengameart.org/content/happy-go-lucky-puzzle

}

gOrbImages = {}

for i = 1, 6 do --6 basic colored orbs to start
    table.insert(gOrbImages, love.graphics.newImage('graphics/Orb_'..tostring(i)..'.png')) --https://opengameart.org/content/orbs-collection, orb images
end



gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 64)

}