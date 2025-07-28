--- @class gogm_scoreboard_settings_btn : DButton
local PANEL = {}

function PANEL:Init()
    self:SetText("")

    self.icon = Material("vgui/gogm_icons/settings.png")
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, HUDPAL.Light2)
    draw.RoundedBox(8, 0, 0, w, h - 1, HUDPAL.Light1)

    surface.SetMaterial(self.icon)

    surface.SetDrawColor(HUDPAL.Dark1)
    surface.DrawTexturedRect(w * 0.5 - 12, h * 0.5 - 12, 24, 24)
end

function PANEL:DoClick()
end

vgui.Register("gogm_scoreboard_settings_btn", PANEL, "DButton")