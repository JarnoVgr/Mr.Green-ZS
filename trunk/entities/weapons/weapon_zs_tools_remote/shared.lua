if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.PrintName = "Remote"
end

SWEP.HoldType = "pistol"

if ( CLIENT ) then
	SWEP.PrintName = "Remote"
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.Slot = 3
	SWEP.SlotPos = 1 
	
	killicon.AddFont("weapon_zs_tools_remote", "CSKillIcons", "D", Color(255, 255, 255, 255 ))
	function SWEP:DrawHUD()
		MeleeWeaponDrawHUD()
	end
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	SWEP.IgnoreBonemerge = true

	
	
end

SWEP.Author = "NECROSSIN"

SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

//SWEP.Info = ""

SWEP.Base				= "weapon_zs_base_dummy"

SWEP.Primary.ClipSize =1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 2.0

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "CombineCannon"
SWEP.Secondary.Delay = 0.15

SWEP.WalkSpeed = 190

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["v_weapon.Right_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 15.75, 0) },
		["v_weapon.button0"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0.847, 0.479, 1.274), angle = Angle(-18.567, -0.868, -6.81) },
		["v_weapon.button6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button9"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-31.361, 17.051, -7.96) },
		["v_weapon.button2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.c4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-1.867, -30, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Left_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 41.122, 0) },
		["v_weapon.button8"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Left_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 10.953, 0) },
		["v_weapon.Left_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 5.278, 0) },
		["v_weapon.Left_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(26.527, 30.117, -1.349) },
		["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(3.184, 8.116, -3.767), angle = Angle(27.763, -12.801, -26.563) },
		["v_weapon.button1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.591, 10.23, 7.918) },
		["v_weapon.button4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button7"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	
	self.VElements = {
		["part1+"] = { type = "Model", model = "models/props_lab/reciever01b.mdl", bone = "v_weapon", rel = "hand", pos = Vector(-2.758, -0.019, 0.256), angle = Angle(4.462, -86.359, -0.524), size = Vector(0.268, 0.268, 0.268), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["part1"] = { type = "Model", model = "models/props_lab/reciever01b.mdl", bone = "v_weapon", rel = "hand", pos = Vector(2.151, -0.26, 0.282), angle = Angle(4.462, -86.359, -0.524), size = Vector(0.268, 0.268, 0.268), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hand"] = { type = "Model", model = "models/Weapons/W_pistol.mdl", bone = "v_weapon.Right_Hand", rel = "", pos = Vector(5.271, -1.137, -2.896), angle = Angle(23.625, 164.044, 101.749), size = Vector(0.882, 0.882, 0.882), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["part2"] = { type = "Model", model = "models/props_c17/grinderclamp01a.mdl", bone = "v_weapon", rel = "hand", pos = Vector(-0.922, -0.543, 0.546), angle = Angle(-5.014, 90.796, -87.232), size = Vector(0.579, 0.579, 0.579), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.WElements = {
		["part1"] = { type = "Model", model = "models/props_lab/reciever01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "hand", pos = Vector(-0.494, -0.132, 0.606), angle = Angle(4.776, -86.643, -1.063), size = Vector(0.224, 0.578, 0.344), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hand"] = { type = "Model", model = "models/Weapons/W_pistol.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.619, 1.575, -3.425), angle = Angle(-180, 0, 0), size = Vector(0.899, 1.075, 1.286), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["part2"] = { type = "Model", model = "models/props_c17/grinderclamp01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "part1", pos = Vector(-0.262, 3.061, 0.592), angle = Angle(0, -180, -90), size = Vector(0.33, 0.33, 0.33), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

function SWEP:OnDeploy()
	if SERVER then
		if self.Owner.Turret and ValidEntity(self.Owner.Turret) then
			if self.Owner.Turret:GetTable() then
				self.Owner.Turret:GetTable():SetControl(true)
			end
		end
	end
	//Draw animation
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:_OnRemove()
	if SERVER then
		if self.Owner.Turret and ValidEntity(self.Owner.Turret) then
			if self.Owner.Turret:GetTable() then
				self.Owner.Turret:GetTable():SetControl(false)
			end
		end
	end     
end

function SWEP:_OnDrop()
	if SERVER then
		if self.Owner.Turret and ValidEntity(self.Owner.Turret) then
			if self.Owner.Turret:GetTable() then
				self.Owner.Turret:GetTable():SetControl(false)
			end
		end
	end
end

function SWEP:OnHolster()
	if SERVER then
		if self.Owner.Turret and ValidEntity(self.Owner.Turret) then
			if self.Owner.Turret:GetTable() then
				self.Owner.Turret:GetTable():SetControl(false)
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	self.Weapon:SetNextPrimaryFire ( CurTime() + 0.65 )	
end
	
 function SWEP:Reload() 
	return false
 end  

function SWEP:SecondaryAttack()
	return false
end 