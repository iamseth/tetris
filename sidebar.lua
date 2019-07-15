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
    --love.graphics.printf("FPS: "..tostring(love.timer.getFPS( )), windowWidth - offset, 150 + (verticalSpacing * 3), 1000, 'left')
end

