local hud_utils = include("hud/gogm_hud_util.lua")
include("hud/goscrbrd_roles.lua")

--- @class gogm_scoreboard_row : Panel
local PANEL = {}

--- @param role string
--- @return HUDRole
local function matchRole(role)
    return HUDROLES.roles[role] or HUDROLES.roles["default"]
end

---Check if the player is in build mode
---@param ply Player
---@return boolean
local function isInBuildMode(ply)
    return ply:GetNWBool("_Kyle_Buildmode", false) or (ply.InBuildMode ~= nil and ply:InBuildMode())
end

function PANEL:Init()
    self:DockPadding(6, 6, 6, 8)
    self:SetHeight(46)

    self.player = LocalPlayer()

    self._oldPing = 0
    self._oldUserGroup = "user"
    self._oldDeathCount = 0
    self._oldKillCount = 0

    --- @class DButton
    self.playerAvatarBtn = vgui.Create("DButton", self)
    self.playerAvatarBtn.Paint = function() end
    self.playerAvatarBtn:SetSize(32, 32)
    self.playerAvatarBtn:DockMargin(0, 0, 12, 0)
    self.playerAvatarBtn:Dock(LEFT)

    self.playerAvatar = vgui.Create("AvatarImage", self.playerAvatarBtn)
    self.playerAvatar:SetMouseInputEnabled(false)
    self.playerAvatar:SetSize(32, 32)
    self.playerAvatar:Dock(FILL)

    self.playerBuildModeIcon = vgui.Create("gogm_icon", self)
    self.playerBuildModeIcon:SetColor(HUDPAL.Light1)
    self.playerBuildModeIcon:SetIconMaterial("vgui/gogm_icons/handyman.png")
    self.playerBuildModeIcon:DockMargin(0, 0, 12, 0)
    self.playerBuildModeIcon:Dock(LEFT)
    self._oldBuildMode = isInBuildMode(self.player)
    if (self._oldBuildMode) then
        self.playerBuildModeIcon:SetSize(24, 24)
        self.playerBuildModeIcon:DockMargin(0, 0, 12, 0)
    else
        self.playerBuildModeIcon:SetSize(0, 0)
        self.playerBuildModeIcon:DockMargin(0, 0, 0, 0)
    end

    self.playerName = vgui.Create("DLabel", self)
    self.playerName:SetColor(HUDPAL.White)
    self.playerName:SetFont("GOGmScoreboardPlayerName")
    self.playerName:SizeToContents()
    self.playerName:Dock(FILL)

    self.playerMuteBtn = vgui.Create("gogm_scoreboard_mute_btn", self)
    self.playerMuteBtn:SetPlayer(self.player)
    self.playerMuteBtn:SetSize(32, 33)
    self.playerMuteBtn:DockMargin(12, 0, 0, 0)
    self.playerMuteBtn:Dock(RIGHT)

    self.playerPingLabel = vgui.Create("DLabel", self)
    self.playerPingLabel:SetColor(HUDPAL.Light1)
    self.playerPingLabel:SetFont("GOGmScoreboardNumbers")
    self.playerPingLabel:SetText("000")
    self.playerPingLabel:SizeToContents()
    self.playerPingLabel:DockMargin(12, 0, 0, 0)
    self.playerPingLabel:Dock(RIGHT)

    local playerPingIcon = vgui.Create("gogm_icon", self)
    playerPingIcon:SetColor(HUDPAL.Light1)
    playerPingIcon:SetIconMaterial("vgui/gogm_icons/signal_cellular.png")
    playerPingIcon:SetSize(24, 24)
    playerPingIcon:DockMargin(12, 0, 0, 0)
    playerPingIcon:Dock(RIGHT)

    self.playerDeathcountLabel = vgui.Create("DLabel", self)
    self.playerDeathcountLabel:SetColor(HUDPAL.Light1)
    self.playerDeathcountLabel:SetFont("GOGmScoreboardNumbers")
    self.playerDeathcountLabel:SetText("0")
    self.playerDeathcountLabel:SizeToContents()
    self.playerDeathcountLabel:DockMargin(12, 0, 0, 0)
    self.playerDeathcountLabel:Dock(RIGHT)

    local playerDeathcountIcon = vgui.Create("gogm_icon", self)
    playerDeathcountIcon:SetColor(HUDPAL.Light1)
    playerDeathcountIcon:SetIconMaterial("vgui/gogm_icons/skull.png")
    playerDeathcountIcon:SetSize(24, 24)
    playerDeathcountIcon:DockMargin(12, 0, 0, 0)
    playerDeathcountIcon:Dock(RIGHT)

    self.playerKillcountLabel = vgui.Create("DLabel", self)
    self.playerKillcountLabel:SetColor(HUDPAL.Light1)
    self.playerKillcountLabel:SetFont("GOGmScoreboardNumbers")
    self.playerKillcountLabel:SetText("0")
    self.playerKillcountLabel:SizeToContents()
    self.playerKillcountLabel:DockMargin(12, 0, 0, 0)
    self.playerKillcountLabel:Dock(RIGHT)

    local playerKillcountIcon = vgui.Create("gogm_icon", self)
    playerKillcountIcon:SetColor(HUDPAL.Light1)
    playerKillcountIcon:SetIconMaterial("vgui/gogm_icons/swords.png")
    playerKillcountIcon:SetSize(24, 24)
    playerKillcountIcon:DockMargin(12, 0, 0, 0)
    playerKillcountIcon:Dock(RIGHT)

    self.playerRoleLabel = vgui.Create("DLabel", self)
    self.playerRoleLabel:SetColor(matchRole("user").color)
    self.playerRoleLabel:SetFont("GOGmScoreboardPlayerName")
    self.playerRoleLabel:SetText(matchRole("user").name)
    self.playerRoleLabel:SizeToContents()
    self.playerRoleLabel:DockMargin(12, 0, 0, 0)
    self.playerRoleLabel:Dock(RIGHT)

    self.playerRoleIcon = vgui.Create("gogm_icon", self)
    self.playerRoleIcon:SetColor(matchRole("user").color)
    self.playerRoleIcon:SetIconMaterial("vgui/gogm_icons/assignment_ind.png")
    self.playerRoleIcon:SetSize(24, 24)
    self.playerRoleIcon:DockMargin(12, 0, 0, 0)
    self.playerRoleIcon:Dock(RIGHT)
end

function PANEL:ReloadRow()
    self.playerAvatar:SetPlayer(self.player, 32)
    self.playerAvatarBtn.DoClick = function() end
    if (not self.player:IsBot()) then
        self.playerAvatarBtn.DoClick = function()
            self.player:ShowProfile()
            local text = "https://steamcommunity.com/profiles/" .. self.player:SteamID64()
            SetClipboardText(text)
        end
    end
    self.playerName:SetText(self.player:Nick())
    self.playerName:SizeToContents()

    local usgdat = matchRole(self.player:GetUserGroup())
    self.playerRoleIcon:SetColor(usgdat.color)
    self.playerPingLabel:SetText(hud_utils.leftpad(tostring(math.Clamp(self.player:Ping(), 0, 999)), 3, "0"))
    self.playerRoleLabel:SetColor(usgdat.color)
    self.playerRoleLabel:SetText(usgdat.name)
    self.playerDeathcountLabel:SetText(tostring(self.player:Deaths()))
    self.playerKillcountLabel:SetText(tostring(self.player:Frags()))
    self.playerMuteBtn:SetPlayer(self.player)
end

function PANEL:SetPlayer(ply)
    self.player = ply
    self:ReloadRow()
    self:Think()
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

    if (self.player:Nick() ~= self._oldName) then
        self._oldName = self.player:Nick()
        self.playerName:SetText(self._oldName)
    end

    if (self.player:Alive() ~= self._oldAlive) then
        self._oldAlive = self.player:Alive()
        if (self._oldAlive) then
            self.playerName:SetText(self._oldName)
        else
            self.playerName:SetText(self._oldName .. " (" .. language.GetPhrase("goscrbrd.playerdead") .. ")")
        end
    end

    if (self.player:Ping() ~= self._oldPing) then
        self._oldPing = self.player:Ping()
        self.playerPingLabel:SetText(hud_utils.leftpad(tostring(self._oldPing), 3, "0"))
    end

    if (self.player:GetUserGroup() ~= self._oldUserGroup) then
        self._oldUserGroup = self.player:GetUserGroup()
        self.playerRoleIcon:SetColor(matchRole(self._oldUserGroup).color)
        self.playerRoleLabel:SetColor(matchRole(self._oldUserGroup).color)
        self.playerRoleLabel:SetText(matchRole(self._oldUserGroup).name)
        self.playerRoleLabel:SizeToContents()
    end

    if (self.player:Deaths() ~= self._oldDeathcount) then
        self._oldDeathcount = self.player:Deaths()
        self.playerDeathcountLabel:SetText(tostring(self._oldDeathcount))
        self.playerDeathcountLabel:SizeToContents()
    end

    if (self.player:Frags() ~= self._oldKillcount) then
        self._oldKillcount = self.player:Frags()
        self.playerKillcountLabel:SetText(tostring(self._oldKillcount))
        self.playerKillcountLabel:SizeToContents()
    end

    if (isInBuildMode(self.player) ~= self._oldBuildMode) then
        self._oldBuildMode = isInBuildMode(self.player)
        if (self._oldBuildMode) then
            self.playerBuildModeIcon:SetSize(24, 24)
            self.playerBuildModeIcon:DockMargin(0, 0, 12, 0)
        else
            self.playerBuildModeIcon:SetSize(0, 0)
            self.playerBuildModeIcon:DockMargin(0, 0, 0, 0)
        end
    end
end

vgui.Register("gogm_scoreboard_row", PANEL)