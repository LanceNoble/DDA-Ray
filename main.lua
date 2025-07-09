local tileSize = 30
local tileMapWidth = 20
local tileMapHeight = 20
local tileMap = {}

for i = 1, tileMapHeight do
    tileMap[i] = {}
    for j = 1, tileMapWidth do
        if i == 1 or i == tileMapHeight or j == 1 or j == tileMapWidth then
            tileMap[i][j] = 1
        else
            tileMap[i][j] = 0
        end
    end
end

love.window.setMode(1280, 720)

local gridStartX = love.graphics.getWidth() * 0.5 - tileMapWidth * tileSize * 0.5
local gridStartY = love.graphics.getHeight() * 0.5 - tileMapHeight * tileSize * 0.5
local gridEndX = gridStartX + tileMapWidth * tileSize
local gridEndY = gridStartY + tileMapHeight * tileSize

local radius = 10
local speed = 1

local playerX = love.graphics.getWidth() * 0.5
local playerY = love.graphics.getHeight() * 0.5

local mouseX = love.graphics.getWidth() * 0.5
local mouseY = love.graphics.getHeight() * 0.5

love.graphics.setLineWidth(2)

function love.load(args)
end

function love.update(dt)
    if love.keyboard.isDown("w") then
        playerY = playerY - speed
    end
    if love.keyboard.isDown("a") then
        playerX = playerX - speed
    end
    if love.keyboard.isDown("s") then
        playerY = playerY + speed
    end
    if love.keyboard.isDown("d") then
        playerX = playerX + speed
    end

    mouseX, mouseY = love.mouse.getPosition()
    if love.mouse.isDown(1) and mouseX > gridStartX and mouseX < gridEndX and mouseY > gridStartY and mouseY < gridEndY then
        tileMap[math.floor((mouseY - gridStartY) / tileSize) + 1][math.floor((mouseX - gridStartX) / tileSize) + 1] = 1
    elseif love.mouse.isDown(2) and mouseX > gridStartX and mouseX < gridEndX and mouseY > gridStartY and mouseY < gridEndY then
        tileMap[math.floor((mouseY - gridStartY) / tileSize) + 1][math.floor((mouseX - gridStartX) / tileSize) + 1] = 0
    end
end

function love.draw()
    love.graphics.setColor(0, 1, 0)
    for i = 1, tileMapHeight do
        for j = 1, tileMapWidth do
            if tileMap[i][j] == 1 then
                love.graphics.rectangle("fill", gridStartX + 1 + (j - 1) * tileSize, gridStartY + 1 + (i - 1) * tileSize,
                    tileSize - 2, tileSize - 2)
            end
        end
    end

    love.graphics.setColor(1, 1, 1)
    for y = 0, tileMapHeight do
        love.graphics.line(gridStartX, y * tileSize + gridStartY, gridEndX, y * tileSize + gridStartY)
    end
    for x = 0, tileMapWidth do
        love.graphics.line(x * tileSize + gridStartX, gridStartY, x * tileSize + gridStartX, gridEndY)
    end

    local dx = mouseX - playerX
    local dy = mouseY - playerY

    local m = math.sqrt(dx * dx + dy * dy)

    local nx = dx / m
    local ny = dy / m

    local sx = m / math.abs(dx)
    local sy = m / math.abs(dy)

    local tileStartX = (playerX - gridStartX) / tileSize + 1
    local tileStartY = (playerY - gridStartY) / tileSize + 1

    local xm = (math.ceil(tileStartX) - tileStartX) * sx
    if nx < 0 then
        xm = (tileStartX - math.floor(tileStartX)) * sx
    end

    local ym = (math.ceil(tileStartY) - tileStartY) * sy
    if ny < 0 then
        ym = (tileStartY - math.floor(tileStartY)) * sy
    end

    local smaller
    repeat
        if xm <= ym or ny == 0 then
            smaller = xm
            xm = xm + sx
        else
            smaller = ym
            ym = ym + sy
        end
        love.graphics.setColor(0, 0, 1)
        love.graphics.line(playerX, playerY, playerX + nx * smaller * tileSize, playerY + ny * smaller * tileSize)
        love.graphics.setColor(1, 0, 1)
        love.graphics.circle("fill", playerX + nx * smaller * tileSize, playerY + ny * smaller * tileSize, 5)
        local i = math.floor(tileStartY + ny * smaller + ny * 0.1)
        local j = math.floor(tileStartX + nx * smaller + nx * 0.1)
    until i < 1 or i > tileMapHeight or j < 1 or j > tileMapWidth or tileMap[i][j] == 1

    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", playerX, playerY, radius)
end

