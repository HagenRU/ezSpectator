--TODO Активное отображение начала энрейджа после его включения, как для игроков, так и для тех кто смотрит матч через аддон, желательно сопроводить это звуковым эффектом и каким-то анонсом по центру экрана.
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




--tb = ezSpectator_HealthBar:Create(self, true, true, 10 * _ezSpectatorScale, 177, 26, _ezSpectatorScale, 'LEFT', UIParent, 'CENTER', 0, 0)
--tb:SetClass(1)
--tb:SetMaxValue(100000)
--tb:SetValue(30000)
--tb:SetNickname('Test')
--tb:SetDescription('Animation')



tb = ezSpectator_PlayerWorker:Create(_ezSpectator)
tb:SetNickname('Test bar')
tb:SetClass(1)
tb:SetPowerType(1)
tb:SetMaxHealth(10000)
tb:SetMaxPower(1000)
tb:SetHealth(5000)
tb:SetPower(7000)
--tb:SetTeam(67)
table.insert(_ezSpectator.Interface.Players, tb)



--_ezSpectator.Interface.TopFrame:Show()
--_ezSpectator.Interface.TopFrame:StartTimer(290)



function play(...)
	_ezSpectator.Sound:Play('Berzerk')
	--tb:SetCast(...)
end