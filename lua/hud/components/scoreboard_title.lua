local hud_utils = include("hud/gogm_hud_util.lua")
include("hud/components/icon.lua")

local PANEL = {}

local function updatePlayerCount(self)
    self.playerCount = #player.GetAll()
    self.playerCountLabel:SetText(hud_utils.leftpad(tostring(self.playerCount), 3, "0")
        .. " / " .. hud_utils.leftpad(tostring(game.MaxPlayers()), 3, "0"))
end

function PANEL:Init()
    self.title = vgui.Create("DLabel", self)
    self.title:SetFont("GOGmScoreboardTitle")
    self.title:SetTextColor(HUDPAL.Light3)

    self.playerCount = 0

    self.playerCountLabel = vgui.Create("DLabel", self)
    self.playerCountLabel:SetFont("GOGmScoreboardNumbers")
    self.playerCountLabel:SetTextColor(HUDPAL.Light3)

    self.playerCountIcon = vgui.Create("gogm_icon", self)
    self.playerCountIcon:SetColor(HUDPAL.Light3)
    self.playerCountIcon:SetIconMaterial("vgui/gogm_icons/group.png")

    updatePlayerCount(self)
end

function PANEL:PerformLayout(w, h)
    surface.SetFont("GOGmScoreboardTitle")
    local t_width, t_height = surface.GetTextSize(self.title:GetText())
    self.title:SetSize(t_width, t_height)
    self.title:Dock(LEFT)
    surface.SetFont("GOGmScoreboardNumbers")

    local pc_width, pc_height = surface.GetTextSize(self.playerCountLabel:GetText())
    self.playerCountLabel:SetSize(pc_width, pc_height)
    self.playerCountLabel:Dock(RIGHT)

    self.playerCountIcon:SetSize(24, 24)
    self.playerCountIcon:DockMargin(0, 0, 12, 0)
    self.playerCountIcon:Dock(RIGHT)
end

function PANEL:Think()
    local newHostName = GetHostName()
    if (newHostName ~= self._oldHostName) then
        self.title:SetText(newHostName)
        self._oldHostName = newHostName
    end

    if (self.playerCount == #player.GetAll()) then return end
    updatePlayerCount(self)
end

vgui.Register("gogm_scoreboard_title", PANEL)