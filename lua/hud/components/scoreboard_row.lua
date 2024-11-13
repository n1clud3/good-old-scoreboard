local hud_utils = include("hud/gogm_hud_util.lua")

local PANEL = {}

local roles = {
    ["user"] = "Player",
    ["admin"] = "Admin",
    ["superadmin"] = "Super Admin",
}
local function matchRole(role)
    return roles[role] or "Unknown Role"
end

function PANEL:Init()
    self.player = LocalPlayer()

    self._oldPing = 0
    self._oldUserGroup = "user"

    self.playerAvatarBtn = vgui.Create("DButton", self)
    self.playerAvatarBtn.Paint = function() end

    self.playerAvatar = vgui.Create("AvatarImage", self.playerAvatarBtn)
    self.playerAvatar:SetMouseInputEnabled(false)

    self.playerName = vgui.Create("DLabel", self)
    self.playerName:SetColor(HUDPAL.White)
    self.playerName:SetFont("GOGmScoreboardPlayerName")

    self.playerMuteBtn = vgui.Create("gogm_scoreboard_mute_btn", self)
    self.playerMuteBtn:SetPlayer(self.player)

    self.playerPingLabel = vgui.Create("DLabel", self)
    self.playerPingLabel:SetColor(HUDPAL.Light1)
    self.playerPingLabel:SetFont("GOGmScoreboardNumbers")
    self.playerPingLabel:SetText("000")

    self.playerPingIcon = vgui.Create("gogm_icon", self)
    self.playerPingIcon:SetColor(HUDPAL.Light1)
    self.playerPingIcon:SetIconMaterial("vgui/gogm_icons/signal_cellular.png")

    self.playerRoleLabel = vgui.Create("DLabel", self)
    self.playerRoleLabel:SetColor(HUDPAL.Light1)
    self.playerRoleLabel:SetFont("GOGmScoreboardPlayerName")
    self.playerRoleLabel:SetText(matchRole("user"))

    self.playerRoleIcon = vgui.Create("gogm_icon", self)
    self.playerRoleIcon:SetColor(HUDPAL.Light1)
    self.playerRoleIcon:SetIconMaterial("vgui/gogm_icons/assignment_ind.png")
end

function PANEL:ReloadRow()
    self.playerAvatar:SetPlayer(self.player, 32)
    if (not self.player:IsBot()) then
        self.playerAvatarBtn.DoClick = function()
            self.player:ShowProfile()
            local text = "https://steamcommunity.com/profiles/" .. self.player:SteamID64()
            SetClipboardText(text)
        end
    else
        self.playerAvatarBtn.DoClick = function() end
    end
    self.playerName:SetText(self.player:Nick())
    self.playerPingLabel:SetText(hud_utils.leftpad(tostring(math.Clamp(self.player:Ping(), 0, 999)), 3, "0"))
    self.playerRoleLabel:SetText(matchRole(self.player:GetUserGroup()))
end

function PANEL:SetPlayer(ply)
    self.player = ply
    self:ReloadRow()
    self:Think()
end

function PANEL:PerformLayout(w, h)
    self:SetSize(w, 46)
    self:DockPadding(6, 6, 6, 8)

    self.playerAvatarBtn:SetSize(32, 32)
    self.playerAvatarBtn:DockMargin(0, 0, 12, 0)
    self.playerAvatarBtn:Dock(LEFT)
    self.playerAvatar:SetSize(32, 32)
    self.playerAvatar:Dock(FILL)

    surface.SetFont(self.playerName:GetFont())
    local pn_width, pn_height = surface.GetTextSize(self.playerName:GetText())
    self.playerName:SetSize(pn_width, pn_height)
    self.playerName:Dock(LEFT)

    self.playerMuteBtn:SetSize(32, 33)
    self.playerMuteBtn:DockMargin(12, 0, 0, 0)
    self.playerMuteBtn:Dock(RIGHT)

    surface.SetFont(self.playerPingLabel:GetFont())
    local pp_width, pp_height = surface.GetTextSize(self.playerPingLabel:GetText())
    self.playerPingLabel:SetSize(pp_width, pp_height)
    self.playerPingLabel:DockMargin(12, 0, 0, 0)
    self.playerPingLabel:Dock(RIGHT)

    self.playerPingIcon:SetSize(24, 24)
    self.playerPingIcon:DockMargin(12, 0, 0, 0)
    self.playerPingIcon:Dock(RIGHT)

    surface.SetFont(self.playerRoleLabel:GetFont())
    local pr_width, pr_height = surface.GetTextSize(self.playerRoleLabel:GetText())
    self.playerRoleLabel:SetSize(pr_width, pr_height)
    self.playerRoleLabel:DockMargin(12, 0, 0, 0)
    self.playerRoleLabel:Dock(RIGHT)

    self.playerRoleIcon:SetSize(24, 24)
    self.playerRoleIcon:DockMargin(12, 0, 0, 0)
    self.playerRoleIcon:Dock(RIGHT)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, HUDPAL.Dark2)
    draw.RoundedBox(8, 0, 0, w, h - 2, HUDPAL.Dark3)
end

function PANEL:Think()
    if (not IsValid(self.player)) then
        self:SetZPos(9999)
        self:Remove()
        return
    end

    local newName = self.player:Nick()
    if (newName ~= self._oldName) then
        self.playerName:SetText(newName)
        self._oldName = newName
    end

    local newPing = self.player:Ping()
    if (newPing ~= self._oldPing) then
        self.playerPingLabel:SetText(hud_utils.leftpad(tostring(newPing), 3, "0"))
        self._oldPing = newPing
    end

    local newUsg = self.player:GetUserGroup()
    if (newUsg ~= self._oldUserGroup) then
        self.playerRoleLabel:SetText(matchRole(newUsg))
        self._oldUserGroup = newUsg
    end
end

vgui.Register("gogm_scoreboard_row", PANEL)