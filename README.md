```lua
    local dg = require("ww-dinosaur-game.init")

    local dg_cfg = {
        player_sprite = "2",
        obstacles_sprite = "0",
        x = 200,
        y = 1000,
        size = 7,
        start_key = "F7",
        jump_key = "L",
        passthrough = true,
        colors = {
            player = "#FFFFFF",
            obstacles = "#85c0f9",
        },
        tick_rate = 20,
        seed = 100,
        jump_hook = nil
    }
    dg.setup(config, dg_cfg)
```
