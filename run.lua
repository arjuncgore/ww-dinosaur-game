local waywall = require("waywall")
local u = require("ww-dinosaur-game.utils")

local M = {}

local obstacles = {}

M.object_setup = function(cfg, level)
    obstacles = {}
    local tile_time = TILE_WIDTH / SPEED
    for k, v in ipairs(level) do
        if v == 1 then
            table.insert(obstacles, { release = (k - 1) * tile_time, obj = nil })
        end
    end
end

local cur_x = function(obstacle, time, cfg)
    if time < obstacle.release then
        return nil
    end
    local x = cfg.x + START_X - SPEED * (time - obstacle.release)
    if x < cfg.x - STOP_X then
        return nil
    end
    return x
end

M.handle_run = function(time, cfg)
    local remaining = false
    for _, obstacle in ipairs(obstacles) do
        obstacle.obj = u.clear(obstacle.obj)
        local x = cur_x(obstacle, time, cfg)
        if x then
            obstacle.obj = waywall.text(cfg.obstacles_sprite,
                { x = math.floor(x), y = cfg.y, color = cfg.colors.obstacles, size = cfg.size })
        end
        if x or time < obstacle.release then
            remaining = true
        end
    end
    return remaining
end

M.clear_all = function()
    for _, obstacle in ipairs(obstacles) do
        obstacle.obj = u.clear(obstacle.obj)
    end
end

return M
