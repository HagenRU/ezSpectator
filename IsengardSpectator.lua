_ezSpectatorScale = 1.15

ezSpectator = {}
ezSpectator.__index = ezSpectator

function ezSpectator:Create()
	local self = {}
	setmetatable(self, ezSpectator)
	
	self.Interface = ezSpectator_InterfaceWorker:Create(self, self.Teams, self.Players)
	self.Handler = ezSpectator_MessageHandler:Create(self.Interface)
	
	return self
end

_ezSpectator = ezSpectator:Create()

--tb = ezSpectator_HealthBar:Create(true, true, 10 * _ezSpectatorScale, 177, 26, _ezSpectatorScale, 'LEFT', UIParent, 'CENTER', 0, 0)
--tb:SetClass(1)
--tb:SetMaxValue(100000)
--tb:SetValue(30000)
--tb:SetNickname('Test')
--tb:SetDescription('Animation')

function play(value)
	if not value then
		value = math.random(1, 100000)
	end
	
	tb:SetValue(value)
end