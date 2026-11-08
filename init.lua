-- ==== cfg

-- local cfg = {
--     x = 200,
--     y = 200,
--     size = 7,
--     start_key = "F7",
--     jump_key = "h",
--     passthrough = true,
--     colors = {
--         Player = "#FFFFFF",
--         Obsticle = "#85c0f9",
--     },
--     tick_rate = 20,
--     seed = 123
-- }

-- ==== IMPORTS
local waywall = require("waywall")
local M = {}
local u = require("ww-dinosaur-game.utils")

-- Consts

-- Vars
Jumping = false
Leveling = false
Player_Position = { y = 0, }
Sprite_obj = {}
Time = 0

-- Functions


-- APIs
M.start_game = function()
end

M.stop_game = function()
end

M.game_running = function()
end

M.setup = function(config, cfg)
    u.set_cfg(cfg)

    local level = u.generate_level(cfg.seed)
    -- print(u.level_text(level))

    config.actions["L"] = function()
        if Jumping then return end
        Jumping = true
        local t = 0
        while true do
            local h = u.height(2500, -10000, t)
            if h < 0 then break end
            t = t + cfg.tick_rate / 1000
            u.print_sprite(h)
            waywall.sleep(cfg.tick_rate)
        end
        Jumping = false
    end

    config.actions["K"] = function()
        local level_text = u.level_text(level)
        if Leveling then return end
        Leveling = true
        local t = 0
        while true do
            local d = t * 1000
            if d > 100000 then break end
            t = t + cfg.tick_rate / 1000
            u.print_level(level_text, d)
            waywall.sleep(cfg.tick_rate)
        end
        Leveling = false
    end
end

return M
