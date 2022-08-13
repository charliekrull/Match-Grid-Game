SuperOrb = Class{__includes = Orb}

--[[
    A special kind of Orb that will blow up nice and big, scoring a bunch of points, when used in a set
]]

function SuperOrb:init(x, y, color, level, type)
    --board positions
    self.gridX = x
    self.gridY = y

    --coordinate positions
    self.x = (self.gridX - 1) * 64
    self.y = (self.gridY - 1) * 64
    --a number 1-6
    self.color = color
    
    self.level = level
    self.type = type
 
end


function SuperOrb:activate()

    return self.level, self.type    

end

function SuperOrb:render(x, y)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gOrbImages[self.color], self.x + x, self.y + y, 0, 0.5, 0.5)

    love.graphics.rectangle('fill', self.x + x + 16, self.y + y + 40, 56, 10)
end



