--

Sidebar = {}
Sidebar.__index = Sidebar


function Sidebar:new()
    local this = {
        width = 200,
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
    love.graphics.rectangle('fill',  windowWidth - self.width, 0, 200, windowHeight)
    love.graphics.setColor(self.fontColor)
    love.graphics.printf('Score: ' .. game.score, windowWidth - 180, 150, 1000, 'left')
    love.graphics.printf('High Score: ' .. game.highscore, windowWidth - 180, 180, 1000, 'left')
    love.graphics.printf('Level: ' .. game.level, windowWidth - 180, 210, 1000, 'left')
    love.graphics.printf("FPS: "..tostring(love.timer.getFPS( )), windowWidth - 180, 240, 1000, 'left')
end

