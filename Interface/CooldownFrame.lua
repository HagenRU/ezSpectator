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


        self.CooldownIcons[Index].Spell = nil

        self.CooldownIcons[Index].Reactor:SetScript('OnMouseUp', function(self)
            if self.Parent.Backdrop:IsShown() then
                self.Parent.Parent.Tooltip:ShowSpell(self, self.Parent.Spell)
            end
        end)

        self.CooldownIcons[Index]:SetTextAlignTop()
        self.CooldownIcons[Index]:SetTextInteractive(true)
        self.CooldownIcons[Index]:Hide()
    end

    self.UpdateFrame = CreateFrame('Frame', nil, nil)
    self.UpdateFrame.Parent = self

    self.UpdateFrame.ElapsedTick = 0
    self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
        self.ElapsedTick = self.ElapsedTick + Elapsed

        if self.ElapsedTick > 1 then
            self.Parent:Update()

            self.ElapsedTick = 0
        end
    end)

    return self
end



function ezSpectator_CooldownFrame:Show()
    self.MainFrame:Show()
end



function ezSpectator_CooldownFrame:Hide()
    self.MainFrame:Hide()

    for Index = 1, self.MaxCount, 1 do
        self.CooldownIcons[Index]:SetTexture(EMPTY_TEXTURE, self.TextureSize, false)
        self.CooldownIcons[Index].IsFree = nil
        self.CooldownIcons[Index]:Hide()
    end
    self.CooldownLinks = {}
end



function ezSpectator_CooldownFrame:Push(Nickname, Spell, Cooldown)
    if Cooldown >= 0 then
        if not self.CooldownLinks[Nickname] then
            self.CooldownLinks[Nickname] = {}
        end

        if self.CooldownLinks[Nickname][Spell] then
            self.CooldownLinks[Nickname][Spell]:SetCooldown(GetTime(), Cooldown)
            self.CooldownLinks[Nickname][Spell]:SetText(Cooldown)
        else
            for Index = 1, self.MaxCount, 1 do
                if self.CooldownIcons[Index].Spell == nil then
                    local SpellTexture = select(3, GetSpellInfo(Spell))
                    self.CooldownIcons[Index]:SetTexture(SpellTexture, self.TextureSize, true)
                    self.CooldownIcons[Index]:SetCooldown(GetTime(), Cooldown)
                    self.CooldownIcons[Index]:SetText(Cooldown)

                    self.CooldownIcons[Index].Spell = Spell
                    self.CooldownIcons[Index]:Show()

                    self.CooldownLinks[Nickname][Spell] = self.CooldownIcons[Index]
                    break
                end
            end
        end
    end
end



function ezSpectator_CooldownFrame:Update()
    for Index = 1, self.MaxCount, 1 do
        if self.CooldownIcons[Index].Spell then
            local Time
            local Text = self.CooldownIcons[Index]:GetText()

            if Text then
                Time = tonumber(Text)

                Time = Time - 1
                if Time > 0 then
                    self.CooldownIcons[Index]:SetText(Time)
                else
                    self.CooldownIcons[Index]:SetText(0)
                end
            end
        end
    end
end