ezSpectator_ClickIcon = {}
ezSpectator_ClickIcon.__index = ezSpectator_ClickIcon

--noinspection LuaOverlyLongMethod
function ezSpectator_ClickIcon:Create(Parent, ParentFrame, Style, Size, ...)
	local self = {}
	setmetatable(self, ezSpectator_ClickIcon)

	self.Parent = Parent

	self.Action = nil
	self.IsTextInteractive = false
	
	self.Textures = ezSpectator_Textures:Create()
	self.ParentFrame = ParentFrame
	
	self.Backdrop = CreateFrame('Frame', nil, self.ParentFrame)
	self.Backdrop:SetFrameLevel(1)
	self.Backdrop:SetFrameStrata('HIGH')
	self.Backdrop:SetSize(Size, Size)
	self.Backdrop:SetScale(_ezSpectatorScale)
	self.Backdrop:SetPoint(...)
	self.Textures:ClickIcon_Backdrop(self.Backdrop)
	
	self.Normal = CreateFrame('Frame', nil, self.ParentFrame)
	self.Normal:SetFrameLevel(4)
	self.Normal:SetFrameStrata('HIGH')
	self.Normal:SetSize(Size, Size)
	self.Normal:SetScale(_ezSpectatorScale)
	self.Normal:SetPoint(...)
	
	self.Highlight = CreateFrame('Frame', nil, self.ParentFrame)
	self.Highlight:SetFrameLevel(5)
	self.Highlight:SetFrameStrata('HIGH')
	self.Highlight:SetSize(Size, Size)
	self.Highlight:SetScale(_ezSpectatorScale)
	self.Highlight:SetPoint(...)
	self.Highlight:Hide()
	
	local SizeMod = 0
	if Style == 'gold' then
		self.Textures:ClickIcon_Normal_Gold(self.Normal)
		self.Textures:ClickIcon_Highlight_Gold(self.Highlight)
	elseif Style == 'silver' then
		self.Textures:ClickIcon_Normal_Silver(self.Normal)
		self.Textures:ClickIcon_Highlight_Silver(self.Highlight)
		
		SizeMod = 0.5
	elseif Style == 'clear' then
		self.Backdrop.texture:SetTexture(EMPTY_TEXTURE)
	end
	
	self.Icon = CreateFrame('Frame', nil, self.Backdrop)
	self.Icon:SetFrameLevel(2)
	self.Icon:SetFrameStrata('HIGH')
	self.Icon:SetSize(Size, Size)
	self.Icon:SetScale(_ezSpectatorScale)
	
	self.Icon:SetPoint('CENTER', self.Normal, 'CENTER', 0, SizeMod)
	
	self.Cooldown = CreateFrame('Cooldown', nil, self.Icon)
	self.Cooldown:SetFrameLevel(3)
	self.Cooldown:SetFrameStrata('HIGH')
	self.Cooldown:SetSize(Size, Size)
	self.Cooldown:SetPoint('CENTER', self.Normal, 'CENTER', 0, SizeMod)

	self.TextFrame = CreateFrame('Frame', nil, self.ParentFrame)
	self.TextFrame:SetFrameStrata('TOOLTIP')
	self.TextFrame:SetSize(1, 1)

	self.Text = self.TextFrame:CreateFontString(nil, 'OVERLAY')
	self.Text:SetFont('Interface\\Addons\\IsengardSpectator\\Fonts\\DejaVuSans.ttf', 8)
	self.Text:SetTextColor(1, 1, 1, 0.75)
	self.Text:SetShadowColor(0, 0, 0, 0.75)
	self.Text:SetShadowOffset(1, -1)
	self.Text:SetPoint('CENTER', 0, 1)

	self.Reactor = CreateFrame('Frame', nil, self.ParentFrame)
	self.Reactor:SetFrameStrata('TOOLTIP')
	self.Reactor:SetSize(Size, Size)
	self.Reactor:SetScale(_ezSpectatorScale)
	self.Reactor:SetPoint(...)
	
	self.Reactor:EnableMouse(true)
	self.Reactor:SetScript('OnEnter', function()
		if self.Backdrop:IsShown() then
			self.Normal:Hide()
			self.Highlight:Show()
		end
	end)
	self.Reactor:SetScript('OnLeave', function()
		if self.Backdrop:IsShown() then
			self.Highlight:Hide()
			self.Normal:Show()
		end
	end)
	self.Reactor:SetScript('OnUpdate', function()
		if self.IsTextInteractive then
			local OffsetX, OffsetY, Width, Height = self.Normal:GetBoundsRect()
			OffsetX = OffsetX + 237
			OffsetY = OffsetY + 194

			local CenterX = OffsetX + Width / 2
			local CenterY = OffsetY + Height / 2

			local CursorX, CursorY =  GetCursorPosition()

			local DiffX = abs(CenterX - CursorX)
			local DiffY = abs(CenterY - CursorY)

			local Distance = math.sqrt(DiffX * DiffX + DiffY * DiffY)

			self.TextFrame:SetAlpha(1 - Distance / 200)
		end
	end)
	
	return self
end



function ezSpectator_ClickIcon:Show()
	self.Backdrop:Show()
	self.Normal:Show()
	self.Icon:Show()
	self.Cooldown:Show()
	self.TextFrame:Show()
	self.Reactor:Show()
end



function ezSpectator_ClickIcon:Hide()
	self.Backdrop:Hide()
	self.Normal:Hide()
	self.Highlight:Hide()
	self.Icon:Hide()
	self.Cooldown:Hide()
	self.TextFrame:Hide()
	self.Reactor:Hide()
end



function ezSpectator_ClickIcon:IsShown()
	return self.Backdrop:IsShown()
end



function ezSpectator_ClickIcon:SetAlpha(Value)
	self.Backdrop:SetAlpha(Value)
	self.Normal:SetAlpha(Value)
	self.Highlight:SetAlpha(Value)
	self.TextFrame:SetAlpha(Value)
end



function ezSpectator_ClickIcon:SetCooldown(Time, Duration)
	self.Cooldown:SetCooldown(Time, Duration)
end



function ezSpectator_ClickIcon:SetTexture(Name, Size, CutBorders)
	Size = Size / _ezSpectatorScale

	self.Icon:SetSize(Size, Size)
	self.Cooldown:SetSize(Size, Size)
	
	local Texture = self.Textures:Load(self.Icon, Name)
	if CutBorders then
		Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end
	Texture:SetAllPoints(self.Icon)
	self.Icon.texture = Texture
end



function ezSpectator_ClickIcon:SetIcon(Name)
	local Record

	--noinspection UnusedDef
	for Index, Value in pairs(self.Parent.Data.ClickIconOffset) do
		if Value[1] == Name then
			Record = Value
			break
		end
	end
	
	if Record then
		self.Icon:SetSize(Record[6], Record[6])
		self.Cooldown:SetSize(Record[6], Record[6])
		
		local Texture = self.Textures:Load(self.Icon, 'Interface\\Addons\\IsengardSpectator\\Textures\\Icons\\' .. Record[1] .. '.tga')
		Texture:SetTexCoord(Record[2], Record[3], Record[4], Record[5])
		Texture:SetAllPoints(self.Icon)
		self.Icon.texture = Texture
	end
end



function ezSpectator_ClickIcon:SetText(Value)
	self.Text:SetText(Value)
end



function ezSpectator_ClickIcon:SetTextAlignTop()
	self.TextFrame:ClearAllPoints()
	self.TextFrame:SetPoint('BOTTOM', self.Normal, 'TOP', 0, 2)
end



function ezSpectator_ClickIcon:SetTextAlignBottom()
	self.TextFrame:ClearAllPoints()
	self.TextFrame:SetPoint('TOP', self.Normal, 'BOTTOM', 0, -2)
end



function ezSpectator_ClickIcon:SetTextInteractive(IsInteractive)
	self.IsTextInteractive = IsInteractive

	if not IsInteractive then
		self.TextFrame:SetAlpha(1)
	end
end



function ezSpectator_ClickIcon:SetAction(Action)
	if not self.Action then
		self.Reactor:SetScript('OnMouseDown', function()
			if self.Backdrop:IsShown() then
				self.Backdrop:SetFrameStrata('DIALOG')
				self.Icon:SetFrameStrata('FULLSCREEN')
				self.Icon:SetAlpha(0.75)
			end
		end)
		self.Reactor:SetScript('OnMouseUp', function()
			if self.Backdrop:IsShown() then
				self.Backdrop:SetFrameStrata('LOW')
				self.Icon:SetFrameStrata('MEDIUM')
				self.Icon:SetAlpha(1)
				
				if self.Action then
					self.Action()
				end
			end
		end)
	end
	
	self.Action = Action
end