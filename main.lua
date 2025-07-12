local utils = require("utils")

local tileSize = 30
local tileMapW = 20
local tileMapH = 20
local tileMap = {}

for i = 1, tileMapH do
    tileMap[i] = {}
    for j = 1, tileMapW do
        if i == 1 or i == tileMapH or j == 1 or j == tileMapW then
            tileMap[i][j] = 1
        else
            tileMap[i][j] = 0
        end
    end
end

love.window.setMode(1280, 720)

local gridX1 = love.graphics.getWidth() * 0.5 - tileMapW * tileSize * 0.5
local gridY1 = love.graphics.getHeight() * 0.5 - tileMapH * tileSize * 0.5
local gridX2 = gridX1 + tileMapW * tileSize
local gridY2 = gridY1 + tileMapH * tileSize

local playerRad = 10
local playerSpd = 2
local playerAngle = math.pi * 0.25
local playerX = love.graphics.getWidth() * 0.5
local playerY = love.graphics.getHeight() * 0.5
local playerUnitX = (playerX - gridX1) / tileSize + 1
local playerUnitY = (playerY - gridY1) / tileSize + 1

local mouseX
local mouseY

love.graphics.setLineWidth(2)

function love.update(dt)
    if love.keyboard.isDown("j") then
        playerAngle = playerAngle - 0.01
    end
    if love.keyboard.isDown("l") then
        playerAngle = playerAngle + 0.01
    end

    local playerOffX = 0
    local playerOffY = 0

    if love.keyboard.isDown("w") then
        playerOffY = playerOffY - playerSpd
    end
    if love.keyboard.isDown("a") then
        playerOffX = playerOffX - playerSpd
    end
    if love.keyboard.isDown("s") then
        playerOffY = playerOffY + playerSpd
    end
    if love.keyboard.isDown("d") then
        playerOffX = playerOffX + playerSpd
    end

    local playerOffDistance = math.sqrt(playerOffX * playerOffX + playerOffY * playerOffY)

    playerOffX = playerOffX / playerOffDistance * playerSpd
    if playerOffX == playerOffX and playerOffX ~= 0 then
        local xRay
        if playerOffX < 0 then
            xRay = utils.castRay(playerUnitX, playerUnitY, math.pi, tileMap)
        else
            xRay = utils.castRay(playerUnitX, playerUnitY, 0, tileMap)
        end
        if math.abs(xRay[1] * tileSize) < math.abs(playerOffX) then
            if playerOffX < 0 then
                playerX = playerX + xRay[1] * tileSize + 0.1
            else
                playerX = playerX + xRay[1] * tileSize - 0.1
            end
        else
            playerX = playerX + playerOffX
        end
        playerUnitX = (playerX - gridX1) / tileSize + 1
    end

    playerOffY = playerOffY / playerOffDistance * playerSpd
    if playerOffY == playerOffY and playerOffY ~= 0 then
        local yRay
        if playerOffY < 0 then
            yRay = utils.castRay(playerUnitX, playerUnitY, math.pi * 1.5, tileMap)
        else
            yRay = utils.castRay(playerUnitX, playerUnitY, math.pi * 0.5, tileMap)
        end
        if math.abs(yRay[2] * tileSize) < math.abs(playerOffY) then
            if playerOffY < 0 then
                playerY = playerY + yRay[2] * tileSize + 0.1
            else
                playerY = playerY + yRay[2] * tileSize - 0.1
            end
        else
            playerY = playerY + playerOffY
        end
        playerUnitY = (playerY - gridY1) / tileSize + 1
    end

    mouseX, mouseY = love.mouse.getPosition()
    if love.mouse.isDown(1) and mouseX > gridX1 and mouseX < gridX2 and mouseY > gridY1 and mouseY < gridY2 then
        tileMap[math.floor((mouseY - gridY1) / tileSize) + 1][math.floor((mouseX - gridX1) / tileSize) + 1] = 1
    elseif love.mouse.isDown(2) and mouseX > gridX1 and mouseX < gridX2 and mouseY > gridY1 and mouseY < gridY2 then
        tileMap[math.floor((mouseY - gridY1) / tileSize) + 1][math.floor((mouseX - gridX1) / tileSize) + 1] = 0
    end
end

function love.draw()
    love.graphics.setColor(0, 1, 0)
    for i = 1, tileMapH do
        for j = 1, tileMapW do
            if tileMap[i][j] == 1 then
                love.graphics.rectangle("fill", gridX1 + 1 + (j - 1) * tileSize, gridY1 + 1 + (i - 1) * tileSize,
                    tileSize - 2, tileSize - 2)
            end
        end
    end

    love.graphics.setColor(1, 1, 1)
    for y = 0, tileMapH do
        love.graphics.line(gridX1, y * tileSize + gridY1, gridX2, y * tileSize + gridY1)
    end
    for x = 0, tileMapW do
        love.graphics.line(x * tileSize + gridX1, gridY1, x * tileSize + gridX1, gridY2)
    end

    local pts = { 0, 0 }
    local playerToMouseX = mouseX - playerX
    local playerToMouseY = mouseY - playerY
    if playerToMouseX ~= 0 or playerToMouseY ~= 0 then
        pts = utils.castRay(playerUnitX, playerUnitY, playerAngle, tileMap)
        local mag = math.sqrt(pts[1] * pts[1] + pts[2] * pts[2])
        local height = love.graphics.getHeight() / mag
        local screenCenterY = love.graphics.getHeight() * 0.5
        love.graphics.line(100, screenCenterY - height / 2, 100, screenCenterY + height / 2)
    end

    love.graphics.setColor(0, 0, 1)
    love.graphics.line(playerX, playerY, playerX + pts[1] * tileSize, playerY + pts[2] * tileSize)

    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", playerX, playerY, playerRad)
end
