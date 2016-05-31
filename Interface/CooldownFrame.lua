ezSpectator_CooldownFrame = {}
ezSpectator_CooldownFrame.__index = ezSpectator_CooldownFrame

function ezSpectator_CooldownFrame:Create(Parent, ParentFrame, IsLeft)
    local self = {}
    setmetatable(self, ezSpectator_CooldownFrame)

    self.MaxCount = 13
    self.IconSize = 22
    self.OffsetX = 52 * _ezSpectatorScale
    self.OffsetY = -22.5 * _ezSpectatorScale

    self.Parent = Parent
    self.ParentFrame = ParentFrame
    self.IsLeft = IsLeft

    self.MainFrame = CreateFrame('Frame', nil, nil)
    self.MainFrame:SetFrameLevel(1)
    self.MainFrame:SetFrameStrata('HIGH')
    self.MainFrame:SetScale(_ezSpectatorScale)
    self.MainFrame:SetSize(1, 1)

    if IsLeft then
        self.MainFrame:SetPoint('LEFT', self.ParentFrame, 'BOTTOMLEFT', self.OffsetX, self.OffsetY)
    else
        self.MainFrame:SetPoint('RIGHT', self.ParentFrame, 'BOTTOMRIGHT', -self.OffsetX, self.OffsetY)
    end


    self.CooldownIcons = {}
    for Index = 1, self.MaxCount, 1 do
        if self.IsLeft then
            self.CooldownIcons[Index] = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'silver', self.IconSize, 'BOTTOMLEFT', self.MainFrame, 'BOTTOMLEFT', (Index - 1) * self.IconSize, 0)
        else
            self.CooldownIcons[Index] = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'silver', self.IconSize, 'BOTTOMRIGHT', self.MainFrame, 'BOTTOMRIGHT', (Index - 1) * -self.IconSize, 0)
        end
    end

    return self
end



function ezSpectator_CooldownFrame:Show()
    self.MainFrame:Show()
end



function ezSpectator_CooldownFrame:Hide()
    self.MainFrame:Hide()
end



function ezSpectator_CooldownFrame:Push(Spell, Cooldown)
    print(Spell, Cooldown)
end