ezSpectator_Nameplate = {}
ezSpectator_Nameplate.__index = ezSpectator_Nameplate

--noinspection LuaOverlyLongMethod
function ezSpectator_Nameplate:Create(Parent, ParentFrame, Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	local self = {}
	setmetatable(self, ezSpectator_Nameplate)

	self.Parent = Parent

	self.AnimationStartSpeed = 0
	self.AnimationProgress = 10
	self.IsLayerAnimated = true
	self.IsSparkAnimated = false
		self.IsSparkSmoothMode = false
	
	self.CurrentValue = nil
	self.TargetValue = 0
	
	self.Scale = 0.66 * _ezSpectatorScale
	self.ParentFrame = ParentFrame
	self.Textures = ezSpectator_Textures:Create()
	
	self.Width = 128
	self.Height = 16
	
	self.MainFrame = CreateFrame('Frame', nil, ParentFrame)
	self.MainFrame:SetSize(1, 1)
	self.MainFrame:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)

	self.Backdrop = CreateFrame('Frame', nil, self.MainFrame)
	self.Backdrop:SetFrameLevel(2 + self.Parent.Data.NamePlateLevel)
	self.Backdrop:SetFrameStrata('BACKGROUND')
	self.Backdrop:SetSize(128, self.Height)
	self.Backdrop:SetScale(self.Scale)
	self.Backdrop:SetPoint('CENTER', 0, 0)
	self.Textures:Nameplate_Backdrop(self.Backdrop)
	
	self.Glow = CreateFrame('Frame', nil, self.MainFrame)
	self.Glow:SetFrameLevel(1 + self.Parent.Data.NamePlateLevel)
	self.Glow:SetFrameStrata('BACKGROUND')
	self.Glow:SetSize(141, 30)
	self.Glow:SetScale(self.Scale)
	self.Glow:SetPoint('TOPLEFT', self.Backdrop, 'TOPLEFT', -6, 6)
	self.Textures:Nameplate_Glow(self.Glow)
	
	self.ProgressBar = CreateFrame('Frame', nil, self.MainFrame)
	self.ProgressBar:SetFrameLevel(4 + self.Parent.Data.NamePlateLevel)
	self.ProgressBar:SetFrameStrata('BACKGROUND')
	self.ProgressBar:SetSize(self.Width, self.Height)
	self.ProgressBar:SetScale(self.Scale)
	self.ProgressBar:SetPoint('TOPLEFT', self.Backdrop, 'TOPLEFT', 0, 0)
	self.Textures:Nameplate_Normal(self.ProgressBar)
	
	if self.IsLayerAnimated then
		self.AnimationDownBar = CreateFrame('Frame', nil, self.MainFrame)
		self.AnimationDownBar:SetFrameLevel(3 + self.Parent.Data.NamePlateLevel)
		self.AnimationDownBar:SetFrameStrata('BACKGROUND')
		self.AnimationDownBar:SetSize(0, self.Height)
		self.AnimationDownBar:SetScale(self.Scale)
		self.AnimationDownBar:SetPoint('TOPLEFT', self.Backdrop, 'TOPLEFT', 0, 0)
		self.Textures:HealthBar_Normal(self.AnimationDownBar)
		self.AnimationDownBar.texture:SetVertexColor(1, 0, 0)
		
		self.AnimationUpBar = CreateFrame('Frame', nil, self.MainFrame)
		self.AnimationUpBar:SetFrameLevel(5 + self.Parent.Data.NamePlateLevel)
		self.AnimationUpBar:SetFrameStrata('BACKGROUND')
		self.AnimationUpBar:SetSize(0, self.Height - 2)
		self.AnimationUpBar:SetScale(self.Scale)
		self.AnimationUpBar:SetPoint('RIGHT', self.ProgressBar, 'RIGHT', 0, 0)
		self.Textures:HealthBar_Normal(self.AnimationUpBar)
		self.AnimationUpBar.texture:SetVertexColor(0, 1, 0)
	end
	
	self.Overlay = CreateFrame('Frame', nil, self.MainFrame)
	self.Overlay:SetFrameLevel(6 + self.Parent.Data.NamePlateLevel)
	self.Overlay:SetFrameStrata('BACKGROUND')
	self.Overlay:SetSize(128, self.Height)
	self.Overlay:SetScale(self.Scale)
	self.Overlay:SetPoint('CENTER', 0, 0)
	self.Textures:Nameplate_Overlay(self.Overlay)
	
	self.Effect = CreateFrame('Frame', nil, self.MainFrame)
	self.Effect:SetFrameLevel(7 + self.Parent.Data.NamePlateLevel)
	self.Effect:SetFrameStrata('BACKGROUND')
	self.Effect:SetSize(128, self.Height)
	self.Effect:SetScale(self.Scale)
	self.Effect:SetPoint('CENTER', 0, 0)
	self.Textures:Nameplate_Effect(self.Effect)
	
	self.TextFrame = CreateFrame('Frame', nil, self.MainFrame)
	self.TextFrame:SetFrameLevel(8 + self.Parent.Data.NamePlateLevel)
	self.TextFrame:SetFrameStrata('BACKGROUND')
	self.TextFrame:SetSize(1, 1)
	self.TextFrame:SetScale(1)
	self.TextFrame:SetPoint('BOTTOM', self.Backdrop, 'TOP', 0, 8)
	
	self.Nickname = self.TextFrame:CreateFontString(nil, 'OVERLAY')
	self.Nickname:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSans.ttf', 12)
	self.Nickname:SetTextColor(1, 1, 1, 1)
	self.Nickname:SetShadowColor(0, 0, 0, 0.75)
	self.Nickname:SetShadowOffset(1, -1)
	self.Nickname:SetPoint('CENTER', 0, 0)
	
	self.UpdateFrame = CreateFrame('Frame', nil, self.MainFrame)
	self.UpdateFrame.Parent = self
	
	self.AnimationDownCycle = 0
	self.IsAnimatingDown = false
	
	self.AnimationUpCycle = 0
	self.IsAnimatingUp = false
	
	self.UpdateFrame.ElapsedTick = 0
	self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
		self.ElapsedTick = self.ElapsedTick + Elapsed
		
		if self.ElapsedTick > 0.03 then
			if self.Parent.IsAnimatingDown then
				self.Parent:DecAnimatedValue()
			end
			
			if self.Parent.IsAnimatingUp then
				self.Parent:IncAnimatedValue()
			end
			
			self.ElapsedTick = 0
		end
	end)

	self.Parent.Data.NamePlateLevel = self.Parent.Data.NamePlateLevel + 8
	return self
end



function ezSpectator_Nameplate:DecAnimatedValue()
	if self.IsLayerAnimated then
		self.AnimationDownCycle = self.AnimationDownCycle + self.AnimationProgress
		local AnimateWidth = self.AnimationDownBar:GetWidth() - self.Weight * self.AnimationDownCycle
		
		if AnimateWidth <= 0 then
			self.AnimationDownBar:Hide()
		else
			self.AnimationDownBar:Show()
		end
		self.AnimationDownBar:SetWidth(AnimateWidth)
		self.AnimationDownBar.texture:SetTexCoord(0, AnimateWidth / self.Width, 0, 1)
		
		self.IsAnimatingDown = self.AnimationDownBar:GetWidth() >= self.ProgressBar:GetWidth()
	end
	
	if self.IsSparkAnimated then
		self.AnimationDownCycle = self.AnimationDownCycle + self.AnimationProgress
		local AnimateValue = self.CurrentValue - self.AnimationDownCycle
		
		if AnimateValue < self.TargetValue then
			self.IsAnimatingDown = false
			AnimateValue = self.TargetValue
		end
		
		self:SetValue(AnimateValue, true)
	end
end



function ezSpectator_Nameplate:IncAnimatedValue()
	if self.IsLayerAnimated then
		self.AnimationUpCycle = self.AnimationUpCycle + self.AnimationProgress
		local AnimateWidth = self.AnimationUpBar:GetWidth() - self.Weight * self.AnimationUpCycle
		
		if AnimateWidth <= 0 then
			self.AnimationUpBar:Hide()
		else
			self.AnimationUpBar:Show()
		end
		self.AnimationUpBar:SetWidth(AnimateWidth)
		self.AnimationUpBar.texture:SetTexCoord((self.Width - (self.Width - self.ProgressBar:GetWidth()) - self.AnimationUpBar:GetWidth()) / self.Width, self.ProgressBar:GetWidth() / self.Width, 0, 1)
		
		self.IsAnimatingUp = self.AnimationUpBar:GetWidth() > 0
	end
	
	if self.IsSparkAnimated then
		self.AnimationUpCycle = self.AnimationUpCycle + self.AnimationProgress
		local AnimateValue = self.CurrentValue + self.AnimationUpCycle
		
		if AnimateValue > self.TargetValue then
			self.IsAnimatingUp = false
			AnimateValue = self.TargetValue
		end
		
		self:SetValue(AnimateValue, true)
	end
end



function ezSpectator_Nameplate:Show()
	self.MainFrame:Show()

	self.Backdrop:Show()
	self.Glow:Hide()
	self.ProgressBar:Show()
	
	if self.IsLayerAnimated then
		self.AnimationUpBar:Show()
		self.AnimationDownBar:Show()
	end
	
	self.Overlay:Show()
	self.Effect:Hide()
	self.TextFrame:Show()
end



function ezSpectator_Nameplate:Hide()
	self.MainFrame:Hide()

	self.Backdrop:Hide()
	self.Glow:Hide()
	self.ProgressBar:Hide()
	
	if self.IsLayerAnimated then
		self.AnimationUpBar:Hide()
		self.AnimationDownBar:Hide()
	end
	
	self.Overlay:Hide()
	self.Effect:Hide()
	self.TextFrame:Hide()
end



function ezSpectator_Nameplate:SetAlpha(Value)
	self.MainFrame:SetAlpha(Value)
end



function ezSpectator_Nameplate:ResetAnimation()
	if self.IsLayerAnimated then
		self.AnimationUpBar:SetWidth(0)
		self.AnimationDownBar:SetWidth(0)
	end
	
	if self.IsSparkAnimated then
		self:SetValue(self.CurrentValue, true)
	end
end



function ezSpectator_Nameplate:SetMaxValue(Value)
	self.MaxValue = Value
	self.Weight = self.Width / self.MaxValue
	
	if self.CurrentValue then
		self:SetValue(self.CurrentValue, true)
	end
end



function ezSpectator_Nameplate:SetValue(Value, IsInnerCall)
	if not self.MaxValue or (self.MaxValue == 0) then
		return
	end
	
	if Value == 0 then
		Value = -1
	end
	
	if Value > self.MaxValue then
		Value = self.MaxValue
	end
	
	local ProgressWidth = Value * self.Weight
	
	if self.CurrentValue and (IsInnerCall ~= true) then
		if Value > self.CurrentValue then
			if self.IsLayerAnimated then
				local AnimationWidth = self.AnimationUpBar:GetWidth() + ProgressWidth - self.ProgressBar:GetWidth()
				
				self.AnimationUpBar:SetWidth(AnimationWidth)
				self.AnimationUpBar.texture:SetTexCoord((self.Width - (self.Width - ProgressWidth) - self.AnimationUpBar:GetWidth()) / self.Width, ProgressWidth / self.Width, 0, 1)
				
				if not self.IsAnimatingUp then
					self.AnimationUpCycle = self.AnimationStartSpeed
					self.IsAnimatingUp = true
				end
			end
			
			if self.IsSparkAnimated then
				self.TargetValue = Value
				
				if not self.IsAnimatingUp then
					self.AnimationUpCycle = self.AnimationStartSpeed
					self.IsAnimatingUp = true
					
					if self.IsSparkSmoothMode then
						self.IsAnimatingDown = false
					end
				end
			end
		else
			if self.IsLayerAnimated then
				local AnimationWidth = self.AnimationUpBar:GetWidth() + ProgressWidth - self.ProgressBar:GetWidth()
				
				if AnimationWidth < 0 then
					AnimationWidth = 0
				end
				
				self.AnimationUpBar:SetWidth(AnimationWidth)
				self.AnimationUpBar.texture:SetTexCoord((self.Width - (self.Width - ProgressWidth) - self.AnimationUpBar:GetWidth()) / self.Width, ProgressWidth / self.Width, 0, 1)
				
				if not self.IsAnimatingDown then
					self.AnimationDownBar:SetWidth(self.ProgressBar:GetWidth())
					self.AnimationDownBar.texture:SetTexCoord(0, self.ProgressBar:GetWidth() / self.Width, 0, 1)
					
					self.AnimationDownCycle = self.AnimationStartSpeed
					self.IsAnimatingDown = true
				end
			end
			
			if self.IsSparkAnimated then
				self.TargetValue = Value
				
				if not self.IsAnimatingDown then
					self.AnimationDownCycle = self.AnimationStartSpeed
					self.IsAnimatingDown = true
					
					if self.IsSparkSmoothMode then
						self.IsAnimatingUp = false
					end
				end
			end
		end
	end
	
	if self.IsSparkAnimated and self.CurrentValue and (IsInnerCall ~= true) then
		return true
	end
	
	self.ProgressBar:SetWidth(ProgressWidth)
	self.ProgressBar.texture:SetTexCoord(0, ProgressWidth / self.Width, 0, 1)
	
	self.CurrentValue = Value
end



function ezSpectator_Nameplate:SetNickname(Value)
	self.Nickname:SetText(Value)
end



function ezSpectator_Nameplate:SetTeam(Value)
	if Value then
		if Value == 1 then
			self.Nickname:SetTextColor(0, 0.75, 0)
			--self.ProgressBar.texture:SetVertexColor(0, 0.75, 0)
			--self.Glow.texture:SetVertexColor(0, 0.75, 0, 0.5)
			--self.Effect.texture:SetVertexColor(0, 0.75, 0)
		end
		
		if Value == 2 then
			self.Nickname:SetTextColor(0.9, 0.9, 0)
			--self.ProgressBar.texture:SetVertexColor(0.9, 0.9, 0)
			--self.Glow.texture:SetVertexColor(0.9, 0.9, 0, 0.5)
			--self.Effect.texture:SetVertexColor(0.9, 0.9, 0)
		end
		
		--self.Glow:Show()
		--self.Effect:Show()
		self.Glow:Hide()
		self.Effect:Hide()
	else
		self.Nickname:SetTextColor(1, 1, 1)
		self.ProgressBar.texture:SetVertexColor(1, 1, 1)
		self.Glow:Hide()
		self.Effect:Hide()
	end
end



function ezSpectator_Nameplate:SetClass(Value)
	local Class, Color

	Class = self.Parent.Data.ClassTextEng[Value]

	if Class then
		Color = RAID_CLASS_COLORS[Class]
	end
	
	if Color then
		self.ProgressBar.texture:SetVertexColor(Color.r, Color.g, Color.b)
	else
		self.ProgressBar.texture:SetVertexColor(1, 1, 1)
	end
end