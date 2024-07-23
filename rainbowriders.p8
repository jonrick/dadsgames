pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

-- UTILITIES
#include src/utils/colors.lua
#include src/utils/special_effects.lua
#include src/utils/rbp_rainbow.lua
#include src/utils/math.lua

-- SCREENS
#include src/screens/title.lua
#include src/screens/character_select.lua
#include src/screens/game_over.lua
#include src/screens/game.lua

screens = {
    title = {
        view = function () title_screen_view() end,
        controller = function () title_screen_controller() end
    },
    character_select = {
        view = function () character_select_view() end,
        controller = function () character_select_controller() end
    },
    game = {
        view = function () game_view() end,
        controller = function () game_controller() end
    },
    game_over = {
        view = function () game_over_view() end,
        controller = function () game_over_controller() end
    },
    high_score = {
        view = function () high_score_view() end,
        controller = function () high_score_controller() end
    },
    credits = {
        view = function () credits_view() end,
        controller = function () credits_controller() end
    }
}

-- Initialize variables
player = {
    x = 16,
    y = 104,
    dy = 0,
    jump_strength = -4,
    gravity = 0.4,
    on_ground = true,
    sprite = 1, -- Default sprite index
    width = 6, -- Tighter collision box width
    height = 6, -- Tighter collision box height
    oscillation = 0 --Variable for oscillation
}
debug_mode = false
obstacles = {}
spawn_timer = 0
spawn_interval = 20
title_screen = true
char_select_screen = false
game_over = false
game_over_timer = 0
game_over_delay = 180 -- 1 second (60 frames per second)
background_x = 0
background_n = 128 * 8 -- number of tiles wide for the background in the map * 8
background_y = 96--84
clouds = {}
cloud_timer = 0
cloud_interval = 120
grass = {}

rainbow_colors = {8, 9, 10, 11, 12, 13, 14}
color_index = 1
color_timer = 0
color_interval = 5
selected_char = 1
char_names = {"lizzie", "lily", "riker", "lukas", "maverick", "michael"}

-- Timer variables
timer = 0
timer_frame_counter = 0

-- Score variable
score = 0
high_score = 0

function _init()
    cartdata("dads_rr_1")
    high_score = dget(0)
    menuitem(1, "reset high score",
    function()
        score = 0
        high_score = 0
        dset(0,0)
    end
    )
    menuitem(2, "debug toggle",
    function()
        if debug_mode == true then
            debug_mode = false
        else
            debug_mode = true
        end
    end
    )
end

function _update()
    if title_screen then
        title_screen_controller()
    elseif char_select_screen then
        character_select_controller()
    elseif game_over then
        game_over_controller()
    else
        game_controller()
    end
end

function _draw()
    cls()
    if title_screen then
        title_screen_view()
    elseif char_select_screen then
        character_select_view()
    elseif game_over then
        game_over_view()
    else
        game_view()
    end

    --this must be last
    if debug_mode == true then
        print("D", 1,1,7)
    end
end

__gfx__
000000000000000000000000000000000000000000000000004f0000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004f000000af0000004f0000004f00000004f00004ff0000000000000000000000000000000000000000000000000000000000000000000000000000
0070070004ff00000aff000000ff000000ff0000000ff00004220500000000000000000000000000000000000000000000000000000000000000000000000000
000770000020e00000e0b0000030c00000c00000000805000022f500000000000000000000000000000000000000000000000000000000000000000000000000
00077000002fe00000efb000003fc00005cf88000008f50000220500000000000000000000000000000000000000000000000000000000000000000000000000
007007000080e0000080b0000050c000055c88000006050000660500000000000000000000000000000000000000000000000000000000000000000000000000
000000000eeeee000bbbbb000ccccc0008888dd00555555055555550000000000000000000000000000000000000000000000000000000000000000000000000
000000000d000d000d000d000d000d000d000dd00d000d000d000d00000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bbbbbb000000000770000070000000777770000000000000000000000000000000000000000000000000000000000000007ccc0000000000000000000000
00bb334433bbb00007777770077777007777777000000000000000000000000000000000000000700000000000000000000007ccccc000000000000000000000
0044334444443b007777777777677777777777770000000000000000000000000000777600000766000000000000000000007ccccccc00000000000000000000
043344b4bb434300766777770006667776677666000000000000000000000000000666666600066600000000000007600007ccccccccc0000000000000000000
003b34bbb433300000066600000000000066600000000000000000000000000000cc6c6c6c6006650007c00000007660066dddddddddd6600000000000000000
bb44bb4434443bb000000000000000000000000000000000000000000000000007dd6d6d6d666665007cccc0000766605b6b6b6b6b6b6b6b0000000000000000
043343b444bb43000000000000000000000000000b00000000000000000000b0066666666666666500ccccc66666666005666666666666600000000000000000
043bb344443333b00000000000000000000000000bb0b00bb0b00b000b000bb0566666666665666006ddddd66666666500555555555555000000000000000000
0b344444444bb3000000000000000000000000000000000e8000000000000000056666566666506566666666666666660000b333333b00000000000000000000
bb433344433433300000007eee00e8000000007ccccccce888cccccccc00000000555665666665005666656665666665000b33355533b0000000000000000000
0300004440000300000007ee88805600000007ccccccc7e2488cccccccc000000000550056666650055566566656660000b3335151333b000000000000000000
000000404000000000007e5e8588560000007ccccccc7e244488cccccccc0000000000000555550000000005666500000b333335533333b00000000000000000
00000044400000000007e56e856886000007ccccccc7e24444488cccccccc00000000000000000000000000055500000b33335353533333b0000000000000000
0000004440000000007e566e85668800007ccccccc7e2444444488cccccccc0000000000000000000000000000000000b33333555333333b0000000000000000
000004442400000007e5666e8566688007ccccccc7e244444444488cccccccc00000000000000000000000000000000003333335333333300000000000000000
00004242424000007e888888888888887cccccccce8244444444488ccccccccc0000000000000000000000000000000000333353533333000000000000000000
00999900000000000055555555555500005555555555555555555555555555000cccccccccccccc0000000000000000000000000000000000000000000000000
099aa99000000000005666666666660000566666666666666666666666666600cc7c7c7c777c77cc000000000000000000000000000000000000000000000000
99aaaa990000000000566a66666666000056e888888888888888888888888600cc7c7c7c7c7c7c7c000000000000000000000000000000000000000000000000
9aaaaaa90000000000569aa6664466000056eddddd8668dddd8dddd8dddd8600cc7c777c7c7c77cc000000000000000000000000000000000000000000000000
9aaaaaa90000000000569aa6624446000056eddddd8668dddd8dddd8dddd8600cc7c7c7c777c7ccc000000000000000000000000000000000000000000000000
99aaaa99000000000056444662d446000056ed5d5d8668dddd8dddd8dddd8600ccccccc8ccccc8cc000000000000000000000000000000000000000000000000
099aa9900000000003565556624446300356eddddd8666636666366663666630cccccccc8ccc8ccc000000000000000000000000000000000000000000000000
00999900000000003336666bb24443333336eddddd86663336633366333663330dddddddd888ddd0000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000e00000088000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000e8800007878000000a0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000033300000000000e880008878880000a9a000000000004000000400000000000000000000000000000000
0000000000000000000bbb0000000000000080000003333300088000000800000787800000aaa000000000004444444400000000000000000000000000000000
000000000000000000b33b300009000000078700000066600088880000050000008800000aa9aa00000000004000000400000000000000000000000000000000
00009000000650000b33b33b000aa000000777000000333000588000000050000005000000050000000000004444444400000000000000000000000000000000
0004440000655500b33b33b300099000000400000000333000088000000500000005000000050000000c0c004000000400000000000000000000000000000000
00442240065565500333333000aaaa000004000000003550008888000000000000050000000500001cc1c11c4000000400000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f000000000
00000004f00000000000000000000af000000000000000000004f000000000000000000004f0000000000000000000004f0000000000000000004ff000000000
0000004ff0000000000000000000aff00000000000000000000ff00000000000000000000ff000000000000000000000ff000000000000000000422050000000
000000020e0000000000000000000e0b000000000000000000030c0000000000000000000c000000000000000000000080500000000000000000022f50000000
00000002fe0000000000000000000efb00000000000000000003fc0000000000000000005cf8800000000000000000008f500000000000000000022050000000
000000080e000000000000000000080b000000000000000000050c00000000000000000055c88000000000000000000060500000000000000000066050000000
000000eeeee00000000000000000bbbbb00000000000000000ccccc000000000000000008888dd00000000000000005555550000000000000005555555000000
000000d000d00000000000000000d000d00000000000000000d000d00000000000000000d000dd0000000000000000d000d00000000000000000d000d0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000099909990999099009990099090900000999099909900999099900990000000000000000000000000000000000000000
00000000000000000000000000000000090909090090090909090909090900000909009009090900090909000000000000000000000000000000000000000000
00000000000000000000000000000000099009990090090909900909090900000990009009090990099009990000000000000000000000000000000000000000
00000000000000000000000000000000090909090090090909090909099900000909009009090900090900090000000000000000000000000000000000000000
00000000000000000000000000000000090909090999090909990990099900000909099909990999090909900000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000077707770777007700770000007707770777077707770000000000000000000000000000000000000000000000
00000000000000000000000000000000000000070707070700070007000000070000700707070700700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000077707700770077707770000077700700777077000700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000070007070700000700070000000700700707070700700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000070007070777077007700000077000700707070700700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000110010000000110011011101010111011100110101011100000110011101110111000000000000011001110110001100100000001101110111011100110
10001000001000001000101010101010101001001000101001000000010010100010001000000000000010101010101010001000000010001010111010001000
10001000001000001000101011101110110001001000111001000000010011100010001000001110000010101110101011100000000010001110101011001110
10001000001000001000101010000010101001001010101001000000010000100010001000000000000010101010101000100000000010101010101010000010
01000110010000000110110010001110101011101110101001000000111000100010001000000000000011101010111011000000000011101010101011101100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
4041000000525300000000000052530000000000005253000040410000000000000000404100525300000000000000005455565700000048490044004a4b00004c4d0060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051450046626300460047000062630045000047006263004650510045000046474645505145626345470000464668696465666746470058590047465a5b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
151000000c0530000024625000000c0530000024625000000c05300000246250c053000000c05324625000000c0530000024625000000c0530000024625000000c05300000246250c053000000c0532462500000
901000000ca5000a0018a5000a000ca5000a0018a5000a000ca5000a0018a500ca5000a000ca5018a5000a0011a5000a0011a5000a0011a5000a0011a5000a0013a5000a0013a5000a0013a5000a0013a5000a00
00100000280500000000000000002405000000210501f05000000000001f05000000220502405000000000001f050000001d050000001d050000001d050000001f050000001f0500000022050240500000000000
001000002405000000240500000024050000002405000000220500000022050000002205000000220500000021050000002105000000210500000021050000002005000000200500000020050000001f05000000
0010000028050000002805000000280500000024050000001d050000001f05000000220500000024050000002205000000220500000021050000001f050000002105000000220500000021050000001805000000
01100000240500000022050000000000000000220500000021050000000000000000000000000000000000001d050000001b050000000000000000000001b0500000018050000001605000000180500000000000
0010000018a5024a5022a501ba501da5018a5016a5017a5018a5024a5022a501ba501da5018a5016a5017a5024a5030a503aa5033a5035a5030a5022a5023a5030a503ca503aa503fa5035a503ca503aa503ba50
001000000ca500000000000000000ca5000000000000ca50000000ca500000000000000000000000000000000fa500000000000000000fa5000000000000fa50000000fa50000000000000000000000000000000
001000001da500000000000000001da5000000000001da50000001da5000000000000000000000000000000020a5000000000000000020a50000000000022a50000000000022a500000000000000000000000000
001000001fa50000001fa500000018a50000001fa5024a50000000000024a500000022a5021a5000000000001fa500000018a500000018a50000001fa50000001da50000001ba50000001ca5018a500000000000
0010000024a500000028a500000024a500000028a5026a5000000000001fa500000021a5022a5000000000000ca500000010a500000011a500000013a50000000000000000000000000000000000000000000000
0020000024a500000027a500000029a5027a5029a502ba5024a50000002ea50000002da50000002ca502ba5000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41424346
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
01 01404344
00 01024344
00 01024344
00 0102034c
00 01024344
00 01020344
00 01024444
00 01020646
00 01020644
00 01024744
00 41020944
00 41020a44
00 01020944
00 01024344
02 01420744

