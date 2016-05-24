ezSpectator_MessageHandler = {}
ezSpectator_MessageHandler.__index = ezSpectator_MessageHandler

function ezSpectator_MessageHandler:Create(Interface)
	local self = {}
	setmetatable(self, ezSpectator_MessageHandler)
	
	self.Interface = Interface
	
	self.EventFrame = CreateFrame('Frame', nil, nil)
	self.EventFrame.Parent = self
	
	self.EventFrame:RegisterEvent('CHAT_MSG_ADDON')
	self.EventFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
	self.EventFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	self.EventFrame:SetScript('OnEvent', self.EventHandler)
	
	return self
end



function ezSpectator_MessageHandler:EventHandler(Event, ...)
	if Event == 'CHAT_MSG_ADDON' then
		if arg1 == 'ARENASPEC' and arg3 == 'WHISPER' and arg4 == '' then
			self.Parent:ProcessMessage(arg2)
		end
	elseif Event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		if arg2 == 'UNIT_DIED' then
			if self.Parent.Interface.Players[arg7] then
				--self.Parent.Interface.Players[arg7]:SetStatus(0)
			end
		end
	end
end



function ezSpectator_MessageHandler:ProcessMessage(Message)
	local DelimiterPosition = 1
	local DataPosition = 1
	local MessageTarget = nil
	
	if Message:find(';AUR=') then
		local AuraTarget, Message = strsplit(';', Message)
		local _, DataPart = strsplit('=', Message)
		local aremove, astack, aexpiration, aduration, aspellId, adebyfftype, aisdebuff, acaster = strsplit(',', DataPart)

		self:ProcessCommand(AuraTarget, 'AUR', tonumber(aremove), tonumber(astack), tonumber(aexpiration), tonumber(aduration), tonumber(aspellId), tonumber(adebyfftype), tonumber(aisdebuff), acaster)
		return
	end
	
	DataPosition = strfind(Message, ';', DelimiterPosition)
	MessageTarget = strsub(Message, 1, DataPosition - 1)
	DelimiterPosition = DataPosition + 1
	
	repeat
		DataPosition = strfind(Message, ';', DelimiterPosition)
		if (DataPosition ~= nil) then
			local Command = strsub(Message, DelimiterPosition, DataPosition - 1)
			DelimiterPosition = DataPosition + 1
			
			local Prefix = strsub(Command, 1, strfind(Command, '=') - 1)
			local Value = strsub(Command, strfind(Command, '=') + 1)
			
			self:ProcessCommand(MessageTarget, Prefix, Value)
		end
	until DataPosition == nil
end



function ezSpectator_MessageHandler:ProcessCommand(Target, Prefix, ...)
	local Value = ...
	local TeamID = nil
	
	if self.Interface.Players[Target] == nil then
		if Target == '67' then
			TeamID = 1
		end
		
		if Target == '469' then
			TeamID = 2
		end
		
		if not TeamID then
			self.Interface.Players[Target] = ezSpectator_PlayerWorker:Create(self.Interface)
			self.Interface.Players[Target]:SetNickname(Target)
			self.Interface.Players[Target]:Hide()
		end
	else
		if self.Interface.Players[Target]:IsReady() and not self.Interface.Players[Target]:IsShown() then
			self.Interface.Players[Target]:Show()
		end
	end
	
	if Prefix == 'CHP' then
		self.Interface.Players[Target]:SetHealth(tonumber(Value))
	elseif Prefix == 'MHP' then
		self.Interface.Players[Target]:SetMaxHealth(tonumber(Value))
	elseif Prefix == 'CPW' then
		self.Interface.Players[Target]:SetPower(tonumber(Value))
	elseif Prefix == 'MPW' then
		self.Interface.Players[Target]:SetMaxPower(tonumber(Value))
	elseif Prefix == 'PWT' then
		self.Interface.Players[Target]:SetPowerType(tonumber(Value))
	elseif Prefix == 'TEM' then
		self.Interface.Players[Target]:SetTeam(tonumber(Value))
	elseif Prefix == 'STA' then
		self.Interface.Players[Target]:SetStatus(tonumber(Value))
	elseif Prefix == 'CLA' then
		self.Interface.Players[Target]:SetClass(tonumber(Value))
	elseif Prefix == 'SPE' then
		self.Interface.Players[Target]:SetCast(tonumber(strsub(Value, 1, strfind(Value, ',') - 1)), tonumber(strsub(Value, strfind(Value, ',') + 1)))
	elseif Prefix == 'AUR' then
		self.Interface.Players[Target]:SetAura(...)
	elseif Prefix == 'TRG' then
		self.Interface.Players[Target]:SetTarget(self.Interface.Players[Value])
	elseif Prefix == 'LEV' then
		self.Interface.Players[Target]:SetLock(tonumber(Value))
	elseif Prefix == 'ELA' then
		self.Interface:SetMatchElapsed(Value)
	elseif Prefix == 'TAL' then
		self.Interface.Players[Target]:SetSpec(Value)
	elseif Prefix == 'NAM' then
		self.Interface:SetTeamName(TeamID, Value)
	elseif Prefix == 'COL' then
		self.Interface:SetTeamColor(TeamID, Value)
	elseif Prefix == 'SRC' then
		self.Interface:SetTeamScore(TeamID, Value)
	elseif Prefix == 'ENB' then
		self.Interface:SetMode(tonumber(Value))
	else
		DEFAULT_CHAT_FRAME:AddMessage('Unhandled prefix: ' .. Prefix .. '. Try to update to newer version')
	end
	
	self.Interface:UpdateTeams()
	self.Interface:UpdateTargets()
end