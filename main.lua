--

require('game')
require('grid')
require('block')
require('sidebar')


function reset()
    game:reset()
    grid = Grid:new()
    sidebar = Sidebar:new()

    nextBlock = Block:new()
    currentBlock = Block:new()
end


function love.load()
    game = Game:new()
    love.mouse.setVisible(false)
    reset()
end


function love.keypressed(key)
    if key == 'q' then
        love.event.quit()
    end
    if key == 'escape' then
        reset()
    end

    -- Handle pausing the game.
    if key == 'p' then
        if game.state == 'running' then
            game.state = 'paused'
        elseif game.state == 'paused' then
            game.state = 'running'
        end
    end

    -- Don't continue unless the game is in a running state.
    if game.state ~= 'running' then
        return
    end

    -- Handle movement and rotation of the falling block.
    if key == 'left' and validMove(currentBlock.x - 1, currentBlock.y, currentBlock.rotation) then
        currentBlock.x = currentBlock.x - 1
    end
    if key == 'right' and validMove(currentBlock.x + 1, currentBlock.y, currentBlock.rotation) then
        currentBlock.x = currentBlock.x + 1
    end
    if key == 'up' then
        r = currentBlock.rotation + 1
        if r > #blockDescriptions[currentBlock.shape] then
            r = 1
        end
        if validMove(currentBlock.x, currentBlock.y, r) then
            currentBlock.rotation = r
        end
    end
    if key == 'down' then
        r = currentBlock.rotation - 1
        if r < 1 then
            r = #blockDescriptions[currentBlock.shape]
        end
        if validMove(currentBlock.x, currentBlock.y, r) then
            currentBlock.rotation = r
        end
    end
    if key == 'space' then
        while validMove(currentBlock.x, currentBlock.y + 1, currentBlock.rotation) do
            currentBlock.y = currentBlock.y + 1
        end
        
        -- Save the block to the grid, swap the next block into the current block and create a new next/preview block.
        currentBlock:save(grid)
        currentBlock = nextBlock
        nextBlock = Block:new()
    end

    -- These are debug options and to be removed before play.
    if key == '=' then
        game.level = game.level + 1
    end
    if key == '-' then
        game.level = game.level - 1
    end
end


function love.update(dt)

    if not love.window.hasFocus() then
        game.state = 'paused'
        return
    end

    -- Only go forward if running.
    if game.state ~= 'running' then
        return
    end
                game:saveScore()

    -- Determine if enough time has elapsed to move the block. Also figure out if next move is valid.
    if game:canMove(dt) then
        -- If we can move, drop the block. IF we can't move, create a new block.
        if validMove(currentBlock.x, currentBlock.y + 1, currentBlock.rotation) then
            currentBlock.y = currentBlock.y + 1
        else
            currentBlock:save(grid)
            currentBlock = nextBlock
            -- if the new current block isn't valid, it's game over.
            if not validMove(currentBlock.x, currentBlock.y, currentBlock.rotation) then
                game.state = 'over'
            end
            nextBlock = Block:new()
        end
    end
    lines = grid:countLines()
    if lines > 0 then
        game:addScore(lines)
    end
end


function love.draw()
    sidebar:draw()
    if game.state ==  'paused' then
        love.graphics.setColor(255, 255, 255)
        love.graphics.print('Game is paused.', 100, 100)
        return
    end
    grid:draw()
    if game.state == 'over' then
        love.graphics.setColor(255, 255, 255)
        love.graphics.print('fucked', 100, 100)
        return
    end
    currentBlock:draw()
end


function validMove(newX, newY, rotation)
    for x = 1, 4 do
        for y = 1, 4 do
            if blockDescriptions[currentBlock.shape][rotation][y][x] ~= ' ' and (
                newX + x < 1 or
                newX + x > grid.width or
                newY + y > grid.height or
                grid.tiles[newY + y][newX + x] ~= ' ') then
                return false
            end
        end
    end
    return true
end


colors = {
    [' '] = {.87, .87, .87},
    i = {.47, .76, .94},
    j = {.93, .91, .42},
    l = {.49, .85, .76},
    o = {.92, .69, .47},
    s = {.83, .54, .93},
    t = {.97, .58, .77},
    z = {.66, .83, .46},
}


blockDescriptions = {
    {
        {
            {' ', ' ', ' ', ' '},
            {'i', 'i', 'i', 'i'},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 'o', 'o', ' '},
            {' ', 'o', 'o', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', 'j', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {'j', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'j', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', 'j', ' '},
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'l', 'l', 'l', ' '},
            {'l', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'l', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', ' ', 'l', ' '},
            {'l', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
       {
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
        },
     
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', ' ', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {' ', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        }, 
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 's', 's', ' '},
            {'s', 's', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'s', ' ', ' ', ' '},
            {'s', 's', ' ', ' '},
            {' ', 's', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {' ', 'z', 'z', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'z', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {'z', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
}
