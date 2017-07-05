-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Defender' Rifle"

	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true

	
	SWEP.VElements = {
	["4"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.801, -4.5, 0), angle = Angle(0, -8.183, 75.973), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -6, -2), angle = Angle(90, 180, 0), size = Vector(0.5, 0.6, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["5"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.AK47_Bolt", rel = "", pos = Vector(-0.519, 0, -2.597), angle = Angle(0, 90, 0), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["barrel+"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -4, -14), angle = Angle(90, -57.273, 12.857), size = Vector(0.6, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["barrel"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -4.2, -18.182), angle = Angle(0, 0, 87.662), size = Vector(0.6, 1.728, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["7"] = { type = "Model", model = "models/props_c17/pulleywheels_small01.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -4.676, 1.557), angle = Angle(0, 90, 0), size = Vector(0.2, 0.2, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["2"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -4, -5.715), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["6"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "v_weapon.AK47_Bolt", rel = "", pos = Vector(0, 0, -3.636), angle = Angle(0, 0, 0), size = Vector(0.05, 0.05, 0.107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["3"] = { type = "Model", model = "models/props_phx/construct/wood/wood_boardx1.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.7, -4, 0), angle = Angle(-90, 0, 0), size = Vector(0.1, 0.3, 0.1), color = Color(200, 170, 148, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
	["1+"] = { type = "Model", model = "models/props_c17/pulleywheels_small01.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1, -1.558, -3.636), angle = Angle(-15.195, 90, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1, -4.676, 7.791), angle = Angle(80.649, 90, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1++"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1, -6.901, 23), angle = Angle(180, 0, 101.688), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.IconLetter = "b"
	killicon.AddFont( "weapon_zs_defender", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ) )
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(-0.073, -8.16, 3.904), angle = Angle(-90, 0, 90), size = Vector(0.55, 0.55, 1.036), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.517, 0.296, -3.316), angle = Angle(91.203, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Slot = 2
SWEP.Weight = 3
SWEP.Type = "Assault Rifle"
SWEP.Base				= "weapon_zs_base"
SWEP.UseHands = true
SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_ak47.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_rif_ak47.mdl" )
SWEP.PrintName			= "'Defender' Rifle"
SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AK47.SingleHeavy")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 22
SWEP.Primary.Delay			= 0.15
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.ConeMax = 0.1
SWEP.ConeMin = 0.04

sound.Add( {
name = "Weapon_AK47.SingleHeavy",
channel = CHAN_WEAPON,
volume = 1.0,
level = 100,
pitch = 130,
sound = ")weapons/ak47/ak47-1.wav"
} )

SWEP.IronSightsPos = Vector(-2, -4, 1.5)
SWEP.IronSightsAng = Vector(0,0,0)

