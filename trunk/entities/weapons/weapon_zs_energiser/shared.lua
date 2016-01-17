-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
AddCSLuaFile()
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false


if CLIENT then
	SWEP.PrintName = "Energiser"
	SWEP.Author	= "Braindawg"	
	SWEP.IconLetter = "/"
	SWEP.SelectFont = "HL2MPTypeDeath"
	
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0.604, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(3.313, -2.029, -0.288), angle = Angle(1.784, 0, 0) },
		["ValveBiped.base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -27.358, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(4.771, -1.787, -3.855), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 75.274, 0) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 41.097, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.512, -27.164, 35.742) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.031, 1.031, 1.031), pos = Vector(0, -0.181, 0), angle = Angle(0, -21.049, 42.616) }
	}	

	SWEP.VElements = {
		["Pulse Rifle"] = { type = "Model", model = "models/props_combine/bunker_gun01.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(1.8, 15.876, 4.991), angle = Angle(85.933, -82.482, -0.181), size = Vector(1.075, 1.06, 0.97), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}


	SWEP.WElements = {
		["pulse rifle"] = { type = "Model", model = "models/props_combine/bunker_gun01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.866, 1.685, 6.893), angle = Angle(-7.947, 0.086, -180), size = Vector(1.027, 0.947, 0.924), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	--c:AddModel("models/props_combine/bunker_gun01.mdl", Vector(10.866, 1.685, 6.893), Angle(-7.947, 0.086, -180), "ValveBiped.Bip01_R_Hand", Vector(1.027, 0.947, 0.924), nil, nil)

	
	killicon.AddFont("weapon_zs_energiser", "HL2MPTypeDeath", SWEP.IconLetter, Color(0, 96, 255, 255 ))
end

SWEP.HoldType = "smg"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.Base				= "weapon_zs_base"
SWEP.HumanClass = 		"engineer"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.UseHands = true
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound = Sound("Airboat.FireGunHeavy")
SWEP.Primary.Recoil			= 1.8
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 10
SWEP.Primary.Delay			= 0.21
SWEP.Primary.Automatic		= true
SWEP.TracerName = "AR2Tracer"

SWEP.Primary.Ammo			= "none"

SWEP.Cone 			= 0.04
SWEP.ConeMoving		 = SWEP.Cone *1.4
SWEP.ConeCrouching 	 = SWEP.Cone *0.90
SWEP.ConeIron 		 = SWEP.Cone *0.95
SWEP.ConeIronCrouching   	= SWEP.ConeCrouching *0.9
SWEP.ConeIronMoving	 = SWEP.ConeMoving *0.9

SWEP.IronSightsPos = Vector(-6.68, -7.976, 2.2)
SWEP.IronSightsAng = Vector(0, -0.021, -4.286)

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.WalkSpeed = SPEED_RIFLE
SWEP.fired = false
SWEP.lastfire = 0
SWEP.rechargetimer = 0
SWEP.rechargerate = 0.65
SWEP.startcharge = 0.25
SWEP.MaxClip = 10

function SWEP:Think()
	if SERVER then
		local ply = self.Owner
		
		
		
		if ply:KeyDown(IN_ATTACK) then
			if not self.fired then
				self.fired = true
			end

			self.lastfire = CurTime()
		else
		
			if self:GetOwner():GetPerk("Engineer") then
				self.MaxClip = 10 + (10*(5*self:GetOwner():GetRank())/100)
				self.rechargerate = 0.65 - (0.65*(2*self:GetOwner():GetRank())/100)				
			end
			
			if (CurTime() - self.startcharge) > self.lastfire and CurTime() > self.rechargetimer then
				self.Weapon:SetClip1(math.min(self.MaxClip, self.Weapon:Clip1() + 1))
				self.rechargerate = 0.1
				self.rechargetimer = CurTime() + self.rechargerate 
				
			end
			if self.fired then 
				self.fired = false
			end
		end
	end

	return self.BaseClass.Think(self)
end

function SWEP:Reload()
	return false
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(0.8)
		e:SetMagnitude(0.2)
		e:SetScale(0.2)
	util.Effect("cball_bounce", e)

	GenericBulletCallback(attacker, tr, dmginfo)
end