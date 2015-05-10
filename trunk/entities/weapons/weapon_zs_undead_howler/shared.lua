-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_base"


SWEP.PrintName = "Howler"

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
	--SWEP.FakeArms = true
end


SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Primary.Duration = 1.4
SWEP.Primary.Delay = 0.6
SWEP.Primary.Damage = 15
SWEP.Primary.Reach = 47

SWEP.Secondary.Reach = 400
SWEP.Secondary.Duration = 1.0
SWEP.Secondary.Delay = 0
SWEP.Secondary.Next = 4.5

function SWEP:Precache()
	self.BaseClass.Precache(self)

	util.PrecacheSound("ambient/energy/zap6.wav")
	util.PrecacheSound("npc/barnacle/barnacle_bark1.wav")

	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[5].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].AttackSounds) do
		util.PrecacheSound(snd)
	end
end	

function SWEP:Think()
	self.BaseClass.Think(self)

	--if SERVER then
		if self:IsScreaming() == true and not self:IsInSecondaryAttack() then
		self:Screaming(false)	
		end 
	--end
end

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
  
	if SERVER then
		self.Owner:EmitSound(Sound("player/zombies/howler/howler_mad_0"..math.random(1, 4)..".wav"),80)
	end

end

function SWEP:PostPerformPrimaryAttack(hit)
	if CLIENT then
		return
	end

	if hit then
		self.Owner:EmitSound(Sound("npc/zombiegreen/hit_punch_0".. math.random(1, 8) ..".wav"))
	else
		self.Owner:EmitSound(Sound("npc/zombiegreen/claw_miss_"..math.random(1, 2)..".wav"))
	end
end

function SWEP:StartSecondaryAttack()	
	-- Get owner
	local mOwner = self.Owner
	if not IsValid(mOwner) then
		return
	end
	
	-- Cannot scream in air
	-- Pufulet: Why not?
	--if not mOwner:OnGround() then	
	--	return
	--end
		
	--Thirdperson animation and sound
	mOwner:DoAnimationEvent(CUSTOM_SECONDARY)

	--Just server from here
	if CLIENT then
		return
	end

	--Emit Sound
	mOwner:EmitSound(table.Random(ZombieClasses[mOwner:GetZombieClass()].AttackSounds), 100, math.random(95, 135))
	
	--Screaming on and off!
	self:Screaming(true)
	
	--Find in sphere
	for k,v in ipairs(team.GetPlayers(TEAM_HUMAN)) do
		local fDistance = v:GetPos():Distance( self.Owner:GetPos() )

		--Check for conditions
		if not v:IsPlayer() or not v:IsHuman() or not v:Alive() or fDistance > self.Secondary.Reach then
			continue
		end

		local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.Secondary.Reach )
		local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
			
		-- Exploit trace
		if not Trace.Hit or not IsValid(Trace.Entity) or Trace.Entity ~= v then
			continue
		end
		
		--Calculate percentage of being hit
		local fHitPercentage = math.Clamp(1 - (fDistance / self.Secondary.Reach), 0, 1)
															
		--Inflict damage
		local fDamage = math.Round(24 * fHitPercentage, 0, 10)
	--	local fDamage = math.Round(12 * fHitPercentage, 0, 10)
		if fDamage > 0 then
			v:TakeDamage(fDamage, self.Owner, self)
		end

		--Check if last Howler scream was recently (we don't want to stack attacks)
		if v.lastHowlerScream and v.lastHowlerScream >= (CurTime()-4) then
			continue
		end

		--Set last Howler scream
		v.lastHowlerScream = CurTime()

		--Shakey shakey
		local fFuckIntensity = fHitPercentage + 3 --Duby test.

		GAMEMODE:OnPlayerHowlered(v, fFuckIntensity)

		-- Calculate base velocity
		--local Velocity = -1 * mOwner:GetForward() * 120
		--if not bPull then
		--	Velocity = -1 * Velocity * 2
		--end
		
		
		--Velocity.x, Velocity.y, Velocity.z = Velocity.x * 0.5, Velocity.y * 0.5, math.random(190, 230)
		--if not bPull then
		--	Velocity = Vector(Velocity.x * 0.45, Velocity.y * 0.45, Velocity.z)
		--end

		--Apply velocity		
		--v:SetVelocity(Velocity)
				
		-- Play sound
		--timer.Simple(0.2, function()
		--	if IsValid(v) then
		--		sound.Play("npc/barnacle/barnacle_bark1.wav", v:GetPos() + Vector(0, 0, 20), 120, math.random(60, 75))
		--	end
		--end)
	end
	
	--Scream effect for myself
	self.Owner:SendLua("WraithScream()")
end

function SWEP:Screaming(bl)
	self:SetDTBool(0,bl)
	self:DrawShadow(bl)
end

function SWEP:IsScreaming()
	return self:GetDTBool(0)
end

function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then
		--mv:SetMaxSpeed(0)
		return true
	end
	if self:IsInSecondaryAttack() then
		--mv:SetMaxSpeed(0)
		return true
	end
end

if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() or ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()

		draw.SimpleTextOutlined("TIP:", "ArialBoldFive", w-ScaleW(150), h-ScaleH(63), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		draw.SimpleTextOutlined("Right Click To Howl!", "ArialBoldFive", w-ScaleW(150), h-ScaleH(40), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))

	end
end