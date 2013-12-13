-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	local umsg = umsg
end

local meta = FindMetaTable("Player")
if not meta then return end

-- Returns if player is taking DOT
function meta:IsTakingDOT()
	return self:GetDTBool( 0 )
end

-- Zombie raging
function meta:IsZombieInRage()
	return self.IsInRage and self:IsZombie() and self:IsCommonZombie()
end

-- Player invisible
function meta:IsInvisible()
	local r,g,b,a = self:GetColor() return ( tonumber( a ) <= 1 )
end

-- Zombie howler protected
function meta:HasHowlerProtection()
	return self:IsZombie() and ( self.HowlerProtection and self.HowlerProtection > CurTime() )
end

-- Poison zombie healing aura
function meta:IsZombieInAura()
	return self.InHealTime and self.InHealTime > CurTime()
end

function meta:GetHandsModel()
	return player_manager.TranslatePlayerHands(self.PlayerModel)
end

function meta:IsZombieInHorde()
	if not ValidEntity(self) then return end
	if not self:Alive() then return end
	if not self:IsZombie() then return end
	
	local ct = CurTime()
	
	self._LastHordeTime = self._LastHordeTime or 0
	
	if self._LastHordeTime >= ct then
		if self._LastHordeCount and self._LastHordeCount ~= 0 then
			return true
		else
			return false
		end
	end
	
	self._LastHordeTime = ct + 4
	
	for _, Zombie in ipairs( team.GetPlayers(TEAM_UNDEAD) ) do
		if IsValid( Zombie ) and Zombie:Alive() and Zombie ~= self and self:GetPos():Distance(Zombie:GetPos()) <= HORDE_MAX_DISTANCE then
			return true
		end
	end
	return false
end

local LastHordeCount = 0
local LastHordeTime = 0
function meta:GetHordeCount(beat)
	if LastHordeTime <= CurTime() then
		LastHordeTime = CurTime() + 1
		
		local max = math.min(team.NumPlayers(TEAM_UNDEAD),HORDE_MAX_ZOMBIES)
		if beat then
			max = 10
		end
		
		LastHordeCount = math.Clamp(GetZombieFocus( self, HORDE_MAX_DISTANCE ),0,max)
	end

	return LastHordeCount or 0
end

local LastResistanceCount = 0
local LastResistanceTime = 0
function meta:GetResistanceCount()
	if LastResistanceTime <= CurTime() then
		LastResistanceTime = CurTime() + 1
		
		local max = math.min(team.NumPlayers(TEAM_UNDEAD),HORDE_MAX_ZOMBIES)
		if beat then
			max = 10
		end
		
		LastResistanceCount = math.Clamp(team.NumPlayers(TEAM_UNDEAD) - GetZombieFocus(self, HORDE_MAX_DISTANCE), 0, max)
	end

	return LastResistanceCount or 0
end

function meta:GetHordePercent()
	return (self:GetHordeCount()/HORDE_MAX_ZOMBIES)*(HORDE_MAX_RESISTANCE/100) or 0
end

-- Get spawn time
function meta:GetSpawnTime()
	return self.SpawnTime
end

-- Is spawnprotected
function meta:HasSpawnProtection()
	return self:GetSpawnTime() + self:GetSpawnTimeLimit() >= CurTime()
end

-- Get time limit
function meta:GetSpawnTimeLimit()
	if self:IsHuman() then
		return 40
	else
		return 4
	end
end

-- Get spawn time protection
function meta:GetSpawnTimeProtection()
	-- Time limit for protection
	local protectionTime, iDiff = self:GetSpawnTimeLimit()
	
	-- Calculate appropriate time
	if self:IsHuman() then
		iDiff = 0
	else
		iDiff = protectionTime
	end
	
	return math.Clamp(math.abs(iDiff - (GetInfliction() * protectionTime)), 5, protectionTime)
end

-- Get suitable damage
function meta:GetSpawnDamagePercent()

	-- Time limit for protection
	local protectionTime = self:GetSpawnTime() + self:GetSpawnTimeLimit()

	-- Percent damage reduction
	return math.Clamp((protectionTime - math.abs(CurTime() - self:GetSpawnTime())) / protectionTime, 0, 1)
end

-- Hook on spawn
hook.Add("PlayerSpawn", "SpawnTime", function(pl)
	pl.SpawnTime = CurTime()
end)

--[=[---------------------------------------
      Returns active human level
----------------------------------------]=]
function meta:GetLevel()
	if not self.DataTable or ( self.DataTable and not self.DataTable.ClassData ) then return end
	
	return self.DataTable["ClassData"][ string.lower ( self:GetHumanClassString() ) ].level
end

--[=[-----------------------------------------------------------
       Returns the name of the active human class
------------------------------------------------------------]=]
function meta:GetHumanClassString()
	return HumanClasses[ self:GetHumanClass() ].Name
end

--[=[--------------------------------------
       See if player is a human
---------------------------------------]=]
function meta:IsHuman()
	return self:Team() == TEAM_HUMAN
end

--[=[---------------------------------------
       See if player is a zombie
----------------------------------------]=]
function meta:IsZombie()
	return self:Team() == TEAM_UNDEAD
end

function meta:SyncAngles()
	local ang = self:EyeAngles()
	ang.pitch = 0
	ang.roll = 0
	return ang
end

--[=[-------------------------------------------
         See if player is a spectator
---------------------------------------------]=]
function meta:IsSpectator()
	return self:Team() == TEAM_SPECTATOR
end

function meta:IsFreeSpectating()
	return self:GetObserverMode() == OBS_MODE_ROAMING or self:GetObserverMode() == OBS_MODE_CHASE
end

function meta:GetMeleeFilter()
	return team.GetPlayers(self:Team())
end

function meta:TraceHull(distance, mask, size, filter, start)
	start = start or self:GetShootPos()
	return util.TraceHull({start = start, endpos = start + self:GetAimVector() * distance, filter = filter or self, mask = mask, mins = Vector(-size, -size, -size), maxs = Vector(size, size, size)})
end

function meta:DoubleTrace(distance, mask, size, mask2, filter)
	local tr1 = self:TraceLine(distance, mask, filter)
	if tr1.Hit then return tr1 end
	if mask2 then
		local tr2 = self:TraceLine(distance, mask2, filter)
		if tr2.Hit then return tr2 end
	end

	local tr3 = self:TraceHull(distance, mask, size, filter)
	if tr3.Hit then return tr3 end
	if mask2 then
		local tr4 = self:TraceHull(distance, mask2, size, filter)
		if tr4.Hit then return tr4 end
	end

	return tr1
end

function meta:MeleeViewPunch(damage)
	local maxpunch = (damage + 25) * 0.5
	local minpunch = -maxpunch
	self:ViewPunch(Angle(math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch), math.Rand(minpunch, maxpunch)))
end


function meta:MeleeTrace(distance, size, filter, start)
	return self:TraceHull(distance, MASK_SOLID, size, filter, start)
end

function meta:PenetratingMeleeTrace(distance, size, prehit, start)
	start = start or self:GetShootPos()

	local t = {}
	local trace = {start = start, endpos = start + self:GetAimVector() * distance, filter = self:GetMeleeFilter(), mask = MASK_SOLID, mins = Vector(-size, -size, -size), maxs = Vector(size, size, size)}
	local onlyhitworld
	for i=1, 50 do
		local tr = util.TraceHull(trace)

		if not tr.Hit then
			break
		end

		if tr.HitWorld then
			table.insert(t, tr)
			break
		end

		if onlyhitworld then
			break
		end

		local ent = tr.Entity
		if ent and ent:IsValid() then
			if not ent:IsPlayer() then
				trace.mask = MASK_SOLID_BRUSHONLY
				onlyhitworld = true
			end

			table.insert(t, tr)
			table.insert(trace.filter, ent)
		end
	end

	if prehit and (#t == 1 and not t[1].HitNonWorld and prehit.HitNonWorld or #t == 0 and prehit.HitNonWorld) then
		t[1] = prehit
	end

	return t
end

--[=[---------------------------------------------------------
     Used to get what pistols the player is holding
---------------------------------------------------------]=]
function meta:GetPistol()
	local MyWeapons, Pistols = self:GetWeapons(), {}

	for k,v in pairs ( MyWeapons ) do
		if v:IsValid() then
			if v:GetType() == "pistol" then
				table.insert ( Pistols, v )
			end
		end
	end
	
	return Pistols[1] or false
end

--[=[---------------------------------------------------------
     Used to check if player has a weapon
	 Note: This is a GLua function but it was only serverside
---------------------------------------------------------]=]
if CLIENT then
	function meta:HasWeapon(className)
		if not className then
			return false
		end	
		
		local weaponsTable = self:GetWeapons()

		for k, wep in pairs(weaponsTable) do
			--Check for invalid weapons
			if not wep:IsValid() then
				continue
			end
			
			--Check if classes don't match
			if wep:GetClass() ~= className then
				continue
			end
			
			--Match found
			return true
		end
		
		--Weapon not found
		return false
	end
end

--[=[-------------------------------------------------------------------------
     Used to get what rifle/smg/awp/shotgun the player is holding
-------------------------------------------------------------------------]=]
function meta:GetAutomatic()
	local MyWeapons, Automatic = self:GetWeapons(), {}

	for k,v in pairs ( MyWeapons ) do
		if v:IsValid() then
			if v:GetType() == "rifle" or v:GetType() == "smg" or v:GetType() == "shotgun" or v:GetType() == "rifle" then
				table.insert ( Automatic, v )
			end
		end
	end
	
	return Automatic[1] or false
end

--[=[----------------------------------------------------------------
     Used to get what melee weapon the player is holding
----------------------------------------------------------------]=]
function meta:GetMelee()
	local MyWeapons, Melee = self:GetWeapons(), {}

	for k,v in pairs ( MyWeapons ) do
		if v:IsValid() then
			if v:GetType() == "melee" then
				table.insert ( Melee, v )
			end
		end
	end
	
	return Melee[1] or false
end

--[=[----------------------------------------------------------------
     Used to get what melee weapon the player is holding
----------------------------------------------------------------]=]
function meta:GetTools()
	local MyWeapons, Tools = self:GetWeapons(), {}

	for k,v in pairs ( MyWeapons ) do
		if v:IsValid() then
			if v:GetType() == "tools" then
				table.insert ( Tools, v )
			end
		end
	end
	
	return Tools[1] or false
end

--[=[----------------------------------------------------------------
     Used to compare 2 weapons and return strongest one
----------------------------------------------------------------]=]
function meta:CompareMaxDPS ( Class1, Class2 )
	if Class1 == nil or Class2 == nil then return end
	if type ( Class1 ) ~= "string" or type ( Class2 ) ~= "string" then return end
	
	-- Get damage (dps)
	local TableDPS = { [ tostring( Class1 ) ] = GetWeaponDPS ( Class1 ), [ tostring( Class2 ) ] = GetWeaponDPS ( Class2 ) }

	-- Compare them
	local Compare, WeaponWin = -5500
	for k,v in pairs ( TableDPS ) do
		if v > Compare then
			Compare = v
			WeaponWin = k
		end
	end

	return WeaponWin or "weapon_zs_usp"
end

function meta:GetSurvivalPercent()
	if self:IsZombie() then return 1 end
	
	-- Default 100%
	local fPercent = 1
	
	-- Get zombies near for start
	local iZombies, fNearZombiePercent = GetZombieFocus( self, 300 )
	fNearZombiePercent = 1 - ( math.Clamp ( iZombies, 0, 6 ) / 6 )
	
	-- Get total zombies
	local iTotalZombs = team.NumPlayers ( TEAM_UNDEAD )
	fZombiePercent = 1 - iTotalZombs / #player.GetAll()
	
	-- Health percent
	local fHealth, iMaxHealth, fHealthPercent = self:Health(), self:GetMaximumHealth()
	fHealthPercent = fHealth / iMaxHealth
	
	-- Per total
	fPercent = ( fNearZombiePercent + fZombiePercent + fHealthPercent ) / 3
	
	return fPercent
end

--[==[---------------------------------------------------------
      Return the amount time left to ammo regen
---------------------------------------------------------]==]
function meta:GetAmmoTime()
	if self:Team() ~= TEAM_HUMAN then return 0 end
	
	-- the variable is missing
	if self.AmmoRegenTime == nil then return 0 end
	
	return self.AmmoRegenTime
end

--[==[----------------------------------------------------------
             Shared get weapon function/method
-----------------------------------------------------------]==]
meta.BaseGetWeapon = meta.GetWeapon
function meta:GetWeapon(Class)
	if Class == nil then return end
	
	-- Base function - Server function
	if SERVER then return self:BaseGetWeapon ( Class ) end
	
	-- Client function
	if SERVER then return end
	
	-- Loop through weapons
	local tbWeapons = self:GetWeapons()
	for k,v in pairs ( tbWeapons ) do
		if v:GetClass() == Class then
			return v
		end
	end
end

--[==[---------------------------------------------------
        Improved clientside/serverside FOV
----------------------------------------------------]==]
meta.BaseSetFOV = meta.SetFOV
function meta:SetFOV(Fov, Time)
	if Fov == nil then return end
	
	-- Server-side default function
	if SERVER then self:BaseSetFOV ( Fov, Time ) end
	
	-- Clientside function
	if CLIENT then self.Fov = Fov or GetConVar("fov_desired"):GetInt() end
end

--[==[---------------------------------------------------
        Improved clientside/serverside FOV
----------------------------------------------------]==]
meta.BaseGetFOV = meta.GetFOV
-- function meta:GetFOV()
-- 	if SERVER then return self:BaseGetFOV() else return self.ApproachFov or GetConVar("fov_desired"):GetInt() end
-- end

--[==[---------------------------------------------------------
   Overwrite base give function so we can clamp it
---------------------------------------------------------]==]
meta.BaseGiveAmmo = meta.GiveAmmo
function meta:GiveAmmo( Amount, AmmoType )
	if CLIENT then return end
	if Amount == 0 then return end
	
	-- If the player has no weapons then our job is done
	if #self:GetWeapons() == 0 then return end
	
	-- We need a ranged bullet weapon for this
	local AmmoCount, MaximumLoad, Gun = self:GetAmmoCount ( AmmoType )
	local WeaponType = GetWeaponTypeByAmmo ( AmmoType ) 
	
	-- Get weapons
	local Pistol, Automatic = self:GetPistol(), self:GetAutomatic()
	
	-- Check which weapon we should clamp the ammo on
	if WeaponType == "Pistol" then if ValidEntity ( Pistol ) then Gun = Pistol end end
	if WeaponType == "Automatic" then if ValidEntity ( Automatic ) then Gun = Automatic end end
	
	if Gun then
		local Clamper, Multiplier = 350, 8
		
		-- Pistols and automatic guns are different so use different maximum values
		if GetWeaponCategory ( Gun:GetClass() ) == "Automatic" then
			Clamper, Multiplier = 750, 8
		end
		
		--Fix max. ammo at 9999 for now
		MaximumLoad = 9999
	end
		
	-- Clamp it
	Amount = ARENA_MODE and Amount or math.Clamp ( Amount, 1, ( ( MaximumLoad or 750 ) - AmmoCount ) )
	
	-- Actually give the player ammunition
	self:BaseGiveAmmo( Amount, AmmoType )
end

--[==[----------------------------------------------
        No, it doesn't check for health
-----------------------------------------------]==]
meta.OldAlive = meta.Alive
function meta:Alive()
	if self:GetObserverMode() ~= OBS_MODE_NONE or self:Team() == TEAM_UNDEAD and self:IsCrow() then return false end

	return self:OldAlive()
end

meta.OldSetWalkSpeed = meta.SetWalkSpeed

function meta:SetWalkSpeed( s )
	self:OldSetWalkSpeed( s + (s >= 2 and SHARED_SPEED_INCREASE or 0)) 
end

meta.OldSetRunSpeed = meta.SetRunSpeed

function meta:SetRunSpeed( s )
	self:OldSetRunSpeed( s + (s >= 2 and SHARED_SPEED_INCREASE or 0))
end

--[=[function meta:Alive()
	if self:GetMoveType() == MOVETYPE_OBSERVER then return false end

	return self.BaseAlive
end

local oldspec = meta.Spectate
function meta:Spectate(obsm)
	self:StripWeapons()
	oldspec(self, obsm)
	print(tostring(self).." spectating")
end

local oldunspec = meta.UnSpectate
function meta:UnSpectate()
	if self:GetMoveType() == MOVETYPE_OBSERVER then
		oldunspec(self, obsm)
		print(tostring(self).." unspectated")
	end
end]=]

--[=[function meta:Alive()

	-- Using only health verif.
	local bAlive = true
	if self:Health() <= 0 then bAlive = false end
	
	return bAlive
end]=]

--[==[----------------------------------------------------
	    See if zombie is common type
----------------------------------------------------]==]
function meta:IsCommonZombie()
	return self:GetZombieClass() == 1
end

--[==[------------------------------------------------
	  See if zombie is fast type
------------------------------------------------]==]
function meta:IsFastZombie()
	return self:GetZombieClass() == 2
end

--[==[--------------------------------------------------
	  See if zombie is poison type
---------------------------------------------------]==]
function meta:IsPoisonZombie()
	return self:GetZombieClass() == 3
end

--[==[-----------------------------------------
	See if zombie is apparation
-----------------------------------------]==]
function meta:IsWraith()
	return self:GetZombieClass() == 4
end

--[==[-----------------------------------------
	See if zombie is a howler
-----------------------------------------]==]
function meta:IsHowler()
	return self:GetZombieClass() == 5
end

--[==[-------------------------------------------
	See if zombie is a headcrab
--------------------------------------------]==]
function meta:IsHeadcrab()
	return self:GetZombieClass() == 6
end

--[==[-------------------------------------------
	See if zombie is a p. crab
--------------------------------------------]==]
function meta:IsPoisonCrab()
	return self:GetZombieClass() == 7
end

function meta:IsCrow ()
	return self:GetZombieClass() == 9
end

--[==[----------------------------------------------
	See if zombie is a chem. zombie
------------------------------------------------]==]
function meta:IsChemZombie()
	return self:GetZombieClass() == 66
end

function meta:IsBossZombie()
	return ZombieClasses[self:GetZombieClass()] and ZombieClasses[self:GetZombieClass()].IsBoss
end

function meta:IsSuperBossZombie()
	return ZombieClasses[self:GetZombieClass()] and ZombieClasses[self:GetZombieClass()].IsSuperBoss
end

--[==[------------------------------------------
	See if zombie is a zombine
------------------------------------------]==]
function meta:IsZombine()
	return self:GetZombieClass() == 8
end

--[==[---------------------------------------
	See if a human is medic
---------------------------------------]==]
function meta:IsMedic()
	return self:GetHumanClass() == 1
end

--[==[------------------------------------------
	See if a human is commando
--------------------------------------------]==]
function meta:IsCommando()
	return self:GetHumanClass() == 2
end

--[==[--------------------------------------------
	See if a human is berserker
----------------------------------------------]==]
function meta:IsBerserker()
	return self:GetHumanClass() == 3
end

--[==[------------------------------------------
	See if a human is engineer
--------------------------------------------]==]
function meta:IsEngineer()
	return self:GetHumanClass() == 4
end

--[==[------------------------------------------
	See if a human is support
------------------------------------------]==]
function meta:IsSupport()
	return self:GetHumanClass() == 5
end


--[==[-----------------------
	Return logging tag
------------------------]==]
function meta:GetClassTag()
	if (self:IsHuman()) then
		return HumanClasses[self:GetHumanClass()].Tag
	else
		return ZombieClasses[self:GetZombieClass()].Tag
	end

end

--[==[---------------------------------------------------------
      Set the amount of time left to ammo regen
---------------------------------------------------------]==]
function meta:SetAmmoTime( Time, UpdateClient )
	
	--[==[if Time == nil then return end
	if self:Team() ~= TEAM_HUMAN and SERVER then return end
	
	-- Initialize server-side checking variable since the timer is clientside
	if SERVER then if self.ServerCheckTime == nil then self.ServerCheckTime = CurTime() + AMMO_REGENERATE_RATE end end

	-- Update it
	self.AmmoRegenTime = Time
	
	-- We can't update client with umsg if we are client
	if CLIENT or UpdateClient == nil then return end
	
	-- Set it on the client
	umsg.Start ( "UpdateAmmoTime", self )
		umsg.Short ( self.AmmoRegenTime )
	umsg.End()
	
	Debug ( "Updating client Ammo-Regeneration Timer. Countdown: "..tostring ( self.AmmoRegenTime ) )
	]==]
end

--[==[----------------------------------------------------------------
          Check if the player has already voted or not
----------------------------------------------------------------]==]
function meta:HasVoted(VOTES)
	if table.HasValue(VOTES.YES, self) or table.HasValue(VOTES.NO, self) then 
		return true
	end
	
	return false
end

function meta:HasGasMask()
	return false-- self:Alive() and self:IsHuman() and self:GetWeapon("weapon_zs_pickup_gasmask") and IsValid(self:GetWeapon("weapon_zs_pickup_gasmask"))
end

function meta:IsHolding()
	return self.status_human_holding and self.status_human_holding:IsValid()
end

function meta:CanRedeem()
	if CLIENT then
		return
	end

	if not ValidEntity(self) or ENDROUND or LASTHUMAN or self:Team() ~= TEAM_UNDEAD or team.NumPlayers(TEAM_HUMAN) == 1 or self:IsBossZombie() then
		return false
	end
		
	if REDEEM and AUTOREDEEM and util.tobool(self:GetInfoNum("_zs_autoredeem",1)) then
		local requiredScore = REDEEM_KILLS
		if self:HasBought("quickredemp") then
			requiredScore = REDEEM_FAST_KILLS
		end
		
		if self:GetScore() >= requiredScore then
			--Redeem is possible
			return true
		end
	end

	return false
end

if SERVER then
	util.AddNetworkString("SetPlayerScore")
	util.AddNetworkString("SetLocalPlayerScore")
end

function meta:SetScore(newAmount)
	if not ValidEntity(self) then
		return false
	end
	
	--Set local value
	self.Score = newAmount or 0

	if SERVER then
		--Send new score to clients
		net.Start("SetPlayerScore")
		net.WriteEntity(self)
		net.WriteInt(self.Score,32)
		net.Broadcast()
		--[[net.Start("SetLocalPlayerScore")
		net.WriteEntity(self)
		net.WriteInt(self.Score,32)
		net.Send(self)]]

		--Clamp because of frags limitation bug
		self:SetFrags(math.Clamp(self.Score,-1999,1999))
	end

	return true
end

function meta:GetScore()
	return self.Score or 0
end

if SERVER then
	function meta:AddScore(amountToAdd)
		if type (amountToAdd) ~= "number" then
			ErrorNoHalt( "Wrongly called AddScore. AmountToAdd: ".. amountToAdd )
		end

		if amountToAdd == 0 or not amountToAdd then
			return 0
		end

		--Calculate new score
		local newScore = self:GetScore() + amountToAdd

		if self:SetScore(newScore) then
			return newScore
		else
			return 0
		end
	end

	--OBSOLETE
	--TODO: Check if still used somewhere
	function meta:ScoreAdd(score)
		return self:AddScore(score)
	end
end

--[==[----------------------------------------------------------
  Used to see if a player is near toxic fumes (Shared)
------------------------------------------------------------]==]
function meta:IsInToxicFumes(ToxicFumeTable)
	if not self:Alive() then return end
	if ToxicFumeTable == nil then return false end
	
	for _, point in pairs( ToxicFumeTable ) do
		local vPos if SERVER then vPos = point:GetPos() else vPos = point end
		if self:GetPos():Distance( vPos + Vector( 0,0,40 ) ) < 140 then
			return true
		end
	end
		
	return false
end

function meta:IsStuck( position, smallbox)
	if not ValidEntity(self) or not self:Alive() then return end
	
	-- Make things easier
	local pl = self
	local pos = position
	local x,y,z = pos.x,pos.y,pos.z
	local obbmins, obbmaxs 
	local filters = { }
	
	local stringFilters = { "ammo","hpvial","mine","playergib","supplybox","nail","turret", "camera" }
	
	-- Filter crows
	for k,somefilters in pairs (ents.GetAll()) do
		-- Add the weapons. Every weapon
		if string.find (somefilters:GetClass(), "weapon") then
			table.insert (filters, somefilters)
		end
		
		-- Add the entities i've wrote up
		for i = 1, #stringFilters do
			if string.find (somefilters:GetClass(), tostring (stringFilters[i])) then
				table.insert (filters, somefilters)
			end
		end
	end
		
	-- Filter Team members
	for k,filterteam in pairs (team.GetPlayers (pl:Team()) ) do
		table.insert (filters, filterteam)
	end

	-- print ("Filters are  :\n")
	-- PrintTable (filters)
	
	local playerheight = 72
	if pl:Crouching() then
		playerheight = 30
	else
		playerheight = 72
	end
	
	if smallbox == true then
		obbmins = Vector (x-10,y-10,z)
		obbmaxs = Vector (x+10,y+10,15)
	else
		obbmins = pl:OBBMins()
		if ZombieClasses[pl:GetZombieClass()].IsSmall == true then
			obbmaxs = Vector (pl:OBBMaxs().x,pl:OBBMaxs().y,40)
		else
			obbmaxs = Vector (pl:OBBMaxs().x,pl:OBBMaxs().y,playerheight)
		end
	end
	
	-- See if there are props, too (besides world) Make the box smaller so that it won't get the props near you
	local blocks = ents.FindInBox ( obbmins, obbmaxs )
	
	local StuckEntites = 0
	-- See if there are entites in the box
	for k,v in pairs (blocks) do
		if string.find(v:GetClass(), "func_physbox") or string.find(v:GetClass(), "prop") or (v:IsPlayer() and v:Alive() and v:Team() ~= pl:Team() and v ~= pl) then
			StuckEntites = StuckEntites + 1
		end
	end
	
	local hulltrace = util.TraceHull ( { start = pos, endpos = pos, filter = filters, mins = obbmins, maxs = obbmaxs } )
	local traces = 0 --- Maximum Traces = 8
	local positiontable = {
		[1] = { startpos = pos,endpos = Vector (x - 16,y,z) },
		[2] = { startpos = pos,endpos = Vector (x + 16,y,z) },
		[3] = { startpos = pos,endpos = Vector (x,y + 16,z) },
		[4] = { startpos = pos,Vector (x,y - 16,z) },
		[5] = { startpos = Vector (x - 16,y - 16,z),endpos = Vector (x - 16,y - 16,z + playerheight) },
		[6] = { startpos = Vector (x + 16,y + 16,z),endpos = Vector (x + 16,y + 16,z + playerheight) },
		[7] = { startpos = Vector (x - 16,y + 16,z),endpos = Vector (x - 16,y + 16,z + playerheight) },
		[8] = { startpos = Vector (x + 16,y - 16,z),endpos = Vector (x + 16,y - 16,z + playerheight) },
	}
	
	-- trace scripts
	for i=1,8 do
		local startpos,endpos = positiontable[i].startpos,positiontable[i].endpos
		local tracedata = {start = startpos,endpos = endpos,filter = ents.GetAll(),mask = MASK_PLAYERSOLID}
		local tr = util.TraceLine(tracedata)
		
		if tr.Hit then
			if tr.HitWorld then
				traces = traces + 1
			end
		end
	end

	if smallbox then
		return (hulltrace.Entity ~= NULL or StuckEntites > 0)
	else
		return (hulltrace.Entity ~= NULL or StuckEntites > 0) or traces > 1
	end
end

if SERVER then
	util.AddNetworkString( "notice.GetNotice" )
end

function meta:Message(sText, iType, Col, iDuration)
	
	--Send message
	if SERVER then
		
		net.Start( "notice.GetNotice" )
			net.WriteString(sText)
			net.WriteDouble(iType or 2)
			net.WriteString(Col or "zs_please")
			net.WriteDouble(iDuration or -1)
		net.Send(self)
		
		--[==[umsg.Start( "notice.GetNotice", self )
			umsg.String ( sText )
			umsg.Short ( iType )
			umsg.String ( Col )
		umsg.End()]==]
	end
	
	--Clientside
	if CLIENT then 
	    notice.Message(sText, Col, iType, iDuration) 
	end
end
	
function meta:GetZombieClass()
	return self:GetDTInt(2) or 1
end

function meta:GetHumanClass()
	return 1-- self.ClassHuman or
end

function meta:SetHumanClass ( cl )
	if CLIENT then return end

	self.ClassHuman = cl
	self.TempClassHuman = cl
	self:ConCommand("_zs_redeemclass "..cl.."")
		
	-- Add one point to each class chosen every time someone changes class. (for endgame stats)
	timer.Simple( 0.1, function() 
		if ValidEntity ( self ) then
			local classname = HumanClasses[cl].Name
			GAMEMODE.TeamMostChosenClass[ classname ] = GAMEMODE.TeamMostChosenClass[ classname ] + 1
		end
	end )
		
	-- Send information from all players to player changing class
	-- UpdatePlayerClass ( player.GetAll(), { self }, "UpdateHumanClass", "ClassHuman" )
	
	-- Send information from player changing class to all players
	-- UpdatePlayerClass ( { self }, player.GetAll(), "UpdateHumanClass", "ClassHuman" )
end

function meta:SetMaximumHealth ( Max )
	if CLIENT then return end
	
	self:SetMaxHealth ( Max )
	self.MaximumHealth = Max
	self:SetDTInt ( 0, math.Round ( Max ) )
end

function meta:GetMaximumHealth ( Health )
	return self:GetDTInt ( 0 )
end

--[=[
function meta:IsCrow ()
	if not ValidEntity (self) then return false end
	
	if (self.camera and self.camera:IsValid()) or (self:Team() == TEAM_UNDEAD and self:GetZombieClass() == 10) then
		if self.camera:GetOwner() == self then
			return true
		end
	end
	
	return false
end]=]

if SERVER then
-- util.AddNetworkString( "SendZombieClass" )
end

function meta:SetZombieClass(cl)
	if CLIENT then
		return
	end

	self.Class = cl
	self.ClassTable = ZombieClasses[cl]
	
	self:SetDTInt(2,cl)
end
--[=[
function meta:GetXP()
	if self:IsBot() then return 0 end
	if SERVER then
	
		if not self.DataTable["ClassData"]["default"] then return end
		
		return self.DataTable["ClassData"]["default"].xp
	elseif CLIENT then
		
		if MySelf == self then
			if not MySelf.DataTable then return 0 end
			if MySelf.DataTable["ClassData"] and MySelf.DataTable["ClassData"]["default"] then
				return MySelf.DataTable["ClassData"]["default"].xp
			end
		else
			return self.XP
		end
	end
	return 0
end]=]

function meta:GetXP()
	if not ValidEntity(self) then return 0 end
	if self:IsBot() then return 0 end
	
	if SERVER then
		if not self.DataTable["ClassData"]["default"] then return 0 end
		
		return self.DataTable["ClassData"]["default"].xp
	elseif CLIENT then
		if not MySelf.DataTable then return 0 end
		if MySelf.DataTable["ClassData"] and MySelf.DataTable["ClassData"]["default"] then
			return MySelf.DataTable["ClassData"]["default"].xp
		end
	end
	return 0
end


-- broke my brain while trying to figure out better calculation
function meta:NextRankXP()
	if self:IsBot() then return 0 end
		local exp = 0
		
		for i=0,self:GetRank() do
			exp = exp + XP_BLANK + XP_INCREASE_BY*(i+1)
		end

		return exp or 2000
end
function meta:CurRankXP()
	if self:IsBot() then return 0 end
		local exp = 0
		
		for i=0,math.Clamp(self:GetRank()-1,0,999999) do
			exp = exp + XP_BLANK + XP_INCREASE_BY*(i+1)
		end

		return exp or 0
end

function meta:GetRank()
	if not ValidEntity(self) then return 0 end
	if self:IsBot() then return 0 end
	if SERVER then
		if not self.DataTable["ClassData"]["default"] then return 0 end
		
		return self.DataTable["ClassData"]["default"].rank
	elseif CLIENT then
		if not MySelf.DataTable then return 0 end-- temp fix
		
		if MySelf.DataTable["ClassData"] and MySelf.DataTable["ClassData"]["default"] then
			return MySelf.DataTable["ClassData"]["default"].rank
		end
	end
	return 0
end

--[=[
function meta:GetRank()
	if self:IsBot() then return 0 end
	if SERVER then
	
		if not self.DataTable["ClassData"]["default"] then return 0 end
		
		return self.DataTable["ClassData"]["default"].rank
	elseif CLIENT then
		
		if MySelf == self then
			if not MySelf.DataTable then return 0 end-- temp fix
			if MySelf.DataTable["ClassData"] and MySelf.DataTable["ClassData"]["default"] then
				return MySelf.DataTable["ClassData"]["default"].rank
			end
		else
			return self.Rank
		end
	end
	return 0
end]=]

--[==[function meta:GetPerk()
	return self.Perk
end]==]

function meta:GetPerk(prk)
	self.Perk = self.Perk or {}
	return table.HasValue(self.Perk,prk) or false
end



function meta:IsBlocked( item )
	
	if not GAMEMODE:IsRetroMode() then return false end
	
	local blockedweapon = GAMEMODE.HumanWeapons[item] and GAMEMODE.HumanWeapons[item].NoRetro == true 
	local blockedperk = GAMEMODE.Perks[item] and GAMEMODE.Perks[item].NoRetro == true 
	
	if blockedweapon or blockedperk then
		return true
	end
	
	return false
end


function meta:IsRetroOnly( item )
		
	local allowedweapon = GAMEMODE.HumanWeapons[item] and GAMEMODE.HumanWeapons[item].OnlyRetro == true 
	local allowedperk = GAMEMODE.Perks[item] and GAMEMODE.Perks[item].OnlyRetro == true 
	
	if GAMEMODE:IsRetroMode() and (allowedweapon or allowedperk) then
		return true
	end
	
	return false
end

function meta:HasUnlocked(item)
	local unl = false
	
	for i=0,table.maxn(GAMEMODE.RankUnlocks) do
		if i > self:GetRank() or not GAMEMODE.RankUnlocks[i] then
			continue
		end
		
		for _,v in pairs(GAMEMODE.RankUnlocks[i]) do
			if item == v then
				unl = true
			end
		end
	end
	
	return unl
end

function meta:TraceLine ( distance, _mask, filter )
	local vStart = self:GetShootPos()
	if filter then 
		return util.TraceLine({start=vStart, endpos = vStart + self:GetAimVector() * distance, filter = self, mask = _mask, filter = filter })
	else
		return util.TraceLine({start=vStart, endpos = vStart + self:GetAimVector() * distance, filter = self, mask = _mask })
	end
end

function meta:IsNearCrate()
	local pos = self:EyePos()

	for _, ent in pairs(ents.FindByClass("game_supplycrate")) do
		local nearest = ent:NearestPoint(pos)
		if pos:Distance(nearest) <= 120 then
			return true
		end
	end

	return false
end

function meta:PlaySound(sound)
	if CLIENT then return end
	if not self:IsValid() then return end 
	
	umsg.Start("PlaySoundClient", self)
		umsg.String(sound)
	umsg.End() 
end

local ViewHullMins = Vector(-8, -8, -8)
local ViewHullMaxs = Vector(8, 8, 8)
function meta:GetThirdPersonCameraPos(origin, angles)
	local allplayers = player.GetAll()
	local tr = util.TraceHull({start = origin, endpos = origin + angles:Forward() * -math.max(50, self:BoundingRadius()), mask = MASK_SHOT, filter = allplayers, mins = ViewHullMins, maxs = ViewHullMaxs})
	return tr.HitPos + tr.HitNormal * 5
end

function meta:IsHolding()
	return self.status_human_holding and self.status_human_holding:IsValid()
end
meta.IsCarrying = meta.IsHolding

-- Male pain / death sounds
local VoiceSets = {}

VoiceSets["male"] = {}
VoiceSets["male"]["PainSoundsLight"] = {
Sound("vo/npc/male01/ow01.wav"),
Sound("vo/npc/male01/ow02.wav"),
Sound("vo/npc/male01/pain01.wav"),
Sound("vo/npc/male01/pain02.wav"),
Sound("vo/npc/male01/pain03.wav")
}

VoiceSets["male"]["PainSoundsMed"] = {
Sound("vo/npc/male01/pain04.wav"),
Sound("vo/npc/male01/pain05.wav"),
Sound("vo/npc/male01/pain06.wav")
}

VoiceSets["male"]["PainSoundsHeavy"] = {
Sound("vo/npc/male01/pain07.wav"),
Sound("vo/npc/male01/pain08.wav"),
Sound("vo/npc/male01/pain09.wav")
}

VoiceSets["male"]["DeathSounds"] = {
Sound("vo/npc/male01/no02.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_no01.wav"),
Sound("vo/npc/Barney/ba_no02.wav")
}

-- Female pain / death sounds
VoiceSets["female"] = {}
VoiceSets["female"]["PainSoundsLight"] = {
Sound("vo/npc/female01/pain01.wav"),
Sound("vo/npc/female01/pain02.wav"),
Sound("vo/npc/female01/pain03.wav")
}

VoiceSets["female"]["PainSoundsMed"] = {
Sound("vo/npc/female01/pain04.wav"),
Sound("vo/npc/female01/pain05.wav"),
Sound("vo/npc/female01/pain06.wav")
}

VoiceSets["female"]["PainSoundsHeavy"] = {
Sound("vo/npc/female01/pain07.wav"),
Sound("vo/npc/female01/pain08.wav"),
Sound("vo/npc/female01/pain09.wav")
}

VoiceSets["female"]["DeathSounds"] = {
Sound("vo/npc/female01/no01.wav"),
Sound("vo/npc/female01/ow01.wav"),
Sound("vo/npc/female01/ow02.wav")
}

VoiceSets["combine"] = {}
VoiceSets["combine"].PainSoundsLight = {
Sound("npc/combine_soldier/pain1.wav"),
Sound("npc/combine_soldier/pain2.wav"),
Sound("npc/combine_soldier/pain3.wav")
}

VoiceSets["combine"].PainSoundsMed = {
Sound("npc/metropolice/pain1.wav"),
Sound("npc/metropolice/pain2.wav")
}

VoiceSets["combine"].PainSoundsHeavy = {
Sound("npc/metropolice/pain3.wav"),
Sound("npc/metropolice/pain4.wav")
}

VoiceSets["combine"].DeathSounds = {
Sound("npc/combine_soldier/die1.wav"),
Sound("npc/combine_soldier/die2.wav"),
Sound("npc/combine_soldier/die3.wav")
}

function meta:HasBought(str)
	if not str or not self.DataTable or (SERVER and self:IsBot()) then
		return false
	end
	
	if not self.DataTable["ShopItems"] then
		return false
	end
	
	if self.DataTable["ShopItems"][str] then
		return true
	end
	
	return self.DataTable["ShopItems"][ util.GetItemID( str ) ]
end

function meta:GetSuit()
	if not ValidEntity(self) or not self:Alive() then
		return
	end
	
	if ValidEntity(self.Suit) then
		return self.Suit:GetHatType() or "none"
	end
	
	return "none"
end

function meta:IsGonnaBeABoss()
	return self:IsZombie() and GAMEMODE:IsBossRequired() and GAMEMODE:GetPlayerForBossZombie() == self
end

function meta:IsStartingZombie()
	return self:IsZombie() and self:Alive() and self:Health() > ZombieClasses[self:GetZombieClass()].Health and not self:IsSteroidZombie() and not self:GetZombieClass() == 0
end

local function SkullCam(pl, ent)
	if not ent:IsValid() or not pl:IsValid() then
		return
	end
	
	umsg.Start("SkullCam", pl)
	umsg.Entity(ent)
	umsg.End()
end

function meta:GetAchvProgress()
	local subnumber = 0
	local totnumber = 0
	for k, v in pairs(self.DataTable["Achievements"]) do
		totnumber = totnumber + 1
		if v == true then
			subnumber = subnumber + 1
		end
	end
	return subnumber/totnumber*100
end

function meta:PlayDeathSound()
	local snds = VoiceSets[self.VoiceSet].DeathSounds
	self:EmitSound(snds[math.random(1, #snds)])
end

function meta:PlayZombieDeathSound()
	local snds = self.ClassTable.DeathSounds
	
	local vol,pitch = 100,100
	
	if self:GetZombieClass() == 14 then pitch = math.random(80,90) end
	
	self:EmitSound(snds[math.random(1, #snds)],vol,pitch)
end

function meta:PlayPainSound()
	if CurTime() < self.NextPainSound then
		return
	end
	self.NextPainSound = CurTime() + 0.5

	if self:Team() == TEAM_UNDEAD then
		local snds = ZombieClasses[ self:GetZombieClass() ].PainSounds
		if not snds then
			return
		end
		
		-- Cooldown for howler is increased
		if self:IsHowler() then self.NextPainSound = CurTime() + 1.5 end
		if self:GetZombieClass() == 14 then self.NextPainSound = CurTime() + 10 end
		
		local vol,pitch = 100,100
		
		if self:GetZombieClass() == 14 then pitch = math.random(80,90) end
		
		if self:GetZombieClass() == 12 then self.NextPainSound = CurTime() + 2.5 vol = 110 end
		
		if self:IsStartingZombie() then vol,pitch = 110, 86 end
		
		self:EmitSound(snds[math.random(1, #snds)],vol,pitch)
	else
		local health = self:Health()
		local set = VoiceSets[self.VoiceSet]

		if self.IsSkeleton == true then
			self:EmitSound(VoiceSetsGhost.PainSounds[math.random(1,#VoiceSetsGhost.PainSounds)])
		else
			if health > 68 then
				local snds = set.PainSoundsLight
				self:EmitSound(snds[math.random(1, #snds)])
			elseif health > 36 then
				local snds = set.PainSoundsMed
				self:EmitSound(snds[math.random(1, #snds)])
			else
				local snds = set.PainSoundsHeavy
				self:EmitSound(snds[math.random(1, #snds)])
			end
		end
	end
end

-- Male voiceset
function meta:IsMale()
	return self:IsHuman() and self.VoiceSet == "male"
end

-- Female voiceset
function meta:IsFemale()
	return self:IsHuman() and self.VoiceSet == "female"
end

-- Combine voiceset
function meta:IsCombine()
	return self:IsHuman() and self.VoiceSet == "combine"
end

-- Play spawn music
function meta:PlaySpawnMusic()
	if self:IsSpectator() then return end
	if ROUNDTIME*0.1 < ServerTime() then return end
	-- No music
	if not Ambience then return end
	if TranslateMapTable[ game.GetMap() ] and TranslateMapTable[ game.GetMap() ].DisableMusic then return end

	
	-- Can't play dead
	if not self:Alive() or ENDROUND or LASTHUMAN or UNLIFE or SERVER then return end
	if FIRSTAPRIL then return end
	-- Team check
	local sSound = table.Random ( Ambience.Human )
	if self:IsZombie() then sSound = table.Random ( Ambience.Zombie ) end

	-- Delay it
	-- RunConsoleCommand ( "stopsounds" )
	timer.Simple( 0.2, function() surface.PlaySound ( sSound ) end )
end

local metaEntity = FindMetaTable( "Entity" )

meta.OldSetHealth = metaEntity.SetHealth
function meta:SetHealth(health)
	self:OldSetHealth(health)
	if self.Team and self:Team() == TEAM_HUMAN and self:IsPlayer() then
		self:CheckSpeedChange()
	end
end

function meta:IsSteroidZombie()
	if ValidEntity(self:GetStatus("champion")) then
		return true
	end
	return false
end

function meta:GetSteroidZombieType()
	if self:IsSteroidZombie() then
		local st = self:GetStatus("champion")
		if st.GetType then
			return st:GetType() or 0
		end
	end
end


if CLIENT then
function meta:GetStatus(sType)
	local ent = self["status_"..sType]
	if ent --[=[and ent:GetOwner() == self]=] then return ent end
end

function meta:DoHulls(classid, teamid)
	teamid = teamid or self:Team()

	if teamid == TEAM_UNDEAD then
		classid = classid or -10
		local classtab = ZombieClasses[ classid ]
		local tbl
		if classtab then
			local powerup = self:IsSteroidZombie()
			if powerup then tbl = ZombiePowerups[self:GetSteroidZombieType()] or {} end
			
			if not classtab.Hull or not classtab.HullDuck then				
				if tbl and tbl.Scale then
					self:SetHull(HULL_PLAYER[1], Vector(HULL_PLAYER[2].x,HULL_PLAYER[2].y,HULL_PLAYER[2].z*tbl.Scale))
					self:SetHullDuck(HULL_PLAYER[1], Vector(HULL_PLAYER[3].x,HULL_PLAYER[3].y,HULL_PLAYER[3].z*tbl.Scale))
				else
					self:ResetHull()
				end
			end
			if classtab.Hull then
				if tbl and tbl.Scale then
					self:SetHull(classtab.Hull[1]*tbl.Scale, classtab.Hull[2]*tbl.Scale)
				else
					self:SetHull(classtab.Hull[1], classtab.Hull[2])
				end
			end
			if classtab.HullDuck then
				if tbl and tbl.Scale then
					self:SetHullDuck(classtab.HullDuck[1]*tbl.Scale, classtab.HullDuck[2]*tbl.Scale)
				else
					self:SetHullDuck(classtab.HullDuck[1], classtab.HullDuck[2])
				end
			end
			if classtab.ViewOffset then
				if tbl and tbl.Scale then
					self:SetViewOffset(classtab.ViewOffset*tbl.Scale)
				else
					self:SetViewOffset(classtab.ViewOffset)
				end
			elseif self:GetViewOffset() ~= DEFAULT_VIEW_OFFSET then
				if tbl and tbl.Scale then
					self:SetViewOffset(DEFAULT_VIEW_OFFSET*tbl.Scale)
				else
					self:SetViewOffset(DEFAULT_VIEW_OFFSET)
				end
			end
			if classtab.ViewOffsetDucked then
				if tbl and tbl.Scale then
					self:SetViewOffsetDucked(classtab.ViewOffsetDucked*tbl.Scale)
				else
					self:SetViewOffsetDucked(classtab.ViewOffsetDucked)
				end
			elseif self:GetViewOffsetDucked() ~= DEFAULT_VIEW_OFFSET_DUCKED then
				if tbl and tbl.Scale then
					self:SetViewOffsetDucked(DEFAULT_VIEW_OFFSET_DUCKED*tbl.Scale)
				else
					self:SetViewOffsetDucked(DEFAULT_VIEW_OFFSET_DUCKED)
				end
			end
			if classtab.StepSize then
				self:SetStepSize(classtab.StepSize)
			elseif self:GetStepSize() ~= DEFAULT_STEP_SIZE then
				self:SetStepSize(DEFAULT_STEP_SIZE)
			end
			--[==[if classtab.ModelScale then
				if tbl and tbl.Scale then
					self:SetModelScale(classtab.ModelScale*tbl.Scale,0)
				else
					self:SetModelScale(classtab.ModelScale,0)
				end
			elseif self:GetModelScale() ~= DEFAULT_MODELSCALE then
				if tbl and tbl.Scale then
					self:SetModelScale(DEFAULT_MODELSCALE*tbl.Scale,0)
				else
					self:SetModelScale(DEFAULT_MODELSCALE,0)
				end
			end]==]

			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMass(classtab.Mass or DEFAULT_MASS)
			end
		end
	else
		self:ResetHull()
		self:SetViewOffset(DEFAULT_VIEW_OFFSET)
		self:SetViewOffsetDucked(DEFAULT_VIEW_OFFSET_DUCKED)
		self:SetStepSize(DEFAULT_STEP_SIZE)
		-- self:SetModelScale(DEFAULT_MODELSCALE,0)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(DEFAULT_MASS)
		end
	end
end

net.Receive( "DoHulls", function(len)
	local ent = net.ReadEntity()
	if not IsValid(ent) then
		return
	end
	
	local classid = net.ReadDouble()
	local teamid = net.ReadDouble()
	
	
	ent:DoHulls(classid, teamid)
	timer.Simple(0,function()
		if not IsValid(ent) then
			return
		end
		
		ent:DoHulls(classid, teamid)
	end)
end)

--[[----------------------------------------------------]]--

function meta:HasBoughtPointsWithCoins()
    return MySelf.BoughtPointsWithCoins
end

function meta:CanBuyPointsWithCoins()
    return not MySelf.BoughtPointsWithCoins and MySelf:GreenCoins() >= 200
end

function meta:SetBoughtPointsWithCoins( bool )
    MySelf.BoughtPointsWithCoins = bool
end

--[[----------------------]]--

net.Receive("BoughtPointsWithCoins", function(len)
    MySelf:SetBoughtPointsWithCoins(tobool(net.ReadBit()))
end)

--[[----------------------------------------------------]]--

end


