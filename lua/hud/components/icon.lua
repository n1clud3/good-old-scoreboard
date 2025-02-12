--- @class gogm_icon : Panel
local PANEL = {}

function PANEL:Init()
    self.icon = Material("icon16/application.png")
    self.color = Color(255, 255, 255)
end

function PANEL:GetIconMaterial()
    return self.icon
end

function PANEL:SetIconMaterial(newmat)
    self.icon = Material(newmat)
end

function PANEL:GetIconTexture()
    return self.icon:GetTexture("$basetexture")
end

function PANEL:GetColor(clr)
    return self.color
end

function PANEL:SetColor(clr)
    self.color = clr
end

function PANEL:Paint(w, h)
    surface.SetMaterial(self.icon)
    surface.SetDrawColor(self.color)
    surface.DrawTexturedRect(0, h * 0.5 - self.icon:Height() * 0.5, self.icon:Width(), self.icon:Height())
end

vgui.Register("gogm_icon", PANEL)