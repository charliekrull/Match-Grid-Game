SuperOrb = Class{__includes = Orb}

--[[
    A special kind of Orb that will blow up nice and big, scoring a bunch of points, when used in a set
]]

function SuperOrb:init(x, y, color, level, type)
    --board positions
    self.gridX = x
    self.gridY = y

    --coordinate positions
    self.x = (x - 1) * 64
    self.y = (x - 1) * 64
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
    if self.type == 'horizontal' then
        love.graphics.rectangle('fill', self.x + x + 16, self.y + y + 40, 56, 10)
    elseif self.type == 'vertical' then
        love.graphics.rectangle('fill', self.x + x + 40, self.y + y + 16, 10, 56)

    elseif self.type == 'cross' then
        love.graphics.rectangle('fill', self.x + x + 16, self.y + y + 40, 56, 10)
        love.graphics.rectangle('fill', self.x + x + 40, self.y + y + 16, 10, 56)

    elseif self.type == 'radial' then
        love.graphics.circle('line', self.x + 45 + x, self.y + 45 + y, 28)
    end
end



