if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "weapon_zs_base_dummy"

SWEP.HoldType = "slam"

if ( CLIENT ) then
	SWEP.PrintName = "Ammo Pack"
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	
	killicon.AddFont( "weapon_zs_tools_plank", "HL2MPTypeDeath", "9", Color(255, 255, 255, 255 ) )
	
	--SWEP.NoHUD = true
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true
	SWEP.UseHands = true
	
end

SWEP.Author = "NECROSSIN"

SWEP.ViewModel = Model("models/weapons/cstrike/c_c4.mdl")
--SWEP.ViewModel  = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = Model("models/items/boxmrounds.mdl")

SWEP.Slot = 5
SWEP.SlotPos = 1 

-- SWEP.Info = ""
SWEP.HumanClass = "support"
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1
SWEP.ShowViewModel = false
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.15

SWEP.WalkSpeed = SPEED_MELEE

function SWEP:InitializeClientsideModels()
	self.VElements = {
	--	["crate"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, -90), size = Vector(0.3, 0.3, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		["crate"] = { type = "Model", model = "models/items/boxmrounds.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(9, 5, 14), angle = Angle(0, 0, -90), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.ViewModelBoneMods = {
		["v_weapon.c4"] = { scale = Vector(0.01,0.01, 0.01), pos = Vector(-10.555, -12.747, -0.622), angle = Angle(9.326, 7.46, 37.305) },
	
		["v_weapon.button0"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button1"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button2"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button3"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button4"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button5"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button6"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button7"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button8"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button9"] = { scale = Vector(0.001, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	}
end

function SWEP:OnInitialize()
	if SERVER then
		self.Weapon.FirstSpawn = true
	end	
end

function SWEP:OnDeploy()

	if (self.Weapon.FirstSpawn) then
		self:SetClip1(self:Clip1()+ (self.Owner:GetRank() * 0.5))
		self.Weapon.FirstSpawn = false
	end
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	
	local aimvec = self.Owner:GetAimVector()
	local shootpos = self.Owner:GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = self.Owner})

	if self and self:IsValid() and self.Weapon:Clip1() < 1 then
		return
	end
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(75, 80))
	
	if SERVER then
		local ent = ents.Create("zs_ammobox")
		if IsValid(ent) then
			ent:SetPos(tr.HitPos)
			ent:SetAngles(aimvec:Angle())
			ent:Spawn()
			self:TakePrimaryAmmo(1)
		end
	end
end

function SWEP:EmitFireSound()
		self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(75, 80))
end
function SWEP:Reload() 
	return false
end  
 
function SWEP:SecondaryAttack()
return false
end 
