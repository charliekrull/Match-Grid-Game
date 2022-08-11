--The arrangement of Orbs with which we must try to find matching sets of 3,
--vertically or horizontally

Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = y
    self.matches = {}

    self:initializeOrbs()
    

    self.highlightedOrb = self.orbs[1][1]
end

function Board:initializeOrbs()
    self.orbs = {}

    for orbY = 1, 8 do
    
        self.orbs[#self.orbs + 1] = {}

        for orbX = 1, 8 do
            --create a new orb at X, Y with random color and shape
            table.insert(self.orbs[orbY], Orb(orbX, orbY, math.random(6)))
        end
    end
end



function Board:render()
    for y = 1, #self.orbs do
        for x = 1, #self.orbs[1] do
            self.orbs[y][x]:render(self.x, self.y)
        end
    end
end

