AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Beer Bottle"

	SWEP.ViewModelFlip = false

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true
	SWEP.VElements = {
--	["bottle"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1, -5), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	["bottle"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1, -9), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["bottle"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1, -3.636), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "debug/env_cubemap_model", skin = 0, bodygroup = {} }
	}
	
	killicon.AddFont( "weapon_zs_beer", "HL2MPTypeDeath", "6", Color(255, 255, 255, 255 ) )	
end

SWEP.Base = "weapon_zs_melee_base"

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_junk/garbage_glassbottle003a.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.Slot = 0
SWEP.Type = "Beer Bottle"
SWEP.Weight = 1
SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 40
SWEP.MeleeRange = 50
SWEP.MeleeSize = 1
SWEP.Durability = 2
SWEP.Primary.Delay = 0.2

SWEP.SwingRotation = Angle(0, -90, -60)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.3
SWEP.SwingHoldType = "melee"

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 80, math.Rand(90, 105))
end

function SWEP:PlayHitSound()

	self:EmitSound("physics/glass/glass_impact_bullet"..math.random(1, 4)..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetMagnitude(1)
		effectdata:SetScale(0.5)
		util.Effect("GlassImpact", effectdata)
	
	if SERVER then
		self.Durability = self.Durability - 1
		if self.Durability == 0 then
			self.Owner:EmitSound("physics/glass/glass_bottle_break1.wav", 80, math.Rand(90, 105))	
			DropWeapon(self.Owner)
			self:Remove()	
		end
	end	
end




