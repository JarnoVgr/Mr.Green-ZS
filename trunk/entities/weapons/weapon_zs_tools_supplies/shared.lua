-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.PrintName = "Mobile Supplies"

if CLIENT then
	SWEP.Slot = 4
	SWEP.SlotPos = 1 
	SWEP.ViewModelFlip = false
	SWEP.DrawCrosshair = false
	SWEP.IconLetter = "V"

	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.IgnoreBonemerge = true
	
	function SWEP:DrawHUD()
		MeleeWeaponDrawHUD()
	end	
	
	--Killicon
	killicon.AddFont("weapon_zs_tools_supplies", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base = "weapon_zs_base_dummy"

SWEP.Author	= "NECROSSIN"	

SWEP.ViewModelFOV = 65

SWEP.Info = "Left click to place a Mobile Supplies"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "normal"

SWEP.Primary.Delay			= 0.9 	
SWEP.Primary.Recoil			= 0		
SWEP.Primary.Damage			= 7	
SWEP.Primary.NumShots		= 1		
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"	

SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 6
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"

SWEP.WalkSpeed = 200

local ShootSound = Sound("items/ammo_pickup.wav")
local FailSound = Sound("buttons/combine_button_locked.wav")

function SWEP:InitializeClientsideModels()
	self.ViewModelBoneMods = {
		--["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-11.089, -16.17, 4.663) },
		["v_weapon.c4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
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
		--["v_weapon.Left_Arm"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		--["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-0.594, 3.637, 2.168), angle = Angle(0, 0.324, 13.687) }
	}

	
	--[[self.VElements = {
		["crate"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(-2.681, 1.43, 0.307), angle = Angle(-1.67, -3.294, -108.269), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}]]
	
	self.WElements = {
		["crate"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.105, 4.942, -0.801), angle = Angle(-160.631, 95.724, -54.231), size = Vector(0.203, 0.146, 0.123), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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
		effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 32)
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
		local aimvec = self.Owner:GetAimVector()
		local shootpos = self.Owner:GetPos()+Vector(aimvec.x,aimvec.y,0)*25+Vector(0,0,1)
		local canPlaceCrate = false
		
		local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 70, filter = self.Owner})

		local htrace = util.TraceHull({start = tr.HitPos, endpos = tr.HitPos, mins = Vector (-28,-28,0), maxs = Vector (28,28,25)})
		local trground = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos - Vector(0,0,1.5)})
		
		--Check if we hit world
		if trground.HitWorld then
			canPlaceCrate = true
		else
			canPlaceCrate = false
		end
		
		--Check distance to Supply Crates
		for _, point in pairs(RealCrateSpawns) do
			if tr.HitPos then
				if tr.HitPos:Distance(point) < 80 then
					self.Owner:Message("You must place the crate 80 units away from a Supply Crate",1,"white")
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
		local angles = aimvec:Angle()
		local ent = ents.Create("zs_ammobox")
		if (ent ~= nil and ent:IsValid()) then
			--Logging, Note to Clavus - add crate logging
			--log.PlayerAction( self.Owner, "place_turret")
			
			ent:SetPos(tr.HitPos)
			ent:SetAngles(Angle(0,angles.y,angles.r))
			ent:SetPlacer(self.Owner)
			ent:Spawn()
			ent:Activate()
			ent:EmitSound("npc/roller/blade_cut.wav")
			self.Owner.Crate = ent
			self:TakePrimaryAmmo(1)
							
			if self and self:IsValid() then
				DropWeapon(self.Owner)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:_OnDrop()
	if not SERVER then
		return
	end
	
	if self and self:IsValid() then
		self:Remove()
	end
end