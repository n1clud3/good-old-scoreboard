local hud_utils = include("hud/gogm_hud_util.lua")
include("hud/goscrbrd_roles.lua")

local PANEL = {}

local function matchRole(role)
    return HUDROLES[role] or HUDROLES["default"]
end

function PANEL:Init()
    self.player = LocalPlayer()

    self._oldPing = 0
    self._oldUserGroup = "user"
    self._oldDeathCount = 0
    self._oldKillCount = 0

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
    self.playerPingLabel:SetColor(HUDPAL.Light3)
    self.playerPingLabel:SetFont("GOGmScoreboardNumbers")
    self.playerPingLabel:SetText("000")

    self.playerPingIcon = vgui.Create("gogm_icon", self)
    self.playerPingIcon:SetColor(HUDPAL.Light3)
    self.playerPingIcon:SetIconMaterial("vgui/gogm_icons/signal_cellular.png")

    self.playerDeathcountLabel = vgui.Create("DLabel", self)
    self.playerDeathcountLabel:SetColor(HUDPAL.Light3)
    self.playerDeathcountLabel:SetFont("GOGmScoreboardNumbers")
    self.playerDeathcountLabel:SetText("0")

    self.playerDeathcountIcon = vgui.Create("gogm_icon", self)
    self.playerDeathcountIcon:SetColor(HUDPAL.Light3)
    self.playerDeathcountIcon:SetIconMaterial("vgui/gogm_icons/skull.png")

    self.playerKillcountLabel = vgui.Create("DLabel", self)
    self.playerKillcountLabel:SetColor(HUDPAL.Light3)
    self.playerKillcountLabel:SetFont("GOGmScoreboardNumbers")
    self.playerKillcountLabel:SetText("0")

    self.playerKillcountIcon = vgui.Create("gogm_icon", self)
    self.playerKillcountIcon:SetColor(HUDPAL.Light3)
    self.playerKillcountIcon:SetIconMaterial("vgui/gogm_icons/swords.png")

    self.playerRoleLabel = vgui.Create("DLabel", self)
    self.playerRoleLabel:SetColor(matchRole("user").color)
    self.playerRoleLabel:SetFont("GOGmScoreboardPlayerName")
    self.playerRoleLabel:SetText(matchRole("user").name)

    self.playerRoleIcon = vgui.Create("gogm_icon", self)
    self.playerRoleIcon:SetColor(matchRole("user").color)
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

    local usgdat = matchRole(self.player:GetUserGroup())
    self.playerRoleIcon:SetColor(usgdat.color)
    self.playerPingLabel:SetText(hud_utils.leftpad(tostring(math.Clamp(self.player:Ping(), 0, 999)), 3, "0"))
    self.playerRoleLabel:SetColor(usgdat.color)
    self.playerRoleLabel:SetText(usgdat.name)
    self.playerDeathcountLabel:SetText(self.player:Deaths())
    self.playerKillcountLabel:SetText(self.player:Frags())
    self.playerMuteBtn:SetPlayer(self.player)
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

    surface.SetFont(self.playerDeathcountLabel:GetFont())
    local pdc_width, pdc_height = surface.GetTextSize(self.playerDeathcountLabel:GetText())
    self.playerDeathcountLabel:SetSize(pdc_width, pdc_height)
    self.playerDeathcountLabel:DockMargin(12, 0, 0, 0)
    self.playerDeathcountLabel:Dock(RIGHT)

    self.playerDeathcountIcon:SetSize(24, 24)
    self.playerDeathcountIcon:DockMargin(12, 0, 0, 0)
    self.playerDeathcountIcon:Dock(RIGHT)

    surface.SetFont(self.playerKillcountLabel:GetFont())
    local pkc_width, pkc_height = surface.GetTextSize(self.playerKillcountLabel:GetText())
    self.playerKillcountLabel:SetSize(pkc_width, pkc_height)
    self.playerKillcountLabel:DockMargin(12, 0, 0, 0)
    self.playerKillcountLabel:Dock(RIGHT)

    self.playerKillcountIcon:SetSize(24, 24)
    self.playerKillcountIcon:DockMargin(12, 0, 0, 0)
    self.playerKillcountIcon:Dock(RIGHT)

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
        self.playerRoleIcon:SetColor(matchRole(newUsg).color)
        self.playerRoleLabel:SetColor(matchRole(newUsg).color)
        self.playerRoleLabel:SetText(matchRole(newUsg).name)
        self._oldUserGroup = newUsg
    end

    local newDeathcount = self.player:Deaths()
    if (newDeathcount ~= self._oldDeathcount) then
        self.playerDeathcountLabel:SetText(newDeathcount)
        self._oldDeathcount = newDeathcount
    end

    local newKillcount = self.player:Frags()
    if (newKillcount ~= self._oldKillcount) then
        self.playerKillcountLabel:SetText(newKillcount)
        self._oldKillcount = newKillcount
    end
end

vgui.Register("gogm_scoreboard_row", PANEL)