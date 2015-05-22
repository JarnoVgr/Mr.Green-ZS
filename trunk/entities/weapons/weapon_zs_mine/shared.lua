-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.HoldType = "melee"

if CLIENT then
	SWEP.PrintName = "C4"
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	SWEP.DrawCrosshair = false
	
	SWEP.ShowViewModel = true
	SWEP.AlwaysDrawViewModel = true
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = false
	SWEP.ScaleDownLeftHand = true
	SWEP.ScaleDownRightHand = true
	
	killicon.AddFont( "weapon_zs_mine", "CSKillIcons", "I", Color(255, 255, 255, 255 ) )
	
	function SWEP:DrawHUD()
		MeleeWeaponDrawHUD()
	end
end

function SWEP:InitializeClientsideModels()
	self.WElements = {} 
end

ActualMines = ActualMines or {}

SWEP.Base				= "weapon_zs_base_dummy"

------------------------------------------------------------------------------------------------------
SWEP.Author			= "" -- Original code by Amps
SWEP.Instructions	= "Stand close to a wall to plant the mine. Detonates when enemy is within visible range." 
SWEP.NextPlant = 0
------------------------------------------------------------------------------------------------------
SWEP.ViewModelFOV	= 50
SWEP.ViewModelFlip	= false
------------------------------------------------------------------------------------------------------
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
------------------------------------------------------------------------------------------------------
SWEP.ViewModel      = Model ( "models/weapons/v_c4.mdl")
SWEP.WorldModel   = Model ( "models/weapons/w_c4.mdl" )
SWEP.UseHands = true
------------------------------------------------------------------------------------------------------
SWEP.Primary.Delay			= 0.01 	
SWEP.Primary.Recoil			= 0		
SWEP.Primary.Damage			= 7	
SWEP.Primary.NumShots		= 1		
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 4
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "slam"	
------------------------------------------------------------------------------------------------------
SWEP.Secondary.Delay		= 0.04
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 6
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"

------------------------------------------------------------------------------------------------------
SWEP.WalkSpeed = SPEED

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

function SWEP:Equip ( NewOwner )
	if CLIENT then return end
	
		if self.Weapon.FirstSpawn then
			self.Weapon.FirstSpawn = false
		end	
		
		if self.Owner:GetPerk("_mine") then
			self.Clip1 = 8
		end
	
	
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end

function SWEP:PrimaryAttack()
local owner = self.Owner
	if( CurTime() < self.NextPlant ) or not self:CanPrimaryAttack() then return end
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return false end
		self.NextPlant = ( CurTime() + 0.2 );
	-- 
	local trace = {}
	local pos = self.Owner:GetPos()
	local mines = 0
	local cades = 0
	
	local mymines = 0
	
	trace.start = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64
	trace.filter = ents.GetAll() -- Ignore everything but the world.
	local tr = util.TraceLine( trace )
	-- 
	
	for k,v in pairs(ents.FindByClass("mine")) do
		if v and v:GetOwner() == self.Owner then
			mymines = mymines + 1
		end
	end
	

		if owner:GetPerk("_mine") then
			if mymines > 10 then
		if SERVER then
			self.Owner:Message("You can't place more than 10 mines per ground",1,"white")
		end
		return
	end
	
		else	
			
	if mymines > 5 then
		if SERVER then
			self.Owner:Message("You can't place more than 5 mines per ground",1,"white")
		end
		return
	end
	
	end
	
	
	for k,v in pairs ( ActualMines ) do
		if IsValid( v ) and tr.HitPos:Distance(v:GetPos()) <= 32 then
				mines = mines + 1
		end
	end
		
	if mines >= 1 then

		return
	end
	

	if cades >= 1 then
		if SERVER then 
			self.Owner:Message("You must place the mine more away from barricades",1)
		end
		
		return
	end
	
	if ( tr.Hit ) and tr.HitNormal.z != -1 then

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
		timer.Simple(self.Weapon:SequenceDuration(),function() 
			if self and self:IsValid() and self.Owner and self.Owner:GetActiveWeapon() == self then 
				if 0 < self:Clip1() then 

					self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_DRAW )
				else
					self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )
				end
			end 
		end)
		--
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
				self.Owner:EmitSound("weapons/c4/c4_plant.wav" )
				
				ent:GetTable():WallPlant( tr.HitPos + tr.HitNormal, tr.HitNormal )
				self:TakePrimaryAmmo( 1 )
								
			end
		else
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
		end
	end
	
	end
	
end

