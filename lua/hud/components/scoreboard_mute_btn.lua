--- @class gogm_scoreboard_mute_btn : DButton
local PANEL = {}

function PANEL:Init()
    self:SetText("")

    self.volumeOnMaterial = Material("vgui/gogm_icons/volume_on.png")
    self.volumeOffMaterial = Material("vgui/gogm_icons/volume_off.png")

    self.player = LocalPlayer()

    self.userMuted = self.player:IsMuted()
end

--- @param ply Player
function PANEL:SetPlayer(ply)
    self.player = ply
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, HUDPAL.Light2)
    draw.RoundedBox(8, 0, 0, w, h - 1, HUDPAL.Light3)

    if (self.userMuted) then surface.SetMaterial(self.volumeOffMaterial) else surface.SetMaterial(self.volumeOnMaterial) end

    surface.SetDrawColor(HUDPAL.Dark1)
    surface.DrawTexturedRect(w * 0.5 - 12, h * 0.5 - 12, 24, 24)
end

function PANEL:DoClick()
    self.userMuted = not self.userMuted
    self.player:SetMuted(self.userMuted)
end

vgui.Register("gogm_scoreboard_mute_btn", PANEL, "DButton")