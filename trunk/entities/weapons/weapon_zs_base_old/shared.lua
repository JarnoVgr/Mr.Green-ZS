-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight	= 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom	= true
end

if CLIENT then
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = true
	SWEP.CSMuzzleFlashes = true
	SWEP.ShowViewModel = false
	SWEP.PlayerFOV = 75
	
	-- killicons
	surface.CreateFont( "csd", ScreenScale( 30 ), 500, true, true, "CSKillIcons" )
	surface.CreateFont( "csd", ScreenScale( 60 ), 500, true, true, "CSSelectIcons" )
	SWEP.VElements = {}
	SWEP.WElements = {} 
	SWEP.ViewModelBoneMods = {
	["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
	-- SWEP.Arms = {}

end

SWEP.Author = "Ywa and ClavusElite"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage	= 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = 0.15
SWEP.ConeMoving	= 0.03
SWEP.ConeCrouching = 0.013

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize	= 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "CombineCannon"
SWEP.IsShotgun = false
SWEP.WalkSpeed = 200

SWEP.IronSightMultiplier = 0.5
SWEP.IronSightsPos = Vector( 0,0,0 )
SWEP.IronSightsAng = Vector( 0,0,0 )

SWEP.OverridePos = Vector( 0,0,0 )
SWEP.OverrideAng = Vector( 0,0,0 )

SWEP.Tracer = "Tracer"

-- Deploy speed
SWEP.DeploySpeed = 1.1

-- Numbers used to draw the crosshair and calculate the cone
SWEP.WeaponCones = { ["pistol"] = { Cone = 0.1, Length = 14 }, ["smg"] = { Cone = 0.13, Length = 17 }, ["rifle"] = { Cone = 0.14, Length = 18 }, ["shotgun"] = { Cone = 0.26, Length = 22 }, ["admin"] = { Cone = 0.30, Length = 27 } }

-- Optimisation Event!
	

function SWEP:Precache() 
	util.PrecacheSound(self.Primary.Sound)
end
--[==[------------------------------------
       Called on weapon deploy
------------------------------------]==]
function SWEP:Deploy()
	self:SetIronsights( false )
	
	-- Player the draw animation
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	-- Add a bit of time before we start shooting
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.8 )
	
	self.Owner:StopAllLuaAnimations()
	
	self:OnDeploy()
	
	-- Speed change
	if SERVER then GAMEMODE:WeaponDeployed( self.Owner, self ) return true else self:SetViewModelColor ( Color(255,255,255,255) ) 
	end
	
end
-- Additional func
function SWEP:OnDeploy()
MakeNewArms(self)
if CLIENT then

		

end
end

--[==[-------------------------------------------
       Called on weapon initialization
-------------------------------------------]==]
function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	
	-- Deploy speed
	self:SetDeploySpeed ( self.DeploySpeed )
	
	
	
	-- Clavus' code goes here:
    if CLIENT then
        self:CreateModels(self.VElements) --  create viewmodels
        self:CreateModels(self.WElements) --  create worldmodels
       
        --  init view model bone build function
 		self.BuildViewModelBones = function( s )
			if LocalPlayer():GetActiveWeapon() == self and self.ViewModelBoneMods then
				for k, v in pairs( self.ViewModelBoneMods ) do
					local bone = s:LookupBone(k)
					if (not bone) then continue end
					local m = s:GetBoneMatrix(bone)
					if (not m) then continue end
					m:Scale(v.scale)
					m:Rotate(v.angle)
					m:Translate(v.pos)
					s:SetBoneMatrix(bone, m)
				end
			end
		end         
    end
	 self:OnInitialize() 
	
end

function SWEP:OnInitialize()
	if CLIENT then
		-- MakeNewArms(self)
	end
end

--[==[------------------------------------
          Called on pressed R
-------------------------------------]==]
function SWEP:Reload()
	if self.Owner.KnockedDown or self.Owner:IsHolding() then return end
	local Magazine = self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )
	-- Disable ironsight while reloading
	self:SetIronsights( false )
	--  If the player hasn't anymore ammo then stop running this
	if self.Weapon:Clip1() >= self.Primary.ClipSize or Magazine == 0 then return end
	

	
	if SERVER then

		if self.Weapon:Clip1() <= math.floor (self.Primary.ClipSize / 1.5) and math.random(1,2) == 1 then
			local rlsnd = VoiceSets[self.Owner.VoiceSet].ReloadSounds
			timer.Simple ( 0.2, function ()
				if ValidEntity ( self ) then self:EmitSound(rlsnd[math.random(1, #rlsnd)]) end
			end, self )
		end
	end
	
	-- Default reload animation
	self.Weapon:DefaultReload( ACT_VM_RELOAD )		
	if self.ReloadSound then
		self.Weapon:EmitSound(self.ReloadSound)
	end
end

--[==[------------------------------------
          Called on holstered
-------------------------------------]==]
function SWEP:Holster()
	self:SetIronsights( false ) 
	RemoveNewArms(self)
	 if CLIENT then
		
		RestoreViewmodel(self.Owner)
    end
	
	return true
end

function SWEP:OnRemove()
    RemoveNewArms(self)     
    if CLIENT then
        self:RemoveModels()
		RestoreViewmodel(self.Owner)
		
    end
     
end

--[==[--------------------------------------------------
     Called on Primary Fire Attack ( +attack )
---------------------------------------------------]==]
SWEP.PrimaryFire = 0
function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner:IsHolding() then return end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	if not self:CanPrimaryAttack() then return end
	
	-- Get owner
	local Owner = self.Owner

	-- Ironsight precision
	local iIronsightMul
	if self:GetIronsights() then iIronsightMul = self.IronSightMultiplier else iIronsightMul = 2 end
		
	-- Recoil 
	if Owner.ViewPunch then Owner:ViewPunch( Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil * 0.25, math.Rand(-0.1,0.1) * self.Primary.Recoil * 0.35, 0) ) end
	if ( ( SinglePlayer() and SERVER ) or ( not SinglePlayer() and CLIENT and IsFirstTimePredicted() ) ) then
		local eyeang = self.Owner:EyeAngles()
		local recoil = math.Rand( 0.1, 0.2 )
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end
	
	local WeaponType = self:GetType()
	
	-- The crosshair enlarges
	if CLIENT then
		local Scale
		local Cone = self.WeaponCones[WeaponType].Cone
	
		-- Get the current action of the player
		if MySelf:GetVelocity():Length() > 25 then
			Scale = ( ScrW() / 1024 ) * 10 * Cone * 1.5
		else
			if MySelf:Crouching() then
				Scale = ( ScrW() / 1024 ) * 10 * Cone * 0.8
			else
				Scale = ( ScrW() / 1024 ) * 10 * Cone * 1.1
			end
		end
		
		local MaxRecoil = math.abs ( Scale * 15 )
		self.CrosshairGap = math.Clamp ( self.CrosshairGap + 7, 0, MaxRecoil * 1.5 )
	end
		
	-- Fire sound
	self:EmitSound ( self.Primary.Sound )
	-- Calculate cone
	local Cone = self.WeaponCones[WeaponType].Cone
	local fRunCone, fCrouchCone, fCone, fDamage, iNumShots = 1.7, 0.8, 1.3, self.Primary.Damage, self.Primary.NumShots
	
	-- Running or standing still or crouching cones
	
	if self.Owner:GetVelocity():Length() > 25 then
		self:ShootBullets ( fDamage, iNumShots, ( Cone * fRunCone ) * 0.25 * iIronsightMul )
	else
		if self.Owner:Crouching() then self:ShootBullets ( fDamage, iNumShots, ( Cone * fCrouchCone ) * 0.25 * iIronsightMul ) else self:ShootBullets ( fDamage, iNumShots, ( Cone * fCone ) * 0.25 * iIronsightMul ) end
	end
	-- Leech ammunition
	self:TakePrimaryAmmo( 1 )
		
	if self.IsShotgun and self.IsShotgun == true then
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
		self.Weapon:EmitSound("Weapon_Shotgun.Special1")
	end
end

--[==[--------------------------------------------------
	   Half Life 2 like tracer origins
---------------------------------------------------]==]
function SWEP:GetTracerOrigin()
	if SERVER then return end

	local bIron = self.Weapon:GetIronsights() 
	local ply = self:GetOwner()
	local ViewModel = self.Owner:GetViewModel()
	
	local vecEye = MySelf:EyePos()
	local vForward, vRight 
	
	vForward = MySelf:GetForward()  
	vRight = MySelf:GetRight()
	
	
	
	local vecSrc = vecEye + vForward * 40.0 + vRight * 12.5 + Vector( 0, 0, -8 )
	
	if bIron == true then
		pos = ply:EyePos() + ply:EyeAngles():Forward()
		return pos
	end
		
	return vecSrc
end

function SWEP:BulletCallback ( attacker, trace, dmginfo )
	if trace.Hit then
		local ent = trace.Entity
		if ValidEntity ( ent ) then
			local owner = self.Owner or self.Entity
			local damage = self.Primary.Damage or 12
			if not ValidEntity ( owner ) then return end
			-- No damage to humans 
			if ( ent:IsPlayer() and ent:IsHuman() ) then return end
			
			-- Predict some damage clientside
			-- if CLIENT then 
				-- if self.PrimaryFire <= CurTime() then
					-- self.PrimaryFire = CurTime() + self.Primary.Delay 
					-- gamemode.Call ( "EntityTakeDamage", ent, owner, damage, dmginfo ) 
				
					-- return 
				-- end
			-- end
			
			if ent:GetPhysicsObject() and ent:GetPhysicsObject():IsValid() and not string.find (ent:GetClass(),"door") then
				local phys = ent:GetPhysicsObject()
				local velCenter = owner:EyeAngles():Forward() * 500 * ( damage / 8) 
				local velOffset = { Vector(math.Rand (-10,10),math.Rand (-10,10),math.Rand (-5,5)), Vector(math.Rand (-10,10),math.Rand (-10,10),math.Rand (-5,5)) }
				
				--Apply the whole force thing to objects and not players
				if not ent:IsPlayer() then
					phys:ApplyForceCenter ( velCenter )
					phys:ApplyForceOffset ( velOffset[1], velOffset[2] )
				end
				
				--Set the physics attacker and take damage
				ent:SetPhysicsAttacker ( owner )
				ent:TakeCustomDamage ( damage, owner, DMG_BULLET, dmginfo )
			end
		end
	end
end

function SWEP:ShootBullets ( dmg, numbul, cone )
	local owner = self.Owner
	local bullet = {}
	bullet.Num = numbul
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = owner:GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)  
	bullet.Tracer = 1
	bullet.Force = 1
	bullet.Damage = 0
	bullet.TracerName = self.Tracer or "Tracer"
	bullet.Callback = function ( a, b, c )
		self:BulletCallback ( a, b, c )
	end
	
	owner:FireBullets(bullet)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	owner:MuzzleFlash()
	owner:SetAnimation(PLAYER_ATTACK1)
end

if CLIENT then
	local scalebywidth = ( ScrW() / 1024 ) * 10
	SWEP.CrossHairScale = 1
	SWEP.CHalpha = 210
	SWEP.CColor = Color (124,198,227,210)
	SWEP.CrosshairGap = 10
	
	function SWEP:DrawHUD()
		local MySelf = LocalPlayer()
		if not MySelf:IsValid() then return end
		
		if ENDROUND or ZOMBIE_CLASSES then return end
		if self.Weapon:GetIronsights() == true and GetConVar( "_zs_ironsight" ):GetBool() == false then return end 
		
		-- SQL ready
		if not MySelf.ReadySQL then return end

		local x = w * 0.5
		local y = h * 0.5

		local Scale
		if not self.DotColor then
			self.DotColor = Color ( 255, 0, 0, math.min(self.CHalpha*3,230) )
		end
		
		if self.Owner.KnockedDown or self.Owner:IsHolding() then return end
		
		-- Color change script
		local owner = self.Owner
		local mypos = owner:GetShootPos()
		local angle = owner:GetAimVector()
		
		local tracedata = { }
		tracedata.start = mypos
		tracedata.endpos =  mypos + ((angle)*32000)
		tracedata.filter = owner
		
		local tr = util.TraceLine (tracedata)
		
		if tr.Hit then
			local ent = tr.Entity
			if IsValid( ent ) and ent:IsPlayer() and ( not ent:IsWraith() ) then
				if ent:Team() ~= owner:Team() and ent:Alive() then
					self.CColor = Color (245,5,5,self.CHalpha)
					self.DotColor = Color (255, 255, 255, math.min(self.CHalpha*3,230))
				end
			else
				self.CColor = Color (255,255,255, self.CHalpha)-- 124,198,227
				self.DotColor = Color (255, 0, 0, math.min(self.CHalpha*3,230))
			end
		end

		self.CHalpha = math.Approach(self.CHalpha, 210, FrameTime() * 200)

		local WeaponType = self:GetType()
		local Cone = self.WeaponCones[WeaponType].Cone
		
		-- Get the current action of the player
		if MySelf:GetVelocity():Length() > 25 then
			Scale = scalebywidth * Cone * 1.5
		else
			if MySelf:Crouching() then
				Scale = scalebywidth * Cone * 0.8
			else
				Scale = scalebywidth * Cone * 1.1
			end
		end

		surface.SetDrawColor( self.CColor )

		-- space between the lines
		
		if self.IsShotgun and self.IsShotgun == true then
		self.CrosshairGap = math.Approach ( self.CrosshairGap, math.abs ( Scale * 6 ), FrameTime() * 55 )
		
		--surface.DrawCircle( x, y, 50, Color(255,255,255,255) ) 
		local scr = 35
		local bcr = 35
		
		scr = scr + self.CrosshairGap
		bcr = bcr + self.CrosshairGap
		
		surface.SetDrawColor( Color(0,0,0,255) )
		for i = 0, math.pi * 2, 1 / math.max(bcr, bcr) do
			surface.DrawRect( x - 1.5 + math.sin(i) * bcr, y - 1.5 + math.cos(i) * bcr, 6, 6)
		end
		
		surface.SetDrawColor( Color(255,255,255,255) )
		for i = 0, math.pi * 2, 1 / math.max(scr, scr) do
			surface.DrawRect( x + math.sin(i) * scr, y + math.cos(i) * scr, 3, 3)
		end
		
		else
		self.CrosshairGap = math.Approach ( self.CrosshairGap, math.abs ( Scale * 15 ), FrameTime() * 50 )
		
		local length = ScaleW( self.WeaponCones[WeaponType].Length )
		
		for i = 0, 1 do
			surface.DrawLine( x - self.CrosshairGap, y + i, x - length - self.CrosshairGap, y + i )
		end
		
		for i = 0, 1 do 
			surface.DrawLine( x + self.CrosshairGap, y + i, x + length + self.CrosshairGap, y + i )
		end
		
		for i = 0, 1 do 
			surface.DrawLine( x + i, y - self.CrosshairGap, x + i, y - length - self.CrosshairGap )
		end
		
		for i = 0, 1 do 
			surface.DrawLine( x + i, y + self.CrosshairGap, x + i, y + length + self.CrosshairGap )
		end

		surface.SetDrawColor ( self.DotColor ) 
		surface.DrawRect( x - 1, y - 1, 2, 2 )
		
		end
	end
end

--[==[------------------------------------------------------
            Called when the weapon is equiped
-------------------------------------------------------]==]
function SWEP:Equip ( NewOwner )
	if CLIENT then return end
	
	-- If the weapon is dropped and has 10 bullets less in the current clip, then substract that amount for the new owner
	if self.Primary.RemainingAmmo then
		self:TakePrimaryAmmo ( self:Clip1() - self.Primary.RemainingAmmo )
	end

	
	-- Magazine clip is stored in the weapon, instaed of player
	NewOwner:RemoveAmmo ( 1500, self:GetPrimaryAmmoTypeString() )
	NewOwner:GiveAmmo ( self.Primary.Magazine or self.Primary.DefaultClip, self:GetPrimaryAmmoTypeString() )
	
	
	
	
			
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then
		self.Weapon:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		
		self:Reload() 
		
		return false
	end
	
	return true
end

SWEP.NextSecondaryAttack = 0
function SWEP:SecondaryAttack()
	if ( not self.IronSightsPos ) then return end
	if self.Owner.KnockedDown or self.Owner:IsHolding() then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bIronsights = !self.Weapon:GetIronsights() 
	
	-- Set ironsights
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.4
end
if CLIENT then
SWEP.IRONSIGHT_TIME = 0.25

function SWEP:GetViewModelPosition( pos, ang )
self.Fov = GetConVar("fov_desired"):GetInt()
local ENABLE_WEPPOS = util.tobool(GetConVarNumber("_zs_customweaponpos")) -- we need this thing inside the hook, so it will check every damn second
if ENABLE_WEPPOS then
	if self.OverridePos and self.OverrideAng then
	ang = ang * 1
	ang:RotateAroundAxis( ang:Right(), 		self.OverrideAng.x )
	ang:RotateAroundAxis( ang:Up(), 		self.OverrideAng.y )
	ang:RotateAroundAxis( ang:Forward(), 	self.OverrideAng.z )
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	pos = pos + self.OverridePos.x * Right
	pos = pos + self.OverridePos.y * Forward
	pos = pos + self.OverridePos.z * Up
	
	end
else
	ang = ang
	pos = pos
end
	if ( not self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetIronsights() 
	
	if ( bIron ~= self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( not bIron and fIronTime < CurTime() - self.IRONSIGHT_TIME ) then 
		return pos, ang
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - self.IRONSIGHT_TIME ) then
		Mul = math.Clamp( ( CurTime() - fIronTime) / self.IRONSIGHT_TIME, 0, 1 )
		if (not bIron) then Mul = 1 - Mul end
	end
	local Offset = self.IronSightsPos

	
	if ( self.IronSightsAng ) then
		if self.OverrideAng and ENABLE_WEPPOS then
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		(self.IronSightsAng.x - self.OverrideAng.x) * Mul )
		ang:RotateAroundAxis( ang:Up(), 		(self.IronSightsAng.y - self.OverrideAng.y) * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	(self.IronSightsAng.z - self.OverrideAng.z) * Mul )
		else
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
		end
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	--bc2 style weapon positions :D
	if ENABLE_WEPPOS then
		if self.OverridePos and self.OverrideAng then
			pos = pos + (Offset.x * Right - self.OverridePos.x * Right) * Mul -- without this code ironsights gets screwed :o
			pos = pos + (Offset.y * Forward - self.OverridePos.y * Forward) * Mul
			pos = pos + (Offset.z * Up - self.OverridePos.z * Up) * Mul
		else
			pos = pos + Offset.x * Right * Mul
			pos = pos + Offset.y * Forward * Mul
			pos = pos + Offset.z * Up * Mul
		end
	else
		pos = pos + Offset.x * Right * Mul
		pos = pos + Offset.y * Forward * Mul
		pos = pos + Offset.z * Up * Mul
	end
	return pos, ang
end
end

--[==[---------------------------------------------------------------
                       Enable/Disable Ironsight
----------------------------------------------------------------]==]
function SWEP:SetIronsights ( bIron )
	if self:GetIronsights() == bIron then return end
	
	-- Get owner
	local Owner = self.Owner
	if not ValidEntity ( Owner ) then return end
	
	-- Toggle ironsight
	self.IronSight = bIron
	
	-- Set clientside irons
	if CLIENT then 
		if self:GetIronsights() == true then self.PlayerFOV = GetConVar("fov_desired"):GetInt() - 20 or 55 else self.PlayerFOV = GetConVar("fov_desired"):GetInt() end --  or 75
		
		-- Set clientside fov
		Owner:SetFOV ( self.PlayerFOV )
	end
	
	-- Manage speed set-up
	if CLIENT then return end
	GAMEMODE:WeaponDeployed ( self.Owner, self, bIron )
end

--[==[---------------------------------------------------
           Get Weapon Ironsight Status
---------------------------------------------------]==]
function SWEP:GetIronsights ()
	return self.IronSight
end
function SWEP:OnDrop()
RemoveNewArms(self)
end

local function OnWeaponDropped ( um )
	if SERVER then return end
	if not ValidEntity ( MySelf ) then return end
	
	-- Disable the ironsight
	MySelf:SetFOV ( GetConVar("fov_desired"):GetInt()  ) -- 75
end
if CLIENT then usermessage.Hook ( "OnWeaponDropped", OnWeaponDropped ) end

function SWEP:OnRestore()
	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
end

-- Some more code 
if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
	
		
	
		self.ViewModelFOV = GetConVarNumber("_zs_wepfov") or self.ViewModelFOV
		
		if not self.Owner then return end
		if not self.Owner:IsValid() then return end
		if not self.Owner:IsPlayer() then return end
		
		local vm = self.Owner:GetViewModel()
		if not ValidEntity(vm) then return end

		
		
		
		

		
		if self.Owner.KnockedDown or self.Owner:IsHolding() then 
		
		vm:SetColor(255,255,255,1) 
		self:DrawWorldModel()
		return end
		
		if (self.ShowViewModel == nil or self.ShowViewModel) then
			vm:SetColor(255,255,255,255)
		else
			--  we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
			vm:SetColor(255,255,255,1) 
		end


		
		if vm.BuildBonePositions ~= self.BuildViewModelBones then
			vm.BuildBonePositions = self.BuildViewModelBones
		end

		UpdateArms(self) -- testing
		
		if (not self.VElements) then return end
		
		if (not self.vRenderOrder) then
			
			--  we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (not v) then self.vRenderOrder = nil break end
		
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (not v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (not pos) then continue end
			
			if (v.type == "Model" and ValidEntity(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				model:SetModelScale(v.size)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if self.Owner:IsHolding() then return end
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
				if self.Owner.KnockedDown and ValidEntity(self.Owner:GetRagdollEntity()) then
					local bone1 = self.Owner:GetRagdollEntity():LookupBone("ValveBiped.Bip01_R_Hand")
					if (bone1) then
					pos1, ang1 = Vector(0,0,0), Angle(0,0,0)
					local m1 = self.Owner:GetRagdollEntity():GetBoneMatrix(bone)
						if (m1) then
							pos1, ang1 = m1:GetTranslation(), m1:GetAngle()
							-- self:SetPos(pos1)
							-- self:SetAngles(ang1)
							-- print(tostring(pos1))
						end
					end	
				end
			self:DrawModel()
		end
		
		if (not self.WElements) then return end
		
		if (not self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (ValidEntity(self.Owner)) then
			if self.Owner.KnockedDown and ValidEntity(self.Owner:GetRagdollEntity()) then
				bone_ent = self.Owner:GetRagdollEntity()
			else
				bone_ent = self.Owner
			end
		else
			--  when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (not v) then self.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (not pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and ValidEntity(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				model:SetModelScale(v.size)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel ~= "") then
			
			local v = basetab[tab.rel]
			
			if (not v) then return end
			
			--  Technically, if there exists an element with the same name as a bone
			--  you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (not pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (not bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngle()
			end
			
			if (ValidEntity(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r --  Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (not tab) then return end

		--  Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model ~= "" and (not ValidEntity(v.modelEnt) or v.createdModel ~= v.model) and 
					string.find(v.model, ".mdl") and file.Exists ("../"..v.model) ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (ValidEntity(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) 
				and file.Exists ("../materials/"..v.sprite..".vmt")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				--  make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end

	function SWEP:OnRemove()
		self:RemoveModels()
		
		RemoveNewArms(self)
		
	end

	function SWEP:RemoveModels()
		if (self.VElements) then
			for k, v in pairs( self.VElements ) do
				if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		if (self.WElements) then
			for k, v in pairs( self.WElements ) do
				if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.VElements = nil
		self.WElements = nil
	end

end

if CLIENT then


SWEP.BoneTable = {}
SWEP.TempBones = nil

function SWEP:AddSetupBones()
		self.Owner:GetViewModel():SetupBones()
		self.Owner:GetViewModel(1):SetupBones()
end


end

