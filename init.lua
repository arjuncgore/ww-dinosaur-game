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
local r = require("ww-dinosaur-game.run")

-- Consts

-- Vars
Jumping = false
Running = false
Falling = false
Player_y = 0
START_X = 2000
STOP_X = 300
SPEED = 1000
PLAYER_WIDTH = 8
OBSTACLE_WIDTH = 8
TILE_HEIGHT = 10
BUFFER = 50
local jump_id = 0

-- Functions
local jump = function(cfg)
    local gravity = -500 * cfg.tick_rate
    local max_height = 150
    local initial_velocity = u.initial_velocity(0, gravity, max_height)
    local t_highest = initial_velocity / -gravity

    if Jumping and not (Falling and Player_y < BUFFER) then return end

    jump_id = jump_id + 1
    local cur_id = jump_id
    Jumping = true
    Falling = false
    if cfg.jump_hook then
        cfg.jump_hook()
    end

    local t = 0
    while true do
        Player_y = u.height(initial_velocity, gravity, t)
        Falling = t > t_highest
        u.print_sprite(math.max(0, Player_y), cfg)
        t = t + cfg.tick_rate / 1000
        waywall.sleep(cfg.tick_rate)
        if cur_id ~= jump_id then
            return
        end
        if Player_y < 0 then
            break
        end
    end

    Player_y = 0
    Falling = false
    Jumping = false
end

local run = function(cfg, level)
    if Running then return end
    Running = true
    r.object_setup(cfg, level)
    u.print_sprite(0, cfg)
    local start = waywall.current_time()

    local run_status
    while true do
        local time = (waywall.current_time() - start) / 1000
        run_status = r.handle_run(time, cfg)
        if run_status ~= "continue" then
            break
        end
        waywall.sleep(cfg.tick_rate)
    end

    -- handle run_status

    r.clear_all()
    u.clear_sprite()
    Running = false
end

-- APIs
M.start_game = function()
end

M.stop_game = function()
end

M.game_running = function()
end

M.setup = function(config, cfg)
    PLAYER_WIDTH = cfg.size * (8 * #cfg.player_sprite - 2)
    OBSTACLE_WIDTH = cfg.size * (8 * #cfg.obstacles_sprite - 2)
    TILE_HEIGHT = cfg.size * 10

    local level = u.generate_level(cfg.seed)

    config.actions[cfg.jump_key] = function()
        jump(cfg)
        return not cfg.passthrough
    end

    config.actions["K"] = function()
        run(cfg, level)
    end
end

return M
