-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.PrintName = "Mobile Supplies"

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.DrawCrosshair = false
	SWEP.IconLetter = "V"
	
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = true
	SWEP.IgnoreBonemerge = true
	
	function SWEP:DrawHUD()
		MeleeWeaponDrawHUD()
	end	
	
	--Killicon
	killicon.AddFont("weapon_zs_tools_supplies", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255))
end

SWEP.Base = "weapon_zs_base_dummy"

SWEP.Author	= "NECROSSIN"	

SWEP.Slot = 4
SWEP.Weight = 6
SWEP.Type = "Deployable"

SWEP.Info = "Left click to place a Mobile Supplies"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel = Model("models/weapons/cstrike/c_c4.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/Items/item_item_crate.mdl")

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "normal"

SWEP.Primary.Delay			= 0.9 	
SWEP.Primary.Recoil			= 0		
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1		
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"	

SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"

local ShootSound = Sound("items/ammo_pickup.wav")
local FailSound = Sound("buttons/combine_button_locked.wav")

function SWEP:InitializeClientsideModels()
	self.VElements = {
	--	["crate"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, -90), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		["crate"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(-2, 0, 0), angle = Angle(0, 0, -90), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.ViewModelBoneMods = {
		["v_weapon.c4"] = { scale = Vector(0.01,0.01, 0.01), pos = Vector(-10.555, -12.747, -0.622), angle = Angle(9.326, 7.46, 37.305) },
		["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -48.498, 0) },
	--	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(46.631, -33.576, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.631, -33.576, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(29.844, 26.114, -39.172) },
	--	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-5.597, 9.326, 0), angle = Angle(11.192, 0, -63.42) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-4.041, 0.31, -5.908), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-3.731, 27.979, -18.653) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -24.25, 0) },
		["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0, -7.461, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.192, 0, 0) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(13.057, 0, 0) },
		["v_weapon.button0"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button7"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button8"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button9"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	}
end

SWEP.AmmoMode = {
	[1] = {
		Name = "Automatic",
		Time = 75,
		Type = {
			["ar2"] = {Amount = 90, Icon = "V"},
			["smg1"] = {Amount = 90, Icon = "W"},
			["buckshot"] = {Amount = 40, Icon = "J"},
		}
	},
	[2] = {
		Name = "Pistol",
		Time = 40,
		Type = {
			["pistol"] = {Amount = 40, Icon = "R"},
			["357"] = {Amount = 25, Icon = "T"},
		}
	}
}

-- Call this function to update weapon slot and others
function SWEP:Equip(NewOwner)
	if not SERVER then
		return
	end
	
	if SERVER then
		self.Owner.Weight = self.Owner.Weight + self.Weight
		self.Owner:CheckSpeedChange()
	end
	
	gamemode.Call("OnWeaponEquip", NewOwner, self)
end

function SWEP:OnInitialize()
	self.FirstThink = false
end

function SWEP:Think()
	if not SERVER then
		return
	end
	
	if self.FirstThink then
		local owner = self.Owner
		local effectdata = EffectData()
		effectdata:SetEntity(owner)
		effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 32 + Vector(0,0,20))
		effectdata:SetNormal(owner:GetAimVector())
		util.Effect("crateghost", effectdata, true, true)
		self.FirstThink = false
	end

	
end

function SWEP:OnDeploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

	if SERVER then
		self.FirstThink = true
	end
end

function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or (self.Owner.IsHolding and self.Owner:IsHolding()) then
		return
	end

	--Set next primary fire
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.65)

	

	
	if SERVER then
		local vecAim = self.Owner:GetAimVector()
		local posShoot = self.Owner:GetShootPos()
	
		local tr = util.TraceLine({start = posShoot, endpos = posShoot+100*vecAim, filter = self.Owner})
	
		local canPlaceCrate = false

		--Check if we really need to draw the crate
		if tr.HitPos and tr.HitWorld and tr.HitPos:Distance(self.Owner:GetPos()) > 28 then
			--Check traceline position area
			local hTrace = util.TraceHull({start = tr.HitPos, endpos = tr.HitPos, mins = Vector(-26,-26,0), maxs = Vector(26,26,25)})

			if hTrace.Entity == NULL then
				canPlaceCrate = true
			end
		end

		if canPlaceCrate then
			--Check distance to Supply Crates
			for _, Ent in pairs(ents.FindByClass("game_supplycrate")) do
				if tr.HitPos:Distance(Ent:GetPos()) <= 100 then
					self.Owner:Message("Place the Mobile Supplies further away from the Supply Crate", 2)
					canPlaceCrate = false
					break
				end
			end
		end

		--Exit when cannot place
		if not canPlaceCrate then
			return
		end

		--Display animation
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		--Create entity
		local angles = vecAim:Angle()
		local ent = ents.Create("game_mobilesupplycrate")
		if (ent ~= nil and ent:IsValid()) then
			--Logging, Note to Clavus - add crate logging
			--log.PlayerAction( self.Owner, "place_turret")
			
			ent:SetPos(Vector(tr.HitPos.x,tr.HitPos.y,tr.HitPos.z+17))
			ent:SetAngles(Angle(0,angles.y,angles.r))
			ent:SetPlacer(self.Owner)
			ent:Spawn()
			ent:Activate()
			ent:EmitSound(Sound("npc/roller/blade_cut.wav"))
			self.Owner.Crate = ent
			self:TakePrimaryAmmo(1)
							
			if self and self:IsValid() then
				--self.Owner.Weight = self.Owner.Weight - self.Weight	
				DropWeapon(self.Owner)	
				self:Remove()				
				
			end
		end
	end
end

function SWEP:SecondaryAttack()
	return false
end
--[[
function SWEP:_OnDrop()
	if not SERVER then
		return
	end
	
	if self and self:IsValid() then
		self:Remove()
	end
end
]]--