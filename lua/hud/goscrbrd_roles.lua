HUDROLES = {}

--- @param group_name string
--- @param group_color Color
function HUDROLES:Set(group_name, group_color)
    self[group_name] = {}
    self[group_name].name = language.GetPhrase("goscrbrd.role." .. group_name)
    self[group_name].color = group_color
end

function HUDROLES:ReloadLocales()
    for k, v in pairs(self) do
        if (isfunction(v)) then continue end
        v.name = language.GetPhrase("goscrbrd.role." .. k)
    end
end

local OldLanguageChanged = LanguageChanged or function() end
function LanguageChanged()
    HUDROLES:ReloadLocales()
    concommand.Run(LocalPlayer(), "cl_goscrbrd_reload")
    OldLanguageChanged()
end

HUDROLES:Set("default", Color(200, 200, 200))
HUDROLES:Set("user", Color(200, 230, 255))
HUDROLES:Set("admin", Color(255, 203, 203))
HUDROLES:Set("superadmin", Color(239, 210, 255))
