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

local cvar_blur_toggle = CreateConVar("cl_goscrbrd_blur", "1", FCVAR_ARCHIVE, "Toggle the scoreboard background blur"):GetBool()
local cvar_blur_intensity = CreateConVar("cl_goscrbrd_blur_intensity", 3.0, FCVAR_ARCHIVE, "Intensity of the background blur", 0.0):GetFloat()
local cvar_dim_toggle = CreateConVar("cl_goscrbrd_dim", "1", FCVAR_ARCHIVE, "Scoreboard background dim toggle"):GetBool()
local cvar_dim_intensity = CreateConVar("cl_goscrbrd_dim_intensity", 0.4, FCVAR_ARCHIVE, "Intensity of the background dim", 0.0, 1.0):GetFloat()


do -- Scoreboard root
    local PANEL = {}

    function PANEL:Init()
        self.matBlurScreen = Material("pp/blurscreen")
        self.blurToggle = cvar_blur_toggle
        self.blurFactor = cvar_blur_intensity

        self.dimToggle = cvar_dim_toggle
        self.dimIntensity = cvar_dim_intensity

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
        if (self.blurToggle) then -- draw blur
            surface.SetMaterial(self.matBlurScreen)
            surface.SetDrawColor(255, 255, 255)

            for i = 0.33, 1, 0.33 do
                self.matBlurScreen:SetFloat("$blur", self.blurFactor * i)
                self.matBlurScreen:Recompute()
                render.UpdateScreenEffectTexture()
                surface.DrawTexturedRect(0, 0, w, h)
            end
        end

        draw.NoTexture() -- reset blur material

        -- dim background
        if (self.dimToggle) then
            surface.SetDrawColor(0, 0, 0,255 * self.dimIntensity)
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
        for id,ply in ipairs(player.GetAll()) do
            if (IsValid(ply.scorerow)) then ply.scorerow:Remove() end
        end
        self.scoreboardFrame:Remove()
        self:Remove()
    end

    function PANEL:SetBlurToggle(val)
        self.blurToggle = val
    end

    function PANEL:SetBlurFactor(fact)
        self.blurFactor = fact
    end

    function PANEL:SetDimToggle(val)
        self.dimToggle = val
    end

    function PANEL:SetDimIntensity(fact)
        self.dimIntensity = fact
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
    print("Scoreboard reloaded.")
    if (IsValid(scoreboard)) then
        scoreboard:RemoveScoreboard()
    end
end

cvars.AddChangeCallback("cl_goscrbrd_blur", function(cvar, oldV, newV)
    cvar_blur_toggle = tobool(newV)
    if (IsValid(scoreboard)) then
        scoreboard:SetBlurToggle(cvar_blur_toggle)
    end
end)

cvars.AddChangeCallback("cl_goscrbrd_blur_intensity", function(cvar, oldV, newV)
    cvar_blur_intensity = newV
    if (IsValid(scoreboard)) then
        scoreboard:SetBlurFactor(newV)
    end
end)

cvars.AddChangeCallback("cl_goscrbrd_dim", function(cvar, oldV, newV)
    cvar_dim_toggle = tobool(newV)
    if (IsValid(scoreboard)) then
        scoreboard:SetDimToggle(cvar_dim_toggle)
    end
end)

cvars.AddChangeCallback("cl_goscrbrd_dim_intensity", function(cvar, oldV, newV)
    cvar_dim_intensity = newV
    if (IsValid(scoreboard)) then
        scoreboard:SetDimIntensity(cvar_dim_intensity)
    end
end)

concommand.Add("cl_goscrbrd_reload", reloadScoreboard)
hook.Add("OnReloaded", hook_name, reloadScoreboard)
