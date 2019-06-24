--

Game = {}
Game.__index = Game

local speed = { 20, 30, 60, 110, 160 } -- TODO find a way to compute this
local pointsPerLine = 100
local tetrisMultiplier = 2


function Game:new()
    local this = {
        score = 0,
        timer = 0,
        level = 1,
        state = 'running',
        magickNumber = 10,
        highscore = 0,
    }

    local data = love.filesystem.load('highscore.lua')
    if data then
        data()
        this.highscore = highscore -- luacheck: ignore
    end
    setmetatable(this, self)
    return this
end


-- Determine the number of seconds that must elapse before a block falls.
function Game:getSeconds()
    return self.magickNumber / speed[self.level]
end



-- Determine if it's time to move. -- TODO change the name of this.
function Game:canMove(dt)
    self.timer = self.timer + dt
    if self.timer > (self.magickNumber / speed[self.level]) then
        self.timer = 0
        return true
    end
    return false
end


-- Increment the score for the number of lines given.
function Game:addScore(lines)
    local multiplier = 1
    if lines == 4 then
        multiplier = tetrisMultiplier
    end
    self.score = self.score + pointsPerLine * lines * multiplier
end



function Game:saveScore()
    if self.score >= self.highscore then
        local file = love.filesystem.newFile('highscore.lua', 'w')
        file:write('highscore = ' .. self.score)
        file:close()
    end
end

