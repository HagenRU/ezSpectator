ezSpectator_DataWorker = {}
ezSpectator_DataWorker.__index = ezSpectator_DataWorker

function ezSpectator_DataWorker:Create()
    local self = {}
    setmetatable(self, ezSpectator_DataWorker)

    self.NamePlateLevel = 0

    self.ViewpointAlpha = 0.33
    self.ViewpointNameplateAlpha = 0.50

    self.EnrageStartAt = 420
    self.EnrageStackInterval = 30
    self.EnrageStackMax = 10

    self.TimeWarnings = {
        [300] = '5_minute_warning',
        [180] = '3_minutes_remain',
        [120] = '2_minutes_remain',
        [60] = '1_minute_remains',
        [30] = '30_seconds_remain',
        [20] = '20_seconds',
        [10] = 'ten',
        [9] = 'nine',
        [8] = 'eight',
        [7] = 'seven',
        [6] = 'six',
        [5] = 'five',
        [4] = 'four',
        [3] = 'three',
        [2] = 'two',
        [1] = 'one'
    }

    self.MatchEndings = {
        ['DEFAULT'] = {
            'EndOfRound',
            'SKAARJannihilation',
            'SKAARJbloodbath',
            'SKAARJerradication',
            'SKAARJextermination',
            'SKAARJslaughter',
            'SKAARJtermination'
        }
    }

    self.ClassTextEng = {
        'WARRIOR',
        'PALADIN',
        'HUNTER',
        'ROGUE',
        'PRIEST',
        'DEATHKNIGHT',
        'SHAMAN',
        'MAGE',
        'WARLOCK',
        '',
        'DRUID',
    }

    self.ClassIconOffset = {
        {0, 0.25, 0, 0.25},
        {0, 0.25, 0.5, 0.75},
        {0, 0.25, 0.25, 0.5},
        {0.49609375, 0.7421875, 0, 0.25},
        {0.49609375, 0.7421875, 0.25, 0.5},
        {0.25, 0.49609375, 0.5, 0.75},
        {0.25, 0.49609375, 0.25, 0.5},
        {0.25, 0.49609375, 0, 0.25},
        {0.7421875, 0.98828125, 0.25, 0.5},
        {},
        {0.7421875, 0.98828125, 0, 0.25}
    }

    self.ClassTreeInfo = {
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

    self.SpellFunctor = {}
    self.SpellFunctor.RESET_COOLDOWN = 1

    self.ClassSpellInfo = {
        --Воин
        {
            --Глухая оборона (Общий)
            [871] = true,
            --Устрашающий крик (Общий)
            [5246] = true,
            --Разоружение (Общий)
            [676] = false,
            --Безудержное восстановление (Общий)
            [55694] = true,
            --Вихрь клинков (Оружие)
            [46924] = true,
            --Ни шагу назад (Защита)
            [12975] = false,
            --Ударная волна (Защита)
            [46968] = true,
            --Оглушающий удар (Защита)
            [12809] = true,
            --Жажда смерти (Неистовство)
            [12292] = true
        },
        --Паладин
        {
            --Божественный щит (Общий)
            [642] = true,
            --Длань защиты (Общий)
            [10278] = true,
            --Длань жертвенности (Общий)
            [6940] = true,
            --Молот правосудия (Общий)
            [10308] = false,
            --Гнев карателя (Общий)
            [31884] = true,
            --Длань свободы (Общий)
            [1044] = false,
            --Святая клятва (Общий)
            [54428] = false,
            --Мастер аур (Свет)
            [31821] = true,
            --Покаяние (Воздаяние)
            [20066] = true,
            --Священная жертва (Защита)
            [64205] = true
        },
        --Охотник
        {
            --Сдерживание (Общий)
            [19263] = true,
            --Замораживающая стрела (Общий)
            [60192] = true,
            --Готовность (Стрельба)
            [23989] = {
                functor = self.SpellFunctor.RESET_COOLDOWN,
                params = {19263, 34490, 53271, 19503, 60192, 49012}
            },
            --Глушащий выстрел (Стрельба)
            [34490] = false,
            --Укус виверны (Выживание)
            [49012] = true,
            --Звериный гнев (Повелитель зверей)
            [19574] = true,
            --Приказ хозяина (Повелитель зверей)
            [53271] = false,
            --Дезориентирующий выстрел (Повелитель зверей)
            [19503] = true
        },
        --Разбойник
        {
            --Плащ Теней (Общий)
            [31224] = true,
            --Исчезновение (Общий)
            [26889] = true,
            --Ослепление (Общий)
            [2094] = true,
            --Долой оружие (Общий)
            [51722] = true,
            --Череда убийств (Бой)
            [51690] = true,
            --Выброс адреналина (Бой)
            [13750] = true,
            --Шквал клинков (Бой)
            [13877] = true,
            --Подготовка (Скрытность)
            [14185] = {
                functor = self.SpellFunctor.RESET_COOLDOWN,
                params = {26889}
            },
            --Танец теней (Скрытность)
            [51713] = true
        },
        --Жрец
        {
            --Исчадие Тьмы (Общий)
            [34433] = true,
            --Гимн надежды (Общий)
            [64901] = false,
            --Ментальный крик (Общий)
            [10890] = true,
            --Глубинный ужас (Тьма)
            [64044] = true,
            --Безмолвие (Тьма)
            [15487] = true,
            --Слияние с Тьмой (Тьма)
            [47585] = true,
            --Подавление боли (Послушание)
            [33206] = true,
            --Молитва отчаяния  (Послушание)
            [48172] = true
        },
        --Рыцарь смерти
        {
            --Антимагический панцирь (Общий)
            [48707] = true,
            --Удушение (Общий)
            [47476] = true,
            --Усиление рунического оружия (Общий)
            [47568] = true,
            --Смертельный союз (Общий)
            [48743] = true,
            --Незыблемость льда (Обший)
            [48792] = true,
            --Перерождение (Лед)
            [49039] = true,
            --Ненасытная стужа (Лед)
            [49203] = true,
            --Зона антимагии (Нечестивость)
            [51052] = true,
            --Призыв горгульи (Нечестивость)
            [49206] = true,
            --Истерия
            [49016] = true,
            --Танцующее руническое оружие
            [49028] = true
        },
        --Шаман
        {
            --Жажда крови (Общий)
            [2825] = true,
            --Героизм (Общий)
            [32182] = true,
             --Сглаз (Общий)
            [51514] = true,
            --Тотем каменного когтя (Общий)
            [58582] = true,
            --Ярость шамана (Совершенствование)
            [30823] = true,
            --Дух дикого волка (Совершенствование)
            [51533] = true,
            --Покорение стихий (Стихии)
            [16166] = false,
            --Тотем прилива маны (Исцеление)
            [16190] = true,
            --Природная стремительность (Исцеление)
            [16188] = false
        },
        --Маг
        {
            --Антимагия (Общий)
            [2139] = true,
            --Ледяная глыба (Общий)
            [45438] = true,
            --Прилив сил (Общий)
            [12051] = true,
            --Зеркальное изображение
            [55342] = true,
            --Мощь тайной магии (Тайная магия)
            [12042] = true,
            --Дыхание дракона (Огонь)
            [42950] = true,
            --Возгорание (Огонь)
            [11129] = true,
            --Глубокая заморозка (Лед)
            [44572] = true
        },
        --Чернокнижник
        {
            --Лик смерти (Общий)
            [47860] = true,
            --Вой ужаса (Общий)
            [17928] = true,
            --Демонический круг: телепортация (Общий)
            [48020] = true,
            --Господство Скверны (Демонология)
            [18708] = true,
            --Метаморфоза (Демонология)
            [47241] = true,
            --Неистовство Тьмы (Разрушение)
            [47847] = true,
        },
        --Blizzard sucks
        {},
        --Друид
        {
            --Дубовая кожа (Общий)
            [22812] = true,
            --Оглушить (Общий)
            [8983] = false,
            --Озарение (Общий)
            [29166] = true,
            --Хватка природы (Общий)
            [53312] = true,
            --Звездопад (Баланс)
            [53201] = true,
            --Инстинкты выживания (Сила зверя)
            [61336] = false,
            --Берсерк (Сила зверя)
            [50334] = true,
            --Природная стремительность (Исцеление)
            [17116] = false
        },
    }

    self.Trinkets = {
        [65547] = 120,
        [42292] = 120,
        [59752] = 120,
        [7744] = 45
    }

    self.ClickIconOffset = {
        {'Eye_Normal', 0.21875, 0.7890625, 0.21875, 0.7890625, 18},
        {'Eye_Stroked', 0.21875, 0.7890625, 0.21875, 0.7890625, 18},
        {'Logout', 0.25, 0.7578125, 0.25, 0.7578125, 14},
        {'Refresh', 0.25, 0.7578125, 0.25, 0.7578125, 12}
    }

    self.DebuffList = {
        [0] = 'none',
        [1] = 'magic',
        [2] = 'curse',
        [3] = 'disease',
        [4] = 'poison'
    }

    self.DebuffColor = {
        ['none'] = {r = 0.80, g = 0, b = 0},
        ['magic'] = {r = 0.20, g = 0.60, b = 1.00},
        ['curse'] = {r = 0.60, g = 0.00, b = 1.00},
        ['disease'] = {r = 0.60, g = 0.40, b = 0},
        ['poison'] = {r = 0.00, g = 0.60, b = 0}
    }

    self.CAST_SUCCESS = 99997
    self.CastInfo = {
        --range
        [99995] = {r = 1, g = 1, b = 0, Text = 'Отменено', IsProgressMode = false},
        --los
        [99996] = {r = 1, g = 1, b = 0, Text = 'Отменено', IsProgressMode = false},
        --success
        [self.CAST_SUCCESS] = {r = 0, g = 1, b = 0, Text = 'Успешно', IsProgressMode = false},
        --canceled
        [99998] = {r = 1, g = 1, b = 0, Text = 'Отменено', IsProgressMode = false},
        --interrupt
        [99999] = {r = 1, g = 0, b = 0, Text = 'Прерван!', IsProgressMode = false},
        --casting
        [100000] = {r = 0, g = 1, b = 1, Text = nil, IsProgressMode = true}
    }

    self.PowerInfo = {
        -- mana
        [0] = {r = 0, g = 0.5, b = 1, AnimationStartSpeed = 0, AnimationProgress = 10},
        -- rage
        [1] = {r = 1, g = 0, b = 0, AnimationStartSpeed = 5, AnimationProgress = 1},
        -- energy
        [3] = {r = 1, g = 1, b = 0, AnimationStartSpeed = 5, AnimationProgress = 1},
        -- runic power
        [6] = {r = 0, g = 1, b = 1, AnimationStartSpeed = 5, AnimationProgress = 1}
    }

    self.AuraRootEffect = 1
    self.AuraSilenceEffect = 2
    self.AuraCrowdControlEffect = 3
    self.AuraStunEffect = 4
    self.AuraImmunitylEffect = 5

    self.ControlList = {
        -- Death Knight
        [47481] = self.AuraStunEffect,			-- Gnaw (Ghoul)
        [51209] = self.AuraCrowdControlEffect,	-- Hungering Cold
        [47476] = self.AuraSilenceEffect,		-- Strangulate
        -- Druid
        [8983]  = self.AuraStunEffect,			-- Bash (also Shaman Spirit Wolf ability)
        [33786] = self.AuraStunEffect,			-- Cyclone
        [18658] = self.AuraCrowdControlEffect,	-- Hibernate (works against Druids in most forms and Shamans using Ghost Wolf)
        [49802] = self.AuraStunEffect,			-- Maim
        [49803] = self.AuraStunEffect,			-- Pounce
        [53308] = self.AuraRootEffect,			-- Entangling Roots
        [53313] = self.AuraRootEffect,			-- Entangling Roots (Nature's Grasp)
        [45334] = self.AuraRootEffect,			-- Feral Charge Effect (immobilize with interrupt [spell lockout, not silence])
        -- Hunter
        [60210] = self.AuraCrowdControlEffect,	-- Freezing Arrow Effect
        [14309] = self.AuraCrowdControlEffect,	-- Freezing Trap Effect
        [24394] = self.AuraStunEffect,			-- Intimidation
        [14327] = self.AuraCrowdControlEffect,	-- Scare Beast (works against Druids in most forms and Shamans using Ghost Wolf)
        [19503] = self.AuraCrowdControlEffect,	-- Scatter Shot
        [49012] = self.AuraCrowdControlEffect,	-- Wyvern Sting
        [34490] = self.AuraSilenceEffect,		-- Silencing Shot
        [53359] = self.AuraSilenceEffect,		-- Chimera Shot - Scorpid
        [19306] = self.AuraRootEffect,			-- Counterattack
        [64804] = self.AuraRootEffect,			-- Entrapment
        -- Hunter Pets
        [53568] = self.AuraStunEffect,			-- Sonic Blast (Bat)
        [53543] = self.AuraSilenceEffect,		-- Snatch (Bird of Prey)
        [53548] = self.AuraRootEffect,			-- Pin (Crab)
        [53562] = self.AuraStunEffect,			-- Ravage (Ravager)
        [55509] = self.AuraRootEffect,			-- Venom Web Spray (Silithid)
        [4167]  = self.AuraRootEffect,			-- Web (Spider)
        -- Mage
        [44572] = self.AuraStunEffect,			-- Deep Freeze
        [31661] = self.AuraCrowdControlEffect,	-- Dragon's Breath
        [12355] = self.AuraCrowdControlEffect,	-- Impact
        [12826] = self.AuraCrowdControlEffect,	-- Polymorph
        [55021] = self.AuraSilenceEffect,		-- Silenced - Improved Counterspell
        [64346] = self.AuraSilenceEffect,		-- Fiery Payback
        [33395] = self.AuraRootEffect,			-- Freeze (Water Elemental)
        [42917] = self.AuraRootEffect,			-- Frost Nova
        [12494] = self.AuraRootEffect,			-- Frostbite
        [55080] = self.AuraRootEffect,			-- Shattered Barrier
        -- Paladin
        [10308] = self.AuraStunEffect,			-- Hammer of Justice
        [48817] = self.AuraCrowdControlEffect,	-- Holy Wrath (works against Warlocks using Metamorphasis and Death Knights using Lichborne)
        [20066] = self.AuraCrowdControlEffect,	-- Repentance
        [20170] = self.AuraStunEffect,			-- Stun (Seal of Justice proc)
        [10326] = self.AuraCrowdControlEffect,	-- Turn Evil (works against Warlocks using Metamorphasis and Death Knights using Lichborne)
        [63529] = self.AuraSilenceEffect,		-- Shield of the Templar
        -- Priest
        [605]   = self.AuraCrowdControlEffect,	-- Mind Control
        [64044] = self.AuraStunEffect,			-- Psychic Horror
        [10890] = self.AuraCrowdControlEffect,	-- Psychic Scream
        [10955] = self.AuraCrowdControlEffect,	-- Shackle Undead (works against Death Knights using Lichborne)
        [15487] = self.AuraSilenceEffect,		-- Silence
        [64058] = self.AuraSilenceEffect,		-- Psychic Horror (duplicate debuff names not allowed atm, need to figure out how to support this later)
        -- Rogue
        [2094]  = self.AuraCrowdControlEffect,	-- Blind
        [1833]  = self.AuraStunEffect,			-- Cheap Shot
        [1776]  = self.AuraCrowdControlEffect,	-- Gouge
        [8643]  = self.AuraStunEffect,			-- Kidney Shot
        [51724] = self.AuraCrowdControlEffect,	-- Sap
        [1330]  = self.AuraSilenceEffect,		-- Garrote - Silence
        [18425] = self.AuraSilenceEffect,		-- Silenced - Improved Kick
        [51722] = self.AuraSilenceEffect,		-- Dismantle
        -- Shaman
        [39796] = self.AuraStunEffect,			-- Stoneclaw Stun
        [51514] = self.AuraCrowdControlEffect,	-- Hex (although effectively a silence+disarm effect, it is conventionally thought of as a self.AuraCrowdControlEffect, plus you can trinket out of it)
        [64695] = self.AuraRootEffect,			-- Earthgrab (Storm, Earth and Fire)
        [63685] = self.AuraRootEffect,			-- Freeze (Frozen Power)
        -- Warlock
        [18647] = self.AuraStunEffect,			-- Banish (works against Warlocks using Metamorphasis and Druids using Tree Form)
        [47860] = self.AuraStunEffect,			-- Death Coil
        [6215]  = self.AuraCrowdControlEffect,	-- Fear
        [17928] = self.AuraCrowdControlEffect,	-- Howl of Terror
        [6358]  = self.AuraCrowdControlEffect,	-- Seduction (Succubus)
        [47847] = self.AuraStunEffect,			-- Shadowfury
        [24259] = self.AuraSilenceEffect,		-- Spell Lock (Felhunter)
        -- Warrior
        [7922]  = self.AuraStunEffect,			-- Charge Stun
        [12809] = self.AuraStunEffect,			-- Concussion Blow
        [20253] = self.AuraStunEffect,			-- Intercept (also Warlock Felguard ability)
        [20511] = self.AuraCrowdControlEffect,	-- Intimidating Shout
        [5246]  = self.AuraCrowdControlEffect,	-- Intimidating Shout
        [12798] = self.AuraStunEffect,			-- Revenge Stun
        [46968] = self.AuraStunEffect,			-- Shockwave
        [18498] = self.AuraSilenceEffect,		-- Silenced - Gag Order
        [676]   = self.AuraSilenceEffect,		-- Disarm
        [58373] = self.AuraRootEffect,			-- Glyph of Hamstring
        [23694] = self.AuraRootEffect,			-- Improved Hamstring
        -- Other
        [20549] = self.AuraStunEffect,			-- War Stomp
        [28730] = self.AuraSilenceEffect,		-- Arcane Torrent
        -- Immunities
        [46924] = self.AuraImmunitylEffect,		-- Bladestorm (Warrior)
        [642]   = self.AuraImmunitylEffect,		-- Divine Shield (Paladin)
        [45438] = self.AuraImmunitylEffect,		-- Ice Block (Mage)
        [34471] = self.AuraImmunitylEffect,		-- The Beast Within (Hunter)
        [12051] = self.AuraImmunitylEffect,		-- Evocation (Mage)
        [47585] = self.AuraImmunitylEffect		-- Dispersion (Priest)
    }

    return self
end



function ezSpectator_DataWorker:SafeTexCoord(Value)
    if Value > 1 then
        Value = 1
    end

    if Value < 0 then
        Value = 0
    end

    return Value
end



function ezSpectator_DataWorker:SafeSize(Value)
    --if Value < 0 then
    --    Value = 0
    --end

    return Value
end



function ezSpectator_DataWorker:IsCooldownTracked(Class, Value)
    if self.ClassSpellInfo[Class] then
        return (self.ClassSpellInfo[Class][Value] == true) or (type(self.ClassSpellInfo[Class][Value]) == 'table')
    else
        return false
    end
end