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

M.print_object = function(obj, distance, cfg)
    if obj ~= nil then
        obj:close()
        obj = nil
    end
    distance = distance or 0
    cfg = cfg or cur_cfg
    obj = waywall.text(cfg.obstacle_sprite,
        { x = cfg.x - distance, y = cfg.y, color = cfg.colors.obstacles, size = cfg.size })
end

local test_obstacle = {
    idx = 1,      -- 1, 2, 3, 4
    release = 19, -- tick to release at
    obj = nil,    -- waywall text object
}

M.run_object = function(obstacle, cfg)
    local t = 0
    while true do
        local d = t * 50 * cfg.tick_rate
        if d > 100000 then break end
        t = t + cfg.tick_rate / 1000
        M.print_object(obstacle.obj, d - 500)
        waywall.sleep(cfg.tick_rate)
    end
    Leveling = false
end

M.level_text = function(level, cfg)
    local level_copy = {}
    for k, v in ipairs(level) do
        if v == 0 then
            level_copy[k] = cfg.obstacle_sprite
        elseif v == 1 then
            level_copy[k] = "O"
        end
    end
    return table.concat(level_copy, "")
end


return M
