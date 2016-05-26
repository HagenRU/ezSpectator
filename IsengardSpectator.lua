--TODO Таргет игрока на текущий момент, включая пета, таргет по пету периодически бывает очень важен.
--TODO Отдельный вывод самых важных кулдаунов где-то сбоку (общий для каждой из команд).
--TODO Хп бары над головами игроков: Количество ХП в цвет команды
--TODO Хп бары над головами игроков: Иконка класса/контроля игрока (охеренно полезная вещь, когда игрок находится в контроле)
--TODO Хп бары над головами игроков: + обозначающий суппорта
--TODO Турнирные анонсы поверх аддона, их действительно не хватает когда скрыт интерфейс.

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
	
	return self
end

_ezSpectator = ezSpectator:Create()



function ezSpectator_Demo()
	_ezSpectator.Interface.IsRunning = true
	_ezSpectator.Interface.TopFrame:Show()
	_ezSpectator.Interface.TopFrame:StartTimer(230)

	local SoundName = _ezSpectator.Data.MatchEndings['DEFAULT']
	if type(SoundName) == 'table' then
		SoundName = SoundName[math.random(#SoundName)]
	end

	_ezSpectator.Sound:Play(SoundName, 5)
end