-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "TMP SMG"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.ViewModelFOV = 65
	SWEP.SlotPos = 19
	SWEP.IconLetter = "d"
	killicon.AddFont("weapon_zs_tmp", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model("models/weapons/cstrike/c_smg_tmp.mdl")
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_tmp.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_TMP.Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 11.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay 		= 0.06
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.MaxAmmo			    = 250


SWEP.Cone = 0.067
SWEP.ConeMoving = SWEP.Cone *1.3
SWEP.ConeCrouching = SWEP.Cone *0.85
SWEP.ConeIron = SWEP.Cone *0.85
SWEP.ConeIronCrouching = SWEP.ConeCrouching *0.80
--SWEP.ConeIronMoving = SWEP.Moving *0.80

SWEP.WalkSpeed = 197
SWEP.MaxBulletDistance 		= 2250

SWEP.IronSightsPos = Vector(-2, -4, 1.5)
SWEP.IronSightsAng = Vector(0,0,0)

SWEP.OverridePos = Vector(1.559, -3.116, 1.6)
SWEP.OverrideAng = Vector(0, 0, 0)

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.TMP_Parent", rel = "", pos = Vector(0, -5.909, -10.079), angle = Angle(90, 90, 0), size = Vector(0.535, 0.535, 0.712), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/sniper/xms_sniperrifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.53, 1.159, -2.718), angle = Angle(-13.704, 0, 0), size = Vector(0.961, 0.961, 0.961), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end


--SWEP.IronSightsPos = Vector(1.559, -3.116, 1.6)
--SWEP.IronSightsAng = Vector(0, 0, 0)