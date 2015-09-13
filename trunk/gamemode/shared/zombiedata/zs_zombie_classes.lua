-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

----------------------------
-- ZOMBIE CLASSES --
-----------------------------

ZombieClasses = {} -- Leave this.

util.PrecacheSound("npc/zombie/foot1.wav")
util.PrecacheSound("npc/zombie/foot2.wav")
util.PrecacheSound("npc/zombie/foot3.wav")
util.PrecacheSound("npc/zombie/foot_slide1.wav")
util.PrecacheSound("npc/zombie/foot_slide2.wav")
util.PrecacheSound("npc/zombie/foot_slide3.wav")

ZombieClasses[0] =						
{
	Name = "Infected",	
	Tag = "infected",	
	Infliction = 0,
	Revives = true,
	Health = 200,
	MaxHealth = 350,
	Bounty = 100,
	SP = 5,
	Threshold = 0,	
	SWEP = "weapon_zs_undead_infected",			
	JumpPower = 190,
	CanCrouch = true,
	CanGib = true, 
	Model = Model("models/player/zombie_classic.mdl"),
	Speed = 143,
	AngleFix = true,
	Description = "The backbone of the horde.",
	DescriptionGameplay = { "> PRIMARY: Claws", "> SPECIAL: Propkill", "> HEALTH: 200 ", "> SPEED: 143", "> DAMAGE: 24" },
	DescriptionGameplay2 = { "TYPE: Back bone of a horde " },
	PainSounds = {
		Sound("npc/zombie/zombie_pain1.wav"),
		Sound("npc/zombie/zombie_pain2.wav"),
		Sound("npc/zombie/zombie_pain3.wav"),
		Sound("npc/zombie/zombie_pain4.wav"),
		Sound("npc/zombie/zombie_pain5.wav"),
		Sound("npc/zombie/zombie_pain6.wav")

	}, 
	DeathSounds = {
		Sound("npc/zombie/zombie_die1.wav"),
		Sound("npc/zombie/zombie_die2.wav"),
		Sound("npc/zombie/zombie_die3.wav")
	}, 	
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 72) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 39.5)},
	
	PlayerFootstep = false,
	Unlocked = true,
	OnSpawn = function(pl)	
	pl:SetHumanBonePositions()	
		--Force human player model
		if pl.ForcePlayerModel then
			--Reset
			pl.ForcePlayerModel = false

			local status2 = pl:GiveStatus("simple_revive2")
			if status2 then
				status2:SetReviveTime(CurTime() + 2)
				status2:SetReviveDuration(1.37)
				-- status2:SetZombieInitializeTime(CurTime() + 0.1)
			end
			
			--Set model and face
			--pl:SetModel(player_manager.TranslatePlayerModel(pl.PlayerModel))
			--pl:SetRandomFace()		
		end
	end,
	ModelScale = 1
}


InfectedZombiemodels = { 	
"models/player/group03/male_02.mdl",
"models/player/group03/Male_04.mdl",
"models/player/group03/male_06.mdl",
"models/player/group03/male_07.mdl",
"models/player/alyx.mdl",
"models/player/barney.mdl",
"models/player/eli.mdl",
"models/player/mossman.mdl",
"models/player/kleiner.mdl",
"models/player/breen.mdl"
}
--Obsolete class (not removed to prevent gamemode from breaking)
ZombieClasses[1] =		--I re-added this class to add some diversity into the game. We need faster classes				
{
	Name = "Ghoul",
	--Name = "Obsolete",
	Tag = "zombie",	
	Infliction = 0.0,
	Revives = false,
	Health = 100,
	MaxHealth = 140,
	Bounty = 60,
	SP = 4,
	Threshold = 99,	
	SWEP = "weapon_zs_undead_ghoul",	
	JumpPower = 190,
	Unlocked = false,
	Hidden = false,
	CanCrouch = true,
	CanGib = true, 
	Model = table.Random(InfectedZombiemodels), 
	Speed = 140,	
	AngleFix = true,
	DescriptionGameplay = { "> PRIMARY: Claws", "> SECONDARY: Throw flesh","> RELOAD: Create blood spawner on ground", "> FLESH: 10 health to zombies, 5 damage to props and humans", "> CLAW POISON: 10 | 2 per 1.5 seconds", "> HEALTH: 100 ", "> SPEED: 148", "> DAMAGE: 15" },
	DescriptionGameplay2 = { "TYPE: Back bone of a horde! " },
	PainSounds = {
		Sound("npc/zombiegreen/been_shot_1.wav"),
		Sound("npc/zombiegreen/been_shot_2.wav"),
		Sound("npc/zombiegreen/been_shot_3.wav"),
		Sound("npc/zombiegreen/been_shot_4.wav"),
		Sound("npc/zombiegreen/been_shot_5.wav"),
		Sound("npc/zombiegreen/been_shot_6.wav"),
		Sound("npc/zombiegreen/been_shot_7.wav"),
		Sound("npc/zombiegreen/been_shot_8.wav"),
		Sound("npc/zombiegreen/been_shot_9.wav"),
		Sound("npc/zombiegreen/been_shot_10.wav"),
		Sound("npc/zombiegreen/been_shot_11.wav"),
		Sound("npc/zombiegreen/been_shot_12.wav"),
		Sound("npc/zombiegreen/been_shot_13.wav"),
		Sound("npc/zombiegreen/been_shot_14.wav"),
		Sound("npc/zombiegreen/been_shot_15.wav"),
		Sound("npc/zombiegreen/been_shot_16.wav"),
		Sound("npc/zombiegreen/been_shot_17.wav"),
		Sound("npc/zombiegreen/been_shot_18.wav"),
		Sound("npc/zombiegreen/been_shot_19.wav"),
		Sound("npc/zombiegreen/been_shot_20.wav"),
		Sound("npc/zombiegreen/been_shot_21.wav")
	}, 
	DeathSounds = {
		Sound("npc/zombiegreen/death_17.wav"),
		Sound("npc/zombiegreen/death_18.wav"),
		Sound("npc/zombiegreen/death_19.wav"),
		Sound("npc/zombiegreen/death_20.wav"),
		Sound("npc/zombiegreen/death_21.wav"),
		Sound("npc/zombiegreen/death_22.wav"),
		Sound("npc/zombiegreen/death_23.wav"),
		Sound("npc/zombiegreen/death_24.wav"),
		Sound("npc/zombiegreen/death_25.wav"),
		Sound("npc/zombiegreen/death_26.wav"),
		Sound("npc/zombiegreen/death_27.wav"),
		Sound("npc/zombiegreen/death_28.wav"),
		Sound("npc/zombiegreen/death_29.wav"),
		Sound("npc/zombiegreen/death_30.wav"),
		Sound("npc/zombiegreen/death_31.wav"),
		Sound("npc/zombiegreen/death_32.wav"),
		Sound("npc/zombiegreen/death_33.wav"),
		Sound("npc/zombiegreen/death_34.wav"),
		Sound("npc/zombiegreen/death_35.wav")
	}, 	
	IdleSounds = {
		Sound("npc/zombie_poison/pz_alert1.wav"),
		Sound("npc/zombie_poison/pz_alert2.wav"),
		Sound("npc/zombie_poison/pz_idle2.wav"),
		Sound("npc/zombie_poison/pz_idle3.wav"),
		Sound("npc/zombie_poison/pz_idle4.wav"),
	},
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 72) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 39.5)},
	
	Unique = "",
	Description = "Toxin filled supporter.",
	OnSpawn = function(pl)
		pl:SetHumanBonePositions()	
		pl:SetRandomFace()
	end,
	--Unique = "Can be deadly in numbers. Can Propkill.",	
	PlayerFootstep = false,
	-- ModelScale = 0.9
	ModelScale = 1
}

ZombieClasses[2] =
{
	Name = "Poison Zombie",
	Tag = "poisonzombie",
	Infliction = 0.63,
	Health = 400,
	MaxHealth = 600,
	TimeLimit = 810,
	Bounty = 175,
	SP = 8,
	Mass = DEFAULT_MASS * 1.5,
	Threshold = 4,
	JumpPower = 185,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_poisonzombie",
	Model = Model( "models/Zombie/Poison.mdl" ),
	Speed = 150,
	--Description = "A hulking mass of flesh far more durable than any other zombie.",
	Description = "The undead meat shield.",
	OnSpawn = function(pl)
		pl:SetHumanBonePositions()	
	end,
	DescriptionGameplay = { "> PRIMARY: Claws", "> SECONDARY: Throw flesh", "> FLESH: 10 health to zombies, 5 damage to props and humans", "> SPECIAL: Propkill", "> CLAW POISON: 10 | 2 per 1.5 seconds", "> HEALTH: 400 ", "> SPEED: 150", "> DAMAGE: 35" },
	PainSounds = {
		Sound("npc/zombie_poison/pz_pain1.wav"),
		Sound("npc/zombie_poison/pz_pain2.wav"),
		Sound("npc/zombie_poison/pz_pain3.wav")
	},
	IdleSounds = {
		Sound("npc/zombie_poison/pz_alert1.wav"),
		Sound("npc/zombie_poison/pz_alert2.wav"),
		Sound("npc/zombie_poison/pz_idle2.wav"),
		Sound("npc/zombie_poison/pz_idle3.wav"),
		Sound("npc/zombie_poison/pz_idle4.wav"),
	},
	DeathSounds = {
		Sound("npc/zombie_poison/pz_die1.wav"),
		Sound("npc/zombie_poison/pz_die2.wav")
	},
	ViewOffset = Vector(0, 0, 50),
	ModelScale = 1
}

ZombieClasses[3] = 
{
	Name = "Fast Zombie",
	Tag = "fastzombie",
	Infliction =0.5,-- 0.5,
	Health = 135,
	MaxHealth = 200,
	TimeLimit = 160,
	Bounty = 80,
	SP = 4,
	Threshold = 2,
	SWEP = "weapon_zs_undead_fastzombie",
	JumpPower = 190,
	CanCrouch = true,
	CanGib = true,
	AngleFix = true,
	Model = Model("models/Zombie/Fast.mdl"),
	Speed = 285,
	Description = "Skin and bones predator.",
	OnSpawn = function(pl)
		pl:SetHumanBonePositions()	
	end,
	DescriptionGameplay = { "> PRIMARY: Claws", "> SECONDARY: Leap", "> HEALTH: 135 ", "> SPEED: 285", "> DAMAGE: 4"  },
	PainSounds = {
		Sound("mrgreen/undead/fastzombie/pain1.wav"),
		Sound("mrgreen/undead/fastzombie/pain2.wav"),
		Sound("mrgreen/undead/fastzombie/pain3.wav"),
		Sound("mrgreen/undead/fastzombie/pain4.wav"),
		Sound("mrgreen/undead/fastzombie/pain5.wav"),
		Sound("mrgreen/undead/fastzombie/pain6.wav"),
		Sound("mrgreen/undead/fastzombie/pain7.wav"),
		Sound("mrgreen/undead/fastzombie/pain8.wav"),
		Sound("mrgreen/undead/fastzombie/pain9.wav"),
		Sound("mrgreen/undead/fastzombie/pain10.wav"),
		Sound("mrgreen/undead/fastzombie/pain11.wav"),
		Sound("mrgreen/undead/fastzombie/pain12.wav"),
		Sound("mrgreen/undead/fastzombie/pain13.wav"),
		Sound("mrgreen/undead/fastzombie/pain14.wav"),
		Sound("mrgreen/undead/fastzombie/pain15.wav"),
		Sound("mrgreen/undead/fastzombie/pain16.wav"),
	},
	DeathSounds = {
		Sound("mrgreen/undead/fastzombie/death1.wav"),
		Sound("mrgreen/undead/fastzombie/death2.wav"),
		Sound("mrgreen/undead/fastzombie/death3.wav"),
		Sound("mrgreen/undead/fastzombie/death4.wav"),
		Sound("mrgreen/undead/fastzombie/death5.wav")
	},
	PlayerFootstep = true,
	ViewOffset = Vector( 0, 0, 50 ),
	ViewOffsetDucked = Vector( 0, 0, 24 ),
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 58) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)},
	ModelScale = 1
	-- ViewOffset = Vector(0, 0, 0)
}

ZombieClasses[4] =
{
	Name = "Ghast",
	Tag = "etherealzombie",
	Infliction = 0.0,
	Health = 100,
	MaxHealth = 200,
	TimeLimit = 200,
	Bounty = 80,
	SP = 4,
	Threshold = 2,
	JumpPower = 180,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_spitter",
	Model = Model( "models/player/soldier_stripped" ),
	Speed = 185,
	Description = "A ghastly figure which can disguise itself as a human!",
	DescriptionGameplay = {"> PRIMARY: Claws", "> SECONDARY: Disguise as a human!", "> SPECIAL: Ignored by turrets and proximity C4", "> HEALTH: 100 / 150 ", "> SPEED: 145 / 185 ", "> DAMAGE: 20" },
	DescriptionGameplay2 = {"TYPE: Support class for horde"},
	PainSounds = {
		Sound("npc/stalker/stalker_pain1.wav"),
		Sound("npc/stalker/stalker_pain2.wav"),
		Sound("npc/stalker/stalker_pain3.wav"),
		--Sound("npc/stalker/stalker_alert1b.wav"),
		--Sound("npc/stalker/stalker_alert12.wav"),
		--Sound("npc/stalker/stalker_alert13.wav"),
		-- Sound("npc/barnacle/barnacle_pull4.wav")
	},
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 72) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 39.5)},
	DeathSounds = {
		Sound("npc/stalker/stalker_die1.wav"),
		Sound("npc/stalker/stalker_die2.wav")
	},
	OnSpawn = function(pl)
		pl:SetHumanBonePositions()	
		pl:DrawShadow(false)
	end,
	ModelScale = 1
	-- ViewOffset = Vector(0, 0, 0)
}

ZombieClasses[5] =
{
	Name = "Ethereal",
	Tag = "etherealzombie",
	Infliction = 0.0,
	Health = 100,
	MaxHealth = 200,
	TimeLimit = 200,
	Bounty = 80,
	SP = 4,
	Threshold = 2,
	JumpPower = 180,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_wraith",
	Model = Model( "models/wraith.mdl" ),
	Speed = 185,
	Description = "A teleporting apparition",
	DescriptionGameplay = {"> PRIMARY: Hooks", "> SECONDARY: Teleport", "> HEALTH: 100 ", "> SPEED: 185", "> DAMAGE: 33" },
	DescriptionGameplay2 = {"TYPE: Support class for horde"},
	PainSounds = {
		--[[Sound("npc/stalker/stalker_pain1.wav"),
		Sound("npc/stalker/stalker_pain2.wav"),
		Sound("npc/stalker/stalker_pain3.wav"),]]
		--Sound("npc/stalker/stalker_alert1b.wav"),
		--Sound("npc/stalker/stalker_alert12.wav"),
		--Sound("npc/stalker/stalker_alert13.wav"),
		-- Sound("npc/barnacle/barnacle_pull4.wav")
	},
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 72) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 39.5)},	
	DeathSounds = {
		Sound("npc/stalker/wraithdeath1.wav"),
		Sound("npc/stalker/wraithdeath2.wav"),	
		Sound("npc/stalker/wraithdeath3.wav"),
		Sound("npc/stalker/wraithdeath4.wav")
	},
	
	OnSpawn = function(pl)
		pl:SetHumanBonePositions()	
		pl:DrawShadow(false)
	end,
	ModelScale = 1
	-- ViewOffset = Vector(0, 0, 0)
}

ZombieClasses[6] =						
{
	Name = "Howler",
	Tag = "howler",	
	Infliction = 0.25,
	Health = 140,
	MaxHealth = 200,
	TimeLimit = 460,
	Bounty = 80,
	SP = 4,
	Threshold = 4,			
	SWEP = "weapon_zs_undead_howler",			
	JumpPower = 180,
	CanCrouch = true,
	CanGib = true,
	Model = Model("models/player/group01/female_01.mdl"), 
	Speed = 143,						
	Description = "A School girl that screams!",
	DescriptionGameplay = {"> PRIMARY: Girly claws", "> SECONDARY: Disorientating scream", "> HEALTH: 140 ", "> SPEED: 143", "> CLAW DAMAGE: 17", "> HOWL: +3 damage against berserkers" },
	DescriptionGameplay2 = { "TYPE: Support class for horde" },
	PlayerFootstep = true,
	AttackSounds = { 
		Sound("player/zombies/howler/howler_scream_01.wav"),
		Sound("player/zombies/howler/howler_scream_02.wav"),
	},
	PainSounds = { 
		Sound("player/zombies/howler/howler_mad_01.wav" ),
		Sound("player/zombies/howler/howler_mad_02.wav" ),
		Sound("player/zombies/howler/howler_mad_03.wav" ),
		Sound("player/zombies/howler/howler_mad_04.wav" ),
	},
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 72) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 39.5)},	
	DeathSounds = {
		Sound( "player/zombies/howler/howler_death_01.wav" ),
	}, 
	OnSpawn = function(pl)
		pl:SetHumanBonePositions()	
		local status = pl:GiveStatus("overridemodel")
		
		if status and status:IsValid() then
			status:SetModel(Model("models/mrgreen/howler.mdl"))
		end
	end,
	ModelScale = 1
	-- ViewOffset = Vector( 0, 0, 0 )
}

ZombieClasses[7] =
{
	Name = "Headcrab",
	Tag = "headcrab",
	Infliction = 0,
	Health = 50,
	MaxHealth = 100,
	Bounty = 50,
	SP = 4,
	Mass = 25,
	TimeLimit = 130,
	IsHeadcrab = true,
	JumpPower = 100,
	CanCrouch = false,
	CanGib = false,
	StepSize = 8,
	Threshold = 1,
	SWEP = "weapon_zs_undead_headcrab",
	Model = Model("models/headcrabclassic.mdl"),
	Speed = 180,
	Description = "Head Humper! What is this creature!",
	DescriptionGameplay2 = { "TYPE: Support class for horde" },
	OnSpawn = function(pl)
		pl:SetHumanBonePositions()	
	end,
	DescriptionGameplay = { "> PRIMARY: Lunge", "> SPECIAL: Fits through small holes", "> HEALTH: 50 ", "> SPEED: 180", "> DAMAGE: 10" },
	PainSounds = {
		Sound("npc/headcrab/pain1.wav"),
		Sound("npc/headcrab/pain2.wav"),
		Sound("npc/headcrab/pain3.wav")
	},
	DeathSounds = {
		Sound("npc/headcrab/die1.wav"),
		Sound("npc/headcrab/die2.wav")
	},
	ViewOffset = Vector( 0,0,10 ),
	Hull = { Vector(-12, -12, 0), Vector(12, 12, 18.1)},
	ModelScale = 1
}

ZombieClasses[8] =
{
	Name = "Zombine",
	Tag = "zombine",
	Infliction = 0.8,
	Health = 350,
	MaxHealth = 450, 
	TimeLimit = 1020,
	Bounty = 140,
	SP = 7,
	Mass = DEFAULT_MASS * 1.2,
	Threshold = 4,
	JumpPower = 180,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_zombine",
	Model = Model("models/player/zombie_soldier.mdl"),
	--Speed = 160,
	Speed = 150,
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 72) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 39.5)},	
	RunSpeed = 190,
	Description = "A combine that took a turn to the worse.",
	OnSpawn = function(pl)
		pl:SetHumanBonePositions()	
	end,
	DescriptionGameplay = { "> PRIMARY: Claws", "> SECONDARY: Grenade","> RELOAD: Switch between poison and explosive grenades", "> SPECIAL: Enrage when taken enough damage", "> HEALTH: 350 ", "> SPEED: 150 / 190", "> DAMAGE: 30" },
	PainSounds = {
		Sound( "npc/zombine/zombine_pain1.wav" ),
		Sound( "npc/zombine/zombine_pain2.wav" ),
		Sound( "npc/zombine/zombine_pain3.wav" ),
		Sound( "npc/zombine/zombine_pain4.wav" ),
	},
	DeathSounds = {
		Sound("npc/zombine/zombine_die1.wav"),
		Sound("npc/zombine/zombine_die2.wav"),
	},
	IdleSounds = {
		Sound("npc/zombine/zombine_idle1.wav"),
		Sound("npc/zombine/zombine_idle2.wav"),
		Sound("npc/zombine/zombine_idle3.wav"),
		Sound("npc/zombine/zombine_idle4.wav"),
	},
	AlertSounds = {
		Sound ( "npc/zombine/zombine_alert1.wav" ),
		Sound ( "npc/zombine/zombine_alert2.wav" ),
		Sound ( "npc/zombine/zombine_alert3.wav" ),
		Sound ( "npc/zombine/zombine_alert4.wav" ),
		Sound ( "npc/zombine/zombine_alert5.wav" ),
		Sound ( "npc/zombine/zombine_alert6.wav" ),
		Sound ( "npc/zombine/zombine_alert7.wav" ),
	},
	ModelScale = 1
}

ZombieClasses[9] =
{
	Name = "Poison Headcrab",
	Tag = "poisonheadcrab",
	Infliction = 0.63,
	Health = 70,
	MaxHealth = 100,
	Bounty = 60,
	SP = 4,
	Mass = 40,
	StepSize = 8,
	TimeLimit = 780,
	IsHeadcrab = true,
	JumpPower = 150,
	CanCrouch = false,
	CanGib = true,
	AngleFix = true,
	Threshold = 2,
	SWEP = "weapon_zs_undead_poisonheadcrab",
	Model = Model("models/headcrabblack.mdl"),
	Speed = 165,
	Description = "A headcrab that has adapted to secrete toxins.",
	DescriptionGameplay2 = { "TYPE: Support class for horde" },
	OnSpawn = function(pl)
	pl:SetHumanBonePositions()	
	end,
	DescriptionGameplay = { "> PRIMARY RANGED: Lunge", "> PRIMARY CONTACT: Poison Bite", "> SECONDARY: Spit", "> SPECIAL: Fits through small places", "> DEATH: Chance of dropping an unstable toxin", "> HEALTH: 70 ", "> SPEED: 165", "> SPIT DAMAGE: 20","> BITE DAMAGE: 60 | 3 per second"  },
	PainSounds = {
		Sound("npc/headcrab_poison/ph_pain1.wav"),
		Sound("npc/headcrab_poison/ph_pain2.wav"),
		Sound("npc/headcrab_poison/ph_pain3.wav")
	},
	DeathSounds = {
		Sound("npc/headcrab_poison/ph_rattle1.wav"),
		Sound("npc/headcrab_poison/ph_rattle2.wav"),
		Sound("npc/headcrab_poison/ph_rattle3.wav")
	},
	ViewOffset = Vector( 0,0,10 ),
	Hull = { Vector(-12, -12, 0), Vector(12, 12, 18.1) },
	ModelScale = 1
}

ZombieClasses[10] =										
{
	Name = "Hate",	
	Tag = "hate",	
	Infliction = 0,
	Health = 1000,
	MaxHealth = 1200,
	Bounty = 500,
	SP = 200,
	IsBoss = true,
	Mass = DEFAULT_MASS * 2,
	Threshold = 0,	
	SWEP = "weapon_zs_undead_hate",			
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Model = Model("models/Zombie/Classic.mdl"), 
	Speed = 175,
	Hidden = true,	
	AngleFix = true,
	Description = "",
	Unique = "",
	AttackSounds = {
		Sound("player/zombies/hate/chainsaw_attack_miss.wav"),
		Sound("player/zombies/hate/chainsaw_attack_hit.wav"),
	}, 
	PainSounds = {
		Sound("player/zombies/hate/sawrunner_pain1.wav"),
		Sound("player/zombies/hate/sawrunner_pain2.wav"),
	}, 
	DeathSounds = {
		Sound("npc/zombie_poison/pz_die1.wav"),
		Sound("npc/zombie_poison/pz_die2.wav")
	},
	IdleSounds = {
		Sound("player/zombies/hate/sawrunner_alert10.wav"),
		Sound("player/zombies/hate/sawrunner_alert20.wav"),
		Sound("player/zombies/hate/sawrunner_alert30.wav"),
		Sound("player/zombies/hate/sawrunner_attack2.wav"),
	},
	PlayerFootstep = true,
	Unlocked = false,
	-- ViewOffset = Vector( 0, 0, 0 ),
	OnSpawn = function(pl)
		pl:SetBodyPositions()

	local status = pl:GiveStatus("overridemodel")
		if IsValid(status) then
			status:SetModel("models/Zombie/Poison.mdl")
		--	pl:SetBodyPositions()
		end
	
		local status2 = pl:GiveStatus("simple_revive")
		if IsValid(status2) then
			status2:SetReviveTime(CurTime() + 4)
			-- status2:SetZombieInitializeTime(CurTime() + 0.1)
		end
		
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	--ModelScale = 1.5,-- Vector(1.35,1.35,1.35),
--	ViewOffset = Vector(0, 0, 84),
--	ViewOffsetDucked = Vector(0,0,38),
--	Hull = { Vector(-16,-16, 0), Vector(16,16,97) },
--	HullDuck = { Vector(-16,-16, 0), Vector(16,16,69) },
}

ZombieClasses[20] =										
{
	Name = "HateII",	
	Tag = "hate2",	
	Infliction = 0,
	Health = 1000,
	MaxHealth = 1200,
	Bounty = 500,
	SP = 200,
	IsBoss = true,
	Mass = DEFAULT_MASS * 4,
	Threshold = 0,	
	SWEP = "weapon_zs_undead_hate2",			
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Model = Model("models/Zombie/Classic.mdl"), 
	Speed = 175,
	Hidden = true,	
	AngleFix = true,
	Description = "",
	Unique = "",
	AttackSounds = {
		Sound("player/zombies/hate/chainsaw_attack_miss.wav"),
		Sound("player/zombies/hate/chainsaw_attack_hit.wav"),
	}, 
	PainSounds = {
		Sound("player/zombies/hate/sawrunner_pain1.wav"),
		Sound("player/zombies/hate/sawrunner_pain2.wav"),
	}, 
	DeathSounds = {
		Sound("npc/zombie_poison/pz_die1.wav"),
		Sound("npc/zombie_poison/pz_die2.wav")
	},
	IdleSounds = {
		Sound("player/zombies/hate/sawrunner_alert10.wav"),
		Sound("player/zombies/hate/sawrunner_alert20.wav"),
		Sound("player/zombies/hate/sawrunner_alert30.wav"),
		Sound("player/zombies/hate/sawrunner_attack2.wav"),
	},
	PlayerFootstep = true,
	Unlocked = false,
	-- ViewOffset = Vector( 0, 0, 0 ),
	OnSpawn = function(pl)	
			pl:SetBodyPositions()
		local status = pl:GiveStatus("overridemodel")
		if IsValid(status) then
			status:SetModel("models/Zombie/Poison.mdl")
		end
		
		local status2 = pl:GiveStatus("simple_revive")
		if IsValid(status2) then
			status2:SetReviveTime(CurTime() + 4)
			-- status2:SetZombieInitializeTime(CurTime() + 0.1)
		end
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	--ModelScale = 1.5,-- Vector(1.35,1.35,1.35),
	--ViewOffset = Vector(0, 0, 84),
	--ViewOffsetDucked = Vector(0,0,38),
	--Hull = { Vector(-16,-16, 0), Vector(16,16,97) },
	--HullDuck = { Vector(-16,-16, 0), Vector(16,16,69) },
}

ZombieClasses[11] =
{
	Name = "Behemoth",
	Tag = "behemoth",
	Infliction = 0.1,
	Health = 1200,
	MaxHealth = 1200,
	TimeLimit = 1020,
	Bounty = 500,
	SP = 30,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 180,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_behemoth",
	Model = Model("models/player/zombie_soldier.mdl"),
	Speed = 170,
	Description = "",
	Unique = "",
	PainSounds = {
		Sound( "npc/strider/striderx_pain2.wav" ),
		Sound( "npc/strider/striderx_pain5.wav" ),
		Sound( "npc/strider/striderx_pain7.wav" ),
		Sound( "npc/strider/striderx_pain8.wav" ),
	},
	DeathSounds = {
		Sound("npc/strider/striderx_die1.wav"),
	},
	IdleSounds = {
		Sound("npc/zombine/striderx_alert2.wav"),
		Sound("npc/zombine/striderx_alert4.wav"),
		Sound("npc/zombine/striderx_alert5.wav"),
		Sound("npc/zombine/striderx_alert6.wav"),
	},
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 72) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 39.5)},	
	OnSpawn = function(pl)
		local status = pl:GiveStatus("overridemodel")
		if IsValid(status) then
			status:SetModel("models/player/zombie_soldier.mdl")
		end
		
		local status2 = pl:GiveStatus("simple_revive2")
		if IsValid(status2) then
			status2:SetReviveTime(CurTime() + 4)
			status2:SetReviveDuration(3.37)
			-- status2:SetZombieInitializeTime(CurTime() + 0.1)
		end
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	--ModelScale = 1.15,-- Vector(1.15,1.15,1.15),
	--ViewOffset = Vector(0, 0, 73),
	--ViewOffsetDucked = Vector(0,0,32.2),
	--Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	--HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[12] =
{
	Name = "Seeker",
	Tag = "seeker",
	Infliction = 0,
	Health = 6000,
	MaxHealth = 8000,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 1000,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_seeker",
	Model = Model("models/player/corpse1.mdl"),
	Speed = 195,
	Description = "",
	PainSounds = {
		Sound( "player/zombies/seeker/pain1.wav" ),
		Sound( "player/zombies/seeker/pain2.wav" ),
	},
	DeathSounds = {
		Sound("npc/stalker/go_alert2a.wav"),
	},
	IdleSounds = {
		Sound("bot/come_out_and_fight_like_a_man.wav"),
		Sound("bot/come_out_wherever_you_are.wav"),
		Sound("vo/ravenholm/madlaugh03.wav"),
		Sound("vo/NovaProspekt/eli_nevermindme01.wav"),
		Sound("ambient/creatures/town_child_scream1.wav"),
		Sound("npc/zombie_poison/pz_call1.wav"),
	},
	OnSpawn = function(pl)
		local status = pl:GiveStatus("overridemodel")

		if IsValid(status) then
			status:SetModel("models/player/charple01.mdl")
			status:UsePlayerAlpha(true)
		end		
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	ModelScale = 1.15,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[13] =
{
	Name = "Nerf",
	Tag = "nerf",
	Infliction = 0,
	Health = 1200,
	MaxHealth = 1200,
	TimeLimit = 1020,
	Bounty = 300,
	SP = 150,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 300,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_nerf",
	Model = Model("models/Zombie/Fast.mdl"),
	Speed = 190,
	Description = "",
	Unique = "",
	PainSounds = {
		--Sound("npc/antlion_guard/growl_high.wav"),

	},
	DeathSounds = {
		Sound("npc/antlion_guard/antlion_guard_die1.wav"),
		Sound("npc/antlion_guard/antlion_guard_die2.wav"),
	},
	IdleSounds = {},
	OnSpawn = function(pl)
		pl:SetBodyPositions()
		--pl:SetNerfBodyPositions()
		local status = pl:GiveStatus("overridemodel")
		if IsValid(status) then
			status:SetModel(Model("models/Zombie/Fast.mdl"))
		end		
	end,
	OnRevive = function(pl)
	end,
	ModelScale = 0.85,
	--ViewOffset = Vector( 0, 0, 50 ),
	--ViewOffsetDucked = Vector( 0, 0, 24 ),
	--Hull = { Vector(-16, -16, 0), Vector(16, 16, 58) },
	--HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
}

ZombieClasses[14] =
{
	Name = "Burner",
	Tag = "burner",
	Infliction = 0,
	Health = 1000,
	MaxHealth = 8100,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 1000,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_burner",
	Model = Model("models/zombie/zombie_soldier.mdl"),
	Speed = 187,
	Description = "",
	Unique = "",
	PainSounds = {
		Sound( "npc/strider/striderx_pain2.wav" ),
		Sound( "npc/strider/striderx_pain5.wav" ),
		Sound( "npc/strider/striderx_pain7.wav" ),
		Sound( "npc/strider/striderx_pain8.wav" ),
	},
	DeathSounds = {
		Sound("npc/strider/striderx_die1.wav"),
	},
	IdleSounds = {
		Sound("npc/zombine/striderx_alert2.wav"),
		Sound("npc/zombine/striderx_alert4.wav"),
		Sound("npc/zombine/striderx_alert5.wav"),
		Sound("npc/zombine/striderx_alert6.wav"),
	},
	OnSpawn = function(pl)
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)	
	end,
	ModelScale = 1.15,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	--Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	--HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[15] = --Everyone loves it ^^ Duby: R.I.P until you are loved once more! :<
{
	Name = "Rameil",
	Tag = "rameil",
	Infliction = 0,
	Health = 6500,
	MaxHealth = 8100,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 100,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 170,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_rameil",
	Model = Model("models/player/corpse1.mdl"), 
	OnSpawn = function(pl)
		local Bone = pl:LookupBone("ValveBiped.Bip01_Spine4")
		if Bone then
			--pl:ManipulateBoneAngles( Bone, Angle(30,95,-190)  )
			pl:ManipulateBoneScale( Bone, Vector(1,1,1)  )
		end

		local Bone = pl:LookupBone("ValveBiped.Bip01_L_UpperArm")
		if Bone then
			pl:ManipulateBoneAngles( Bone, Angle(0,0,0)  )
		end

		local Bone = pl:LookupBone("ValveBiped.Bip01_Spine1")
		if Bone then
		 	 pl:ManipulateBoneAngles( Bone, Angle(0,40,0)  )
		end

		local Bone = pl:LookupBone("ValveBiped.Bip01_Spine2")
		if Bone then
			pl:ManipulateBoneAngles( Bone, Angle(0,10,0)  )
		end

		local Bone = pl:LookupBone("ValveBiped.Bip01_Head1")
		if Bone then
			pl:ManipulateBoneAngles( Bone, Angle(0,-40,0)  )
		end
	end,
	Speed = 120,
	Description = "",
	Unique = "",
	PainSounds = {
		Sound( "npc/strider/striderx_pain2.wav" ),
		Sound( "npc/strider/striderx_pain5.wav" ),
		Sound( "npc/strider/striderx_pain7.wav" ),
		Sound( "npc/strider/striderx_pain8.wav" ),
	},
	DeathSounds = {
		Sound("npc/strider/striderx_die1.wav"),
	},
	IdleSounds = {
		Sound("npc/zombine/striderx_alert2.wav"),
		Sound("npc/zombine/striderx_alert4.wav"),
		Sound("npc/zombine/striderx_alert5.wav"),
		Sound("npc/zombine/striderx_alert6.wav"),
	},
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	ModelScale = 1,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	--Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	--HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[16] = --Wife of Adam and deemed to stay in hell for eternity. 
{
	Name = "Lilith",
	Tag = "lilith",
	Infliction = 0,
	Health = 800,
	MaxHealth = 1200,
	TimeLimit = 1020,
	Bounty = 500,
	SP = 100,
	Mass = DEFAULT_MASS * 3,
	Threshold = 4,
	JumpPower = 180,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_lilith",
	Model = Model("models/player/corpse1.mdl"), 
	OnSpawn = function(pl)		
	end,
	Speed = 189,
	Description = "",
	Unique = "",
	PainSounds = {
		Sound( "player/zombies/seeker/pain1.wav" ),
		Sound( "player/zombies/seeker/pain2.wav" ),
	},
	DeathSounds = {
		Sound("npc/stalker/go_alert2a.wav"),
	},
	IdleSounds = {
		Sound("bot/come_out_and_fight_like_a_man.wav"),
		Sound("bot/come_out_wherever_you_are.wav"),
		Sound("vo/ravenholm/madlaugh03.wav"),
		Sound("vo/NovaProspekt/eli_nevermindme01.wav"),
		Sound("ambient/creatures/town_child_scream1.wav"),
		Sound("npc/zombie_poison/pz_call1.wav"),
	},
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	ModelScale = 1,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[17] = --Smoke shit up :P
{
	Name = "Smoker",
	Tag = "weapon_zs_undead_vomiter",
	Infliction = 0.2,
	Health = 4000,
	MaxHealth = 8100,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 50,
	Mass = DEFAULT_MASS * 8,
	Threshold = 4,
	JumpPower = 170,
	CanCrouch = true,
	CanGib = true,
	Unlocked = true,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_vomiter",
	Model = Model("models/zombie/zombie_soldier.mdl"), 
	Speed = 170,
	Description = "Uses smoke to blind humans for the horde to commence its attack!",
	Unique = "",
	PainSounds = {
		Sound( "npc/zombine/zombine_pain1.wav" ),
		Sound( "npc/zombine/zombine_pain2.wav" ),
		Sound( "npc/zombine/zombine_pain3.wav" ),
		Sound( "npc/zombine/zombine_pain4.wav" ),
	},
	OnSpawn = function(pl)
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	--[[PainSounds = {
		Sound( "npc/strider/striderx_pain2.wav" ),
		Sound( "npc/strider/striderx_pain5.wav" ),
		Sound( "npc/strider/striderx_pain7.wav" ),
		Sound( "npc/strider/striderx_pain8.wav" ),
	},]]
	DeathSounds = {
		Sound("npc/strider/striderx_die1.wav"),
	},
	IdleSounds = {
		Sound("npc/zombine/striderx_alert2.wav"),
		Sound("npc/zombine/striderx_alert4.wav"),
		Sound("npc/zombine/striderx_alert5.wav"),
		Sound("npc/zombine/striderx_alert6.wav"),
	},		
	ModelScale = 1.10,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	--Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	--HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}


ZombieClasses[18] = --Creep and Play!
{
	Name = "Seeker",
	Tag = "weapon_zs_undead_boss_seeker2",
	Infliction = 0.2,
	Health = 800,
	MaxHealth = 800,
	TimeLimit = 1020,
	Bounty = 500,
	SP = 100,
	Mass = DEFAULT_MASS * 8,
	Threshold = 4,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Unlocked = true,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_seeker2",
	Model = Model("models/player/corpse1.mdl"), 
	Speed = 149,
	Description = "An experiment gone wrong, and its now out hunting the elite!",
	Unique = "",
	OnSpawn = function(pl)	
		pl:SetRenderMode(RENDERMODE_GLOW)
		pl:SetColor(Color(1,1,1,2))
		pl:SetModel("models/player/charple.mdl")
		
		--Bend him over a bit....
		local Bone = pl:LookupBone("ValveBiped.Bip01_Spine1")
		if Bone then
		 	pl:ManipulateBoneAngles(Bone, Angle(0,40,0))
		end	
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	PainSounds = {
		Sound( "player/zombies/seeker/pain1.wav" ),
		Sound( "player/zombies/seeker/pain2.wav" ),
	},
	DeathSounds = {
		Sound("npc/stalker/go_alert2a.wav"),
	},
	IdleSounds = {
		Sound("bot/come_out_and_fight_like_a_man.wav"),
		Sound("bot/come_out_wherever_you_are.wav"),
		Sound("vo/ravenholm/madlaugh03.wav"),
		Sound("vo/NovaProspekt/eli_nevermindme01.wav"),
		Sound("ambient/creatures/town_child_scream1.wav"),
		Sound("npc/zombie_poison/pz_call1.wav"),
	},
	ModelScale = 1,-- Vector(1.15,1.15,1.15),

}

ZombieClasses[19] = 
{
	Name = "PUMPKING",
	Tag = "weapon_zs_undead_boss_pumpking",
	Infliction = 0.7,
	Health = math.random(5000, 5500 ),
	MaxHealth = 8100,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 0,
	Mass = DEFAULT_MASS * 9,
	Threshold = 4,
	JumpPower = 180,
	CanCrouch = true,
	CanGib = true,
	Unlocked = true,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_pumpking",
	Model = Model("models/Zombie/Poison.mdl"), 
	Speed = 170,
	Description = "A hellish Being!",
	Unique = "",
	OnSpawn = function(pl)	
		pl:SetRenderMode(RENDERMODE_GLOW)
		pl:SetColor(Color(239,128,31,150))
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	--[[PainSounds = {
		Sound( "npc/strider/striderx_pain2.wav" ),
		Sound( "npc/strider/striderx_pain5.wav" ),
		Sound( "npc/strider/striderx_pain7.wav" ),
		Sound( "npc/strider/striderx_pain8.wav" ),
	},]]
	DeathSounds = {
		Sound("npc/barnacle/neck_snap1.wav"),
		Sound("player/zombies/b/scream.wav"),
	},
	IdleSounds = {
		Sound("npc/zombine/striderx_alert2.wav"),
		Sound("npc/zombine/striderx_alert4.wav"),
		Sound("npc/zombine/striderx_alert5.wav"),
		Sound("npc/zombine/striderx_alert6.wav"),
	},
	ModelScale = 1.2,-- Vector(1.15,1.15,1.15),
}