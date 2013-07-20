-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "'Classic' Pistol"
	SWEP.Author = "NECROSSIN"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.ViewModelFlip = true
	SWEP.ViewModelFOV = 60
	
	SWEP.ShowViewModel = false
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = true
	SWEP.ScaleDownLeftHand = true
	SWEP.ScaleDownRightHand = true
	
	SWEP.OverrideAngle = {}
	SWEP.OverrideAngle["ValveBiped.Bip01_R_Finger22"] = Angle(0,-100,0)
	SWEP.OverrideAngle["ValveBiped.Bip01_R_Finger32"] = Angle(0,-100,0)
	SWEP.OverrideAngle["ValveBiped.Bip01_R_Finger12"] = Angle(0,-20,0)

	
	killicon.AddFont( "weapon_zs_classic", "HL2MPTypeDeath", "-", Color(255, 255, 255, 255 ) )
end

if XMAS_2012 then

	function SWEP:InitializeClientsideModels()
	
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(-0.015, 1.549, -3.501), angle = Angle(90, -90, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		self.WElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.096, 1.309, -0.142), angle = Angle(-4.802, -2.119, 170.483), size = Vector(0.529, 0.529, 0.529), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
		
	end
else
	function SWEP:InitializeClientsideModels()
	
		self.VElementsBoneMods = {
			["pistol"] = { 
				["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
				["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
				["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
				["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
				["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
				["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
				["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
				["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
				["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
				},
		}
		
		self.ViewModelBoneMods = {
			["v_weapon.Glock_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
			["v_weapon.Glock_Slide"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
			["v_weapon.Glock_Trigger"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
		}

		self.VElements = {
			["pistol"] = { type = "Model", model = "models/Weapons/v_Pistol.mdl", bone = "v_weapon.Glock_Parent", rel = "", pos = Vector(21.309, -0.937, -4.917), angle = Angle(-1.137, -162.407, -99.919), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		}
		
		self.WElements = {}
		
	end

end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel = Model("models/weapons/v_pist_glock18.mdl")-- Model("models/weapons/v_pistol.mdl")
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")

SWEP.Weight				= 5

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound("Weapon_Pistol.NPC_Single")
SWEP.ReloadSound 			= Sound("Weapon_Pistol.Reload")
SWEP.Primary.Recoil			= 10.5
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 2
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.2
SWEP.Primary.DefaultClip	= 32
SWEP.MaxAmmo			    = 160
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.06 --0.12
SWEP.ConeMoving				= 0.08 -- 0.18
SWEP.ConeCrouching			= 0.04 -- 0.06
SWEP.WalkSpeed = 200

SWEP.Cone = 0.055
SWEP.ConeMoving = 0.075
SWEP.ConeCrouching = 0.035
SWEP.ConeIron = 0.50
SWEP.ConeIronCrouching = 0.030

--[==[SWEP.IronSightsPos = Vector(-5.85, -3,4, 0)
SWEP.IronSightsAng = Vector(0.15, -1, 1.5)]==]

SWEP.IronSightsPos = Vector(4.38, -1.951, 2.68)
SWEP.IronSightsAng = Vector(0, -0.21, 0)


