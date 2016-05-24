ezSpectator_SpecWorker = {}
ezSpectator_SpecWorker.__index = ezSpectator_SpecWorker

function ezSpectator_SpecWorker:Create()
	local self = {}
	setmetatable(self, ezSpectator_SpecWorker)
	
	self.ClassTree = {
		--Воин
		{{'Оружие', '2098'}, {'Неистовство', '41368'}, {'Защита', '71'}},
		--Паладин
		{{'Свет', '18984'}, {'Защита', '52442'}, {'Воздаяние', '13008'}},
		--Охотник
		{{'Повелитель зверей', '1515'}, {'Стрельба', '58434'}, {'Выживание', '37413'}},
		--Разбойник
		{{'Ликвидация', '2098'}, {'Бой', '53'}, {'Скрытность', '19885'}},
		--Жрец
		{{'Послушание', '34020'}, {'Свет', '18984'}, {'Тьма', '589'}},
		--Рыцарь смерти
		{{'Кровь', '48263'}, {'Лёд', '48266'}, {'Нечестивость', '48265'}},
		--Шаман
		{{'Стихии', '41265'}, {'Совершенствование', '324'}, {'Исцеление', '48700'}},
		--Маг
		{{'Тайная магия', '32848'}, {'Огонь', '38066'}, {'Лёд', '10737'}},
		--Чернокнижник
		{{'Колдовство', '23127'}, {'Демонология', '13166'}, {'Разрушение', '39273'}},
		--Blizzard sucks
		{{'', ''}, {'', ''}, {'', ''}},
		--Друид
		{{'Баланс', '8921'}, {'Сила зверя', '40794'}, {'Исцеление', '43422'}}
	}
	
	return self
end



function ezSpectator_SpecWorker:GetData(Class, Talents)
	if not Class or not Talents then
		return ''
	end
	
	local Tree = {}
	local Index, MaxTree, MaxTreeVal = 1, nil, 0
	for Value in string.gmatch(Talents, '([^//]+)') do
		Value = tonumber(Value)
		if MaxTree then
			if Value > MaxTreeVal then
				MaxTreeVal = Value
				--noinspection UnusedDef
				MaxTree = Index
			end
		else
			MaxTree = Index
			MaxTreeVal = Value
		end
		
		Tree[Index] = tonumber(Value)
		Index = Index + 1
	end

	local SpecText
	local SpecIcon = ''

	if MaxTreeVal < 44 then
		SpecText = 'Гибрид'
	else
		if MaxTree then
			SpecText = self.ClassTree[Class][MaxTree][1]
			SpecIcon = select(3, GetSpellInfo(self.ClassTree[Class][MaxTree][2]))
		end
	end
	
	return SpecText, SpecIcon
end