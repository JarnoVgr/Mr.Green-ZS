AddCSLuaFile()
--SWEP.PrintName = "Turret Placer"
SWEP.PrintName = "Turret"

SWEP.HoldType = "melee"

if CLIENT then
	
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	
	--killicon.AddFont( "weapon_zs_turretplacer", "CSKillIcons", "C", Color(255, 80, 0, 255 ) )
	killicon.Add("weapon_zs_turretplacer", "killicon/turret", Color(255, 80, 0, 255 ) )
	killicon.Add("weapon_zs_miniturret", "killicon/turret", Color(255, 80, 0, 255 ) )
	
	SWEP.NoHUD = true
	
	SWEP.IgnoreBonemerge = true
	SWEP.UseHL2Bonemerge = true
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	
end

SWEP.Author = "NECROSSIN"

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/Combine_turrets/Floor_turret.mdl"
SWEP.UseHands = true
SWEP.Base				= "weapon_zs_base_dummy"

SWEP.Slot = 5
SWEP.SlotPos = 1 

-- SWEP.Info = ""
SWEP.HumanClass = "engineer"
SWEP.Primary.ClipSize =1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 2.0

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "SniperRound"
SWEP.Secondary.Delay = 0.15

SWEP.WalkSpeed = SPEED_MELEE_HEAVY

function SWEP:InitializeClientsideModels()
	

	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -34.1, 0) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -18.857, -11.02) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -330), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(-0.445, 0, 0), angle = Angle(0, 0.163, 28.575) },
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -16.306, -24.607) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(24.756, 17.6, -12.756) },
		["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -9.813, 0) },
		["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -34.088, -1.82) },
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.082, 7.224, 0) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -16.706, 0) },
		-- ["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(5.169, 3.28, 6.412), angle = Angle(20.525, -7.2, -0.963) },
		["ValveBiped.Bip01_R_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -25.382, 0) },
		["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -38.5, 0) },
		["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10.938, 12.024) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -17.157, -23.581) }
	}

	
	self.VElements = {
		["turret"] = { type = "Model", model = "models/Combine_turrets/Floor_turret.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-1.157, -0.394, 5.236), angle = Angle(177.162, 169.962, 2), size = Vector(0.17, 0.17, 0.17), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	
	self.WElements = {
		["turret"] = { type = "Model", model = "models/Combine_turrets/Floor_turret.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.868, 3.006, 2.887), angle = Angle(2.849, -25.081, -151.706), size = Vector(0.128, 0.128, 0.128), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["turret_light"] = { type = "Sprite", sprite = "models/roller/rollermine_glow", bone = "ValveBiped.Bip01_R_Hand", rel = "turret", pos = Vector(0.955, 0.28, 7.58), size = { x = 1, y = 1 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	}
	

	
end

function SWEP:Precache()
	util.PrecacheSound("npc/roller/blade_cut.wav")
	
	util.PrecacheModel(self.ViewModel)
end

function SWEP:OnInitialize()
	if SERVER then
		--rotation
		self:SetDTInt(0,0)
	end
end

function SWEP:OnDeploy()
	if SERVER then
		if not self:CanPrimaryAttack() then return end
		local owner = self.Owner
		local effectdata = EffectData()
		effectdata:SetEntity(owner)
		effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 32)
		effectdata:SetNormal(owner:GetAimVector())
		util.Effect("turretghost", effectdata, nil, true)
	end
	self.Owner:DrawViewModel(false)
end

function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	if not self:CanPrimaryAttack() then return end
	self.Weapon:SetNextPrimaryFire ( CurTime() + 0.65 )
if SERVER then
	 	
	local aimvec = self.Owner:GetAimVector()
	local shootpos = self.Owner:GetPos()+Vector(0,0,32)
	local CanCreateTurret = false

	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 70, filter = self.Owner})

	local htrace = util.TraceHull ( { start = tr.HitPos, endpos = tr.HitPos, mins = Vector (-24,-24,0), maxs = Vector (24,24,80), filter=self.Owner} )--  filter = MySelf,
	local trground = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos - Vector(0,0,2)})
	
	self.CanCreateTurret = false
	if trground.HitWorld then
		if htrace.Entity == NULL and tr.HitPos:Distance(self.Owner:GetPos()) > 30 then	
			CanCreateTurret = true
		end
	end
	
	local pos = self.Owner:GetPos()
	local turrets = 0

	for k,v in pairs ( ActualTurrets ) do-- ents.FindInBox (Vector (pos.x - 150,pos.y - 150,pos.z - 150), Vector (pos.x + 150, pos.y + 150, pos.z + 150))
		if IsValid( v ) and tr.HitPos:Distance(v:GetPos()) <= 48 then
			turrets = turrets + 1
		end
	end
		
	if turrets >= 1 then
		if SERVER then 
			self.Owner:Message("Place turret more away from any other turrets", 2)
		end
		
		return
	end
	
	for _, Ent in pairs(ents.FindByClass("game_supplycrate")) do
		if tr.HitPos then
			if tr.HitPos:Distance(Ent:GetPos()) < 32 then
				self.Owner:Message("Place the turret more away from the Supply Crate!", 2)
				return
			end
		end
	end
	
	local angles = aimvec:Angle()	
	if CanCreateTurret then
	--print("I can")
		
	local ent = ents.Create("zs_turret")
		if (IsValid(ent)) then
			--print("done")
			--  logging
			--log.PlayerAction( self.Owner, "place_turret")
		
			ent:SetPos(tr.HitPos)
			ent:SetAngles( Angle (0,angles.y+self:GetRotation(),angles.r) )
			--ent:SetNWEntity("TurretOwner",self.Owner)
			ent:SetDTEntity(0,self.Owner)
			ent:Spawn()
			ent:Activate()
			ent:EmitSound("npc/roller/blade_cut.wav")
			self.Owner.Turret = ent
			self:TakePrimaryAmmo( 1 )
			self:Deploy()
						
				
			--if self and self:IsValid() then
			--	DropWeapon(self.Owner)
			--	self:Remove()	
			--end
		end		
	end	
end
	
	--if self:GetOwner():GetPerk("_remote") then
	--	self:GetOwner():Give("weapon_zs_tools_remote")
	--end
				self:Deploy()	
	
end
	
function SWEP:Reload() 
	return false
end  
 
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.1)
	
	if SERVER then
		self:Rotate()
	elseif CLIENT then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
	end
end 

--[[
function SWEP:_OnDrop()
	if SERVER then
		if self and self:IsValid() then
			self:Remove()
		end
	end
end
]]--
function SWEP:Rotate()
	self:SetDTInt(0,math.NormalizeAngle(self:GetRotation()+22.5))
end

function SWEP:GetRotation()
	return self:GetDTInt(0) or 0
end

function SWEP:Think()
	if SERVER then
		local ammocount = self.Owner:GetAmmoCount(self.Primary.Ammo)
		if 0 < ammocount then

			self:SetClip1(ammocount + self:Clip1())
			self.Owner:RemoveAmmo(ammocount, self.Primary.Ammo)
		end
	
		if self.NextDeploy and self.NextDeploy < CurTime() then
			if 0 < self:Clip1() then
				self:SendWeaponAnim(ACT_VM_DRAW)
			else
				self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			end
		end
	end		
end

if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() or ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()
	end
end
