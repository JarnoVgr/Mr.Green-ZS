if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "weapon_zs_base_dummy"

SWEP.HoldType = "slam"

if ( CLIENT ) then
	SWEP.PrintName = "Pack of Planks"
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	
	killicon.AddFont( "weapon_zs_tools_plank", "HL2MPTypeDeath", "9", Color(255, 255, 255, 255 ) )
	
	--SWEP.NoHUD = true
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true

	
end

SWEP.Author = "NECROSSIN"

SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/props_junk/propane_tank001a.mdl"



SWEP.Slot = 3
SWEP.SlotPos = 3 

-- SWEP.Info = ""

SWEP.Primary.ClipSize =4
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Automatic = false
--SWEP.Primary.Ammo = "none"
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 2.0

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "SniperRound"
SWEP.Secondary.Delay = 0.15

SWEP.WalkSpeed = 175

function SWEP:InitializeClientsideModels()
	

	self.ViewModelBoneMods = {
		["v_weapon.Left_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -5.975, 0) },
		["v_weapon.Left_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27, 0) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-13.825, 2.549, -5.014) },
		["v_weapon.Left_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.261, 0) },
		["v_weapon.Left_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(12.512, -10, -29.639) },
		["v_weapon.Left_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -6.244, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.136, 0), angle = Angle(5.625, 23.011, 15.069) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(15.824, 11.439, 14.48) },
		["v_weapon.Left_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 5.23, 0) },
		["v_weapon.Left_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(23.357, 19.294, -17.288) },
		["v_weapon.Left_Middle02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 22.256, 0) },
		["v_weapon.Left_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.168, 0) },
		["v_weapon.c4"] = { scale = Vector(0.002, 0.002, 0.002), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-7.238, 12.175, -3.358), angle = Angle(58.224, -14.443, 76.694) }
	}




	self.VElements = {
		["plank"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(-3.619, 0.218, 0.619), angle = Angle(6.836, 48.5, -10.445), size = Vector(0.31, 0.31, 0.31), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.WElements = {
		["plank"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.288, 4.263, 0), angle = Angle(52.837, -1.726, 0), size = Vector(0.5, 0.437, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

function SWEP:OnDeploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	
	local aimvec = self.Owner:GetAimVector()
	local shootpos = self.Owner:GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = self.Owner})

	self:SetNextPrimaryFire(CurTime() + 2)

	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(75, 80))
	
	if SERVER then
		local ent = ents.Create("prop_physics_multiplayer")
		if IsValid(ent) then
			ent:SetPos(tr.HitPos)
			ent:SetAngles(aimvec:Angle())
			ent:SetModel("models/props_debris/wood_board06a.mdl")
			ent:Spawn()
			local hp = 350
			--if self.Owner:GetPerk("_plankhp") then
			if self.Owner:GetPerk("_Support(MK1)") then
				hp = hp+hp*0.5
			end			
			ent:SetHealth(hp)
			ent.PropHealth = hp
			ent.PropMaxHealth = hp
			
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMass(30)
			
				phys:SetVelocityInstantaneous(self.Owner:GetVelocity())
			end
			ent:SetPhysicsAttacker(self.Owner)
			self:TakePrimaryAmmo(1)
		end
	end
	
	--[[if SERVER then		
		if self and self:IsValid() and self.Weapon:Clip1() < 1 then
			DropWeapon(self.Owner)
		end
	end]]--
end

function SWEP:Equip ( NewOwner )
	if CLIENT then return end
	
	--if self.Owner:GetPerk("_plankamount") then
	if self.Owner:GetPerk("_Support(MK1)") then
		self.Weapon:SetClip1( 5 ) 	
	end
	
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end
	
function SWEP:Reload() 
	return false
end  
 
function SWEP:SecondaryAttack()
return false
end 


function SWEP:_OnDrop()
	if SERVER then
		if self and self:IsValid() then
			self:Remove()
		end
	end
end