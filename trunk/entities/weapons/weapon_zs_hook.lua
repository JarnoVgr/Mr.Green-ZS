-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_plank.mdl")

if CLIENT then
	SWEP.ShowViewModel = false 
	--SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["1"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 1.557, -5.715), angle = Angle(1.169, 87.662, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		--["pipe1"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 3.635, -4.676), angle = Angle(-12.858, 59.61, -8.183), size = Vector(0.432, 0.432, 0.432), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--	["pipe1"] = { type = "Model", model = "models/props_junk/meathook001a.mdl",  bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.941, 2.631, -6.678), angle = Angle(90, 180, -53.116), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["1"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 1.557, -5.715), angle = Angle(-8.183, 82.986, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		--["pipe2"] = { type = "Model", model = "", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	}
		killicon.AddFont( "weapon_zs_hook", "HL2MPTypeDeath", "6", Color(255, 255, 255, 255 ) )

end

--SWEP.HoldType = "melee2"
SWEP.DeploySpeed = 0.6
-- Name and fov
SWEP.PrintName = "Meat Hook"
SWEP.ViewModelFOV = 60

-- Slot pos
SWEP.Slot = 0

SWEP.Weight = 1
SWEP.Type = "Melee"

-- Damage, distance, delay
SWEP.Primary.Delay = 0.6
SWEP.TotalDamage = SWEP.Primary.Damage

SWEP.MeleeDamage = 30
SWEP.MeleeRange = 48
SWEP.MeleeSize = 1.2

SWEP.SwingTime = 0.6
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingHoldType = "grenade"
SWEP.ShowWorldModel = false 
SWEP.ShowViewModel = false

function SWEP:PlaySwingSound()
	self:EmitSound("Weapon_Crowbar.Single")
end

 function SWEP:PlayHitFleshSound()
self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 75, math.random(120, 130))
end

function SWEP:PlayHitSound()
self:EmitSound("physics/metal/metal_sheet_impact_bullet"..math.random(2)..".wav")
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
        if hitent:IsValid() and hitent:IsPlayer() then
                local combo = self:GetDTInt(2)
                self:SetNextPrimaryFire(CurTime() + math.max(0.2, self.Primary.Delay * (1 - combo / 10)))
 
                self:SetDTInt(2, combo + 1)
        end
end