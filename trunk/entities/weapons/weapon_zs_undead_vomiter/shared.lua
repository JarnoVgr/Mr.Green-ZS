-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--BIG WORK IN PROGRESS
--Created by DubyXD
AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"

SWEP.PrintName = "Smoker!"
if CLIENT then
	SWEP.ViewModelFOV = 35
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	
	

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.075, 1.075, 1.075), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.488, 1.488, 1.488), pos = Vector(0, 0, 0), angle = Angle(-4.139, -1.862, 1.238) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.343, 1.343, 1.343), pos = Vector(0, 0, 0), angle = Angle(-3.389, 0.075, 1.312) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(-3.701, 0.425, -0.288), angle = Angle(0, 0, 0) },
	-- ["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(1.58, 5.205, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.213, 1.213, 1.213), pos = Vector(0, 0, 0), angle = Angle(-0.151, -20.414, -7.045) },
	["ValveBiped.Bip01_Head1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 46.051) },
    ["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 46.051) },
	
}



SWEP.WElements = {
	["4"] = { type = "Model", model = "models/gibs/antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(0.518, 6.752, -3.636), angle = Angle(0, -61.949, 0), size = Vector(1.404, 1.404, 1.404), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8"] = { type = "Model", model = "models/effects/splode.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-6.753, -10.91, -2.597), angle = Angle(0, 0, 0), size = Vector(0.041, 0.041, 0.041), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/gibs/strider_gib7.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-6.753, 9.869, -2.597), angle = Angle(0, -75.974, -80.65), size = Vector(0.497, 0.497, 0.497), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["5"] = { type = "Model", model = "models/gibs/antlion_gib_small_3.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(0, -11.948, -3.636), angle = Angle(0, 3.506, 180), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["2"] = { type = "Model", model = "models/gibs/antlion_gib_small_2.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-8.832, -1.558, 0), angle = Angle(0, -26.883, 94.675), size = Vector(2.506, 2.506, 2.506), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["6"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-5.715, 3.635, -8.832), angle = Angle(-82.987, -22.209, 78.311), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["7"] = { type = "Model", model = "", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["3"] = { type = "Model", model = "models/gibs/antlion_gib_small_1.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(0.518, 6.752, 3.635), angle = Angle(0, -61.949, 0), size = Vector(1.404, 1.404, 1.404), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
["weapon"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.791, 0.518, -5.715), angle = Angle(0, 78.311, 73.636), size = Vector(0.885, 0.885, 0.885), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["9"] = { type = "Model", model = "models/effects/splode.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-3.636, 1.557, -4.676), angle = Angle(0, -99.351, 0), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["8"] = { type = "Model", model = "models/effects/splode.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-10.91, -4.676, -8.832), angle = Angle(19.87, 15.194, -54.936), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}
end

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.Primary.Delay = 0.8
SWEP.Primary.Reach = 50
--SWEP.Primary.Duration = 0.8
SWEP.Primary.Duration = 1.2
SWEP.Primary.Damage = 30
SWEP.Primary.Automatic = true


SWEP.SwapAnims = false

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	if CLIENT then
		self.BreathSound = CreateSound(self.Weapon,Sound("npc/zombie_poison/pz_breathe_loop1.wav"));
		if self.BreathSound then
			self.BreathSound:Play()
		end
	end
end     

function SWEP:Reload()
end


function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then
		mv:SetMaxSpeed(self.Owner:GetMaxSpeed()*8)
		return true
	elseif self:IsInSecondaryAttack() then
		mv:SetMaxSpeed(120)
		return true
	end
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)

	if CLIENT and self.BreathSound then
		self.BreathSound:Stop()
	end

	return true
end

function SWEP:Precache()
	util.PrecacheSound("npc/zombie_poison/pz_throw2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_throw3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn1.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle4.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_breathe_loop1.wav")
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[3].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[3].IdleSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[3].DeathSounds) do
		util.PrecacheSound(snd)
	end
end


function SWEP:StartPrimaryAttack()

-- Hacky way for the animations
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	
	-- Set the thirdperson animation and emit zombie attack sound
	--self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:DoAnimationEvent(CUSTOM_PRIMARY)

local pl = self.Owner
local e = EffectData()
e:SetOrigin( self.Owner:GetShootPos() )
util.Effect( "smokereffect", e )

	self:EmitSound(Sound("player/zombies/hate/sawrunner_attack1.wav"),math.random(100,130),math.random(95,100))
	--self:EmitSound(Sound("player/zombies/hate/sawrunner_attack2.wav"),math.random(100,130),math.random(95,100))
end

function SWEP:PrimaryAttackHit(trace, ent)
	if CLIENT then
		return
	end

	if hit then
		if ent and IsValid(ent) and ent:IsPlayer() then
		pl:EmitSound(Sound("player/zombies/hate/chainsaw_attack_hit.wav"),math.random(100,130),math.random(95,100))
		 pl:EmitSound(Sound("npc/barnacle/barnacle_bark.wav"),math.random(100,130),math.random(95,100))
		else
		pl:EmitSound(Sound("player/zombies/hate/sawrunner_attack2.wav"),math.random(100,130),math.random(95,100))
		pl:EmitSound(Sound("player/zombies/hate/sawrunner_attack1.wav"),math.random(100,130),math.random(95,100))

		end
		end end

if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() or ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()

		draw.SimpleTextOutlined("Hold Primary to create smoke, and attack! ", "ArialBoldFive", w-ScaleW(150), h-ScaleH(63), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined("Use this to cover you're team mates advancing on the humans!", "ArialBoldFive", w-ScaleW(150), h-ScaleH(40), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined("Use Third person so you can see wtf you are doing! 'c'! ", "ArialBoldFive", w-ScaleW(150), h-ScaleH(20), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
end

function SWEP:PlayAttackSound()
   
end


function SWEP:OnDeploy()
	if SERVER then
		self.DeployTime = CurTime() + 3.5
		self.ChainSound = CreateSound( self.Owner, "weapons/melee/chainsaw_idle.wav" ) 
		if not self.Deployed then
			self.Owner:EmitSound("weapons/melee/chainsaw_start_0"..math.random(1,2)..".wav")
			self.Deployed = true
		end
	end
end

