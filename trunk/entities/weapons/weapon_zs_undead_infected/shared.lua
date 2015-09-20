AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Infected"
	SWEP.ViewModelFOV = 80
	SWEP.ViewModelFlip = false	
end

SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Duration = 1.25
SWEP.Primary.Delay = 0.75
SWEP.Primary.Damage = 24
SWEP.Primary.Reach = 48

SWEP.SwapAnims = false

SWEP.LastAttackSound = 0


function SWEP:StartPrimaryAttack()			
	--Hacky way for the animations
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	
	--Set the thirdperson animation and emit zombie attack sound
	self.Owner:DoAnimationEvent(CUSTOM_PRIMARY)
  
	--Emit sound
	if SERVER and #self.AttackSounds > 0 and self.LastAttackSound < CurTime() then
		--print(self.Green)
	--if self.Green then
		self.LastAttackSound = CurTime() + math.random(2,6)
			--self.Owner:EmitSound(Sound(self.GreenAttackSounds[math.random(#self.GreenAttackSounds)]))
		--else
		self.Owner:EmitSound(Sound(self.AttackSounds[math.random(#self.AttackSounds)]))		
	end
	--end
	
	

end

function SWEP:PostPerformPrimaryAttack(hit)
	if CLIENT then
		return
	end

	if hit then
		self.Owner:EmitSound(Sound("npc/zombie/claw_strike".. math.random(1, 3) ..".wav"))
	else
		self.Owner:EmitSound(Sound("npc/zombie/claw_miss"..math.random(1, 2)..".wav"))

	end
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	
	local mOwner = self.Owner
	
	--//Thirdperson animation
	mOwner:DoAnimationEvent( CUSTOM_SECONDARY )
		
	--//Emit both claw attack sound and weird funny sound
	if SERVER then self.Owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav") end

	self.NextYell = CurTime() + 2
end



function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	
	--self.Green = util.tobool(GetConVarNumber("_zs_mrgreenzombiesounds"))
	--if not mrgreenzombiesounds then
	--[[
		for i = 1, 2 do
			table.insert(self.AttackSounds,Sound("npc/zombie/zo_attack"..i..".wav"))
		end
		for i = 1, 14 do
			table.insert(self.IdleSounds,Sound("npc/zombie/zombie_voice_idle"..i..".wav"))
		end
		
		]]--
	--else
		for i = 20, 37 do
			table.insert(self.AttackSounds,Sound("mrgreen/undead/infected/rage_at_victim"..i..".mp3"))
		end
		for i = 1, 31 do
			table.insert(self.IdleSounds,Sound("mrgreen/undead/infected/idle"..i..".mp3"))
		end	
	--end
end

-- Drop crosshair
if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.Primary.Reach ) end
end