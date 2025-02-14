local accent_hue = CreateConVar("cl_goscrbrd_accent_hue", "200", FCVAR_ARCHIVE, "Accent color for the scoreboard"):GetInt()

--- @class HUDPAL
--- @field Black Color
--- @field Dark1 Color
--- @field Dark2 Color
--- @field Dark3 Color
--- @field Light1 Color
--- @field Light2 Color
--- @field Light3 Color
--- @field White Color
HUDPAL = {}

local function rebuildColors()
    local HUDPALhsl = {}
    HUDPALhsl.Dark3 = {}
    HUDPALhsl.Dark3.h = accent_hue
    HUDPALhsl.Dark3.s = 0.43
    HUDPALhsl.Dark3.l = 0.32

    HUDPALhsl.Dark2 = {}
    HUDPALhsl.Dark2.h = accent_hue
    HUDPALhsl.Dark2.s = math.Clamp(HUDPALhsl.Dark3.s * 1.44186, 0, 1)
    HUDPALhsl.Dark2.l = math.Clamp(HUDPALhsl.Dark3.l * 0.53125, 0, 1)

    HUDPALhsl.Dark1 = {}
    HUDPALhsl.Dark1.h = accent_hue
    HUDPALhsl.Dark1.s = math.Clamp(HUDPALhsl.Dark3.s * 2.18604, 0, 1)
    HUDPALhsl.Dark1.l = math.Clamp(HUDPALhsl.Dark3.l * 0.375, 0, 1)

    HUDPALhsl.Light1 = {}
    HUDPALhsl.Light1.h = accent_hue
    HUDPALhsl.Light1.s = math.Clamp(HUDPALhsl.Dark3.s * 1.11627, 0, 1)
    HUDPALhsl.Light1.l = math.Clamp(HUDPALhsl.Dark3.l * 2.8125, 0, 1)

    HUDPALhsl.Light2 = {}
    HUDPALhsl.Light2.h = accent_hue
    HUDPALhsl.Light2.s = math.Clamp(HUDPALhsl.Dark3.s * 0.76744, 0, 1)
    HUDPALhsl.Light2.l = math.Clamp(HUDPALhsl.Dark3.l * 2.125, 0, 1)

    HUDPALhsl.Light3 = {}
    HUDPALhsl.Light3.h = accent_hue
    HUDPALhsl.Light3.s = math.Clamp(HUDPALhsl.Dark3.s * 0.65116, 0, 1)
    HUDPALhsl.Light3.l = math.Clamp(HUDPALhsl.Dark3.l * 1.5, 0, 1)

    HUDPAL.Black = Color(29, 29, 29)
    HUDPAL.Dark1 = HSLToColor(HUDPALhsl.Dark1.h, HUDPALhsl.Dark1.s, HUDPALhsl.Dark1.l)
    HUDPAL.Dark2 = HSLToColor(HUDPALhsl.Dark2.h, HUDPALhsl.Dark2.s, HUDPALhsl.Dark2.l)
    HUDPAL.Dark3 = HSLToColor(HUDPALhsl.Dark3.h, HUDPALhsl.Dark3.s, HUDPALhsl.Dark3.l)
    HUDPAL.Light1 = HSLToColor(HUDPALhsl.Light1.h, HUDPALhsl.Light1.s, HUDPALhsl.Light1.l)
    HUDPAL.Light2 = HSLToColor(HUDPALhsl.Light2.h, HUDPALhsl.Light2.s, HUDPALhsl.Light2.l)
    HUDPAL.Light3 = HSLToColor(HUDPALhsl.Light3.h, HUDPALhsl.Light3.s, HUDPALhsl.Light3.l)
    HUDPAL.White = Color(249, 249, 249)
end

cvars.AddChangeCallback("cl_goscrbrd_accent_hue", function(name, old, new)
    local new = tonumber(new)
    if (new == nil) then
        MsgN("cl_goscrbrd_accent_hue must be a number!")
        GetConVar(name):SetString(old)
        return
    end
    accent_hue = math.Clamp(new, 0, 360)
    rebuildColors()
    concommand.Run(LocalPlayer(), "cl_goscrbrd_reload")
end)

hook.Add("OnReloaded", "good_old_scoreboard_colors", function()
    rebuildColors()
    concommand.Run(LocalPlayer(), "cl_goscrbrd_reload")
end)
rebuildColors()