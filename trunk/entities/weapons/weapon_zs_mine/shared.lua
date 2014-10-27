-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.HoldType = "melee"

if CLIENT then
	SWEP.PrintName = "Explosive"
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	SWEP.DrawCrosshair = false
	
	SWEP.ShowViewModel = true
	SWEP.AlwaysDrawViewModel = true
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = false
	SWEP.ScaleDownLeftHand = true
	SWEP.ScaleDownRightHand = true
	
	-- killicon.AddFont( "weapon_zs_mine", "CSKillIcons", "I", Color(255, 255, 255, 255 ) )
	killicon.Add("weapon_zs_mine", "HUD/scoreboard_bomb", Color(255, 255, 255, 255 ) )
	
	function SWEP:DrawHUD()
		MeleeWeaponDrawHUD()
	end
end

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.444, 15.593, -0.556) },
		["Slam_base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(12.536, 6.918, 32.043) },
		["Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0.625, 17.955) }
	}

	self.VElements = {
		["exp"] = { type = "Model", model = "models/Weapons/w_package.mdl", bone = "Slam_base", rel = "", pos = Vector(-7.4, -66.6, 22.156), angle = Angle(-43.644, -16.65, -113.362), size = Vector(0.675, 0.675, 0.675), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.WElements = {} 
	
end

ActualMines = ActualMines or {}

SWEP.Base				= "weapon_zs_base_dummy"

------------------------------------------------------------------------------------------------------
SWEP.Author			= "" -- Original code by Amps
SWEP.Instructions	= "Stand close to a wall to plant the mine. Detonates when enemy is within visible range." 
SWEP.NextPlant = 0
------------------------------------------------------------------------------------------------------
SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
------------------------------------------------------------------------------------------------------
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
------------------------------------------------------------------------------------------------------
SWEP.ViewModel      = Model ( "models/Weapons/v_slam.mdl")
SWEP.WorldModel   = Model ( "models/Weapons/w_package.mdl" )
------------------------------------------------------------------------------------------------------
SWEP.Primary.Delay			= 0.025 	
SWEP.Primary.Recoil			= 0		
SWEP.Primary.Damage			= 7	
SWEP.Primary.NumShots		= 1		
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= 3
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "slam"	
------------------------------------------------------------------------------------------------------
SWEP.Secondary.Delay		= 0.06
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 6
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
------------------------------------------------------------------------------------------------------
SWEP.WalkSpeed = 190

-- Preload
util.PrecacheSound("weapons/c4/c4_beep1.wav")
util.PrecacheSound("weapons/c4/c4_plant.wav")


function SWEP:On_Deploy()
	-- Draw animation
	if 0 < self:Clip1() then 
		self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_DRAW )
	else
		self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )
		
	end
end

function SWEP:PrimaryAttack()
	if( CurTime() < self.NextPlant ) or not self:CanPrimaryAttack() then return end
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return false end
		self.NextPlant = ( CurTime() + 1.2 );
	-- 
	local trace = {}
	local pos = self.Owner:GetPos()
	local mines = 0
	local cades = 0
	
	local mymines = 0
	
	trace.start = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64
	-- trace.mask = MASK_NPCWORLDSTATIC
	trace.filter = ents.GetAll() -- Ignore everything but the world.
	local tr = util.TraceLine( trace )
	-- 
	
	for k,v in pairs(ents.FindByClass("mine")) do
		if v and v:GetOwner() == self.Owner then
			mymines = mymines + 1
		end
	end
	

		
	if mymines > 5 then
		if SERVER then
			self.Owner:Message("You can't place more than 5 mines per ground",1,"white")
		end
		return
	end
	
	
	
	for k,v in pairs ( ActualMines ) do-- ents.FindInBox (Vector (pos.x - 100,pos.y - 100,pos.z - 100), Vector (pos.x + 100, pos.y + 100, pos.z + 100))
		if IsValid( v ) and tr.HitPos:Distance(v:GetPos()) <= 50 then
			-- if v:GetClass() == "mine" then
				mines = mines + 1
			-- end
		end
	end
		
	if mines >= 1 then
		if SERVER then 
			self.Owner:Message("You must place the mine more away from other mines",1)
		end
		
		return
	end
	
	-- for k,v in pairs (ents.FindInBox (Vector (pos.x - 150,pos.y - 150,pos.z - 150), Vector (pos.x + 150, pos.y + 150, pos.z + 150)) ) do
	-- 	if IsValid( v ) then
	-- 		if v.IsBarricade and v.Nails then
				-- cades = cades + 1
	-- 		end
	-- 	end
	-- end
	
	if cades >= 1 then
		if SERVER then 
			self.Owner:Message("You must place the mine more away from barricades",1)
		end
		
		return
	end
	
	if ( tr.Hit ) and tr.HitNormal.z > 0.5 then
	-- /animation goes here
	-- self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	-- local time = self:SequenceDuration()
	self.NextPlant = ( CurTime() + 1 );

		if not IsValid ( self.Owner ) then return end 
		local trace = {}
		local pos = self.Owner:GetPos()
		local mines = 0
		local cades = 0
	
		trace.start = self.Owner:GetShootPos()
		trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64
		trace.filter = ents.GetAll()
		local tr = util.TraceLine( trace )
		
		if ( tr.Hit ) then	
		-- Shared animation
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		-- self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		--self.Weapon:SetSequence("throw_throw"..math.random(1,2))
		self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_THROW )
		--self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		timer.Simple(self.Weapon:SequenceDuration(),function() 
			if self and self:IsValid() and self.Owner and self.Owner:GetActiveWeapon() == self then 
				if 0 < self:Clip1() then 
					--if CLIENT then
					--	local vm = self.Owner:GetViewModel()
					--	if not IsValid(vm) then return end
					--	vm:SetSequence("detonator_draw")
					--end
					self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_DRAW )
				else
					self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )
				end
			end 
		end)
		if SERVER then
			local ent = ents.Create ("mine")
			if ( ent ~= nil and ent:IsValid() ) then
			
				if self.Owner:IsPlayer() then
					--  logging
					-- log.PlayerAction( self.Owner, "plant_mine")
				end
				
				ent:SetPos(tr.HitPos)		
				ent:SetOwner(self.Owner)
				ent:Spawn()
				ent:Activate()
				self.Owner:EmitSound( "weapons/slam/throw.wav" )
				
				ent:GetTable():WallPlant( tr.HitPos + tr.HitNormal, tr.HitNormal )
				self:TakePrimaryAmmo( 1 )
								
			end
		else
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
		end
	end
	
	end
	
end

function SWEP:SecondaryAttack()
	if( CurTime() < self.NextPlant ) then return end
	self.NextPlant = ( CurTime() + 1 );
	
	if 0 < self:Clip1() then 
		self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_DETONATE )
	else
		self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
	end
	
	if SERVER then
	
		for k,v in pairs(ents.FindByClass("mine")) do
			if v and v:GetOwner() == self.Owner then
				v:Fire("detonate",0)
			end
		end
	
	end
	-- if CLIENT then
	-- 	local vm = self.Owner:GetViewModel()
	-- 	if not IsValid(vm) then return end
	-- 		vm:SetSequence("detonator_detonate")
	-- end
	
end 



 function SWEP:Reload() 
	return false
 end  


function SWEP:_OnDrop()
	if SERVER then
		if self and self:IsValid() then
			self:Remove()
		end
	end
end

SWEP.TimeNextThink = 0
function SWEP:Think()
	if not self.Owner or not self.Owner:Alive() then
		return
	end

	--Set secondary ammo in clip
	local ammocount = self.Owner:GetAmmoCount(self.Primary.Ammo)
	if 0 < ammocount then
		self:SetClip1(ammocount + self:Clip1())
		self.Owner:RemoveAmmo(ammocount, self.Primary.Ammo)
	end
	
	if self.TimeNextThink <= CurTime() then
		if SERVER then
			GAMEMODE:WeaponDeployed (self.Owner, self.Weapon)
		end
		self.TimeNextThink = CurTime() + 0.5
	end
	
	return true
end
