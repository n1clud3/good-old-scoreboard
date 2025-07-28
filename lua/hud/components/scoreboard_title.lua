local hud_utils = include("hud/gogm_hud_util.lua")
include("hud/components/icon.lua")
include("hud/components/scoreboard_settings_btn.lua")

--- @class gogm_scoreboard_title : Panel
local PANEL = {}

local function updatePlayerCount(self)
    self.playerCount = #player.GetAll()
    self.playerCountLabel:SetText(hud_utils.leftpad(tostring(self.playerCount), 3, "0")
        .. " / " .. hud_utils.leftpad(tostring(game.MaxPlayers()), 3, "0"))
end

function PANEL:Init()
    self.title = vgui.Create("DLabel", self)
    self.title:SetFont("GOGmScoreboardTitle")
    self.title:SetTextColor(HUDPAL.Light1)
    self.title:SetText(GetHostName())
    self.title:SizeToContents()
    self.title:Dock(LEFT)

    self.settingsButton = vgui.Create("gogm_scoreboard_settings_btn", self)
    self.settingsButton:SetSize(32, 33)
    self.settingsButton:DockMargin(12, 0, 0, 0)
    self.settingsButton:Dock(RIGHT)

    self.playerCount = 0

    self.playerCountLabel = vgui.Create("DLabel", self)
    self.playerCountLabel:SetFont("GOGmScoreboardNumbers")
    self.playerCountLabel:SetTextColor(HUDPAL.Light1)
    self.playerCountLabel:SetText("000 / 000")
    self.playerCountLabel:SizeToContents()
    self.playerCountLabel:Dock(RIGHT)

    self.playerCountIcon = vgui.Create("gogm_icon", self)
    self.playerCountIcon:SetColor(HUDPAL.Light1)
    self.playerCountIcon:SetIconMaterial("vgui/gogm_icons/group.png")
    self.playerCountIcon:SetSize(24, 24)
    self.playerCountIcon:DockMargin(0, 0, 12, 0)
    self.playerCountIcon:Dock(RIGHT)

    updatePlayerCount(self)
end

function PANEL:Think()
    if (self.playerCount ~= #player.GetAll()) then
        updatePlayerCount(self)
    end
end

vgui.Register("gogm_scoreboard_title", PANEL)
