--

Grid = {}
Grid.__index = Grid


function Grid:new()
    local this = {
        width = 10,
        height = 20,
        blockSize = 40,
        tiles = {},
    }

   -- Start with all tiles empty.
   for y = 1, this.height do
        this.tiles[y] = {}
        for x = 1, this.width do
            this.tiles[y][x] = ' '
        end
    end

    setmetatable(this, self)
    return this
end


function Grid:countLines()
    local lines = 0
    for row = 1, self.height do
        if self:rowComplete(row) then
            self:dropBlocks(row)
            lines = lines + 1
        end
    end
    return lines
end


-- Determines if a given line is complete. Returns true or false.
function Grid:rowComplete(row)
    for col = 1, self.width do
        if self.tiles[row][col] == ' ' then
            return false
        end
    end
    return true
end


function Grid:draw()
    for y = 1, self.height do
        for x = 1, self.width do
            if self.tiles[y][x] ~= ' ' then
                color = colors[self.tiles[y][x]]
                love.graphics.setColor(color)
                love.graphics.rectangle('fill', (x - 1) * self.blockSize, (y - 1) * self.blockSize, self.blockSize-1, self.blockSize-1)
            end
        end
    end
end


function Grid:dropBlocks(startRow)
    -- Iterate from the startRow back to the second row shifting all tiles down.
    for row = startRow, 2, -1 do
        for col = 1, self.width do
            self.tiles[row][col] = self.tiles[row - 1][col]
        end
    end
    -- Empty the top row.
    for col = 1, self.width do
        self.tiles[1][col] = ' '
    end
end
