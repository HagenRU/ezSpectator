ezSpectator_EnrageOrb = {}
ezSpectator_EnrageOrb.__index = ezSpectator_EnrageOrb

function ezSpectator_EnrageOrb:Create(Parent, Size, ...)
	local self = {}
	setmetatable(self, ezSpectator_EnrageOrb)

	self.Parent = Parent

	self.Textures = ezSpectator_Textures:Create()
	


	return self
end



function ezSpectator_EnrageOrb:Hide()

end



function ezSpectator_EnrageOrb:Show()

end