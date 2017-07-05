-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.HoldType = "slam"
SWEP.PrintName = "Proximity Mine"
SWEP.Slot = 4
SWEP.Type = "Deployable"
SWEP.Weight = 2

if CLIENT then
	SWEP.DrawCrosshair = false
	
	SWEP.ShowViewModel = true
	SWEP.AlwaysDrawViewModel = true
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = false
	SWEP.ScaleDownLeftHand = true
	SWEP.ScaleDownRightHand = true
	
	killicon.AddFont( "weapon_zs_proximity_mine", "CSKillIcons", "I", Color(255, 255, 255, 255 ) )
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
SWEP.ViewModelFlip	= false
------------------------------------------------------------------------------------------------------
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
------------------------------------------------------------------------------------------------------
--SWEP.ViewModel      = Model ( "models/weapons/v_c4.mdl")
--SWEP.WorldModel   = Model ( "models/weapons/w_c4.mdl" )

SWEP.ViewModel				= "models/weapons/cstrike/c_c4.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_c4.mdl"	-- Weapon world model
SWEP.UseHands = true
------------------------------------------------------------------------------------------------------
SWEP.Primary.Delay			= 0.8	
SWEP.Primary.Recoil			= 0		
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1		
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= 10
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
SWEP.HumanClass = "engineer"
------------------------------------------------------------------------------------------------------

-- Preload
util.PrecacheSound("weapons/c4/c4_beep1.wav")
util.PrecacheSound("weapons/c4/c4_plant.wav")

SWEP.ArmTime = 3
SWEP.AttemptedArm = 0
SWEP.Planting = false

function SWEP:On_Deploy()

end

function SWEP:OnInitialize()
	if SERVER then
		self.Weapon.FirstSpawn = true
	end	
end

function SWEP:Equip ( NewOwner )
	if CLIENT then return end
	
	
	self.Owner.Weight = self.Owner.Weight + self.Weight
	self.Owner:CheckSpeedChange()	
		if self.Weapon.FirstSpawn then
			self.Weapon.FirstSpawn = false
			if self.Owner:GetPerk("engineer_multimine") then
				self.Weapon:SetClip1( 8 ) 	
			end	
		end	
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end

function SWEP:Think()
	if self.AttemptedArm + self.ArmTime < CurTime() and self.Planting then
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		self.Planting = false	
		
		
		local trace = {}
		local pos = self.Owner:GetPos()
		local mines = 0
		local cades = 0
	
		trace.start = self.Owner:GetShootPos()
		trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 50
		trace.filter = ents.GetAll()
		local tr = util.TraceLine( trace )
		
		
		if ( tr.Hit ) then	
			--[[
			timer.Simple(self.Weapon:SequenceDuration(),function() 
				if self and self:IsValid() and self.Owner and self.Owner:GetActiveWeapon() == self then 
					if 0 < self:Clip1() then 
					--	self.Weapon:SendWeaponAnim( ACT_SLAM_THROW_DRAW )
					else
					--	self.Weapon:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )
					end
				end 
			end)
			]]--
			if SERVER then
				local ent = ents.Create ("mine")
				if ( ent ~= nil and ent:IsValid() ) then
								
					ent:SetPos(tr.HitPos)		
					ent:SetOwner(self.Owner)
					ent:Spawn()
					ent:Activate()
					self.Owner:EmitSound("weapons/c4/c4_plant.wav" )
					
					ent:GetTable():WallPlant( tr.HitPos + tr.HitNormal, tr.HitNormal )
					self:TakePrimaryAmmo( 1 )	
				end
			else

			end		
		end
		
		
	end
end



function SWEP:PrimaryAttack()

	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHuman() and self.Owner:IsHolding() then return false end
	if( CurTime() < self.NextPlant ) or not self:CanPrimaryAttack() then return end
	
	self.AttemptedArm = CurTime()
	self.Planting = true
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	
	
	
	--[[


		self.NextPlant = ( CurTime() + 0.2 );
	-- 
	local trace = {}
	local pos = self.Owner:GetPos()
	local mines = 0
	local cades = 0
	
	local mymines = 0
	
	trace.start = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 50
	trace.filter = ents.GetAll() -- Ignore everything but the world.
	local tr = util.TraceLine( trace )
	-- 
	
	for k,v in pairs ( ActualMines ) do
		if IsValid( v ) and tr.HitPos:Distance(v:GetPos()) <= 32 then
			mines = mines + 1
		end
	end
		
	if mines >= 1 then
		return
	end

	if ( tr.Hit ) and tr.HitNormal.z != -1 then

	
	self.NextPlant = ( CurTime() + 1 );

		
	end
	
	end]]--
	
end

