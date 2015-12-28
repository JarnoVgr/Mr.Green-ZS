-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
AddCSLuaFile()
--[[
if CLIENT then
	SWEP.PrintName = "Pulse SMG"
	SWEP.Author	= "NECROSSIN and Deluvas"	
	SWEP.Slot = 5
	SWEP.SlotPos = 14
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
	SWEP.IconLetter = "/"
	SWEP.SelectFont = "HL2MPTypeDeath"
	
	SWEP.VElements = {
	["thingy2"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01", rel = "disp", pos = Vector(-0.719, -0.694, 3.319), angle = Angle(0, -91.975, -0.051), size = Vector(0.115, 0.115, 0.229), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["disp"] = { type = "Model", model = "models/props_combine/Combine_Dispenser.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.744, -0.399, -4.869), angle = Angle(0, 0, 0), size = Vector(0.059, 0.041, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["thingy"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01", rel = "disp", pos = Vector(0.018, 0.03, 9.244), angle = Angle(-0.689, -180, 1.194), size = Vector(0.159, 0.159, 0.159), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sights"] = { type = "Model", model = "models/props_combine/combine_bridge.mdl", bone = "ValveBiped.Bip01", rel = "disp", pos = Vector(-0.708, -2.895, -3.908), angle = Angle(-91.269, 90.231, 180), size = Vector(0.013, 0.013, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
	["thingy2"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "disp", pos = Vector(-0.77, -0.945, 2.23), angle = Angle(0, -91.975, -0.051), size = Vector(0.115, 0.159, 0.216), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["thingy"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "disp", pos = Vector(0.018, 0.03, 9.244), angle = Angle(-0.689, -180, 1.194), size = Vector(0.159, 0.159, 0.159), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["disp"] = { type = "Model", model = "models/props_combine/Combine_Dispenser.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.086, 2.213, -4.838), angle = Angle(0, -90.495, -100.344), size = Vector(0.059, 0.041, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sights"] = { type = "Model", model = "models/props_combine/combine_bridge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "disp", pos = Vector(-0.708, -2.895, -3.908), angle = Angle(-91.269, 88.111, 180), size = Vector(0.013, 0.013, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	killicon.AddFont("weapon_zs_pulsesmg", "HL2MPTypeDeath", SWEP.IconLetter, Color(0, 96, 255, 255 ))
end]]

if CLIENT then

SWEP.PrintName = "Pulse Rifle"
SWEP.Author	= "NECROSSIN and Deluvas and Duby and BrainDawg"	
SWEP.Slot = 5
SWEP.SlotPos = 14
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.IconLetter = "/"
SWEP.SelectFont = "HL2MPTypeDeath"

SWEP.HoldType = "smg"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}

end

SWEP.Base				= "weapon_zs_base"
SWEP.HumanClass = "engineer"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModel = Model("models/weapons/c_irifle.mdl")
SWEP.WorldModel = "models/weapons/w_irifle.mdl" 
SWEP.UseHands = true
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("Weapon_AR2.Single")
SWEP.Primary.Recoil			= 1.1
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 40
SWEP.Primary.Delay			= 0.1
SWEP.Primary.Automatic		= true
SWEP.TracerName = "AR2Tracer"

SWEP.Primary.Ammo			= "none"

SWEP.Cone 			= 0.05
SWEP.ConeMoving		 = SWEP.Cone *1.3
SWEP.ConeCrouching 	 = SWEP.Cone *0.90
SWEP.ConeIron 		 = SWEP.Cone *0.95
SWEP.ConeIronCrouching   	= SWEP.ConeCrouching *0.9
SWEP.ConeIronMoving	 = SWEP.ConeMoving *0.9

SWEP.IronSightsPos = Vector(-2, -4, 1.5)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.WalkSpeed = SPEED_SMG
SWEP.fired = false
SWEP.lastfire = 0
SWEP.rechargetimer = 0
SWEP.rechargerate = 0.65
SWEP.startcharge = 1
SWEP.MaxClip = 40

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
				self.MaxClip = 40 + (40*(5*self:GetOwner():GetRank())/100)
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