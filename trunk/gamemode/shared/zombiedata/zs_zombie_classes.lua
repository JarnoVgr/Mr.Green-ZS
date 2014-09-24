-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--File optimization by Duby

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
	Revives = false,
	Health = 220,
	MaxHealth = 350,
	Bounty = 80,
	SP = 30,
	Threshold = 0,	
	SWEP = "weapon_zs_undead_infected",			
	JumpPower = 200,
	--JumpPower = 190,
	CanCrouch = true,
	CanGib = true,
	--Model = Model("models/player/group01/male_09.mdl"), 
	Model = Model("models/player/zombie_classic.mdl"),
	--Speed = 173,
	Speed = 160,
	Description = "The backbone of the horde.",
	DescriptionGameplay = { "> PRIMARY: Claws", "> SPECIAL: Propkill" },
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
	PlayerFootstep = false,
	Unlocked = true,
	OnSpawn = function(pl)
	--Duby: This is required as the spitter will mess up the model :P Need to fix this properly.
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	
		--Force human player model
		if pl.ForcePlayerModel then
			--Reset
			pl.ForcePlayerModel = false

			--Set model and face
			pl:SetModel(player_manager.TranslatePlayerModel(pl.PlayerModel))
			pl:SetRandomFace()
		end
	end,
	-- ModelScale = Vector(1.35,1.35,1.35),
}


--Obsolete class (not removed to prevent gamemode from breaking)
ZombieClasses[1] =						
{
	Name = "Ghouler",
	Tag = "zombie",	
	Infliction = 0,
	Revives = false,
	Health = 120,
	MaxHealth = 120,
	Bounty = 100,
	SP = 15,
	Threshold = 99,	
	SWEP = "weapon_zs_undead_ghoul",			
	JumpPower = 200,
	Unlocked = false,
	--Hidden = true,
	CanCrouch = true,
	CanGib = true,
	Model = Model("models/player/corpse1.mdl"), 
	--Model = Model("models/Zombie/Poison.mdl"), 
	Speed = 195,	
	AngleFix = true,
	Description = "A fast and deadly zombie in numbers",
	DescriptionGameplay = { "> PRIMARY: Claws", "> SECONDARY: Fast Attack" },
	PainSounds = {
				Sound("npc/zombie/zombie_pain1.wav"),
				Sound("npc/zombie/zombie_pain2.wav"),
				Sound("npc/zombie/zombie_pain3.wav"),
				Sound("npc/zombie/zombie_pain4.wav"),
				Sound("npc/zombie/zombie_pain5.wav"),
				Sound("npc/zombie/zombie_pain6.wav"),
				
				}, 
	DeathSounds = {
				Sound("npc/zombie/zombie_die1.wav"),
				Sound("npc/zombie/zombie_die2.wav"),
				Sound("npc/zombie/zombie_die3.wav"),
				
				}, 	
	Unique = "",
	Description = "The support of the horde! ",
	OnSpawn = function(pl)
			if pl:Team() == TEAM_UNDEAD and pl:GetZombieClass() == 1 then
	--pl:ManipulateBonePosition(math.Rand(1, 15) , Vector( math.Rand( 5, 5), math.Rand( 5, 5), math.Rand( 1, 5)) )
		
		--Duby: This is required as the spitter will mess up the model :P Need to fix this properly.
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
		
		
		local b = pl:LookupBone("ValveBiped.Bip01_Head1")
	pl:ManipulateBonePosition( b, Vector(-1,1.5,-1)) 
	
		local d = pl:LookupBone("ValveBiped.Bip01_R_Foot")
	pl:ManipulateBonePosition( d, Vector(1,2,3))
	
		--local e = pl:LookupBone("ValveBiped.Bip01_L_Foot")
	--pl:ManipulateBonePosition( e, Vector(1,-10,3))
	
		local f = pl:LookupBone("ValveBiped.Bip01_R_Hand")
	pl:ManipulateBonePosition( f, Vector(1,5,1))
	
		local g = pl:LookupBone("ValveBiped.Bip01_L_Hand")
	pl:ManipulateBonePosition( g, Vector(1,-5,5))
	
		local h = pl:LookupBone("ValveBiped.Bip01_Spine4")
	pl:ManipulateBonePosition( h, Vector(1,5,1))
	
		local i = pl:LookupBone("ValveBiped.Bip01_Spine2")
	pl:ManipulateBonePosition( i, Vector(1,1,1))
		
		else
			return
				end
	end,
	--Unique = "Can be deadly in numbers. Can Propkill.",	
	PlayerFootstep = false,
	-- ModelScale = 0.9
}

ZombieClasses[2] = 
{
	Name = "Fast Zombie",
	Tag = "fastzombie",
	Infliction = 0.4,
	Health = 100,
	MaxHealth = 150,
	TimeLimit = 300,
	Bounty = 80,
	SP = 20,
	Threshold = 2,
	SWEP = "weapon_zs_undead_fastzombie",
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	AngleFix = true,
	Model = Model("models/Zombie/Fast.mdl"),
	Speed = 245,
	Description = "Skin and bones predator.",
	OnSpawn = function(pl)
	--Duby: This is required as the spitter will mess up the model :P Need to fix this properly.
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	end,
	DescriptionGameplay = { "> PRIMARY: Claws", "> SECONDARY: Leap" },
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
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
	-- ViewOffset = Vector(0, 0, 0)
}

ZombieClasses[3] =
{
	Name = "Poison Zombie",
	Tag = "poisonzombie",
	Infliction = 0.55,
	--Health = 400,
	Health = 650,
	MaxHealth = 650,
	TimeLimit = 810,
	Bounty = 130,
	SP = 40,
	Mass = DEFAULT_MASS * 1.5,
	Threshold = 4,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_poisonzombie",
	Model = Model( "models/Zombie/Poison.mdl" ),
	Speed = 195,
	Description = "A hulking mass of flesh far more durable than any other zombie.",
		OnSpawn = function(pl)
	--Duby: This is required as the spitter will mess up the model :P Need to fix this properly.
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	end,
	DescriptionGameplay = { "> PRIMARY: Claws", "> SECONDARY: Throw flesh", "> SPECIAL: Propkill" },
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
	-- ViewOffset = Vector( 0, 0, 0 ),
	
	  ViewOffset = Vector( 0,0,50 )

}

ZombieClasses[4] =
{
	Name = "Ethereal",
	Tag = "etherealzombie",
	Infliction = 0.3,
	Health = 110,
	MaxHealth = 100,
	TimeLimit = 200,
	Bounty = 60,
	SP = 20,
	Threshold = 2,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_wraith",
	Model = Model( "models/wraith.mdl" ),
	Speed = 170,
	Description = "A ghastly figure capable of disguising as a fellow human.",
	DescriptionGameplay = { "> PRIMARY: Claws", "> SECONDARY: Disguise" },
	PainSounds = {
				--Sound("npc/stalker/stalker_pain1.wav"),
				--Sound("npc/stalker/stalker_pain2.wav"),
				--Sound("npc/stalker/stalker_pain3.wav"),
				Sound("npc/stalker/stalker_alert1b.wav"),
				Sound("npc/stalker/stalker_alert12.wav"),
				Sound("npc/stalker/stalker_alert13.wav"),
				-- Sound("npc/barnacle/barnacle_pull4.wav")
				},
	DeathSounds = {
				Sound("npc/stalker/stalker_die1.wav"),
				Sound("npc/stalker/stalker_die2.wav"),
				 Sound("wraithdeath3.wav"),
				 Sound("wraithdeath4.wav")
				},
	OnSpawn = function(pl)	
	pl:SetRenderMode(RENDERMODE_GLOW) pl:SetColor(Color(1,1,1,2))
		--Duby: This is required as the spitter will mess up the model :P Need to fix this properly.
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	
	end,
	-- ViewOffset = Vector(0, 0, 0)
}

util.PrecacheModel("models/mrgreen/howler.mdl")
ZombieClasses[5] =						
{
	Name = "Howler",
	Tag = "howler",	
	Infliction = 0.3,
	Health = 120,
	MaxHealth = 120,
	TimeLimit = 460,
	Bounty = 70,
	SP = 20,
	Threshold = 4,			
	SWEP = "weapon_zs_undead_howler",			
	JumpPower = 200,
	CanCrouch = true,
	CanGib = false,
	Model = Model("models/player/group01/female_01.mdl"), 
	--Model = Model( "models/mrgreen/howler.mdl" ),
	Speed = 180,						
	Description = "Schoolgirl that can scream so loud she can pull or push people.",
	DescriptionGameplay = { "> PRIMARY: Pulling Scream", "> SECONDARY: Pushing Scream" },
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
	DeathSounds = {
				Sound( "player/zombies/howler/howler_death_01.wav" ),
				}, 
	OnSpawn = function(pl)
			--Duby: This is required as the spitter will mess up the model :P Need to fix this properly.
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	
		--pl:SetModel("models/player/group01/female_01.mdl")
	
		local status = pl:GiveStatus("overridemodel")
		
		if status and status:IsValid() then
			status:SetModel("models/mrgreen/howler.mdl")
		end
	end,
	-- ViewOffset = Vector( 0, 0, 0 )
}

ZombieClasses[6] =
{
	Name = "Headcrab",
	Tag = "headcrab",
	Infliction = 0,
	Health = 40,
	MaxHealth = 80,
	Bounty = 50,
	SP = 10,
	Mass = 25,
	TimeLimit = 130,
	IsHeadcrab = true,
	JumpPower = 200,
	CanCrouch = false,
	CanGib = false,
	Threshold = 1,
	SWEP = "weapon_zs_undead_headcrab",
	Model = Model("models/headcrabclassic.mdl"),
	Speed = 190,
	Description = "Head Humper! Nobody knows where this creature came from.",
		OnSpawn = function(pl)
	--Duby: This is required as the spitter will mess up the model :P Need to fix this properly.
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	end,
	DescriptionGameplay = { "> PRIMARY: Lunge", "> SPECIAL: Fits through small holes" },
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
	Hull = { Vector(-12, -12, 0), Vector(12, 12, 18.1)}
}

ZombieClasses[7] =
{
	Name = "Poison Headcrab",
	Tag = "poisonheadcrab",
	Infliction = 0.4,
	Health = 70,
	MaxHealth = 100,
	Bounty = 70,
	SP = 12,
	Mass = 40,
	StepSize = 8,
	TimeLimit = 780,
	IsHeadcrab = true,
	JumpPower = 0,
	CanCrouch = false,
	CanGib = false,
	AngleFix = true,
	Threshold = 2,
	SWEP = "weapon_zs_undead_poisonheadcrab",
	Model = Model("models/headcrabblack.mdl"),
	Speed = 140,
	Description = "A headcrab that has evolved spit poison balls over dangerous distances.",
		OnSpawn = function(pl)
	--Duby: This is required as the spitter will mess up the model :P Need to fix this properly.
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	end,
	DescriptionGameplay = { "> PRIMARY: Spit", "> SPECIAL: Fits through small places", "> DEATH: Chance of dropping a Poison Bomb" },
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
	Hull = { Vector(-12, -12, 0), Vector(12, 12, 18.1) }
}

ZombieClasses[8] =
{
	Name = "Zombine",
	Tag = "zombine",
	Infliction = 0.75,
	Health = 350,
	MaxHealth = 320, 
	TimeLimit = 1020,
	Bounty = 150,
	SP = 35,
	Mass = DEFAULT_MASS * 1.2,
	Threshold = 4,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_zombine",
	Model = Model("models/zombie/zombie_soldier.mdl"),
	Speed = 160,
	RunSpeed = 190,
	Description = "A heavily armoured soldier that has taken a turn for the worst.",
		OnSpawn = function(pl)
	--Duby: This is required as the spitter will mess up the model :P Need to fix this properly.
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	end,
	DescriptionGameplay = { "> PRIMARY: Upgraded Bloody CLAWS", "> SPECIAL: Pulls out grenade, poison or normal", "> SPECIAL: Enrage when taken enough damage" },
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
}

--[[
ZombieClasses[9] =
{
	Name = "Crow",
	Health = 30,
	Infliction = 0,
	Tag = "crow",
	Bounty = 1,
	SP = 1,
	Mass = 2,
	Threshold = 0,
	CanGib = true,
	CanCrouch = false,
	SWEP = "weapon_zs_crow",
	Model = Model("models/crow.mdl"),
	Speed = 60,
	RunSpeed = 125,
	Description = "Use this Infected crow to sneak up humans.",
	PainSounds = {
				Sound("npc/crow/pain1.wav"),
				Sound("npc/crow/pain2.wav")
				},
	DeathSounds = {
				Sound("npc/crow/die1.wav"),
				Sound("npc/crow/die2.wav")
				},
	ViewOffset = Vector(0,0,8),
	Hull = { Vector(-5,-5, 0), Vector(5,5,5) },
	NoPhysics = true,
	Hidden = true
}


]]--


ZombieClasses[9] = --Duby: You will all love my labs new creation. 
{
	Name = "Spitter",
	Tag = "spitterzombie",
	Infliction = 0.45,
	Health = 130,
	MaxHealth = 100,
	TimeLimit = 200,
	Bounty = 60,
	SP = 20,
	Threshold = 2,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	SWEP = "weapon_zs_undead_spitter",
	Model = Model( "models/Zombie/Poison.mdl" ),
	Speed = 140,
	Description = "A flesh spitting monster!",
	DescriptionGameplay = { "> PRIMARY: Fresh Vomit!", "> SECONDARY: " },
	PainSounds = {
				Sound("npc/zombie_poison/pz_pain1.wav"),
				Sound("npc/zombie_poison/pz_pain2.wav"),
				Sound("npc/zombie_poison/pz_pain3.wav")
				},
	DeathSounds = {
				Sound("npc/zombie_poison/pz_die1.wav"),
				Sound("npc/zombie_poison/pz_die2.wav")
				},
	OnSpawn = function(pl)	
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 5, 5), math.Rand( 11, 5)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 8, 5), math.Rand( -10, -10), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 8, 5), math.Rand( 0, 0), math.Rand( -10, -10)) )	--hand left
	

	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 8, 5), math.Rand( 0, 0), math.Rand( -10, -10)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 5, 5), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 8, 5), math.Rand( 5, 5), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 8, 5), math.Rand( 0, 0), math.Rand( -10, -10)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 8, 5), math.Rand( 0, 0), math.Rand( -10, -10)) )	--hand right

	end,
	-- ViewOffset = Vector(0, 0, 0)
}

ZombieClasses[10] =										
{
	Name = "Hate",	
	Tag = "hate",	
	Infliction = 0,
	Health = 11000,
	MaxHealth = 10000,
	Bounty = 1000,
	SP = 150,
	IsBoss = true,
	Mass = DEFAULT_MASS * 2,
	Threshold = 0,	
	SWEP = "weapon_zs_undead_hate",			
	JumpPower = 220,
	CanCrouch = true,
	CanGib = true,
	Model = Model("models/Zombie/Classic.mdl"), 
	Speed = 185,
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
		-- if not pl.Revive then
			local status = pl:GiveStatus("overridemodel")
		
			if status and status:IsValid() then
				status:SetModel("models/Zombie/Poison.mdl")
			end
		-- end

		
		local status2 = pl:GiveStatus("simple_revive")
		if status2 then
			status2:SetReviveTime(CurTime() + 4)
			-- status2:SetZombieInitializeTime(CurTime() + 0.1)
		end
	

	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		
	end,
	ModelScale = 1.35,-- Vector(1.35,1.35,1.35),
	ViewOffset = Vector(0, 0, 84),
	ViewOffsetDucked = Vector(0,0,38),
	--Hull = { Vector(-21,-21, 0), Vector(21,21,97) },
	Hull = { Vector(-16,-16, 0), Vector(16,16,97) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,69) },
}

ZombieClasses[11] =
{
	Name = "Behemoth",
	Tag = "behemoth",
	Infliction = 0.1,
	Health = 10000,
	MaxHealth = 4000,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 350,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 200,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_behemoth",
	Model = Model("models/zombie/Zombie_Soldier.mdl"),
	Speed = 160,
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
		local status = pl:GiveStatus("overridemodel")
		
		if status and status:IsValid() then
			status:SetModel("models/zombie/Zombie_Soldier.mdl")
		end
	
	
		local status2 = pl:GiveStatus("simple_revive2")
		if status2 then
			status2:SetReviveTime(CurTime() + 4)
			status2:SetReviveDuration(3.37)
			-- status2:SetZombieInitializeTime(CurTime() + 0.1)
		end
		
	end,
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	ModelScale = 1.15,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	-- Hull = { Vector(-18,-18, 0), Vector(18,18,83) },
	Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[12] =
{
	Name = "Seeker",
	Tag = "seeker",
	Infliction = 0,
	Health = 8000,
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

		if status and status:IsValid() then
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
	Health = 10000,
	MaxHealth = 7000,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 100,
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
	Speed = 195,
	Description = "",
	Unique = "",
	PainSounds = {
				Sound("npc/fast_zombie/leap1.wav"),
				Sound("npc/fast_zombie/wake1.wav")
				},
	DeathSounds = {
				Sound("npc/antlion_guard/antlion_guard_die1.wav"),
				Sound("npc/antlion_guard/antlion_guard_die2.wav"),
				},
	IdleSounds = {

				},
	OnSpawn = function(pl)
		local status = pl:GiveStatus("overridemodel")
		
		if status and status:IsValid() then
			status:SetModel(Model("models/Zombie/Fast.mdl"))
		end		
	end,
	OnRevive = function(pl)
		--pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	ModelScale = 0.85,-- Vector(0.85,0.85,0.85),
	ViewOffset = Vector( 0, 0, 50 ),
	ViewOffsetDucked = Vector( 0, 0, 24 ),
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 58) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
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
	Model = Model("models/zombie/Zombie_Soldier.mdl"),
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
	Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[15] = --Everyone loves it ^^ Duby: R.I.P until you are loved once more! :<
{
	Name = "Klinator",
	Tag = "klinator",
	Infliction = 0,
	Health = 2000,
	MaxHealth = 8100,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 100,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 160,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_klinator",
	Model = Model("models/player/group01/male_09.mdl"), 
	OnSpawn = function(pl)
		pl:SetModel(Model(player_manager.TranslatePlayerModel("kleiner")))
		pl:SetColor( 39, 148, 6 )	
		pl:SetRandomFace()		
	end,
	Speed = 125,
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
				--Sound("deadlife_mrgreen_insane.mp3"),
				},
	IdleSounds = {
				Sound("npc/zombine/striderx_alert2.wav"),
				Sound("npc/zombine/striderx_alert4.wav"),
				Sound("npc/zombine/striderx_alert5.wav"),
				Sound("npc/zombine/striderx_alert6.wav"),
				},
	OnRevive = function(pl)
		
		-- pl:AnimRestartMainSequence()		

		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	end,
	ModelScale = 1,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	-- Hull = { Vector(-18,-18, 0), Vector(18,18,83) },
	Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
}

ZombieClasses[16] = --Wife of Adam and deemed to stay in hell for eternity. 
{
	Name = "Lilith",
	Tag = "lilith",
	Infliction = 0,
	Health = 9000,
	MaxHealth = 8100,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 100,
	Mass = DEFAULT_MASS * 3,
	Threshold = 4,
	JumpPower = 170,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_lilith",
	Model = Model("models/player/corpse1.mdl"), 
	OnSpawn = function(pl)
		pl:SetRandomFace()		
	end,
	Speed = 180,
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
		
		-- pl:AnimRestartMainSequence()		

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
		
				--Sound( "player/zombies/seeker/pain2.wav" ),
				},
	OnSpawn = function(pl)
		
	end,
	
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	
	
	--PainSounds = {
	--			Sound( "npc/strider/striderx_pain2.wav" ),
	--			Sound( "npc/strider/striderx_pain5.wav" ),
	--			Sound( "npc/strider/striderx_pain7.wav" ),
	--			Sound( "npc/strider/striderx_pain8.wav" ),
	--			},
	DeathSounds = {
				Sound("npc/strider/striderx_die1.wav"),
				},
	IdleSounds = {
				Sound("npc/zombine/striderx_alert2.wav"),
				Sound("npc/zombine/striderx_alert4.wav"),
				Sound("npc/zombine/striderx_alert5.wav"),
				Sound("npc/zombine/striderx_alert6.wav"),
				},
				
	ModelScale = 1.40,-- Vector(1.15,1.15,1.15),
	ViewOffset = Vector(0, 0, 73),
	ViewOffsetDucked = Vector(0,0,32.2),
	-- Hull = { Vector(-18,-18, 0), Vector(18,18,83) },
	Hull = { Vector(-16,-16, 0), Vector(16,16,83) },
	HullDuck = { Vector(-16,-16, 0), Vector(16,16,41) },
	
}


ZombieClasses[18] = --Creep and Play!
{
	Name = "SeekerII",
	Tag = "weapon_zs_undead_boss_seeker2",
	Infliction = 0.2,
	Health = math.random(8000, 7300 ),
	MaxHealth = 8100,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 200,
	Mass = DEFAULT_MASS * 8,
	Threshold = 4,
	JumpPower = 150,
	CanCrouch = true,
	CanGib = true,
	Unlocked = true,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_seeker2",
	--Model = Model("models/player/corpse1.mdl"), 
	Model = Model("models/player/zombie_classic.mdl"), 
	Speed = 140,
	Description = "An experiment gone wrong, its now out hunting the nooby!",
	Unique = "",
	
	OnSpawn = function(pl)	
	pl:SetRenderMode(RENDERMODE_GLOW) pl:SetColor(Color(1,1,1,2))
	end,
	
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	
	
	--PainSounds = {
	--			Sound( "npc/strider/striderx_pain2.wav" ),
	--			Sound( "npc/strider/striderx_pain5.wav" ),
	--			Sound( "npc/strider/striderx_pain7.wav" ),
	--			Sound( "npc/strider/striderx_pain8.wav" ),
	--			},
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
}



ZombieClasses[19] =  --I love Evangelion. So lets make a boss based off of it! >< 
{
	Name = "RAMIEL",
	Tag = "weapon_zs_undead_boss_raimel",
	Infliction = 0.7,
	Health = math.random(6000, 7000 ),
	MaxHealth = 8100,
	TimeLimit = 1020,
	Bounty = 1000,
	SP = 0,
	Mass = DEFAULT_MASS * 8,
	Threshold = 4,
	JumpPower = 180,
	CanCrouch = true,
	CanGib = true,
	Unlocked = true,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_boss_raimel",
	Model = Model("models/player/zombie_classic.mdl"), 
	Speed = 170,
	Description = "An angel has appeared! ",
	Unique = "",
	
	OnSpawn = function(pl)	
	--pl:SetRenderMode(RENDERMODE_GLOW) pl:SetColor(Color(239,16,16,225))
	

	
	end,
	
	OnRevive = function(pl)
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		-- pl:AnimRestartMainSequence()		
	end,
	
	
	--PainSounds = {
	--			Sound( "npc/strider/striderx_pain2.wav" ),
	--			Sound( "npc/strider/striderx_pain5.wav" ),
	--			Sound( "npc/strider/striderx_pain7.wav" ),
	--			Sound( "npc/strider/striderx_pain8.wav" ),
	--			},
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
}


--[[local SantaStart = {
	Sound("vo/ravenholm/engage06.wav"),
	Sound("vo/ravenholm/engage01.wav"),
}]]

--Christmas boss
--[[ZombieClasses[14] =
{
	Name = "Santa Claws",
	Tag = "santa",
	Wave = 0,
	Health = 5000,
	MaxHealth = 5000,
	TimeLimit = 1020,
	Infliction = 0,
	Bounty = 600,
	SP = 600,
	Mass = DEFAULT_MASS * 2,
	Threshold = 4,
	JumpPower = 100,
	CanCrouch = true,
	CanGib = true,
	Unlocked = false,
	Hidden = true,
	IsBoss = true,
	SWEP = "weapon_zs_undead_infected",
	--Model = Model("models/Jaanus/santa.mdl"),
	Model = Model("models/player/group01/male_09.mdl"),
	Speed = 185,
	Description = "",
	Unique = "",
	PainSounds = {
				Sound("vo/ravenholm/madlaugh01.wav"),
				Sound("vo/ravenholm/madlaugh02.wav"),
				Sound("vo/ravenholm/madlaugh03.wav"),
				Sound("vo/ravenholm/madlaugh04.wav"),
				Sound("vo/ravenholm/monk_blocked01.wav");
				},
	DeathSounds = {
				Sound("vo/ravenholm/monk_helpme01.wav"),
				Sound("vo/ravenholm/monk_helpme02.wav"),
				Sound("vo/ravenholm/monk_helpme03.wav"),
				Sound("vo/ravenholm/monk_helpme04.wav"),
				Sound("vo/ravenholm/monk_helpme05.wav"),
				},
	IdleSounds = {

				},
	OnSpawn = function(pl)
		pl:EmitSound(SantaStart[math.random(1,#SantaStart)],110,math.random(80,90))
		--pl:SetRandomFace()
		pl:SetModel(Model(player_manager.TranslatePlayerModel("santa")))
			
		pl:SetRandomFace()
		--Set red color
		--pl:SetColor(math.random(150,180),0,0,255)
	end,
	ModelScale = 1.2,//Vector(1.1,1.1,1.1),
	ViewOffset = Vector( 0, 0, 72 ),
	ViewOffsetDucked = Vector( 0, 0, 32 ),
	Hull = { Vector(-16, -16, 0), Vector(16, 16, 74) },
	HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
}]]