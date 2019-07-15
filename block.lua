--

Block = {}
Block.__index = Block


function Block:new()
    local this = {
        y = 0,
        x = 3,
        rotation = 1,
        size = 40,
    }
    this.shape = love.math.random(1, 7)

    setmetatable(this, self)
    return this
end


function Block:draw()
    local description = blockDescriptions[self.shape][self.rotation]
     for y = 1, 4 do
        for x = 1, 4 do
            if description[y][x] ~= ' ' then
                love.graphics.setColor(colors[description[y][x]])
                _x = (x + self.x - 1) * self.size
                _y = (y + self.y - 1) * self.size
                love.graphics.rectangle('fill', _x, _y, self.size-1, self.size-1)
            end
        end
    end
end


function Block:save(grid)
    local description = blockDescriptions[self.shape][self.rotation]
    for y = 1, 4 do
        for x = 1, 4 do
            if description[y][x] ~= ' ' then
                grid.tiles[self.y + y][self.x + x] = description[y][x]
            end
        end
    end
end

