-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
SWEP.Base	= "weapon_zs_pulse_base"

AddCSLuaFile()

if CLIENT then

	SWEP.IconLetter = "/"
	SWEP.SelectFont = "HL2MPTypeDeath"

	killicon.AddFont("weapon_zs_pulse_smg", "HL2MPTypeDeath", SWEP.IconLetter, Color(100, 255, 255, 255 ))	
	
	SWEP.HoldType = "smg"
	SWEP.ViewModel = "models/weapons/c_smg1.mdl"
	SWEP.WorldModel = "models/weapons/w_smg1.mdl"	

	SWEP.VElements = {
		["smg2"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.118, -0.39, -8.738), angle = Angle(4.191, 0.01, 2.924), size = Vector(0.186, 0.186, 0.186), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["smg4"] = { type = "Model", model = "models/props_urban/fence_barbwire001_128.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.93, -1.991, -3.646), angle = Angle(-0.986, 0.634, 88.175), size = Vector(0.092, 0.092, 0.092), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["smg+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(1.07, -0.876, 3.809), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["smg"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(1.067, -0.728, -4.494), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["smg3"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.136, -1.647, -4.711), angle = Angle(-1.816, 1.735, -1.214), size = Vector(0.085, 0.085, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
	["OP Smg3"] = { type = "Model", model = "models/Items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.624, 1.493, -3.758), angle = Angle(-99.206, 0, 0), size = Vector(0.168, 0.168, 0.168), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["OP Smg2"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.199, 0.587, -4.947), angle = Angle(14.553, 85.567, 101.813), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["OP Smg"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.472, 0.953, -4.992), angle = Angle(-11.238, 91.967, 102.177), size = Vector(0.101, 0.101, 0.101), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.PrintName = "Pulse SMG"

SWEP.Slot = 2
SWEP.Type = "Pulse Tech"
SWEP.Weight = 3

SWEP.ViewModel = "models/weapons/c_smg1.mdl" 
SWEP.WorldModel = "models/Weapons/w_smg1.mdl"

SWEP.Pulse_Static_RechargeRate = 0.15
SWEP.Pulse_Static_ClipSize = 20

SWEP.HoldType = "smg"
SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy2.wav")
SWEP.Primary.Recoil			= 1.6
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.095
SWEP.Primary.Automatic		= true

SWEP.ConeMax = 0.09
SWEP.ConeMin = 0.04

SWEP.IronSightsPos = Vector(-2, -4, 0.92)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(120,125))
end
