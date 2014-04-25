-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "M4A1 Rifle"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.SlotPos = 8
	SWEP.IconLetter = "w"
	
	SWEP.IgnoreThumbs = true
	
	SWEP.OverrideTranslation = {}
	SWEP.OverrideTranslation["v_weapon.Right_Hand"] = Vector(-1.2,0,0)
	
	SWEP.OverrideAngle = {}
	SWEP.OverrideAngle["v_weapon.Right_Arm"] = Angle(0,0,80)

	killicon.AddFont("weapon_zs_m4a1", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	SWEP.ViewModelFOV = 50
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/medic/xms_medigun.mdl", bone = "v_weapon.m4_Parent", rel = "", pos = Vector(0, -5.579, 11.704), angle = Angle(-90, 90, 0), size = Vector(0.342, 0.342, 0.87), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.017, 0.795, -3.843), angle = Angle(-12.945, 0, 0), size = Vector(0.952, 0.952, 0.952), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_rif_m4a1.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_rif_m4a1.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_M4A1.Single")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 23
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 31
SWEP.storeclipsize			= 31
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 93
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.ConeMoving = 0.069
SWEP.Cone = 0.051
SWEP.ConeIron = 0.041
SWEP.ConeCrouching = 0.038
SWEP.ConeIronCrouching = 0.029

SWEP.MaxAmmo			    = 250

SWEP.WalkSpeed = 195
SWEP.MaxBulletDistance 		= 2600

--SWEP.IronSightsPos = Vector(-6, -2, 1)
--SWEP.IronSightsAng = Vector(0, 2, 0 )


SWEP.IronSightsPos = Vector( -2.4, -5, 1.0 )
SWEP.IronSightsAng = Vector(0,0,0)

--SWEP.IronSightsPos = Vector(2.64, -3.379, 1)
--SWEP.IronSightsAng = Vector(0, 0, 3.144)


function think()
if self:GetOwner():GetSuit() == "freeman" then -- freeman suit.
			WalkSpeed = 220
		--	WalkSpeed = 260
		end

end