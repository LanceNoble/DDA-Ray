local utils = require("utils")

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

love.window.setMode(1920, 1080)

local player = {
    fov = math.pi * .5,
    moveSpd = .25,
    lookSpd = .025,
    lookAngle = 0,
    x = 11,
    y = 11
}

local distanceToProjectionPlane = love.graphics.getWidth() * .5 / math.tan(player.fov * .5)

local lookRays = {}
for i = 1, love.graphics.getWidth() do
    lookRays[i] = { 0, 0 }
end

love.graphics.setLineWidth(2)

function love.update(dt)
    if love.keyboard.isDown("j") then
        player.lookAngle = player.lookAngle - player.lookSpd
    end
    if love.keyboard.isDown("l") then
        player.lookAngle = player.lookAngle + player.lookSpd
    end

    local forwardDir = { math.cos(player.lookAngle), math.sin(player.lookAngle) }
    local leftDir = utils.rotate(forwardDir[1], forwardDir[2], -math.pi * .5)

    local dir = { 0, 0 }

    if love.keyboard.isDown("w") then
        dir[1] = dir[1] + forwardDir[1]
        dir[2] = dir[2] + forwardDir[2]
    end
    if love.keyboard.isDown("a") then
        dir[1] = dir[1] + leftDir[1]
        dir[2] = dir[2] + leftDir[2]
    end
    if love.keyboard.isDown("s") then
        dir[1] = dir[1] - forwardDir[1]
        dir[2] = dir[2] - forwardDir[2]
    end
    if love.keyboard.isDown("d") then
        dir[1] = dir[1] - leftDir[1]
        dir[2] = dir[2] - leftDir[2]
    end

    local playerOffDistance = math.sqrt(dir[1] ^ 2 + dir[2] ^ 2)

    local playerOffX = dir[1] / playerOffDistance
    if playerOffX == playerOffX and playerOffX ~= 0 then
        local ray
        if playerOffX < 0 then
            ray = utils.castRay(player.x, player.y, math.pi, tileMap)
        else
            ray = utils.castRay(player.x, player.y, 0, tileMap)
        end
        if math.abs(ray[1]) < math.abs(playerOffX * player.moveSpd) then
            if playerOffX < 0 then
                player.x = player.x + ray[1] + .01
            else
                player.x = player.x + ray[1] - .01
            end
        else
            player.x = player.x + playerOffX * player.moveSpd
        end
    end

    local playerOffY = dir[2] / playerOffDistance
    if playerOffY == playerOffY and playerOffY ~= 0 then
        local ray
        if playerOffY < 0 then
            ray = utils.castRay(player.x, player.y, math.pi * 1.5, tileMap)
        else
            ray = utils.castRay(player.x, player.y, math.pi * 0.5, tileMap)
        end
        if math.abs(ray[2]) < math.abs(playerOffY * player.moveSpd) then
            if playerOffY < 0 then
                player.y = player.y + ray[2] + .01
            else
                player.y = player.y + ray[2] - .01
            end
        else
            player.y = player.y + playerOffY * player.moveSpd
        end
    end
end

function love.draw()
    for i = 1, #lookRays * .5 do
        local angle = math.atan(math.sin(player.fov * .5) / (#lookRays * .5) * i / math.cos(player.fov * .5))
        local ray = utils.castRay(player.x, player.y, player.lookAngle - angle, tileMap)
        local height = love.graphics.getHeight() / (math.sqrt(ray[1] ^ 2 + ray[2] ^ 2) * math.cos(angle))
        local screenCenterY = love.graphics.getHeight() * 0.5
        local barWidth = love.graphics.getWidth() / #lookRays
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", (#lookRays * .5 - i) * barWidth, screenCenterY - height * .5, barWidth, height)
    end
    for i = 1, #lookRays * .5 do
        local angle = math.atan(math.sin(player.fov * .5) / (#lookRays * .5) * i / math.cos(player.fov * .5))
        local ray = utils.castRay(player.x, player.y, player.lookAngle + angle, tileMap)
        local height = love.graphics.getHeight() / (math.sqrt(ray[1] ^ 2 + ray[2] ^ 2) * math.cos(angle))
        local screenCenterY = love.graphics.getHeight() * 0.5
        local barWidth = love.graphics.getWidth() / #lookRays
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", (#lookRays * .5 + i) * barWidth, screenCenterY - height * .5, barWidth, height)
    end
end
