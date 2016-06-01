ezSpectator_CooldownFrame = {}
ezSpectator_CooldownFrame.__index = ezSpectator_CooldownFrame

function ezSpectator_CooldownFrame:Create(Parent, ParentFrame, IsLeft)
    local self = {}
    setmetatable(self, ezSpectator_CooldownFrame)

    self.MaxCount = 20
    self.IconSize = 22
    self.TextureSize = self.IconSize * 0.70
    self.OffsetX = 10 * _ezSpectatorScale
    self.OffsetY = 1 * _ezSpectatorScale

    self.Parent = Parent
    self.ParentFrame = ParentFrame
    self.IsLeft = IsLeft

    self.MainFrame = CreateFrame('Frame', nil, nil)
    self.MainFrame:SetFrameLevel(1)
    self.MainFrame:SetFrameStrata('HIGH')
    self.MainFrame:SetScale(_ezSpectatorScale)
    self.MainFrame:SetSize(1, 1)

    if IsLeft then
        self.MainFrame:SetPoint('LEFT', UIParent, 'BOTTOM', self.OffsetX, self.OffsetY)
    else
        self.MainFrame:SetPoint('RIGHT', UIParent, 'BOTTOM', -self.OffsetX, self.OffsetY)
    end

    self.CooldownLinks = {}

    self.CooldownIcons = {}
    for Index = 1, self.MaxCount, 1 do
        if self.IsLeft then
            self.CooldownIcons[Index] = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'mild-yellow', self.IconSize, 'BOTTOMLEFT', self.MainFrame, 'BOTTOMLEFT', (Index - 1) * self.IconSize, 0)
        else
            self.CooldownIcons[Index] = ezSpectator_ClickIcon:Create(self.Parent, self.MainFrame, 'mild-green', self.IconSize, 'BOTTOMRIGHT', self.MainFrame, 'BOTTOMRIGHT', (Index - 1) * -self.IconSize, 0)
        end

        self.CooldownIcons[Index].IsFree = true
    end

    return self
end



function ezSpectator_CooldownFrame:Show()
    self.MainFrame:Show()
end



function ezSpectator_CooldownFrame:Hide()
    self.MainFrame:Hide()

    for Index = 1, self.MaxCount, 1 do
        self.CooldownIcons[Index]:SetTexture(EMPTY_TEXTURE, self.TextureSize, false)

        self.CooldownIcons[Index].IsFree = true
    end
    self.CooldownLinks = {}
end



function ezSpectator_CooldownFrame:Push(Spell, Cooldown)
    if Cooldown >= 0 then
        if self.CooldownLinks[Spell] then
            self.CooldownLinks[Spell]:SetCooldown(GetTime(), Cooldown)
        else
            for Index = 1, self.MaxCount, 1 do
                if self.CooldownIcons[Index].IsFree then
                    local SpellTexture = select(3, GetSpellInfo(Spell))
                    self.CooldownIcons[Index]:SetTexture(SpellTexture, self.TextureSize, true)
                    self.CooldownIcons[Index]:SetCooldown(GetTime(), Cooldown)

                    self.CooldownIcons[Index].IsFree = false
                    self.CooldownLinks[Spell] = self.CooldownIcons[Index]
                    break
                end
            end
        end
    end
end