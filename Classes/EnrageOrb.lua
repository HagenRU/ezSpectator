ezSpectator_EnrageOrb = {}
ezSpectator_EnrageOrb.__index = ezSpectator_EnrageOrb

function ezSpectator_EnrageOrb:Create(Parent, Size, ...)
	local self = {}
	setmetatable(self, ezSpectator_EnrageOrb)

	self.Parent = Parent

	self.Textures = ezSpectator_Textures:Create()
	
	self.Backdrop = CreateFrame('Frame', nil, nil)
	self.Backdrop:SetFrameStrata('MEDIUM')
	self.Backdrop:SetSize(Size, Size)
	self.Backdrop:SetScale(1)
	self.Backdrop:SetPoint(...)
	self.Textures:EnrageOrb_Backdrop(self.Backdrop)
	self.Backdrop.texture:SetVertexColor(1, 0, 0)
	
	self.Normal = CreateFrame('Frame', nil, nil)
	self.Normal:SetFrameStrata('HIGH')
	self.Normal:SetSize(Size, Size)
	self.Normal:SetScale(1)
	self.Normal:SetPoint(...)
	self.Textures:EnrageOrb_Normal(self.Normal)
	
	self.Cooldown = CreateFrame('Cooldown', nil, self.Backdrop)
	self.Cooldown:SetSize(34, 34)
	self.Cooldown:SetPoint('CENTER', self.Backdrop, 'CENTER', 0, 0)
	self.Cooldown:SetCooldown(GetTime(), 10)
	self.Cooldown:Show()
	
	return self
end



function ezSpectator_EnrageOrb:Hide()
	self.Backdrop:Hide()
	self.Normal:Hide()
	self.Cooldown:Hide()
end



function ezSpectator_EnrageOrb:Show()
	self.Backdrop:Show()
	self.Normal:Show()
	self.Cooldown:Show()
end