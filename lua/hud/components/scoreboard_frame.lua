local frame_width = GetConVar("cl_goscrbrd_width")
local frame_height = GetConVar("cl_goscrbrd_height")

--- @class gogm_scoreboard_frame : Panel
local PANEL = {}

function PANEL:Init()
    self:DockPadding(30, 30, 30, 30)

    self.gap = 8
    self.playerCount = #player.GetAll()

    self.scoreboardTitle = vgui.Create("gogm_scoreboard_title", self)
    self.scoreboardTitle:SetHeight(46)
    self.scoreboardTitle:DockMargin(0, 0, 0, self.gap)
    self.scoreboardTitle:Dock(TOP)

    self.playerRowsPanel = self:Add("DScrollPanel")

    local sbar = self.playerRowsPanel:GetVBar()
    function sbar:Paint(w, h) end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(100, 4, 4, w - 8, h - 8, HUDPAL.Dark2)
        draw.RoundedBox(100, 4, 4, w - 8, h - 10, HUDPAL.Dark3)
    end

    self.playerRowsPanel:Dock(FILL)

    local endrow = vgui.Create("DLabel")
    endrow:SetColor(HUDPAL.Light3)
    endrow:SetFont("GOGmScoreboardRegular")
    endrow:SetText(language.GetPhrase("goscrbrd.eolist"))
    endrow:Dock(TOP)
    endrow:DockMargin(6, 6, 6, 6)
    endrow:SetZPos(9999)
    self.playerRowsPanel:AddItem(endrow)
end

function PANEL:Paint(w, h)
    if (w < frame_width:GetInt() or h < frame_height:GetInt()) then
        surface.SetDrawColor(HUDPAL.Dark1)
        surface.DrawRect(0, 0, w, h)
        return
    end
    draw.RoundedBox(32, 0, 0, w, h, HUDPAL.Dark1)
end

function PANEL:RebuildPlayerList()
    for _, ply in ipairs(player.GetAll()) do
        if (IsValid(ply.scorerow)) then ply.scorerow:Remove() end
    end

    for _, ply in ipairs(player.GetAll()) do
        if (IsValid(ply.scorerow)) then continue end

        ply.scorerow = vgui.Create("gogm_scoreboard_row", ply.scorerow)
        ply.scorerow:SetPlayer(ply)
        ply.scorerow:DockMargin(0, 0, 0, self.gap)
        ply.scorerow:Dock(TOP)

        self.playerRowsPanel:AddItem(ply.scorerow)
    end
end

function PANEL:Think()
    for _, ply in ipairs(player.GetAll()) do
        if (IsValid(ply.scorerow)) then continue end

        ply.scorerow = vgui.Create("gogm_scoreboard_row", ply.scorerow)
        ply.scorerow:SetPlayer(ply)
        ply.scorerow:DockMargin(0, 0, 0, self.gap)
        ply.scorerow:Dock(TOP)

        self.playerRowsPanel:AddItem(ply.scorerow)
    end
end

vgui.Register("gogm_scoreboard_frame", PANEL)