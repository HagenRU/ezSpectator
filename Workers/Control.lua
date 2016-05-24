ezSpectator_ControlWorker = {}
ezSpectator_ControlWorker.__index = ezSpectator_ControlWorker

function ezSpectator_ControlWorker:Create()
	local self = {}
	setmetatable(self, ezSpectator_ControlWorker)
	
	self.ControlIcon = nil
	self.Class = nil
	
	self.CurrentAura = nil
	self.CurrentAuraLevel = -1
	self.IsAnimated = false
	
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
	
	self.ClassIcons = {
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
	
	self.UpdateFrame = CreateFrame('Frame', nil, nil)
	self.UpdateFrame.Parent = self
	self.UpdateFrame.ElapsedTick = 0
	self.UpdateFrame.UpdateTick = 0.5
	self.UpdateFrame.IsRising = false
	self.UpdateFrame.CurrentAlpha = 1
	self.UpdateFrame:SetScript('OnUpdate', function(self, Elapsed)
		self.ElapsedTick = self.ElapsedTick + Elapsed
		
		if self.ElapsedTick > self.UpdateTick then
			self.ElapsedTick = 0
			self.UpdateTick = 0.01
			
			if self.Parent.IsAnimated and self.Parent.ControlIcon and self.Parent.ControlIcon.Backdrop:IsShown() then
				if self.IsRising == true then
					self.CurrentAlpha = self.CurrentAlpha - 0.07
					if self.CurrentAlpha < 0.2 then 
						self.IsRising = false 
					end
				else
					self.CurrentAlpha = self.CurrentAlpha + 0.07
					if self.CurrentAlpha > 1 then 
						self.IsRising = true 
					end
				end
				
				self.Parent.ControlIcon.Icon:SetAlpha(self.CurrentAlpha)
			end
		end
	end)
	
	return self
end



function ezSpectator_ControlWorker:BindIcon(IconClass)
	self.ControlIcon = IconClass
end



function ezSpectator_ControlWorker:SetClass(Class)
	self.CurrentAuraLevel = -1
	
	if Class then
		self.Class = Class
	end
	
	if self.Class then
		local ClassText = nil
		if self.Class == 1 then
			ClassText = 'WARRIOR'
		elseif self.Class == 2 then
			ClassText = 'PALADIN'
		elseif self.Class == 3 then
			ClassText = 'HUNTER'
		elseif self.Class == 4 then
			ClassText = 'ROGUE'
		elseif self.Class == 5 then
			ClassText = 'PRIEST'
		elseif self.Class == 6 then 
			ClassText = 'DEATHKNIGHT'
		elseif self.Class == 7 then
			ClassText = 'SHAMAN'
		elseif self.Class == 8 then
			ClassText = 'MAGE'
		elseif self.Class == 9 then
			ClassText = 'WARLOCK'
		elseif self.Class == 11 then
			ClassText = 'DRUID'
		end
		
		local OffsetTable = self.ClassIcons[ClassText]
		if OffsetTable then
			self.ControlIcon:SetTexture('Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes', 17, false)
			local Left, Right, Top, Bottom = unpack(OffsetTable)
			Left = Left + (Right - Left) * 0.08
			Right = Right - (Right - Left) * 0.08
			Top = Top + (Bottom - Top) * 0.08
			Bottom = Bottom - (Bottom - Top) * 0.08
			
			self.ControlIcon.Icon.texture:SetTexCoord(Left, Right, Top, Bottom)
		end
	else
		return
	end
end



function ezSpectator_ControlWorker:Update(AuraFrame)
	local IsAuraFound = false
	for _, AuraRecord in pairs(AuraFrame.AuraStack) do
		if self.ControlList[AuraRecord.Spell] ~= nil then
			if self.ControlList[AuraRecord.Spell] >= self.CurrentAuraLevel then
				IsAuraFound = true
				
				self.CurrentAura = AuraRecord
				self.CurrentAuraLevel = self.ControlList[AuraRecord.Spell]
			end
		end
	end
	
	if IsAuraFound then
		local _, _, AuraTexture = GetSpellInfo(self.CurrentAura.Spell)
		self.ControlIcon:SetTexture(AuraTexture, 17, true)
		self:DoAnimate(true)
	else
		self:SetClass(nil)
		self:DoAnimate(false)
	end
end



function ezSpectator_ControlWorker:DoAnimate(Value)
	if not self.IsAnimated and Value then
		self.UpdateFrame.UpdateTick = 0.5
		self.UpdateFrame.IsRising = false
		self.UpdateFrame.CurrentAlpha = 1
		
		if self.ControlIcon.Backdrop:IsShown() then
			self.ControlIcon:SetCooldown(0, 0)
		end
	end
	
	self.IsAnimated = Value
	if not Value then
		self.ControlIcon.Icon:SetAlpha(1)
	end
end