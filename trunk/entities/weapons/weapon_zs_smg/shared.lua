-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.PrintName = "SMG"
end

if CLIENT then
	SWEP.PrintName = "SMG"			
	SWEP.Author	= "Deluvas"
	SWEP.Slot = 0
	SWEP.SlotPos = 18
	SWEP.ViewModelFOV = 55
	SWEP.ViewModelFlip = false
	
	SWEP.ShowViewModel = false
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = true
	SWEP.ScaleDownLeftHand = true
	
	SWEP.VElements = {
	-- 	["smg1"] = { type = "Model", model = "models/Weapons/w_smg1.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(-0.826, 0.95, 3.444), angle = Angle(88.787, 143.143, 126.155), size = Vector(0.837, 0.842, 0.856), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.IconLetter = "/"
	surface.CreateFont( "HL2MP", ScreenScale( 30 ), 500, true, true, "HL2KillIcons" )
	surface.CreateFont( "HL2MP", ScreenScale( 60 ), 500, true, true, "HL2SelectIcons" )
	
	killicon.AddFont( "weapon_zs_smg", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 255, 255, 255 ) )
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(-0.189, -1.303, 14.432), angle = Angle(3.562, -89.909, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/engineer/xms_wrench.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(21.04, 1.501, -9.778), angle = Angle(76.043, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end

end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_smg1.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_smg1.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_SMG1.Single")
SWEP.Primary.Recoil			= 6
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.07
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Cone			= 0.05 -- 0.05
SWEP.ConeMoving				= 0.13 -- 0.16
SWEP.ConeCrouching			= 0.04 -- 0.05
SWEP.MaxBulletDistance 		= 3500
SWEP.MaxAmmo			    = 250
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.Cone = 0.05
SWEP.ConeMoving = 0.07
SWEP.ConeCrouching = 0.03
SWEP.ConeIron = 0.07
SWEP.ConeIronCrouching = 0.05

SWEP.WalkSpeed = 185

SWEP.IronSightsPos 		= Vector( -6.44, -11, 2.55 )
SWEP.IronSightsAng 		= Vector( 0, 0, 0 )

