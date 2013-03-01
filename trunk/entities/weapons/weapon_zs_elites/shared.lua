if SERVER then
	AddCSLuaFile("shared.lua")

end

if CLIENT then
	SWEP.PrintName = "Dual Elites"			
	SWEP.Author	= "ClavusElite" -- modified a bit for zs
	SWEP.Slot = 1
	SWEP.SlotPos = 6
	SWEP.IconLetter = "s"
	killicon.AddFont("weapon_zs_elites", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false


	
	//SWEP.ViewModelBonescales = {["v_weapon.Left_Arm"] = Vector(1, 1, 1), ["v_weapon.Right_Arm"] = Vector(1, 1, 1)}
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ("models/weapons/v_pist_elite.mdl")
SWEP.WorldModel			= Model ("models/weapons/w_pist_elite.mdl")

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.HoldType = "duel"
SWEP.IronSightsHoldType = "duel"
SWEP.Primary.Sound			= Sound("Weapon_ELITE.Single")
SWEP.Primary.Recoil			= 9
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.15
SWEP.Primary.DefaultClip	= 50
SWEP.MaxAmmo			    = 100
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.08
SWEP.ConeMoving				= 0.1
SWEP.ConeCrouching			= 0.045

SWEP.Cone = 0.075
SWEP.ConeMoving = 0.1
SWEP.ConeCrouching = 0.075
SWEP.ConeIron = 0.05
SWEP.ConeIronCrouching = 0.04

SWEP.WalkSpeed = 195
--SWEP.IronSightsPos = Vector(0,0,0)
--SWEP.IronSightsAng = Vector(0,0,0)
--SWEP.IronSightsPos = Vector(0, -0.094, 1.205)
--SWEP.IronSightsAng = Vector(0, 0, 0)

--SWEP.IronSightsPos = Vector(0, 1.118, 2.131)
--SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.IronSightsPos = Vector(-0, 1.213, 1.019)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:InitializeClientsideModels()
	
	if XMAS_2012 then
		self.VElements = {
			["lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.slide_left", rel = "", pos = Vector(-0.038, -1.732, -5.624), angle = Angle(93.946, 90, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} },
			["lights2"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.slide_right", rel = "", pos = Vector(0.181, -1.696, 2.497), angle = Angle(-86.361, -90.888, 0), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(0,1), bodygroup = {} }
		}
	else
		self.VElements = {}
	end
	
	self.WElements = {
		["elite1"] = { type = "Model", model = "models/weapons/w_pist_elite_single.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(-0.894, 0.669, 0.006), angle = Angle(-0.32, -2.125, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["elite2"] = { type = "Model", model = "models/weapons/w_pist_elite_single.mdl", bone = "ValveBiped.Bip01_L_Hand", pos = Vector(-0.35, 1.031, -0.633), angle = Angle(0, -19.07, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	//Fixing outdated stuff
	self.ViewModelBoneMods = {
		["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	
end

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(self:Clip1() % 2 == 0 and ACT_VM_PRIMARYATTACK or ACT_VM_SECONDARYATTACK)
end

//KF style Ironsights :D
if CLIENT then
local vec = 1
function SWEP:Think()
	if self:GetIronsights() == true then 
		vec = math.Approach(vec, 1.631, FrameTime())
		self.ViewModelBoneMods["v_weapon.Left_Arm"].scale = Vector(vec,vec,vec)
		self.ViewModelBoneMods["v_weapon.Right_Arm"].scale = Vector(vec,vec,vec)
	elseif self:GetIronsights() == false or self.Weapon:Clip1() <= 1 then
		vec = math.Approach(vec,1, FrameTime())
		self.ViewModelBoneMods["v_weapon.Left_Arm"].scale = Vector(vec,vec,vec)
		self.ViewModelBoneMods["v_weapon.Right_Arm"].scale = Vector(vec,vec,vec)
	end
end
end
/*
function SWEP:OnDeploy()
	
	self.Owner:StopAllLuaAnimations()
	self.Owner:SetLuaAnimation("ElitesHoldtype")

	if CLIENT then
		MakeNewArms(self)
	end
	
end

function SWEP:Holster()
	self:SetIronsights( false ) 
	self.Owner:StopLuaAnimation("ElitesHoldtype") 
	
	
	return true
end

function SWEP:OnRemove()

    self.Owner:StopLuaAnimation("ElitesHoldtype")     

    if CLIENT then
        self:RemoveModels()
		
		RemoveNewArms(self)
    end
end
*/
--Register the animation------------

RegisterLuaAnimation('ElitesHoldtype', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 39,
					RR = 360,
					RF = 55
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = 5
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RF = 5
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -10,
					RR = -31,
					RF = 10
				}
			},
			FrameRate = 1
		}
	},
	Type = TYPE_POSTURE
})
