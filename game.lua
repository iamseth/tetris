--

Game = {}
Game.__index = Game

function Game:new()
    local this = {
        score = 0,
        timer = 0,
        level = 0,
        state = 'running',
        highscore = 0,
    }

    local settings = love.filesystem.load('settings.lua')
    if settings then
        settings()
        this.level = level -- luacheck: ignore
    end
    
    local data = love.filesystem.load('highscore.lua')
    if data then
        data()
        this.highscore = highscore -- luacheck: ignore
    end
    setmetatable(this, self)
    return this
end



function Game:reset()
    self.score = 0
    self.timer = 0
    self.state = 'running'
    local data = love.filesystem.load('highscore.lua')
    if data then
        data()
        self.highscore = highscore -- luacheck: ignore
    end
end


-- Determine if it's time to move. -- TODO change the name of this.
function Game:canMove(dt)
    self.timer = self.timer + dt
    if self.timer > (0.5 + ((self.level + 1) * -0.05)) then
        self.timer = 0
        return true
    end
    return false
end


-- Increment the score for the number of lines given.
function Game:addScore(lines)
    if lines == 1 then
        points = 40 * (self.level + 1) 
    elseif lines == 2 then
        points = 100 * (self.level + 1) 
    elseif lines == 3 then
        points = 300 * (self.level + 1) 
    elseif lines == 4 then
        points = 1200 * (self.level + 1) 
    end
    self.score = self.score + points
end



function Game:saveScore()
    if self.score >= self.highscore then
        local file = love.filesystem.newFile('highscore.lua', 'w')
        file:write('highscore = ' .. self.score)
        file:close()
    end
end

