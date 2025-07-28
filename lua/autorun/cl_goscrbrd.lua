local load_scripts = {
    "hud/gogm_hud_palette.lua",
    "hud/goscrbrd_roles.lua",
    "hud/gogm_hud_scoreboard.lua",
}

local no_autoload_scripts = {
    "hud/gogm_hud_util.lua",
    "hud/gogm_hud_fonts.lua",

    -- hud components
    "hud/components/scoreboard_mute_btn.lua",
    "hud/components/scoreboard_settings_btn.lua",
    "hud/components/scoreboard_row.lua",
    "hud/components/scoreboard_title.lua",
    "hud/components/scoreboard_frame.lua",
    "hud/components/icon.lua"
}

if SERVER then
    resource.AddWorkshop("3368132886")
    for _,script in ipairs(load_scripts) do
        AddCSLuaFile(script)
    end
    for _,script in ipairs(no_autoload_scripts) do
        AddCSLuaFile(script)
    end
else
    for _,script in ipairs(load_scripts) do
        include(script)
    end
end