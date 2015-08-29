-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Constants
local MAX_WEIGHT, MAX_SPEED = 10, 230

-- We are going to need player and cMove tables
local PLAYER, CMOVE = FindMetaTable ( "Player" ), FindMetaTable ( "CMoveData" )

-- Used to predict weapon pickups both clientside and serverside
if CLIENT then hook.Add ( "HUDWeaponPickedUp", "GM:WeaponPickUp", function ( mWeapon ) gamemode.Call ( "OnWeaponEquip", MySelf, mWeapon ) end ) end

local function Initialize( pl )
	pl.Weight = 0
end
hook.Add ( "PlayerInitialSpawn", "InitWeightSpeed", Initialize )


-- Call weapon equip for first time @ client
local function EquipCall( pl )
	if pl == MySelf then
		for k,v in pairs ( pl:GetWeapons() ) do
			gamemode.Call ( "OnWeaponEquip", pl, v )
		end
	end
end
if CLIENT then hook.Add ( "PlayerSpawn", "EquipCall", EquipCall ) end

local function OnEquip ( pl, mWeapon )
	
	local fHealth = pl:Health()

end
hook.Add ( "OnWeaponEquip", "OnEquip", OnEquip )

function PLAYER:GetWeight()
	return self.Weight
end

function PLAYER:SetWeight( fWeight )
	self.Weight = fWeight
end

--[==[----------------------------------------------------
      Returns if move is strafe-ing backward
-----------------------------------------------------]==]
function CMOVE:StrafeBackward()
	return self:GetForwardSpeed() < 0 and ( CMove:GetSideSpeed() < 0 or CMove:GetSideSpeed() > 0 )
end

--[==[----------------------------------------------------
      Returns if move is strafe-ing back-right
-----------------------------------------------------]==]
function CMOVE:StrafeBackRight()
	return self:GetForwardSpeed() < 0 and CMove:GetSideSpeed() > 0
end

--[==[----------------------------------------------------
      Returns if move is strafe-ing back-left
-----------------------------------------------------]==]
function CMOVE:StrafeBackLeft()
	return self:GetForwardSpeed() < 0 and CMove:GetSideSpeed() < 0
end

--[==[----------------------------------------------------
      Returns if move is forward, combo
-----------------------------------------------------]==]
function CMOVE:ComboForward()
	return self:GetForwardSpeed() > 0
end

--[==[----------------------------------------------------
      Returns if move is backward, combo
-----------------------------------------------------]==]
function CMOVE:ComboBackward()
	return self:GetForwardSpeed() < 0
end

--[==[---------------------------------------------------
      Returns if move is strafe-ing forward
---------------------------------------------------]==]
function CMOVE:StrafeForward()
	return self:GetForwardSpeed() > 0 and ( CMove:GetSideSpeed() < 0 or CMove:GetSideSpeed() > 0 )
end

--[==[-----------------------------------------
    Returns if move is walking forw.
-----------------------------------------]==]
function CMOVE:Forward()
	return self:GetForwardSpeed() > 0 and self:GetSideSpeed() == 0
end

--[==[-----------------------------------------
    Returns if move is walking backw.
-----------------------------------------]==]
function CMOVE:Backward()
	return self:GetForwardSpeed() < 0 and self:GetSideSpeed() == 0
end

--[==[-------------------------------------------------------
           Returns if move is strafe combo-right
--------------------------------------------------------]==]
function CMOVE:ComboStrafeRight()
	return self:GetSideSpeed() > 0
end

--[==[--------------------------------------------------------
          Returns if move is strafe combo-left
--------------------------------------------------------]==]
function CMOVE:ComboStrafeLeft()
	return self:GetSideSpeed() < 0
end

--[==[-----------------------------------------
    Returns if move is walking strafe
-----------------------------------------]==]
function CMOVE:Strafe()
	return ( self:GetSideSpeed() < 0 or self:GetSideSpeed() > 0 ) and self:GetForwardSpeed() == 0
end

--[==[---------------------------------------------
    Returns if move is strafeing right
-----------------------------------------------]==]
function CMOVE:StrafeRight()
	return ( self:GetSideSpeed() > 0 and self:GetForwardSpeed() == 0 )
end

--[==[---------------------------------------------
     Returns if move is strafeing left
----------------------------------------------]==]
function CMOVE:StrafeLeft()
	return ( self:GetSideSpeed() < 0 and self:GetForwardSpeed() == 0 )
end

--[==[----------------------------------------------------------
		Set both side/forward speed
-----------------------------------------------------------]==]
function CMOVE:SetSpeed ( iSpeed )
	if not iSpeed then return end
	
	-- Moving forward or backwards
	if self:ComboForward() then self:SetForwardSpeed ( iSpeed ) elseif self:ComboBackward() then self:SetForwardSpeed ( -1 * iSpeed ) end
	
	-- Moving left or right
	if self:ComboStrafeLeft() then self:SetSideSpeed ( -1 * iSpeed ) elseif self:ComboStrafeRight() then self:SetSideSpeed ( iSpeed ) end
end

-- Semi-predicted player take damage hook
local function OnPlayerTakeDamage ( ent, attacker, damage )
	if not IsEntityValid ( ent ) then return end
	
	-- Humans only
	if not ent:IsHuman() then return end
	
	-- Daze victim
	if SERVER then ent:Daze() else if ent == MySelf then ent:Daze() end end
end
-- hook.Add ( "PlayerTakeDamage", "OnPlayerTakeDamage", OnPlayerTakeDamage ) 

function PLAYER:Daze( iDuration )
	if not iDuration then iDuration = 1 end
	if self.IsDazed then return end
	
	-- Lower speed
	self.DazeBeforeSpeed = self:GetMaxSpeed()
	
	-- Status
	self.IsDazed = true
	self.DazeTime = CurTime() + iDuration
	self.DazeDuration = iDuration
	
	-- -- Disable the daze
	timer.Simple ( iDuration, function() 
		if not IsEntityValid ( self ) then return end
		
		-- Daze status
		self.IsDazed = false
	end)
end

-- cMove functions
local cMove = {}
cMove.ZomboMove = {}

function cMove.ZomboMove ( pl, CMove )
	local iForward = CMove:GetForwardSpeed()
	local iSide = CMove:GetSideSpeed()
	
	if pl.IsDazed then
		local iTimeLeft = pl.DazeTime - CurTime()
		local fMul = iTimeLeft / pl.DazeDuration
		
		-- New speed
		local iNewSpeed = pl.DazeBeforeSpeed * ( 1 - fMul ) 
		
		if CMove:GetForwardSpeed() < 0 then
			iNewSpeed = iNewSpeed * SPEED_PENALTY
		end	
		
		CMove:SetSpeed ( iNewSpeed )		
		return
	end	
	--[[
	-- Sprinting
	if pl.bCanSprint then
		-- Slow down side move
		if CMove:Strafe() then
			CMove:SetSideSpeed(iSide * 0.4)
		end
		
		-- Backwards walk is slower
		if iForward < 0 then
			CMove:SetForwardSpeed ( iForward * 0.4 )
			if ( iForward < 0 and iSide > 0 ) or ( iForward < 0 and iSide < 0 ) then CMove:SetSideSpeed ( iSide * 0.4 ) end
				
			return
		end
	end
	]]--
end

function cMove.HumanMove ( pl, CMove )
	local iForward = CMove:GetForwardSpeed()
	local iSide = CMove:GetSideSpeed()
	
	-- Player is dazed
	if pl.IsDazed then
		local iTimeLeft = pl.DazeTime - CurTime()
		local fMul = iTimeLeft / pl.DazeDuration
		
		-- New speed
		local iNewSpeed = pl.DazeBeforeSpeed * ( 1 - fMul ) 
		
		if CMove:GetForwardSpeed() < 0 then
			iNewSpeed = iNewSpeed * SPEED_PENALTY
		end	
		
		CMove:SetSpeed ( iNewSpeed )		
		return
	end
	
	--print(iSide)
	-- Walking backwards slows
end

-- Wondering if I should enable this or not
function GM:Move( pl, CMove )

	if not pl.IsDazed then
		if pl:GetVelocity().z < -190 then
			pl:Daze(0.6)
		elseif pl:GetVelocity().z < -100 then
			pl:Daze(0.4)			
		elseif pl:GetVelocity().z < -60 then

		end
		
		if pl:Crouching() and not pl:OnGround() and CMove:GetForwardSpeed() > 0 then
			pl:Daze(1)
		end
		
		
		
	end
	
	
	
	if CMove:GetForwardSpeed() < 0 then
		--CMove:SetForwardSpeed ( -11 )
		CMove:SetSpeed (SPEED*SPEED_PENALTY)		
	end		
	
	--print(pl:GetForwardSpeed()) 

	-- Move data for humans
	if pl:IsHuman() then cMove.HumanMove ( pl, CMove )return end
	if pl:IsZombie() then 
		local wep = pl:GetActiveWeapon()
				if wep and IsValid(wep) and wep.Move then 
					wep:Move(CMove) 
				end
		cMove.ZomboMove ( pl, CMove )
		return
	end	
	-- Move data for zombos
	--[[
	if pl:IsZombie() then 
		local wep = pl:GetActiveWeapon()
		if wep and IsValid(wep) and wep.Move then 
			wep:Move(CMove) 
			return 
		end
	
		if cMove.ZomboMove[ pl:GetZombieClass() ] then 
			cMove.ZomboMove[ pl:GetZombieClass() ]( pl, CMove ) 
			return 
		end 		
	end
	
	]]--
end

Debug ( "[MODULE] Loaded 'Speed' Script!" )


