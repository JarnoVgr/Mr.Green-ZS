-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
SWEP.Base	= "weapon_zs_pulse_base"
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Pulse Pistol"

	SWEP.WElements = {
	["battery"] = { type = "Model", model = "models/items/battery.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.201, -3.201, 1.557), angle = Angle(0, 90, -176.495), size = Vector(0.449, 0.4, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["front"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "battery", pos = Vector(0.5, 0, -2.597), angle = Angle(0, 0, 180), size = Vector(0.349, 0.349, 0.335), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.VElements = {
	["battery"] = { type = "Model", model = "models/items/battery.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3, -3.5), angle = Angle(0, 90, 0), size = Vector(0.349, 0.4, 0.6), color = Color(142, 211, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["battery+++"] = { type = "Model", model = "models/Items/combine_rifle_cartridge01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -1.601, -2.597), angle = Angle(90, 0, 90), size = Vector(0.2, 0.6, 0.2), color = Color(203, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["battery+"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3, -9.87), angle = Angle(0, 0, 0), size = Vector(0.3, 0.3, 0.3), color = Color(142, 211, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["battery++"] = { type = "Model", model = "models/Items/AR2_Grenade.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.5, -3.201, -4.676), angle = Angle(-90, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(0, 120, 208, 255), surpresslightning = false, material = "models/error/new light1", skin = 0, bodygroup = {} }
	}
	
	SWEP.IconLetter = "u"	
	killicon.AddFont("weapon_zs_pulse_pistol", "CSKillIcons", SWEP.IconLetter, Color(100, 255, 255, 255))
end

SWEP.Slot = 1
SWEP.Type = "Pulse Tech"
SWEP.Weight = 2

SWEP.Pulse_Static_RechargeRate = 0.22
SWEP.Pulse_Static_ClipSize = 10

SWEP.Primary.Delay = 0.15
SWEP.ConeMax = 0.09
SWEP.ConeMin = 0.04
SWEP.Primary.NumShots = 1
SWEP.Primary.Recoil = 3.0
SWEP.Primary.Damage = 20

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")

SWEP.IronSightsPos = Vector(-5.95, 7, 2 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(160,170))
end