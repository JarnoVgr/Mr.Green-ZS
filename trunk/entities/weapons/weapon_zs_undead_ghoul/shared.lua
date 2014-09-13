AddCSLuaFile()
--Made by Duby :P
if CLIENT then
	SWEP.PrintName = "Ghouler"
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = false

	SWEP.FakeArms = true

	SWEP.ViewModelBoneMods = {
		-- ["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-10.202, 19.533, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(0, -7.493, -45.569) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(5.802, 1.06, 0.335), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(52.678, 0, 0) },
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(45.873, -0.348, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-59.774, -9.223, 18.572) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(10.701, -7.301, 42.666) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 9.659, 6.218) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-6.42, 28.499, 7.317) }
	}
	
	
end


SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

--SWEP.Primary.Duration = 1.75
SWEP.Primary.Duration = 1.50
SWEP.Primary.Delay = 0.7
--SWEP.Primary.Delay = 0.9
--SWEP.Primary.Delay = 1.2
--SWEP.Primary.Damage = 25
SWEP.Primary.Damage = 20
SWEP.Primary.Reach = 45

SWEP.SwapAnims = false

SWEP.Secondary.Duration = 1.2
SWEP.Secondary.Delay = 0.3

SWEP.Secondary.Damage = 15
SWEP.Secondary.Reach = 45

	--pl:ManipulateBonePosition(math.Rand(1, 15) , Vector( math.Rand( 1, 5), math.Rand( 1, 5), math.Rand( 1, 5)) )
	


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
	if SERVER and #self.AttackSounds > 0 then
		self.Owner:EmitSound(Sound(self.AttackSounds[math.random(#self.AttackSounds)]))
	end
	
	


end

function SWEP:PostPerformPrimaryAttack(hit)
	if CLIENT then
		return
	end

	if hit then
		self.Owner:EmitSound(Sound("npc/zombie/zombie_hit.wav".. math.random(1, 8) ..".wav"))
		
		
	else
		self.Owner:EmitSound(Sound("npc/zombie/claw_miss1.wav"..math.random(1, 2)..".wav"))
		
		
	end
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	--Attack sounds
	for i = 20, 37 do
		table.insert(self.AttackSounds,Sound("mrgreen/undead/infected/rage_at_victim"..i..".mp3"))
	end

	--Idle sounds
	for i = 1, 31 do
		table.insert(self.IdleSounds,Sound("mrgreen/undead/infected/idle"..i..".mp3"))
	end
end


function SWEP:StartSecondaryAttack()
	local pl = self.Owner
	
	if pl:GetAngles().pitch > 55 or pl:GetAngles().pitch < -55 then
		pl:EmitSound(Sound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav"))
		return
	end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
	if SERVER then
		pl:EmitSound(Sound("npc/zombie_poison/pz_throw".. math.random(2,3) ..".wav"))
	end
end


function SWEP:PerformSecondaryAttack()
	local pl = self.Owner

	-- GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed ) 
	if pl:GetAngles().pitch > 30 or pl:GetAngles().pitch < -30 then 
		if SERVER then
			--pl:EmitSound(Sound("npc/zombie_poison/pz_idle".. math.random(2,4) ..".wav"))
		end

		return 
	end
		
	--Swap Anims
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
		
	if CLIENT then
		return
	end

	local shootpos = pl:GetShootPos()
	local startpos = pl:GetPos()
	startpos.z = shootpos.z
	local aimvec = pl:GetAimVector()
	aimvec.z = math.max(aimvec.z, -0.7)
	
	for i=1, 5 do
		local ent = ents.Create("projectile_poisonpuke")
		if ent:IsValid() then
			local heading = (aimvec + VectorRand()):GetNormal()
			ent:SetPos(startpos + heading * 8)
			ent:SetOwner(pl)
			ent:Spawn()
			ent.TeamID = pl:Team()
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetVelocityInstantaneous(heading * math.Rand(550, 560))
			end
			ent:SetPhysicsAttacker(pl)
		end
	end

	pl:EmitSound(Sound("physics/body/body_medium_break"..math.random(2,4)..".wav"), 80, math.random(70, 80))

	pl:TakeDamage(self.Secondary.Damage, pl, self.Weapon)
end