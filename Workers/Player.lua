ezSpectator_PlayerWorker = {}
ezSpectator_PlayerWorker.__index = ezSpectator_PlayerWorker

--noinspection LuaOverlyLongMethod
function ezSpectator_PlayerWorker:Create(Parent)
	local self = {}
	setmetatable(self, ezSpectator_PlayerWorker)
	
	self.Trinkets = {
		[65547] = 120,
		[42292] = 120,
		[59752] = 120,
		[7744] = 45
	}
	
	self.Parent = Parent
	
	self.SpecWorker = ezSpectator_SpecWorker:Create()
	
	self.SmallFrame = ezSpectator_SmallFrame:Create(self)
	self.SmallFrame:Hide()
	
	self.SmallControlWorker = ezSpectator_ControlWorker:Create()
	self.SmallControlWorker:BindIcon(self.SmallFrame.ControlIcon)
	
	self.PlayerFrame = ezSpectator_BindFrame:Create()
	self.PlayerFrame:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOM', -10, 20)
	self.PlayerFrame.SpellFrame = ezSpectator_SpellFrame:Create(false, 'TOPRIGHT', self.PlayerFrame.Normal, 'TOPLEFT', 0, -19)
	self.PlayerFrame:Hide()
	
	self.PlayerControlWorker = ezSpectator_ControlWorker:Create()
	self.PlayerControlWorker:BindIcon(self.PlayerFrame.ControlIcon)
	
	self.VictimFrame = ezSpectator_BindFrame:Create()
	self.VictimFrame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOM', 10, 20)
	self.VictimFrame.SpellFrame = ezSpectator_SpellFrame:Create(true, 'TOPLEFT', self.VictimFrame.Normal, 'TOPRIGHT', 0, -19)
	self.VictimFrame:Hide()
	
	self.VictimControlWorker = ezSpectator_ControlWorker:Create()
	self.VictimControlWorker:BindIcon(self.VictimFrame.ControlIcon)
	
	self.CurrentTarget = nil
	self.IsNicknameSet = false
		self.Nickname = nil
	self.IsClassSet = false
		self.Class = nil
	self.IsPowerTypeSet = false
	self.IsMaxHealthSet = false
		self.MaxHealth = nil
	self.IsMaxPowerSet = false
	self.IsHealthSet = false
		self.Health = nil
	self.IsPowerSet = false
	self.IsTeamSet = false
		self.Team = nil
	
	self.IsLocked = false
	self.IsDead = false
	
	return self
end



function ezSpectator_PlayerWorker:Hide()
	self.SmallFrame:Hide()
	self.PlayerFrame:Hide()
	self.VictimFrame:Hide()
end



function ezSpectator_PlayerWorker:Show()
	self.SmallFrame:Show()
end



function ezSpectator_PlayerWorker:IsShown()
	return self.SmallFrame.Backdrop:IsShown()
end


function ezSpectator_PlayerWorker:IsReady()
	if self.SmallFrame.IsLocked then
		return false
	end
	
	return self.IsNicknameSet and self.IsClassSet and self.IsPowerTypeSet and self.IsMaxHealthSet and self.IsMaxPowerSet and self.IsHealthSet and self.IsPowerSet and self.IsTeamSet
end



function ezSpectator_PlayerWorker:SetNickname(Nickname)
	if self.SmallFrame.IsLocked then
		return
	end
	
	self.Nickname = Nickname
	self.IsNicknameSet = true
	
	self.SmallFrame.HealthBar:SetNickname(Nickname)
	self.PlayerFrame.HealthBar:SetNickname(Nickname)
	self.VictimFrame.HealthBar:SetNickname(Nickname)
end



function ezSpectator_PlayerWorker:SetClass(Class)
	if self.SmallFrame.IsLocked then
		return
	end
	
	self.Class = Class
	self.IsClassSet = true
	
	self.SmallControlWorker:SetClass(Class)
	self.PlayerControlWorker:SetClass(Class)
	self.VictimControlWorker:SetClass(Class)
	
	self.SmallFrame.HealthBar:SetClass(Class)
	self.PlayerFrame.HealthBar:SetClass(Class)
	self.VictimFrame.HealthBar:SetClass(Class)
end



function ezSpectator_PlayerWorker:SetPowerType(Power)
	if self.SmallFrame.IsLocked then
		return
	end
	
	self.IsPowerTypeSet = true
	self.SmallFrame.PowerBar:SetPowerType(Power)
	self.PlayerFrame.PowerBar:SetPowerType(Power)
	self.VictimFrame.PowerBar:SetPowerType(Power)
end



function ezSpectator_PlayerWorker:SetMaxHealth(Value)
	if self.SmallFrame.IsLocked then
		return
	end
	
	self.MaxHealth = Value
	self.IsMaxHealthSet = true
	
	self.SmallFrame.HealthBar:SetMaxValue(Value)
	self.PlayerFrame.HealthBar:SetMaxValue(Value)
	self.VictimFrame.HealthBar:SetMaxValue(Value)
end



function ezSpectator_PlayerWorker:SetMaxPower(Value)
	if self.SmallFrame.IsLocked then
		return
	end
	
	self.IsMaxPowerSet = true
	self.SmallFrame.PowerBar:SetMaxValue(Value)
	self.PlayerFrame.PowerBar:SetMaxValue(Value)
	self.VictimFrame.PowerBar:SetMaxValue(Value)
end



function ezSpectator_PlayerWorker:SetHealth(Value)
	if self.SmallFrame.IsLocked then
		return
	end
	
	self.Health = Value
	self.IsHealthSet = true
	
	self.SmallFrame.HealthBar:SetValue(Value)
	self.PlayerFrame.HealthBar:SetValue(Value)
	self.VictimFrame.HealthBar:SetValue(Value)
end



function ezSpectator_PlayerWorker:SetPower(Value)
	if self.SmallFrame.IsLocked then
		return
	end
	
	self.IsPowerSet = true
	self.SmallFrame.PowerBar:SetValue(Value)
	self.PlayerFrame.PowerBar:SetValue(Value)
	self.VictimFrame.PowerBar:SetValue(Value)
end



function ezSpectator_PlayerWorker:SetCast(Spell, Time)
	if self.SmallFrame.IsLocked then
		return
	end
	
	if (self.Trinkets[Spell] ~= nil) then
		self.SmallFrame.SpellFrame:Push(Spell)
		self.SmallFrame.TrinketIcon:SetCooldown(GetTime(), self.Trinkets[Spell])
		
		self.PlayerFrame.SpellFrame:Push(Spell)
		self.PlayerFrame.TrinketIcon:SetCooldown(GetTime(), self.Trinkets[Spell])
		
		self.VictimFrame.SpellFrame:Push(Spell)
		self.VictimFrame.TrinketIcon:SetCooldown(GetTime(), self.Trinkets[Spell])
		return
	end
	
	self.SmallFrame.CastFrame:ShowCast(Spell, Time)
	if self.PlayerFrame:IsShown() then
		self.PlayerFrame.CastFrame:ShowCast(Spell, Time)
	end
	if self.VictimFrame:IsShown() then
		self.VictimFrame.CastFrame:ShowCast(Spell, Time)
	end
	
	if Time == 99997 then
		self.SmallFrame.SpellFrame:Push(Spell)
		self.PlayerFrame.SpellFrame:Push(Spell)
		self.VictimFrame.SpellFrame:Push(Spell)
	end
end



function ezSpectator_PlayerWorker:SetTeam(Value)
	if self.SmallFrame.IsLocked then
		return
	end
	
	if not Value or self.IsTeamSet then
		return
	end
	
	if Value == 67 then
		Value = 1
	elseif Value == 469 then
		--noinspection UnusedDef
		Value = 2
	else
		return
	end
	
	self.Team = Value
	self.IsTeamSet = true
	
	table.insert(self.Parent.Interface.Teams[Value], self)
	self:SetPosition(Value, #self.Parent.Interface.Teams[Value])
end



function ezSpectator_PlayerWorker:SetPosition(Team, Position)
	if self.SmallFrame.IsLocked then
		return
	end
	
	local FramePosition = ((Position - 1) * 173 + 125) * -1
	
	self.SmallFrame:ClearAllPoints()
	if Team == 1 then
		self.SmallFrame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 0, FramePosition)
		self.SmallFrame.SpellFrame = ezSpectator_SpellFrame:Create(true, 'TOPLEFT', self.SmallFrame.Normal, 'TOPRIGHT', 0, -19)
	end
	
	if Team == 2 then
		self.SmallFrame.SpellFrame = ezSpectator_SpellFrame:Create(false, 'TOPRIGHT', self.SmallFrame.Normal, 'TOPLEFT', 0, -19)
		self.SmallFrame:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', 0, FramePosition)
	end
end



function ezSpectator_PlayerWorker:SetStatus(Value)
	if self.SmallFrame.IsLocked then
		return
	end
	
	self.IsDead = Value == 0
	
	if Value == 0 then
		self:SetHealth(0)
		self:SetPower(0)
		
		self.SmallFrame:SetAlpha(0.5)
		self.SmallFrame.HealthBar:SetOverride('МЁРТВ')
		self.SmallFrame.AuraFrame:Hide()
		
		self.PlayerFrame:SetAlpha(0.5)
		self.PlayerFrame.HealthBar:SetOverride('МЁРТВ')
		self.PlayerFrame.AuraFrame:Hide()
		
		self.VictimFrame:SetAlpha(0.5)
		self.VictimFrame.HealthBar:SetOverride('МЁРТВ')
		self.VictimFrame.AuraFrame:Hide()
	end
	
	if Value == 1 then
		self.SmallFrame:SetAlpha(1)
		self.SmallFrame.HealthBar:SetOverride(nil)
		
		self.PlayerFrame:SetAlpha(1)
		self.PlayerFrame.HealthBar:SetOverride(nil)
		
		self.VictimFrame:SetAlpha(1)
		self.VictimFrame.HealthBar:SetOverride(nil)
		
		if self:IsReady() then
			self.SmallFrame.AuraFrame:Show()
			self.PlayerFrame.AuraFrame:Show()
			self.VictimFrame.AuraFrame:Show()
		end
	end
end



function ezSpectator_PlayerWorker:SetTarget(Value)
	if self.SmallFrame.IsLocked then
		return
	end
	
	if Value then
		self.CurrentTarget = Value
		self.SmallFrame.Target:SetUnit(Value)
	end
	
	if self.CurrentTarget and self.PlayerFrame:IsShown() then
		self.Parent.Interface:ResetVictims()
		self.CurrentTarget.VictimFrame:Show()
	end
end



function ezSpectator_PlayerWorker:SetSpec(Value)
	if self.SmallFrame.IsLocked then
		return
	end
	
	local SpecName, SpecIcon = self.SpecWorker:GetData(self.Class, Value)
	self.SmallFrame.HealthBar:SetDescription(SpecName)
	self.PlayerFrame.HealthBar:SetDescription(SpecName)
	self.VictimFrame.HealthBar:SetDescription(SpecName)
	
	self.SmallFrame.SpecIcon:SetTexture(SpecIcon, 16, true)
end



function ezSpectator_PlayerWorker:SetAura(...)
	if self.SmallFrame.IsLocked then
		return
	end
	
	self.SmallFrame.AuraFrame:SetAura(...)
	self.PlayerFrame.AuraFrame:SetAura(...)
	self.VictimFrame.AuraFrame:SetAura(...)
	
	self.SmallControlWorker:Update(self.SmallFrame.AuraFrame)
	self.PlayerControlWorker:Update(self.PlayerFrame.AuraFrame)
	self.VictimControlWorker:Update(self.VictimFrame.AuraFrame)
end



function ezSpectator_PlayerWorker:SetLock(Value)
	self.SmallFrame.IsLocked = Value == 1
end



function ezSpectator_PlayerWorker:SetWinner(IsWinner)
	if IsWinner then
		self.SmallFrame:SetAlpha(1)
		self.SmallFrame.HealthBar:SetOverride('ПОБЕДА')
		
		self.PlayerFrame:SetAlpha(1)
		self.PlayerFrame.HealthBar:SetOverride('ПОБЕДА')
		
		self.VictimFrame:SetAlpha(1)
		self.VictimFrame.HealthBar:SetOverride('ПОБЕДА')
	else
		local LockState = self.SmallFrame.IsLocked
		self.SmallFrame.IsLocked = false
		
		self:SetHealth(0)
		self:SetPower(0)
		
		self.SmallFrame.IsLocked = LockState
		
		self.SmallFrame:SetAlpha(0.5)
		self.SmallFrame.HealthBar:SetOverride('ПОРАЖЕНИЕ')
		
		self.PlayerFrame:SetAlpha(0.5)
		self.PlayerFrame.HealthBar:SetOverride('ПОРАЖЕНИЕ')
		
		self.VictimFrame:SetAlpha(0.5)
		self.VictimFrame.HealthBar:SetOverride('ПОРАЖЕНИЕ')
	end
end



function ezSpectator_PlayerWorker:BindViewpoint()
	SendChatMessage('.spectate view ' .. self.Nickname, 'GUILD')
	
	self.Parent.Interface:ResetViewpoint()
	self.PlayerFrame:Show()
	self:SetTarget(nil)
end