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

gBackgroundImages = { --[[
    Artwork created by Luis Zuno (@ansimuz)

License (CC0) You can copy, modify, distribute and perform the work, even for commercial purposes, 
all without asking permission: http://creativecommons.org/publicdomain/zero/1.0/
https://opengameart.org/content/forest-background
]]
    [1] = love.graphics.newImage('graphics/layers/parallax-forest-back-trees.png'),
    [2] = love.graphics.newImage('graphics/layers/parallax-forest-lights.png'),
    [3] = love.graphics.newImage('graphics/layers/parallax-forest-middle-trees.png'),
    [4] = love.graphics.newImage('graphics/layers/parallax-forest-front-trees.png')
}


gFonts = {
    ['small'] = love.graphics.newFont('fonts/Unround.ttf', 16),
    ['medium'] = love.graphics.newFont('fonts/Unround.ttf', 32),
    ['large'] = love.graphics.newFont('fonts/Unround.ttf', 64)

}