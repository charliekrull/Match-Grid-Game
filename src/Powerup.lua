Powerup = Class{__includes = Orb}

--[[
    A special kind of Orb that will blow up nice and big, scoring a bunch of points, when used in a set
]]

function Powerup:init(x, y, color, radius)
    --board positions
    self.gridX = x
    self.grdiY = y

    --coordinate positions
    self.x = (self.gridX - 1) * 64
    self.y = (self.gridY - 1) * 64
    --a number 1-6
    self.color = color

    --size of the explosion, 1-3
    self.radius = radius
 
end



