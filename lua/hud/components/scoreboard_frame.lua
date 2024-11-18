local PANEL = {}

function PANEL:Init()
    self.gap = 8
    self.playerCount = #player.GetAll()

    self.scoreboardTitle = vgui.Create("gogm_scoreboard_title", self)

    self.playerRowsPanel = self:Add("DScrollPanel")
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

function PANEL:PerformLayout(w, h)
    self:DockPadding(30, 30, 30, 30)

    self.scoreboardTitle:SetHeight(46)
    self.scoreboardTitle:DockMargin(0, 0, 0, self.gap)
    self.scoreboardTitle:Dock(TOP)

    self.playerRowsPanel:SetWidth(w, h - (46 + self.gap) * 2)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(32, 0, 0, w, h, HUDPAL.Dark1)
end

function PANEL:Think()
    for id,ply in ipairs(player.GetAll()) do
        if (IsValid(ply.scorerow)) then continue end

        ply.scorerow = vgui.Create("gogm_scoreboard_row", ply.scorerow)
        ply.scorerow:SetPlayer(ply)
        ply.scorerow:DockMargin(0, 0, 0, self.gap)
        ply.scorerow:Dock(TOP)

        self.playerRowsPanel:AddItem(ply.scorerow)
    end
end

vgui.Register("gogm_scoreboard_frame", PANEL)