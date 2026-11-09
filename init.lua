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
local jump = function(cfg)
    if Jumping then return end
    Jumping = true
    local t = 0
    local h = 0
    while true do
        h = u.height(initial_velocity, gravity, t)
        local gravity = -500 * cfg.tick_rate
        local max_height = 150
        local initial_velocity = u.initial_velocity(0, gravity, max_height)
        print(math.max(0, h))
        u.print_sprite(math.max(0, h))
        t = t + cfg.tick_rate / 1000
        waywall.sleep(cfg.tick_rate)
        if h < 0 then break end
    end
    Jumping = false
end

local run = function(cfg, level)
    local level_text = u.level_text(level)
    if Leveling then return end
    Leveling = true
    local t = 0
    while true do
        local d = t * 50 * cfg.tick_rate
        if d > 100000 then break end
        t = t + cfg.tick_rate / 1000
        u.print_level(level_text, d - 500)
        waywall.sleep(cfg.tick_rate)
    end
    Leveling = false
end

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
        jump(cfg)
    end

    config.actions["K"] = function()
        run(cfg, level)
    end
end

return M
