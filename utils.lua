local waywall = require("waywall")

local M = {}

local cur_cfg = {}
M.set_cfg = function(cfg)
    cur_cfg = cfg
end


local sprite_obj = nil
M.print_sprite = function(height, cfg)
    height = height or 0
    cfg = cfg or cur_cfg
    if sprite_obj ~= nil then
        sprite_obj:close()
        sprite_obj = nil
    end
    sprite_obj = waywall.text("0", { x = cfg.x, y = cfg.y - height, color = cfg.color, size = cfg.size })
end

M.height = function(u, a, t)
    return u * t + (1 / 2) * a * t * t
end


M.generate_level = function(seed)
    math.randomseed(seed)
    local add_obstacle = function(level)
        table.insert(level, 1)
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

M.level_text = function(level)
    local level_copy = {}
    for k, v in ipairs(level) do
        if v == 0 then
            level_copy[k] = "_"
        elseif v == 1 then
            level_copy[k] = "|"
        end
    end
    return table.concat(level_copy, "")
end

local level_obj = nil
M.print_level = function(level_text, distance, cfg)
    level_text = level_text or ""
    distance = distance or 0
    cfg = cfg or cur_cfg
    if level_obj ~= nil then
        level_obj:close()
        level_obj = nil
    end
    level_obj = waywall.text(level_text, { x = cfg.x - distance, y = cfg.y, color = cfg.color, size = cfg.size })
end

return M
