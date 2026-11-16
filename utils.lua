local waywall = require("waywall")

local M = {}

M.clear = function(obj)
    if obj ~= nil then
        obj:close()
    end
    return nil
end


local sprite_obj = nil
M.print_sprite = function(height, cfg)
    height = height or 0
    sprite_obj = M.clear(sprite_obj)
    sprite_obj = waywall.text(cfg.player_sprite,
        { x = cfg.x, y = cfg.y - height, color = cfg.colors.player, size = cfg.size })
end

M.height = function(u, a, t)
    return u * t + (1 / 2) * a * t * t
end

M.initial_velocity = function(v, a, s)
    return math.sqrt(v - 2 * a * s)
end


M.generate_level = function(seed)
    math.randomseed(seed)
    local add_obstacle = function(level)
        table.insert(level, 1)
        table.insert(level, 0)
        table.insert(level, 0)
        table.insert(level, 0)
        table.insert(level, 0)
    end

    local level = {}

    for _ = 1, 100 do
        local gap = math.random() * 10
        for _ = 1, gap do
            table.insert(level, 0)
        end
        add_obstacle(level)
    end

    return level
end

return M
