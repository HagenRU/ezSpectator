ezSpectator_TopFrame = {}
ezSpectator_TopFrame.__index = ezSpectator_TopFrame

--noinspection LuaOverlyLongMethod
function ezSpectator_TopFrame:Create(Parent)
	local self = {}
	setmetatable(self, ezSpectator_TopFrame)
	
	self.Parent = Parent
	
	self.MatchTime = nil
	self.Textures = ezSpectator_Textures:Create()
	
	self.MainFrame = CreateFrame('Frame', nil, nil)
	self.MainFrame:SetFrameStrata('BACKGROUND')
	self.MainFrame:SetWidth(GetScreenWidth() / _ezSpectatorScale)
	self.MainFrame:SetHeight(35)
	self.MainFrame:SetScale(_ezSpectatorScale)
	self.MainFrame:SetPoint('TOP', 0, 0)
	--self.MainFrame:SetAlpha(0.66)
	
	--self.Textures:GeneratePanel(self.MainFrame)
	--self.Textures:CreateShadow(self.MainFrame)
	
	self.LeftTeam = ezSpectator_TeamFrame:Create(self.Parent, true, 'TOP', -290, -1)
	
	self.RightTeam = ezSpectator_TeamFrame:Create(self.Parent, false, 'TOP', 290, -1)
	
	--self.EnrageOrb = ezSpectator_EnrageOrb:Create(60, 'TOP', 0, 5)
	
	self.Time = self.MainFrame:CreateFontString(nil, 'OVERLAY', 'SystemFont_Shadow_Huge1')
	self.Time:SetPoint('CENTER', 0, 0)
	
	self.UpdateFrame = CreateFrame('Frame', nil, nil)
	self.UpdateFrame.Parent = self
	self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
		if self.Parent.MatchTime ~= nil then
			self.Parent.MatchTime = self.Parent.MatchTime + Elapsed
			
			local Time = math.floor(self.Parent.MatchTime)
			self.Parent.Time:SetText(string.format('%.2d:%.2d', Time / 60 % 60, Time % 60))
		end
	end)
	
	self.ShowUI = ezSpectator_ClickIcon:Create(self.MainFrame, 'gold', 34 / _ezSpectatorScale, 'LEFT', self.MainFrame, 'LEFT', 0, 0)
	self.ShowUI:SetIcon('Eye_Normal')
	self.ShowUI:SetAction(function()
		UIParent:Show()
		
		self.ShowUI:Hide()
		self.HideUI:Show()
	end)
	
	self.HideUI = ezSpectator_ClickIcon:Create(self.MainFrame, 'gold', 34 / _ezSpectatorScale, 'LEFT', self.MainFrame, 'LEFT', 0, 0)
	self.HideUI:SetIcon('Eye_Stroked')
	self.HideUI:Hide()
	self.HideUI:SetAction(function()
		UIParent:Hide()
		
		self.ShowUI:Show()
		self.HideUI:Hide()
	end)
	
	self.Reset = ezSpectator_ClickIcon:Create(self.MainFrame, 'gold', 34 / _ezSpectatorScale, 'LEFT', self.ShowUI.Normal, 'RIGHT', -3, 0)
	self.Reset:SetIcon('Refresh')
	self.Reset:SetAction(function()
		SendChatMessage('.spectate view ' .. UnitName('player'), 'GUILD')
		self.Parent.Interface:ResetViewpoint()
	end)
	
	self.Leave = ezSpectator_ClickIcon:Create(self.MainFrame, 'gold', 34 / _ezSpectatorScale, 'LEFT', self.Reset.Normal, 'RIGHT', -3, 0)
	self.Leave:SetIcon('Logout')
	self.Leave:SetAction(function()
		LeaveBattlefield()
	end)
	
	self:Hide()
	return self
end



function ezSpectator_TopFrame:Hide()
	self.MainFrame:Hide()
	self.LeftTeam:Hide()
	self.RightTeam:Hide()
	--self.EnrageOrb:Hide()
end



function ezSpectator_TopFrame:Show()
	self.MainFrame:Show()
	self.LeftTeam:Show()
	self.RightTeam:Show()
	--self.EnrageOrb:Show()
end



function ezSpectator_TopFrame:StartTimer(Value)
	self.MatchTime = tonumber(Value)
end