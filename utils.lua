local utils = {}

function utils.castRay(x, y, offX, offY, map)
    local dist = math.sqrt(offX * offX + offY * offY)

    local xDir = offX / dist
    local yDir = offY / dist

    local distPerX = dist / math.abs(offX)
    local distPerY = dist / math.abs(offY)

    local xDist = (math.ceil(x) - x) * distPerX
    if offX < 0 then
        xDist = (x - math.floor(x)) * distPerX
    end

    local yDist = (math.ceil(y) - y) * distPerY
    if offY < 0 then
        yDist = (y - math.floor(y)) * distPerY
    end

    local smallerDist
    repeat
        smallerDist = xDist
        if xDist > yDist or offX == 0 then
            smallerDist = yDist
            yDist = yDist + distPerY
        else
            xDist = xDist + distPerX
        end

        -- Add yDir and xDir at the end so the ray does not undershoot the tile it was supposed to hit
        -- Multiply yDir and xDir by 0.1 so the ray does not overshoot the tile it was supposed to hit
        local i = math.floor(y + yDir * smallerDist + yDir * 0.1)
        local j = math.floor(x + xDir * smallerDist + xDir * 0.1)
    until i < 1 or i > #map or j < 1 or j > #map[1] or map[i][j] == 1

    return { xDir * smallerDist, yDir * smallerDist }
end

return utils
