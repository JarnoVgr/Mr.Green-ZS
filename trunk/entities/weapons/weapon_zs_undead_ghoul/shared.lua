AddCSLuaFile()
--Made by Duby :P
if CLIENT then
	--SWEP.PrintName = "Ghouler"
	SWEP.PrintName = "Toxic Zombie"
	SWEP.ViewModelFOV = 75
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true

	SWEP.FakeArms = false

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
	
	
	SWEP.WElements = {
	
			--["bone1+"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-10, 6.98, 0), angle = Angle(80.311, 0, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			
			["suit2.3"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.363, -6, 0.455), angle = Angle(5.113, 97.158, 82.841), size = Vector(0.435, 0.435, 0.435), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["suit2.1"] = { type = "Model", model = "models/props_combine/combine_intmonitor003.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-2.274, 5.364, -2.274), angle = Angle(9.204, -105.342, 91.023), size = Vector(0.209, 0.209, 0.209), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["suit2.1"] = { type = "Model", model = "models/effects/splode.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-2.274, 5.364, -2.274), angle = Angle(9.204, -105.342, 91.023), size = Vector(0.0209, 0.0209, 0.0209), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["suit2"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-8.636, 5.455, 1.363), angle = Angle(0, 80.794, 82.841), size = Vector(0.72, 0.72, 0.72), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["suit2.2"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-8.636, 5.456, -4.092), angle = Angle(1.023, 80.794, 86.931), size = Vector(0.264, 0.264, 0.264), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["9"] = { type = "Model", model = "models/effects/splode.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-3.636, 1.557, -4.676), angle = Angle(0, -99.351, 0), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
			["8"] = { type = "Model", model = "models/effects/splode.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-6.753, -10.91, -2.597), angle = Angle(0, 0, 0), size = Vector(0.031, 0.031, 0.031), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		}
	
end


SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true


SWEP.Primary.Duration = 1.50
SWEP.Primary.Delay = 0.5
SWEP.Primary.Damage = math.random(25,27)
SWEP.Primary.Reach = 50

SWEP.SwapAnims = false
SWEP.Secondary.Duration = 2
SWEP.Secondary.Delay = 0.8

function SWEP:Move()
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
 
	local pl = self.Owner
	local e = EffectData()
	e:SetOrigin( self.Owner:GetShootPos() )
	util.Effect( "chemzombieambient", e )	

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
		self.Owner:EmitSound(Sound("npc/zombine/zombine_alert"..math.random ( 1,3 )..".wav"))  
		else
		self.Owner:EmitSound(Sound("npc/zombine/zombine_charge1.wav"))  
	end
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	--Attack sounds
		--self.Owner:EmitSound(Sound("npc/zombine/zombine_charge2.wav")) 
	

	--Idle sounds
	--for i = 1, 10 do
	--	self.Owner:EmitSound(Sound("npc/zombine/zombine_idle"..math.random ( 1,4 )..".wav")) 
	--end
end


function SWEP:StartSecondaryAttack()
	--[[local pl = self.Owner
	
	if pl:GetAngles().pitch > 55 or pl:GetAngles().pitch < -55 then
		pl:EmitSound(Sound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav"))
		return
	end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
	if SERVER then
		pl:EmitSound(Sound("npc/zombie_poison/pz_throw".. math.random(2,3) ..".wav"))
	end]]--
end


function SWEP:PerformSecondaryAttack()
			self.Owner:EmitSound(Sound("npc/zombine/zombine_charge2.wav")) 
	--[[local pl = self.Owner

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
	
	for i=1, 6 do
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

	pl:TakeDamage(self.Secondary.Damage, pl, self.Weapon)]]--
end