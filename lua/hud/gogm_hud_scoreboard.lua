local surface = surface

local hook_name = "good_old_scoreboard"

local blur_toggle = CreateClientConVar("cl_goscrbrd_blur", "1", true, false, "Toggle the scoreboard background blur")
local blur_intensity = CreateClientConVar("cl_goscrbrd_blur_intensity", "3.0", true, false, "Intensity of the background blur", 0.0)
local dim_toggle = CreateClientConVar("cl_goscrbrd_dim", "1", true, false, "Scoreboard background dim toggle")
local dim_intensity = CreateClientConVar("cl_goscrbrd_dim_intensity", "0.4", true, false, "Intensity of the background dim", 0.0, 1.0)

local frame_width = CreateClientConVar("cl_goscrbrd_width", "900", true, false, "Width of the scoreboard")
local frame_height = CreateClientConVar("cl_goscrbrd_height", "652", true, false, "Height of the scoreboard")

local frame_centered = CreateClientConVar("cl_goscrbrd_centered", "1", true, false, "Whether the scoreboard should be centered")
local frame_pos_x = CreateClientConVar("cl_goscrbrd_pos_x", "20", true, false, "X position of the scoreboard", 0)
local frame_pos_y = CreateClientConVar("cl_goscrbrd_pos_y", "20", true, false, "Y position of the scoreboard", 0)

local cursor_autolock = CreateClientConVar("cl_goscrbrd_cursor_autolock", "1", true, false, "Should the cursor be locked to the scoreboard upon opening it")

include("hud/gogm_hud_fonts.lua")

include("hud/components/scoreboard_mute_btn.lua")
include("hud/components/scoreboard_row.lua")
include("hud/components/scoreboard_title.lua")
include("hud/components/scoreboard_frame.lua")

do -- Scoreboard root
    --- @class gogm_scoreboard : Panel
    local PANEL = {}

    function PANEL:Init()
        self.matBlurScreen = Material("pp/blurscreen")
        self.scoreboardFrame = vgui.Create("gogm_scoreboard_frame", self)
        self.scoreboardFrame:Show()
    end

    function PANEL:PerformLayout(w, h)
        self.scoreboardFrame:SetSize(frame_width:GetInt(), frame_height:GetInt())
        if (w <= self.scoreboardFrame:GetWide() or h <= self.scoreboardFrame:GetTall()) then
            self.scoreboardFrame:SetSize(w, h)
        end

        if frame_centered:GetBool() then
            self.scoreboardFrame:Center()
        else
            self.scoreboardFrame:SetPos(frame_pos_x:GetFloat(), frame_pos_y:GetFloat())
        end
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
        self:SetMouseInputEnabled(false)
        self:SetKeyboardInputEnabled(false)
    end

    function PANEL:HideScoreboard()
        
        self:Hide()
    end

    function PANEL:RemoveScoreboard()
        for _, ply in ipairs(player.GetAll()) do
            if (IsValid(ply.scorerow)) then ply.scorerow:Remove() end
        end
        self.scoreboardFrame:Remove()
        self:Remove()
    end

    vgui.Register("gogm_scoreboard", PANEL)
end

---@class gogm_scoreboard
local scoreboard = nil

local function setupScoreboard()
        scoreboard = vgui.Create("gogm_scoreboard")
        scoreboard:SetSize(ScrW(), ScrH())
        scoreboard:SetPos(0, 0)
        scoreboard:Hide()
end

local function enableMouseHook()
    if not input.IsMouseDown(MOUSE_RIGHT) then return end
    if not scoreboard or not IsValid(scoreboard) then return end

    scoreboard:MakePopup()

    hook.Remove("HUDPaint", hook_name)
end

hook.Add("ScoreboardShow", hook_name, function()
    if not scoreboard or not IsValid(scoreboard) then
        setupScoreboard()
    end

    scoreboard:ShowScoreboard()
    if not cursor_autolock:GetBool() then
        hook.Add("HUDPaint", hook_name, enableMouseHook)
    else
        scoreboard:MakePopup()
    end
    return true
end)

hook.Add("ScoreboardHide", hook_name, function()
    if scoreboard and IsValid(scoreboard) then
        scoreboard:HideScoreboard()
    end
    hook.Remove("HUDPaint", hook_name)
end)

local function reloadScoreboard()
    if scoreboard and IsValid(scoreboard) then
        scoreboard:RemoveScoreboard()
        setupScoreboard()
    end
    print("Scoreboard reloaded.")
end

hook.Add( "OnScreenSizeChanged", hook_name, function()
    include("hud/gogm_hud_fonts.lua")
    reloadScoreboard()
end)

concommand.Add("cl_goscrbrd_reload", reloadScoreboard)
hook.Add("OnReloaded", hook_name, reloadScoreboard)
