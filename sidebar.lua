--

Sidebar = {}
Sidebar.__index = Sidebar


function Sidebar:new()
    local this = {
        width = 250,
        font = love.graphics.newFont(20),
        backgroundColor = { 255, 255, 255 },
        fontColor = { 0, 0, 0 },
    }

    setmetatable(this, self)
    return this
end


function Sidebar:draw()
    love.graphics.setFont(self.font)
    local time = os.time(os.date("!*t")) - game.start_time
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle('fill',  windowWidth - self.width, 0, self.width, windowHeight)
    love.graphics.setColor(self.fontColor)
    local offset = 230
    local verticalSpacing = 30
    love.graphics.printf('Score: ' .. game.score, windowWidth - offset, 150, 1000, 'left')
    love.graphics.printf('High Score: ' .. game.highscore, windowWidth - offset, 150 + (verticalSpacing * 1), 1000, 'left')
    love.graphics.printf('Level: ' .. game.level, windowWidth - offset, 150 + (verticalSpacing * 2), 1000, 'left')
    love.graphics.printf('Time: ' .. time, windowWidth - offset, 150 + (verticalSpacing * 3), 1000, 'left')

    -- Draw the preview block.
    local description = blockDescriptions[nextBlock.shape][nextBlock.rotation]
    local size = nextBlock.size / 2
     for y = 1, 4 do
        for x = 1, 4 do
            if description[y][x] ~= ' ' then
                love.graphics.setColor(colors[description[y][x]])
                love.graphics.rectangle('fill', x * size + (love.graphics.getWidth() - (self.width-size*2)) + 3, y * size, size-1, size-1)
            end
        end
    end
end




