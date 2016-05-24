ezSpectator_DataWorker = {}
ezSpectator_DataWorker.__index = ezSpectator_DataWorker

function ezSpectator_DataWorker:Create()
    local self = {}
    setmetatable(self, ezSpectator_DataWorker)

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
        ['WARRIOR'] = {0, 0.25, 0, 0.25},
        ['MAGE'] = {0.25, 0.49609375, 0, 0.25},
        ['ROGUE'] = {0.49609375, 0.7421875, 0, 0.25},
        ['DRUID'] = {0.7421875, 0.98828125, 0, 0.25},
        ['HUNTER'] = {0, 0.25, 0.25, 0.5},
        ['SHAMAN'] = {0.25, 0.49609375, 0.25, 0.5},
        ['PRIEST'] = {0.49609375, 0.7421875, 0.25, 0.5},
        ['WARLOCK'] = {0.7421875, 0.98828125, 0.25, 0.5},
        ['PALADIN'] = {0, 0.25, 0.5, 0.75},
        ['DEATHKNIGHT'] = {0.25, 0.49609375, 0.5, 0.75},
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
        ['poison'] = {r = 0.00, g = 0.60, b = 0},
    }

    self.CastInfo = {
        --range
        [99995] = {r = 1, g = 1, b = 0, Text = 'Отменено', IsProgressMode = false},
        --los
        [99996] = {r = 1, g = 1, b = 0, Text = 'Отменено', IsProgressMode = false},
        --success
        [99997] = {r = 0, g = 1, b = 0, Text = 'Успешно', IsProgressMode = false},
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
        [6] = {r = 1, g = 1, b = 0, AnimationStartSpeed = 5, AnimationProgress = 1},
    }

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