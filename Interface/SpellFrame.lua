ezSpectator_SpellFrame = {}
ezSpectator_SpellFrame.__index = ezSpectator_SpellFrame

function ezSpectator_SpellFrame:Create(IsRightShift, ...)
	local self = {}
	setmetatable(self, ezSpectator_SpellFrame)
	
	self.Icons = {}
	self.IconsCount = 4
	
	self.MainFrame = CreateFrame('Frame', nil, nil)
	self.MainFrame:SetSize(1, 1)
	self.MainFrame:SetScale(_ezSpectatorScale)
	self.MainFrame:SetPoint(...)
	
	self.Icons[1] = ezSpectator_SpellIcon:Create(self.MainFrame, IsRightShift, self.MainFrame)
	for IconLoop = 2, self.IconsCount, 1 do
		self.Icons[IconLoop] = ezSpectator_SpellIcon:Create(self.MainFrame, IsRightShift, self.Icons[IconLoop - 1].Normal)
	end
	
	return self
end



function ezSpectator_SpellFrame:Show()
	self.MainFrame:Show()
end



function ezSpectator_SpellFrame:Hide()
	self.MainFrame:Hide()
end



function ezSpectator_SpellFrame:Push(Spell)
	local SpellName, _, SpellTexture = GetSpellInfo(Spell)
	
	for IconLoop = self.IconsCount, 2, -1 do
		self.Icons[IconLoop]:SetTexture(self.Icons[IconLoop - 1].Texture, self.Icons[IconLoop - 1].Normal:GetAlpha())
	end
	
	self.Icons[1]:SetTexture(SpellTexture, 1)
end