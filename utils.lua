local utils = {}

function utils.castRay(x, y, radians, map)
    local xDirection = math.cos(radians)
    local yDirection = math.sin(radians)

    local distancePerX = 1 / math.abs(xDirection)
    local distancePerY = 1 / math.abs(yDirection)

    local xDistance
    if xDirection < 0 then
        xDistance = (x - math.floor(x)) * distancePerX
    else
        xDistance = (math.ceil(x) - x) * distancePerX
    end

    local yDistance
    if yDirection < 0 then
        yDistance = (y - math.floor(y)) * distancePerY
    else
        yDistance = (math.ceil(y) - y) * distancePerY
    end

    local rayDistance
    repeat
        if xDistance < yDistance or yDistance ~= yDistance then
            rayDistance = xDistance
            xDistance = xDistance + distancePerX
        else
            rayDistance = yDistance
            yDistance = yDistance + distancePerY
        end

        -- Add yDirection and xDirection at the end so the ray does not undershoot the tile it was supposed to hit
        -- Multiply yDirection and xDirection by 0.1 so the ray does not overshoot the tile it was supposed to hit
        local i = y + yDirection * rayDistance + yDirection * 0.01
        local j = x + xDirection * rayDistance + xDirection * 0.01

        -- Stop ray from clipping through diagonal walls
        local k = y + yDirection * rayDistance
        local l = x + xDirection * rayDistance
    until i < 1 or i > #map or j < 1 or j > #map[1] or map[math.floor(i)][math.floor(l)] == 1 or map[math.floor(k)][math.floor(j)] == 1

    return { xDirection * rayDistance, yDirection * rayDistance }
end

function utils.emanateRays(x, y, upperRadians, lowerRadians, numLevels, map)
    if numLevels == 0 then
        return {}
    end
    local centerRadians = (upperRadians + lowerRadians) * .5
    local rays = { utils.castRay(x, y, centerRadians, map) }
    for index, value in ipairs(utils.emanateRays(x, y, centerRadians, upperRadians, numLevels - 1, map)) do
        table.insert(rays, value)
    end
    for index, value in ipairs(utils.emanateRays(x, y, centerRadians, lowerRadians, numLevels - 1, map)) do
        table.insert(rays, value)
    end
    return rays
end

return utils
