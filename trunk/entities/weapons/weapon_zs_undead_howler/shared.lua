-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ("shared.lua") end


local math = math
local team = team
local util = util
local timer = timer
local pairs = pairs
local ents = ents

if SERVER then
	local umsg = umsg
end

SWEP.Base = "weapon_zs_undead_generic"
SWEP.Author = "Deluvas"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.PrintName = "Howler"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.ViewModelBoneMods = {
		-- ["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-10.202, 19.533, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(0, -7.493, -45.569) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(5.802, 1.06, 0.335), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(52.678, 0, 0) },
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(45.873, -0.348, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-59.774, -9.223, 18.572) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(10.701, -7.301, 42.666) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 9.659, 6.218) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-6.42, 28.499, 7.317) }
	}
end


SWEP.ViewModel = Model ( "models/Weapons/v_zombiearms.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.ProtectionDistance = 220
SWEP.PropTKDistance = 450
SWEP.DistanceCheck = 450

SWEP.SwapAnims = false
SWEP.AttackAnimations = { "attackD", "attackE", "attackF" }

function SWEP:OnDeploy()
	self.Owner.ZomAnim = math.random(1, 3)
	--[[if SERVER then
		self.Owner:DrawViewModel( false )
		self.Owner:DrawWorldModel( false )
	end]]
end

function SWEP:Precache()
	
	util.PrecacheSound("ambient/energy/zap6.wav")
	util.PrecacheSound("npc/barnacle/barnacle_bark1.wav")
	
	util.PrecacheModel(self.ViewModel)
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[5].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].AttackSounds) do
		util.PrecacheSound(snd)
	end
	
end	

SWEP.NextSwing = 0
function SWEP:DoAttack( bPull ) 
	if CurTime() < self.NextSwing then
		return
	end
	
	-- Get owner
	local mOwner = self.Owner
	if not ValidEntity ( mOwner ) then
		return
	end
	
	-- Cannot scream while in air
	if not mOwner:OnGround() then
		return
	end
	
	-- Cooldown
	self.NextSwing = CurTime() + self.Primary.Delay
	
	-- Stop
	if SERVER then
		-- GAMEMODE:SetPlayerSpeed( self.Owner, 1 )
		-- self.Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
	end
	
	-- Thirdperson animation and sound
	mOwner:DoAnimationEvent( CUSTOM_PRIMARY )
	
	self:SetScreamEndTime(CurTime() + 1.3)
	-- Restore speed
	--[==[timer.Simple ( 1.3, function( mOwner )
		if not ValidEntity ( mOwner ) then return end
		
		-- Conditions
		if not mOwner:Alive() or not mOwner:IsHowler() then return end
		GAMEMODE:SetPlayerSpeed ( mOwner, ZombieClasses[ mOwner:GetZombieClass() ].Speed )
	end, mOwner )]==]
	
	-- Sound
	if SERVER then
		mOwner:EmitSound( table.Random ( ZombieClasses[ mOwner:GetZombieClass() ].AttackSounds ), 100, math.random ( 95,135 ) )
	end
	
	-- Just server from here
	if CLIENT then
		return
	end
	
	-- Get nearby howlers
	local iHowlers = #GetHowlers( mOwner:GetPos(), 450 ) or 1
	if iHowlers == 0 then iHowlers = 1 end
	
	-- Find in sphere
	local iDistance, iRandom = 450, math.Rand( 1, 2.5 )
	-- for k,v in pairs ( ents.FindInSphere ( self.Owner:GetPos(), iDistance ) ) do
	for k,v in ipairs ( team.GetPlayers(TEAM_HUMAN) ) do
	
		-- Players
		if v:IsPlayer() and v:IsHuman() and v:Alive() and v:GetPos():Distance(self.Owner:GetPos()) <= iDistance then
			local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * iDistance )
			local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
			
			-- Exploit trace
			if Trace.Hit then
				if ValidEntity ( Trace.Entity ) then
					if Trace.Entity == v then
						local fDistance = v:GetPos():Distance( self.Owner:GetPos() )
						local iFuckIntensity = math.Clamp ( 4.5 - ( ( fDistance / iDistance ) * 10 ), 1, 2 )
						-- if v:GetHumanClass() == 3 then iFuckIntensity = iFuckIntensity * math.Rand(1.8,2.3) end
						-- Event
						GAMEMODE:OnPlayerHowlered(v, iFuckIntensity)
											
						-- Inflict damage
						local fDamage = math.Round ( math.Clamp ( ( 22 - ( fDistance / 10 ) ) / iHowlers, 0, 5 ) * 2 )
						-- if v:GetHumanClass() == 3 then fDamage = fDamage * math.Rand(1.8,2.3) end
						if fDamage > 0 then v:TakeDamage ( fDamage, self.Owner, self ) end
					end
				end
			end
		end
		
		-- Shield zombies in range
		if iRandom <= 1.5 then
			if v:IsPlayer() and v:IsZombie() and v:Alive() then
				if not v:HasHowlerProtection() and self.Owner:GetPos():Distance( v:GetPos() ) <= self.ProtectionDistance then
					local iDuration = 1.3 + 2.5 
					v.HowlerProtection = iDuration + CurTime()
					
					-- Send usermessage
					net.Start( "howlerDoProtection" ) net.Send(v)
				end
			end
		end
	end
	
	-- On trigger play sound
	if iRandom <= 1.5 then
		self.Owner:EmitSound( "ambient/energy/zap6.wav" )
	end
	
	-- Scream effect for myself
	self.Owner:SendLua( "WraithScream()" )
	
	-- Pull or push targeted object
	local Filter = { mOwner }
	table.Add( Filter, team.GetPlayers( TEAM_UNDEAD ) )
	
	-- Trace to object, see if you see it
	local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.PropTKDistance )
	local Trace = util.TraceLine ( { start = vPos, endpos = vEnd, filter = Filter, mask = MASK_SOLID } )
	
	-- Check object
	if IsValid( Trace.Entity ) then
		local mTK = Trace.Entity
		
		-- Calculate velocity
		local Velocity = -1 * mOwner:GetForward() * 225
		if not bPull then Velocity = -1 * Velocity * 2 end
		
		-- Apply velocity
		if mTK:IsPlayer() and mTK:IsHuman() then
			if ( mTK.HowlerKickTimer or 0 ) <= CurTime() then
				Velocity.x, Velocity.y, Velocity.z = Velocity.x * 0.5, Velocity.y * 0.5, math.random( 250, 270 )
				if not bPull then Velocity = Vector( Velocity.x * 0.4, Velocity.y * 0.4, Velocity.z ) end
			
				-- Player cooldown and apply velocity
				mTK.HowlerKickTimer = CurTime() + 3.2
				mTK:SetVelocity( Velocity )
				
				-- Play sound
				timer.Simple( 0.2, function()
					if IsValid( mTK ) then
						WorldSound( "npc/barnacle/barnacle_bark1.wav", mTK:GetPos() + Vector( 0,0,20 ), 120, math.random( 60, 75 ) )
					end
				end )
			end
		else
			if IsValid( mTK:GetPhysicsObject() ) then
			
				-- Calculate needed velocity
				local fMass = mTK:GetPhysicsObject():GetMass()
				Velocity = -1 * ( mOwner:GetForward() * 225 ) / ( fMass * 0.02 )
				if not bPull then Velocity = -1 * Velocity * 1.3 end
				
				-- Play sound
				-- timer.Simple( 0.2, function()
					if IsValid( mTK ) then
						WorldSound( "npc/barnacle/barnacle_bark1.wav", mTK:GetPos() + Vector( 0,0,20 ), 120, math.random( 60, 75 ) )
					end
				-- end)
				
				-- Apply velocity
				mTK:SetPhysicsAttacker( mOwner )
				mTK:GetPhysicsObject():SetVelocity( Velocity )
			end
		end
	end
end

function SWEP:Think()
	self:CheckScream()

	return self.BaseClass.Think(self)
end

function SWEP:CheckScream()
	local rend = self:GetScreamEndTime()
	if rend == 0 or CurTime() < rend then return end
	self:SetScreamEndTime(0)
	
	if SERVER then
		local pl = self.Owner
		-- GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
	end
	
end

function SWEP:SetScreamEndTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetScreamEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsScreaming()
	return self:GetScreamEndTime() > 0
end

function SWEP:PrimaryAttack()
	self:DoAttack(true)
end

function SWEP:SecondaryAttack()
	self:DoAttack(false)
end

function SWEP:Move(mv)
	if self:IsScreaming() then
		mv:SetMaxSpeed(0)
		return true
	end
end

if SERVER then
	util.AddNetworkString( "howlerDoProtection" )
elseif CLIENT then
	net.Receive( "howlerDoProtection", function( len )
		for k,v in pairs ( ents.FindInSphere ( MySelf:GetPos(), 220 ) ) do
			if v:IsPlayer() and v:IsZombie() and v:Alive() and not (v:IsZombine() and v.bCanSprint) then
				if not v:HasHowlerProtection() then
					local iDuration = 1.3 + 2.5 
					v.HowlerProtection = iDuration + CurTime()
				end
			end
		end	
			
		-- Predict for self
		if not MySelf:HasHowlerProtection() then
			local iDuration = 1.3 + 2.5
			MySelf.HowlerProtection = iDuration + CurTime()
		end	
		
		-- Wraith scream
		WraithScream()
	end)
end

-- Prediction trick
local function howlerDoProtection()
	for k,v in pairs ( ents.FindInSphere ( MySelf:GetPos(), 220 ) ) do
		if v:IsPlayer() and v:IsZombie() and v:Alive() and not (v:IsZombine() and v.bCanSprint) then
			if not v:HasHowlerProtection() then
				local iDuration = 1.3 + 2.5 
				v.HowlerProtection = iDuration + CurTime()
			end
		end
	end	
		
	-- Predict for self
	if not MySelf:HasHowlerProtection() then
		local iDuration = 1.3 + 2.5
		MySelf.HowlerProtection = iDuration + CurTime()
	end	
	
	-- Wraith scream
	WraithScream()
end
if CLIENT then
	usermessage.Hook( "howlerDoProtection", howlerDoProtection )
end

function SWEP:Reload()
	return false
end

if SERVER then
	function SWEP:OnDrop()
		if self and self:IsValid() then
			self:Remove()
		end
	end
end

if CLIENT then
	function SWEP:DrawHUD()
		GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck )
	end
end

function SWEP:_OnRemove()
	if CLIENT then
		self:RemoveArms()
	end
end

function SWEP:OnInitialize()
	if CLIENT then
		self:MakeArms()
	end
end

 

local lerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	lerp = math.Approach(lerp, 0, FrameTime() * ((lerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), 64 * lerp)
	if lerp > 0 then
		pos = pos + -8 * lerp * ang:Up() + -12 * lerp * ang:Forward()
	end
	return pos, ang
	--return self.BaseClass.GetViewModelPosition(self, pos, ang)
end

if CLIENT then

function SWEP:OnViewModelDrawn()

	local vm = self.Owner:GetViewModel();
	if IsValid(self.Arms) and IsValid(vm) then
		
		if self.Arms:GetModel() ~= self.Owner:GetModel() and self.Owner:GetModel() ~= "models/zombie/fast.mdl" then
			self.Arms:SetModel(self.Owner:GetModel())
		end
			
		render.SetBlend(1) 
			self.Arms:SetParent(vm)
			
			self.Arms:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
			
			for b, tbl in pairs(PlayerModelBones) do
				if tbl.ScaleDown then
					local bone = self.Arms:LookupBone(b)
					if bone and self.Arms:GetManipulateBoneScale(bone) == Vector(1,1,1) then
						self.Arms:ManipulateBoneScale( bone, Vector(0.00001, 0.00001, 0.00001) )
					end
				else
					if not tbl.Arm then
						local bone = self.Arms:LookupBone(b)
						if bone and self.Arms:GetManipulateBoneScale(bone) == Vector(1,1,1) then
							self.Arms:ManipulateBoneScale( bone, Vector(1.5, 1.5, 1.5) )
						end
					end
				end
			end
			
			self.Arms:SetRenderOrigin( vm:GetPos()-vm:GetAngles():Forward()*20-vm:GetAngles():Up()*60 )-- self.Arms[1]:SetRenderOrigin( EyePos() )
			self.Arms:SetRenderAngles( vm:GetAngles() )
			
			self.Arms:SetupBones()	
			self.Arms:DrawModel()
			
			self.Arms:SetRenderOrigin()
			self.Arms:SetRenderAngles()
			
		render.SetBlend(1)
	end
	
end

function SWEP:MakeArms()

	self.Arms = ClientsideModel("models/player/group01/male_04.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE) 
	
	if (ValidEntity(self.Arms)) and (ValidEntity(self)) then 
		self.Arms:SetPos(self:GetPos())
		self.Arms:SetAngles(self:GetAngles())
		self.Arms:SetParent(self) 
		self.Arms:SetupBones()
		-- self.Arms:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
		self.Arms:SetNoDraw(true) 
	else
		self.Arms = nil
	end
	
end

function SWEP:RemoveArms()
	if (ValidEntity(self.Arms)) then
		self.Arms:Remove()
	end
		self.Arms = nil
end

end