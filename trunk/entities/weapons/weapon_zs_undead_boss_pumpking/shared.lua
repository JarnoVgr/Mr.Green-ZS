-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--Duby: I am the puuusey boosss!

if CLIENT then

SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -72.75, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -69.2, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -68.004, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -58.772, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.871, -71.754, -22.512) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.777, 11.446, -35.982) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.693, 2.532, 25.214) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.1, -47.251) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 46.051) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(9.029, -52.984, -12.752) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -55.211, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.035, -8.169, -6.045) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20.917, -14.115, -34.5) }
	}
	
SWEP.VElements = {
	["Bat3+"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Bat2", pos = Vector(2.355, -5.079, -3.006), angle = Angle(0.964, 148.757, -180), size = Vector(0.617, 0.617, 0.617), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bat3"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Bat2", pos = Vector(3.598, 0.171, -3.172), angle = Angle(0.964, -100.653, -0.749), size = Vector(0.617, 0.617, 0.617), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bat3++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Bat2", pos = Vector(0.296, -1.448, -5.032), angle = Angle(63.75, -171.497, -101.661), size = Vector(0.623, 0.446, 0.623), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bat2"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Bat", pos = Vector(-0.181, -0.96, -9.044), angle = Angle(-178.62, -170.995, -4.575), size = Vector(1.092, 1.092, 1.092), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bat"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.792, 1.651, -7.797), angle = Angle(0.027, -108.045, -9.823), size = Vector(1.192, 1.192, 1.192), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["Bat3+"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.083, 0.264, -7.881), angle = Angle(0.964, 120.477, -180), size = Vector(0.617, 0.617, 0.617), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bat3"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.598, -0.621, -9.841), angle = Angle(0.964, -100.653, -0.749), size = Vector(0.617, 0.617, 0.617), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bat3++"] = { type = "Model", model = "models/Gibs/HGIBS_rib.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.598, -1, -10.443), angle = Angle(43.103, 99.248, -130.915), size = Vector(0.623, 0.446, 0.623), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bat2"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.177, 0.472, -11.15), angle = Angle(180, 106.268, -4.575), size = Vector(0.768, 0.768, 0.768), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bat"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.043, 1.156, -1.657), angle = Angle(-180, -180, -8.968), size = Vector(0.963, 0.963, 0.963), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
end

SWEP.PrintName = "Pumpking!"
SWEP.DrawAmmo = false
SWEP.ShowWorldModel = true
SWEP.CSMuzzleFlashes = false
SWEP.DrawCrosshair = true

SWEP.Base = "weapon_zs_undead_base"

SWEP.Author = "Duby"
SWEP.Contact = ""
SWEP.Purpose = "To terrify players of course!"
SWEP.Instructions = ""


SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.Primary.Reach = 45
SWEP.Primary.Duration = 2.1
SWEP.Primary.Delay = 1.2
SWEP.Primary.Damage = math.random(30,40)

SWEP.ShowWorldModel = false

function SWEP:StartPrimaryAttack()
	local pl = self.Owner
	
	if pl:GetAngles().pitch > 10 or pl:GetAngles().pitch < -10 then
		--pl:EmitSound(Sound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav"))
		return
	end
	
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
	if SERVER then
		--pl:EmitSound(Sound("npc/zombie_poison/pz_throw".. math.random(2,3) ..".wav"))
	end
local pl = self.Owner
local e = EffectData()
e:SetOrigin( self.Owner:GetShootPos() )
util.Effect( "seekerII", e )
self.Owner:SetRenderMode(RENDERMODE_GLOW) pl:SetColor(Color(239,128,31,150))
timer.Simple(0.5, function() 
	self.Owner:SetRenderMode(RENDERMODE_GLOW) pl:SetColor(Color(239,128,31,100))
	end)
end


function SWEP:PostPerformPrimaryAttack(hit)
	local pl = self.Owner

	if pl:GetAngles().pitch > 55 or pl:GetAngles().pitch < -55 then 

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
	aimvec.z = math.max(aimvec.z, 0.01)
	
	for i=1, 1 do
		local ent = ents.Create("projectile_spitterspit")
		if ent:IsValid() then
			local heading = (aimvec)
			ent:SetPos(startpos + heading * 10)
			ent:SetOwner(pl)
			ent:Spawn()
			ent.TeamID = pl:Team()
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetVelocityInstantaneous(heading * math.Rand(500, 550))
			end
			ent:SetPhysicsAttacker(pl)
		end
	end

	pl:EmitSound(Sound("physics/body/body_medium_break"..math.random(2,4)..".wav"), 80, math.random(70, 80))

	pl:TakeDamage(self.Secondary.Damage, pl, self.Weapon)
end


function SWEP:PrimaryAttackHit(trace, ent)
	if CLIENT then
		return
	end

	if hit then
		if ent and IsValid(ent) and ent:IsPlayer() then
			pl:EmitSound(Sound("player/zombies/seeker/melee_01.wav"),math.random(100,130),math.random(95,100))
			util.Blood(trace.HitPos, math.Rand(self.Primary.Damage * 0.25, self.Primary.Damage * 0.6), (trace.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(self.Primary.Damage * 6, self.Primary.Damage * 12), true)
			
	
		else
			pl:EmitSound(Sound("player/zombies/seeker/melee_02.wav"),math.random(100,130),math.random(95,100))
			
	
		end
	else
		self.Owner:EmitSound(Sound("player/zombies/seeker/melee_03.wav"),math.random(100,130),math.random(95,100))
	end
	
	
end

function SWEP:OnDeploy()
		self.BaseClass.Deploy(self)
	if SERVER then
		self:SetAttacking(false)
		self.Owner:EmitSound(Sound("player/zombies/seeker/pain1.wav"),math.random(100,160),math.random(50,55))
	end

end
	
function SWEP:_OnRemove()
	if SERVER then
		self.GrowlSound:Stop()
	end
	
end





