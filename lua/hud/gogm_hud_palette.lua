local accent_hue = CreateConVar("cl_goscrbrd_accent_hue", "200", FCVAR_ARCHIVE, "Accent color for the scoreboard")
:GetInt()

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
    HUDPAL.Black = Color(29, 29, 29)
    HUDPAL.Dark1 = HSLToColor(accent_hue, 0.94, 0.12)
    HUDPAL.Dark2 = HSLToColor(accent_hue, 0.62, 0.17)
    HUDPAL.Dark3 = HSLToColor(accent_hue, 0.43, 0.32)
    HUDPAL.Light1 = HSLToColor(accent_hue, 0.48, 0.9)
    HUDPAL.Light2 = HSLToColor(accent_hue, 0.33, 0.68)
    HUDPAL.Light3 = HSLToColor(accent_hue, 0.28, 0.48)
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
