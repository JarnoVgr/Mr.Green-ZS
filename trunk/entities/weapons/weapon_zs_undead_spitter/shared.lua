-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"
SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.PrintName = "Ghast"


if CLIENT then
	SWEP.ViewModelFOV = 80
	SWEP.ViewModelFlip = false
	SWEP.FakeArms = true	
end

SWEP.Primary.Duration = 1.5
SWEP.Primary.Delay = 0.6
SWEP.Primary.Reach = 48
SWEP.Primary.Damage = 25
SWEP.DisguiseChoice = 1
SWEP.EmitWraithSound = 0

SWEP.Screams = {
	Sound("npc/stalker/stalker_alert1b.wav"),
	Sound("npc/stalker/stalker_alert2b.wav"),
	Sound("npc/stalker/stalker_alert3b.wav")
}

-- Human scream sounds
SWEP.HumanScreams = {
	Sound("ambient/voices/m_scream1.wav"),
	Sound("ambient/voices/f_scream1.wav")
}

function SWEP:Precache()
	self.BaseClass.Precache(self)

	util.PrecacheSound("npc/stalker/breathing3.wav")
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[4].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[4].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(self.Screams) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(self.HumanScreams) do
		util.PrecacheSound(snd)
	end
	
	for i=1, 4 do
		util.PrecacheSound("npc/stalker/stalker_scream"..i..".wav")
	end
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)

	if SERVER then
		self.ScarySound = CreateSound(self.Owner, Sound("ambient/voices/crying_loop1.wav"))
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
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	if self:IsDisguised() then
		self:EmitSound(Sound("npc/antlion/distract1.wav"), 100, math.random(82, 92))
	else
		self:EmitSound(Sound("npc/antlion/distract1.wav"), 100, math.random(92, 107))
	end
	
	local stopPlayer = true

	if self:IsDisguised() then
		self.Primary.Speed = 200
		stopPlayer = false
	else
		self.Primary.Speed = 0
	end
	 
	if SERVER then
		if stopPlayer then
			self.Owner:SetLocalVelocity(Vector(0, 0, 0))
		end
	end
end

function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then
		mv:SetMaxSpeed(self.Primary.Speed)
		return true
	end
end

function SWEP:SetDisguise(bl)
	self:SetDTBool(0,bl)
	self:DrawShadow(bl)
end

function SWEP:IsDisguised()
	return self:GetDTBool(0)
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + 3)
	-- if self.Disguised then return end
	if self:IsDisguised() then
		self:EmitSound(Sound("npc/fast_zombie/idle"..math.random(1,3)..".wav"), 80)	
		return
	end

	self:SetDisguise(true)
	self.FakeArms = true
	self:SetColor( Color( 255, 255, 255, 1 ) )

	
	--Pick random human model
	if SERVER then	
		self.DisguiseChoice = math.random(1,2)	
		local survivors = team.GetPlayers(TEAM_HUMAN)
		local model = "models/player/kleiner.mdl"
		if #survivors > 0 then
			model = table.Random(survivors):GetModel()
		end
		
		self.Owner:SetModel(model)
		
		self.Owner:EmitSound(Sound("npc/stalker/stalker_scream"..math.random(1,4)..".wav"), 80)
	end
	
	
end

-- Play teleport fail sound
--[[function SWEP:TeleportFail()
	if SERVER then
		if ( self.TeleportWarnTime or 0 ) <= CurTime() then
			-- self.Owner:EmitSound( "npc/zombie_poison/pz_idle4.wav", 70, math.random( 92, 105 ) ) --Moo
			self.Owner:EmitSound( "npc/stalker/stalker_ambient01.wav", 70, 100 ) 
			self.TeleportWarnTime = CurTime() + 0.97
		end
	end
end]]


function SWEP:OnRemove()
	if SERVER then
		self.ScarySound:Stop()
	end

	self.BaseClass.OnRemove(self)
end 

-- Main think
function SWEP:Think()
	self.BaseClass.Think(self)

	if SERVER then
		if self.ScarySound then
			self.ScarySound:PlayEx(0.2, 95 + math.sin(RealTime())*8) 
		end 
	end
end

-- Precache sounds
util.PrecacheSound("npc/antlion/distract1.wav")
util.PrecacheSound("ambient/machines/slicer1.wav")
util.PrecacheSound("ambient/machines/slicer2.wav")
util.PrecacheSound("ambient/machines/slicer3.wav")
util.PrecacheSound("ambient/machines/slicer4.wav")
util.PrecacheSound("npc/zombie/claw_miss1.wav")
util.PrecacheSound("npc/zombie/claw_miss2.wav")



  
