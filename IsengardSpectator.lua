--TODO Хп бары над головами игроков: Иконка класса/каста/контроля игрока
--TODO Хп бары над головами игроков: + обозначающий суппорта
--TODO Базовая иконка неймплейта
--TODO Восстановление цвета оригинального неймплейта
--TODO Упрощенная обработка неймплейтов простых объектов - тотемов, слуг

--TODO Скорректировать отступы тултипов от края экрана (увеличить)
--TODO Установить фиксированный размер для тултипа

--TODO Фильтрация списка аур, уменьшение числа строк аур

--TODO Анимации иконок КД
--TODO Сортировка иконок КД
--TODO Рамка иконок КД

--TODO Таргет игрока на текущий момент, включая пета, таргет по пету периодически бывает очень важен

--TODO Турнирные анонсы поверх аддона, их действительно не хватает когда скрыт интерфейс



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