-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "P90"			
	SWEP.Author	= "Ywa"
	SWEP.Slot = 0
	SWEP.ViewModelFOV = 65
	SWEP.SlotPos = 13
	SWEP.IconLetter = "m"
	killicon.AddFont("weapon_zs_p90", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.p90_Parent", rel = "", pos = Vector(-0.083, -0.32, 5.164), angle = Angle(-76.706, 90, 0), size = Vector(0.694, 0.527, 0.589), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-8.839, 1.111, -2.053), angle = Angle(-93.301, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
	}
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_smg_p90.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_smg_p90.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_P90.Single")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Unrecoil		= 0
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ClipSize		= 50
SWEP.Primary.Delay			= 0.109
SWEP.Primary.DefaultClip	= 100
SWEP.MaxAmmo			    = 250
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )


SWEP.ConeMoving = 0.061
SWEP.Cone = 0.048
SWEP.ConeIron = 0.038
SWEP.ConeCrouching = 0.037
SWEP.ConeIronCrouching = 0.031

SWEP.WalkSpeed = 197
SWEP.MaxBulletDistance 		= 1800

--SWEP.IronSightsPos = Vector(-4.16, -4.488, 2.039)
--SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.IronSightsPos = Vector(-2.641, -4.481, 1 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.OverridePos = Vector(2.299, -2.46, 1.967)
SWEP.OverrideAng = Vector(0, 0, 0)


function think()
if self:GetOwner():GetSuit() == "freeman" then -- freeman suit.
		--	WalkSpeed = 220
			WalkSpeed = 260
		end

end