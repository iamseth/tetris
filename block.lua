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
    local description = self:getDescription()
     for y = 1, 4 do
        for x = 1, 4 do
            if description[y][x] ~= ' ' then
                love.graphics.setColor(colors[description[y][x]])
                love.graphics.rectangle('fill', (x + self.x - 1) * self.size, (y + self.y - 1) * self.size, self.size-1, self.size-1)
            end
        end
    end
end


function Block:drawPreview(sidebar)
    local description = self:getDescription()
    local size = self.size / 2
     for y = 1, 4 do
        for x = 1, 4 do
            if description[y][x] ~= ' ' then
                love.graphics.setColor(colors[description[y][x]])
                love.graphics.rectangle('fill', x * size + (love.graphics.getWidth() - (sidebar.width-size*2)) + 3, y * size, size-1, size-1)
            end
        end
    end
end


function Block:save(grid)
    local description = self:getDescription()
    for y = 1, 4 do
        for x = 1, 4 do
            if description[y][x] ~= ' ' then
                grid.tiles[self.y + y][self.x + x] = description[y][x]
            end
        end
    end
end


function Block:getDescription()
    return blockDescriptions[self.shape][self.rotation]
end
