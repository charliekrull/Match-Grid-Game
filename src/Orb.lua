--A orb on the game board
Orb = Class{}

function Orb:init(x, y, color) --color is 1-6
    --board positions
    self.gridX = x
    self.gridY = y

    --coordinate positions

    self.x = (self.gridX - 1) * 64
    self.y = (self.gridY - 1) * 64

    self.color = color
end

function Orb:render(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gOrbImages[self.color], self.x + x, self.y + y, 0, 0.5, 0.5)
end