--- @class HUDRole
--- @field name string
--- @field color Color

--- @class HUDROLES
--- @field roles table<HUDRole>
HUDROLES = {}
HUDROLES.roles = {}

--- Set a role to be displayed on the scoreboard
--- @param group_name string
--- @param group_color Color
function HUDROLES:Set(group_name, group_color)
    self.roles[group_name] = {}
    self.roles[group_name].name = language.GetPhrase("goscrbrd.role." .. group_name)
    self.roles[group_name].color = group_color
end

--- Reload the locales for the existing roles
function HUDROLES:ReloadLocales()
    for k, v in pairs(self.roles) do
        v.name = language.GetPhrase("goscrbrd.role." .. k)
    end
end

-- Reload locales when the language is changed
local OldLanguageChanged = LanguageChanged or function(lang) end
function _G.LanguageChanged(lang)
    HUDROLES:ReloadLocales()
    concommand.Run(LocalPlayer(), "cl_goscrbrd_reload")
    OldLanguageChanged(lang)
end

HUDROLES:Set("default", Color(200, 200, 200))
HUDROLES:Set("user", HSLToColor(210, 0.95, 0.85))
HUDROLES:Set("admin", HSLToColor(0, 0.95, 0.85))
HUDROLES:Set("superadmin", HSLToColor(280, 0.95, 0.85))
