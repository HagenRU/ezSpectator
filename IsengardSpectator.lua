_ezSpectatorScale = 1.15

ezSpectator = {}
ezSpectator.__index = ezSpectator

function ezSpectator:Create()
	local self = {}
	setmetatable(self, ezSpectator)

	self.Data = ezSpectator_DataWorker:Create(self)
	self.Sound = ezSpectator_Sounds:Create(self)

	self.Interface = ezSpectator_InterfaceWorker:Create(self)
	self.Handler = ezSpectator_MessageHandler:Create(self)

	self.Tooltip = ezSpectator_TooltipWorker:Create(self)

	return self
end

_ezSpectator = ezSpectator:Create()



function ezSpectator_Demo()
	_ezSpectator.Interface.IsRunning = true
	_ezSpectator.Interface.TopFrame:Show()
	_ezSpectator.Interface.TopFrame:StartTimer(235)

	local SoundName = _ezSpectator.Data.MatchEndings['DEFAULT']
	if type(SoundName) == 'table' then
		SoundName = SoundName[math.random(#SoundName)]
	end

	_ezSpectator.Sound:Play(SoundName, 5)
end