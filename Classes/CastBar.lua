ezSpectator_CastBar = {}
ezSpectator_CastBar.__index = ezSpectator_CastBar

function ezSpectator_CastBar:Create(Width, Height, Scale, Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	local self = {}
	setmetatable(self, ezSpectator_CastBar)
	
	self.CurrentValue = nil
	
	self.Textures = ezSpectator_Textures:Create()
	self.Width = Width - 3
	
	self.Backdrop = CreateFrame('Frame', nil, nil)
	self.Backdrop:SetFrameStrata('HIGH')
	self.Backdrop:SetSize(Width, Height)
	self.Backdrop:SetScale(Scale)
	self.Backdrop:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	self.Textures:HealthBar_Backdrop(self.Backdrop)
	
	self.ProgressBar = CreateFrame('Frame', nil, nil)
	self.ProgressBar:SetFrameStrata('DIALOG')
	self.ProgressBar:SetSize(self.Width, Height - 2)
	self.ProgressBar:SetScale(Scale)
	self.ProgressBar:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX + 1, OffsetY - 1)
	self.Textures:HealthBar_Normal(self.ProgressBar)
	self.ProgressBar.texture:SetVertexColor(1, 0, 0)
	
	self.Spark = CreateFrame('Frame', nil, nil)
	self.Spark:SetFrameStrata('FULLSCREEN')
	self.Spark:SetSize(128, Height - 2)
	self.Spark:SetScale(Scale)
	self.Spark:SetAlpha(0.75)
	self.Spark:SetPoint('TOP', self.ProgressBar, 'TOPRIGHT', 0, 0)
	self.Textures:StatusBar_Spark(self.Spark)
	self.Spark.texture:SetVertexColor(1, 0, 0)
	self.Spark:Hide()
	
	self.Overlay = CreateFrame('Frame', nil, nil)
	self.Overlay:SetFrameStrata('FULLSCREEN_DIALOG')
	self.Overlay:SetSize(Width, Height)
	self.Overlay:SetScale(Scale)
	self.Overlay:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	self.Textures:HealthBar_Overlay(self.Overlay)
	
	self.TextFrame = CreateFrame('Frame', nil, nil)
	self.TextFrame:SetFrameStrata('TOOLTIP')
	self.TextFrame:SetSize(Width, Height)
	self.TextFrame:SetScale(Scale)
	self.TextFrame:SetPoint(Point, RelativeFrame, RelativePoint, OffsetX, OffsetY)
	
	self.Text = self.TextFrame:CreateFontString(nil, 'OVERLAY')
	self.Text:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSans.ttf', 8)
	self.Text:SetTextColor(1, 1, 1, 0.75)
	self.Text:SetShadowColor(0, 0, 0, 0.75)
	self.Text:SetShadowOffset(1, -1)
	self.Text:SetPoint('CENTER', 0, 1)
	
	return self
end



function ezSpectator_CastBar:Hide()
	self.Backdrop:Hide()
	self.ProgressBar:Hide()
	self.Spark:Hide()
	self.Overlay:Hide()
	self.TextFrame:Hide()
end



function ezSpectator_CastBar:Show()
	self.Backdrop:Show()
	self.ProgressBar:Show()
	self.Overlay:Show()
	self.TextFrame:Show()
end



function ezSpectator_CastBar:SetText(Name)
	self.Text:SetText(Name)
end


function ezSpectator_CastBar:SetCastType(Spell, Time, SpellName)
	self:SetMaxValue(Time)
	local r, g, b = 1, 1, 1
	local IsProgressMode = false
	
	if Time == 99995 then -- range
		r = 1.0
		g = 1.0
		b = 0.0
		
		self:SetValue(Time)
		self:SetText('Отменено')
	elseif Time == 99996 then -- los
		r = 1.0
		g = 1.0
		b = 0.0
		
		self:SetValue(Time)
		self:SetText('Отменено')
	elseif Time == 99997 then -- success
		r = 0.0
		g = 1.0
		b = 0.0
		
		self:SetValue(Time)
		self:SetText('Успешно')
	elseif Time == 99998 then -- canceled
		r = 1.0
		g = 1.0
		b = 0.0
		
		self:SetValue(Time)
		self:SetText('Отменено')
	elseif Time == 99999 then -- interrupt
		r = 1.0
		g = 0.0
		b = 0.0
		
		self:SetValue(Time)
		self:SetText('Прерван!')
	else --casting
		r = 0.0
		g = 1.0
		b = 1.0
		
		self:SetValue(0)
		self:SetText(SpellName)
		
		IsProgressMode = true
	end
	
	self.Backdrop.texture:SetVertexColor(r, g, b)
	self.ProgressBar.texture:SetVertexColor(r, g, b)
	self.Spark.texture:SetVertexColor(r, g, b)
	
	return IsProgressMode
end



function ezSpectator_CastBar:SetMaxValue(Value)
	self.MaxValue = Value
	self.Weight = self.Width / self.MaxValue
	
	if self.CurrentValue then
		self:SetValue(self.CurrentValue)
	end
end



function ezSpectator_CastBar:SetValue(Value)
	local Result = true
	
	if Value > self.MaxValue then
		Value = self.MaxValue
		Result = false
	end
	
	local ProgressWidth = Value * self.Weight
	
	self.ProgressBar:SetWidth(ProgressWidth)
	self.ProgressBar.texture:SetTexCoord(0, ProgressWidth / self.Width, 0, 1)
	
	local SparkWidth = ProgressWidth + 64
	if SparkWidth > self.Width then
		SparkWidth = 64 + self.Width - ProgressWidth
		self.Spark:SetWidth(SparkWidth)
		self.Spark.texture:SetTexCoord(0, SparkWidth / 128, 0, 1)
		
		self.Spark:ClearAllPoints()
		self.Spark:SetPoint('LEFT', self.ProgressBar, 'RIGHT', -64, 0)
	elseif ProgressWidth < 64 then
		SparkWidth = ProgressWidth + 64
		self.Spark:SetWidth(SparkWidth)
		self.Spark.texture:SetTexCoord(1 - SparkWidth / 128, 1, 0, 1)
		
		self.Spark:ClearAllPoints()
		self.Spark:SetPoint('RIGHT', self.ProgressBar, 'LEFT', SparkWidth, 0)
	else
		self.Spark:SetWidth(128)
		self.Spark.texture:SetTexCoord(0, 1, 0, 1)
		
		self.Spark:ClearAllPoints()
		self.Spark:SetPoint('TOP', self.ProgressBar, 'TOPRIGHT', 0, 0)
	end
	
	if SparkWidth <= 65 then
		self.Spark:Hide()
	else
		if self.Backdrop:IsShown() then
			self.Spark:Show()
		else
			self.Spark:Hide()
		end
	end
	
	self.CurrentValue = Value
	return Result
end