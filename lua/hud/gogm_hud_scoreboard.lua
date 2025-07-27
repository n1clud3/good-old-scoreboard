local surface = surface

local hook_name = "good_old_scoreboard"

include("hud/gogm_hud_fonts.lua")

include("hud/components/scoreboard_mute_btn.lua")
include("hud/components/scoreboard_row.lua")
include("hud/components/scoreboard_title.lua")
include("hud/components/scoreboard_frame.lua")

local blur_toggle = CreateClientConVar("cl_goscrbrd_blur", "1", true, false, "Toggle the scoreboard background blur")
local blur_intensity = CreateClientConVar("cl_goscrbrd_blur_intensity", "3.0", true, false, "Intensity of the background blur", 0.0)
local dim_toggle = CreateClientConVar("cl_goscrbrd_dim", "1", true, false, "Scoreboard background dim toggle")
local dim_intensity = CreateClientConVar("cl_goscrbrd_dim_intensity", "0.4", true, false, "Intensity of the background dim", 0.0, 1.0)


do -- Scoreboard root
    --- @class gogm_scoreboard : Panel
    local PANEL = {}

    function PANEL:Init()
        self.matBlurScreen = Material("pp/blurscreen")
        self.scoreboardFrame = vgui.Create("gogm_scoreboard_frame", self)

        self.scoreboardFrameWidth = 900
        self.scoreboardFrameHeight = 652
    end

    function PANEL:PerformLayout(w, h)
        self.scoreboardFrame:SetSize(self.scoreboardFrameWidth, self.scoreboardFrameHeight)
        if (w <= self.scoreboardFrame:GetWide() or h <= self.scoreboardFrame:GetTall()) then
            self.scoreboardFrame:SetSize(w, h)
        end

        self.scoreboardFrame:Center()
    end

    function PANEL:Paint(w, h)
        -- draw blur
        if (blur_toggle:GetBool() and (w > self.scoreboardFrame:GetWide() and h > self.scoreboardFrame:GetTall())) then
            surface.SetMaterial(self.matBlurScreen)
            surface.SetDrawColor(255, 255, 255)

            for i = 0.33, 1, 0.33 do
                self.matBlurScreen:SetFloat("$blur", blur_intensity:GetFloat() * i)
                self.matBlurScreen:Recompute()
                render.UpdateScreenEffectTexture()
                surface.DrawTexturedRect(0, 0, w, h)
            end
        end

        draw.NoTexture() -- reset blur material

        -- dim background
        if (dim_toggle:GetBool() and (w > self.scoreboardFrame:GetWide() and h > self.scoreboardFrame:GetTall())) then
            surface.SetDrawColor(0, 0, 0, 255 * dim_intensity:GetFloat())
            surface.DrawRect(0, 0, w, h)
        end
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
        for _, ply in ipairs(player.GetAll()) do
            if (IsValid(ply.scorerow)) then ply.scorerow:Remove() end
        end
        self.scoreboardFrame:Remove()
        self:Remove()
    end

    function PANEL:SetScoreboardFrameSize(w, h)
        self.scoreboardFrameWidth = w
        self.scoreboardFrameHeight = h
    end

    vgui.Register("gogm_scoreboard", PANEL)
end

local scoreboard

local function setupScoreboard()
        scoreboard = vgui.Create("gogm_scoreboard")
        scoreboard:SetSize(ScrW(), ScrH())
        scoreboard:SetPos(0, 0)
        scoreboard:Hide()
end

hook.Add("ScoreboardShow", hook_name, function()
    if (not IsValid(scoreboard)) then
        setupScoreboard()
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
        setupScoreboard()
    end
    print("Scoreboard reloaded.")
end

hook.Add( "OnScreenSizeChanged", hook_name, function()
    reloadScoreboard()
end)

concommand.Add("cl_goscrbrd_reload", reloadScoreboard)
hook.Add("OnReloaded", hook_name, reloadScoreboard)
