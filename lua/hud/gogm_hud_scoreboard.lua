local surface = surface

local hook_name = "good_old_scoreboard"

include("hud/gogm_hud_fonts.lua")

local scrW, scrH = ScrW(), ScrH()

hook.Add( "OnScreenSizeChanged", hook_name, function()
    scrW, scrH = ScrW(), ScrH()
end)

include("hud/components/scoreboard_mute_btn.lua")
include("hud/components/scoreboard_row.lua")
include("hud/components/scoreboard_title.lua")
include("hud/components/scoreboard_frame.lua")

do -- Scoreboard root
    local PANEL = {}

    function PANEL:Init()
        self.matBlurScreen = Material("pp/blurscreen")
        self.blurFactor = 3.0

        self.scoreboardFrame = vgui.Create("gogm_scoreboard_frame", self)
        self.scoreboardFrameWidth = 900
        self.scoreboardFrameHeight = 652
    end

    function PANEL:PerformLayout()
        self:SetSize(scrW, scrH)
        self:SetPos(0, 0)

        self.scoreboardFrame:SetSize(self.scoreboardFrameWidth, self.scoreboardFrameHeight)
        self.scoreboardFrame:Center()
    end

    function PANEL:Paint(w, h)
        -- draw blur
        surface.SetMaterial(self.matBlurScreen)
        surface.SetDrawColor(255, 255, 255)

        for i = 0.33, 1, 0.33 do
            self.matBlurScreen:SetFloat("$blur", self.blurFactor * i)
            self.matBlurScreen:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(0, 0, w, h)
        end

        draw.NoTexture() -- reset blur material
        -- dim background
        surface.SetDrawColor(0, 0, 0,255 * 0.4)
        surface.DrawRect(0, 0, w, h)
    end

    function PANEL:ShowScoreboard()
        self:Show()
        self:MakePopup()
        self:SetKeyboardInputEnabled(false)
        self.scoreboardFrame:Show()
    end

    function PANEL:HideScoreboard()
        self.scoreboardFrame:Hide()
        self:Hide()
    end

    function PANEL:RemoveScoreboard()
        self.scoreboardFrame:Remove()
        self:Remove()
    end

    vgui.Register("gogm_scoreboard", PANEL)
end

local scoreboard

hook.Add("ScoreboardShow", hook_name, function()
    if (not IsValid(scoreboard)) then
        scoreboard = vgui.Create("gogm_scoreboard")
    end

    scoreboard:ShowScoreboard()
    return true
end)

hook.Add("ScoreboardHide", hook_name, function()
    if (IsValid(scoreboard)) then
        scoreboard:HideScoreboard()
    end
end)

local function reloadScoreboard()
    if (IsValid(scoreboard)) then
        scoreboard:RemoveScoreboard()
    end
end

concommand.Add("cl_goscrbrd_reload", reloadScoreboard)
hook.Add("OnReloaded", hook_name, reloadScoreboard)
