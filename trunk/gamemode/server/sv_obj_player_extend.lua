-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local umsg = umsg
local ents = ents
local gmod = gmod

local meta = FindMetaTable("Player")
if not meta then return end

function meta:LegsGib()
	self:EmitSound("physics/flesh/flesh_bloody_break.wav", 100, 75)
	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetModel(Model("models/Zombie/Classic_legs.mdl"))
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		ent:Fire("kill", "", 2.5)
	end

	self:Gib()
end


-- Set team event
function GM:OnTeamChange( pl, iFromTeam, iToTeam )
end

-- On team change
meta.BaseSetTeam = meta.SetTeam
function meta:SetTeam( iTeam )
	if not iTeam then iTeam = 0 end
	
	-- Call the event ( player, from, to )
	gamemode.Call( "OnTeamChange", self, self:Team(), iTeam )
	
	-- Change team
	self:BaseSetTeam( iTeam )
end

-- Helper for DOT damage
function takeDamageOverTime( Victim, iDamage, fDelay, iTicks, Attacker, Inflictor )
	if IsValid( Victim ) and Victim:IsTakingDOT() then
		if ( Victim.TeamDOT == Victim:Team() ) and ( Victim.TickDOT < iTicks ) and ( Victim:Alive() ) then
		
			-- Check attacker
			if not IsValid( Attacker ) then
				Victim:ClearDamageOverTime()
				return
			end
			
			-- if Victim:HasBought("naturalimmunity") then
			if Victim:GetPerk() == "_poisonprotect" then
				iDamage = math.ceil(iDamage - iDamage*0.6)
			end
			-- Default take damage only when low on health
			if not IsValid( Inflictor ) then Inflictor = Attacker:GetActiveWeapon() or Attacker end
			if Victim:Health() > iDamage then Victim:SetHealth( Victim:Health() - iDamage ) else Victim:TakeDamage( iDamage, Attacker, Inflictor ) end
			Victim.IsInfected = true
			-- Shake screen
			Victim:ViewPunch( Angle( math.random( -20, 20 ), math.random( -5, 5 ), 0 ) )
			
			-- Cough sound
			Victim:EmitSound( "ambient/voices/cough"..math.random( 1,4 )..".wav" )
			Victim:EmitSound( "player/pl_pain"..math.random( 5,7 )..".wav" )
			
			-- Increase tick
			Victim.TickDOT = Victim.TickDOT + 1
			
			-- Recursion
			--timer.Simple( fDelay, takeDamageOverTime, Victim, iDamage, fDelay, iTicks, Attacker, Inflictor )
			timer.Simple( fDelay,function()
				takeDamageOverTime( Victim, iDamage, fDelay, iTicks, Attacker, Inflictor )
				end)
			
			return
		end
		
		-- Disable status
		Victim:ClearDamageOverTime()
	end
end	

-- Clears DOT damage
function meta:ClearDamageOverTime()
	self.IsInfected = false
	self:SetDTBool( 0, false )
end

-- Adds DOT damage to player
function meta:TakeDamageOverTime( iDamage, fDelay, iTicks, Attacker, Inflictor )
	if self:IsTakingDOT() or not self:Alive() or not IsValid( Attacker ) then return end
	
	-- Default fDelay / Tick
	fDelay, iTicks = fDelay or 1, iTicks or 1
	
	-- Status
	self:SetDTBool( 0, true )
	self.TeamDOT, self.TickDOT = self:Team(), 0
	
	-- Start recursion timer
	--timer.Simple( fDelay, takeDamageOverTime, self, iDamage, fDelay, iTicks, Attacker, Inflictor )
	timer.Simple( fDelay,function()
				takeDamageOverTime( self, iDamage, fDelay, iTicks, Attacker, Inflictor )
				end)
end	

hook.Add( "OnTeamChange", "ClearDamageOverTime", function( pl )
	if IsValid( pl ) then
		if pl:IsTakingDOT() then 
			pl:ClearDamageOverTime()
		end
	end
end )

--[==[---------------------------------------------------
                Spawns the first zombie/s
---------------------------------------------------]==]
function meta:SetFirstZombie()
	if self:Team() == TEAM_UNDEAD then
		return
	end
	
	--Strip weapons
	self:StripWeapons()
	
	--Obviously, set his team to undead
	self:SetTeam(TEAM_UNDEAD)
	
	--Reset kils
	skillpoints.SetupSkillPoints(self)
	self:UnSpectate()
	
	--Spawn him
	self:Message("You've been selected to lead the Undead Army.", 3, "255,255,255,255")
	self:Spawn()
	
	--Aprils first joke
	if FIRSTAPRIL then
		umsg.Start( "MakeBody" )
		umsg.End()
	end
	
	-- Correct any speed changes
	local Class = self:GetZombieClass()
	GAMEMODE:SetPlayerSpeed(self, ZombieClasses[Class].Speed)
	
	--Set him dead in the connect data table
	local Table = DataTableConnected[self:UniqueID()]
	if Table == nil then
		return
	end
	
	Table.IsDead = true
end

function meta:SwitchToZombie()
	
	if self:Team() == TEAM_UNDEAD then return end
	
	-- Strip weapons
	self:StripWeapons()
	
	-- Obviously, set his team to undead
	self:SetTeam( TEAM_UNDEAD )
	
	-- Reset kills
	skillpoints.SetupSkillPoints(self)
	self:UnSpectate()
	-- Spawn him
	-- self:Message( "You've been randomly selected to lead the Undead Army.", 1, "255,255,255,255" )
	self:Spawn()
	
	-- Correct any speed changes
	local Class = self:GetZombieClass()
	GAMEMODE:SetPlayerSpeed ( self, ZombieClasses[Class].Speed )
	
	--  logging
	--log.PlayerJoinTeam( self, TEAM_UNDEAD )
	--log.PlayerRoleChange( self, self:GetClassTag() )
	
	-- Set him dead in the connect data table
	local Table = DataTableConnected[ self:UniqueID() ]
	if Table == nil then return end
	
	Table.IsDead = true
	
end

function meta:RestoreHumanHealth(am,returnhealth)
	if not self:IsHuman() then
		return
	end
	
	local health, maxhealth = self:Health(), 100
	if self:GetPerk("_kevlar") then
		maxhealth = 110
	elseif self:GetPerk("_kevlar2") then
		maxhealth = 130
	elseif self:GetPerk("_kevlar3") then
		maxhealth = 105
	end
	
	
	
	if health == maxhealth and returnhealth then
		return false
	end
	
	self:SetHealth(health+am)
	
	return true
end

meta.BaseGive = meta.Give
function meta:Give ( Weapon )
	
	if Weapon == "weapon_zs_miniturret" then
		self:SpawnMiniTurret()
		return
	end
	
	self:BaseGive(Weapon)
end

--[==[-------------------------------------------------------------
       Rewrite this so we can do various stuff easily
--------------------------------------------------------------]==]
meta.BaseDropWeapon = meta.DropWeapon
function meta:DropWeapon(Weapon)
	if Weapon == nil or not ValidEntity(Weapon) then
		return
	end
		
	--Doesn't have the weapon
	if not self:HasWeapon(Weapon:GetClass()) or not Weapon:IsWeapon() then
		return
	end
	
	--Substract a slot from the category and remove it
	local strCategory = GetWeaponCategory ( Weapon:GetClass() )
	if strCategory == nil then
		return
	end
	
	--We can't spawn the weapon into the void/solids
	if not self:CanDropWeapon(Weapon) then
		Debug("[DEBUG] Weapon trying to spawn in world/outside world. Preventing...")
		return
	end 
	
	--Debug
	local strDebug = "[DEBUG] Preparing to drop weapon for "..tostring ( self )..". Weapon class: "..tostring ( Weapon:GetClass() ) 
	Debug(strDebug)
	
	--Disable ironsight for client only if the weapon is the active weapon one.
	ActiveWeapon = self:GetActiveWeapon()
	if ValidEntity(ActiveWeapon) and ActiveWeapon == Weapon then
		if isfunction(ActiveWeapon.OnDrop) then
			ActiveWeapon:OnDrop()
		end
		
		ClientDropWeapon(self)
	end
	
	--Base function
	self:BaseDropWeapon(Weapon)
	
	--Subtract weapon count
	self.CurrentWeapons[strCategory] = self.CurrentWeapons[strCategory] - 1
end

--[==[----------------------------------------------------------------
    Check to see if player can drop weapon (prevent crash) 
------------------------------------------------------------------]==]
function meta:CanDropWeapon ( Weapon )
	if Weapon == nil then return false end
	if not ValidEntity ( Weapon ) then return false end

	-- Player doesn't have the weapon
	if not self:HasWeapon ( Weapon:GetClass() ) or not Weapon:IsWeapon() then return false end
	
	-- Check spawn location
	local vSpawn = self:GetShootPos() - Vector ( 0,0,12 )
	if not util.IsInWorld ( vSpawn ) or util.PointContents( vSpawn ) == 1 then return false end

	return true
end

--[==[-------------------------------------------------------------
       Rewrite this so we can do various stuff easily
--------------------------------------------------------------]==]
meta.BaseStripWeapons = meta.StripWeapons
function meta:StripWeapons()

	-- Reset the human's weapon counter to 0, for all categories
	-- self.CurrentWeapons = { Automatic = 0, Pistol = 0, Melee = 0, Tools = 0, Others = 0, Explosive = 0, Admin = 0 }
	self.CurrentWeapons = { Automatic = 0, Pistol = 0, Melee = 0, Tool1 = 0, Tool2 = 0, Misc = 0, Admin = 0 }
	-- Remove the weapons
	for k,v in pairs ( self:GetWeapons() ) do
		if IsEntityValid( v ) then
			if v:IsWeapon() then
				v:Remove()
			end
		end
	end
	
	-- Send drop event to client
	ClientDropWeapon(self)
end

--[==[--------------------------------------------------------------------
           Rewrite this so we can do various stuff easily
---------------------------------------------------------------------]==]
meta.BaseStripWeapon = meta.StripWeapon
function meta:StripWeapon ( Class )
	if not self:HasWeapon ( Class ) then return end
	
	-- Substract a slot from the category and remove it
	local strCategory = GetWeaponCategory ( Class )
	if strCategory == nil then return end
	
	-- Get the weapon to strip
	local Weapon, ActiveWeapon = self:GetWeapon ( Class ), self:GetActiveWeapon()
	
	-- We can't spawn in void/world
	if not self:CanDropWeapon(Weapon) then
		Debug("[DEBUG] Weapon trying to spawn in world/outside world. Preventing...")
		return
	end
	
	-- Only disable clientside ironsights if it's the active weapon otherwise don't do it
	if ValidEntity(ActiveWeapon ) and ActiveWeapon == Weapon then
		if isfunction(ActiveWeapon.OnDrop) then
			ActiveWeapon:OnDrop()
		end
		
		ClientDropWeapon(self)
	end
	
	-- Substract weapon count
	self.CurrentWeapons[strCategory] = self.CurrentWeapons[strCategory] - 1
	
	-- Base function
	self:BaseStripWeapon(Class)
end

--[==[-------------------------------------------------------------
       Add some tweaks to the drop weapon function
--------------------------------------------------------------]==]
function meta:DropWeaponNamed ( class ) 
	local ClassToType = GetWeaponType ( class )
	if ClassToType == "none" then return end

	-- Substract a slot from the category and drop it
	local Category = WeaponTypeToCategory[ClassToType]
	self.CurrentWeapons[Category] = self.CurrentWeapons[Category] - 1
	self:DropNamedWeapon ( class )
end
 
function meta:ConnectedIsDead()
	local ID = self:UniqueID() or "UNCONNECTED"
	return DataTableConnected[ID].IsDead
end

function meta:ConnectedHasSuicideSickness()
	local ID = self:UniqueID() or "UNCONNECTED"
	return DataTableConnected[ID].SuicideSickness
end

function meta:ConnectedHealth()
	if not DataTableConnected[ID] then return false end
	
	local ID = self:UniqueID() or "UNCONNECTED"
	return DataTableConnected[ID].Health
end

function meta:ConnectedAlreadyGotWeapons()
	if not DataTableConnected[ self:UniqueID() ] then return false end
	local ID = self:UniqueID() or "UNCONNECTED"
	return DataTableConnected[ID].AlreadyGotWeapons
end

function meta:ConnectedHumanClass()
	local ID = self:UniqueID() or "UNCONNECTED"
	return DataTableConnected[ID].HumanClass
end

--[==[-------------------------------------------------
             Gibs a player - splashes him
--------------------------------------------------]==]
function meta:Gib ( dmginfo )
	if not ValidEntity ( self ) then return end
	
	if self.NoGib and self.NoGib > CurTime() then
		self.NoGib = nil
		if not ValidEntity(self:GetRagdollEntity()) then
			self:CreateRagdoll()
		end
		return 
	end
	
	self.Gibbed = true
	-- Sound effect
	--self:EmitSound( Sound ( "physics/flesh/flesh_bloody_break.wav" ) )

	-- Spawn meat/gibs
	local vPos = self:GetPos() + Vector( 0, 0, 32 )
	local vOtherPos = vPos + Vector( 0, 0, -22 )
	for i = 1, math.random(1,2) do
		local eGib = ents.Create( "playergib" )
		if eGib:IsValid() then
			
			-- Random position/angles
			eGib:SetPos( vPos + VectorRand() * 12 )
			eGib:SetAngles( VectorRand():Angle() )
			
			-- Different model/materials
			local iModel = math.random( 3, 7 )
			eGib:SetModel( HumanGibs[iModel] )
			if iModel > 4 then eGib:SetMaterial( "models/flesh" ) end
			eGib:Spawn()
		end
	end
	
	local effectdata = EffectData()
	effectdata:SetEntity(self)
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetNormal(self:GetVelocity():GetNormal())
	effectdata:SetScale(0)
	util.Effect( "gib_player", effectdata, true, true )
	
end

function meta:GiveAmmoReward()
	if not IsValid(self) or not IsValid(self:GetActiveWeapon()) or self:IsZombie() then
		return
	end

	local WeaponToFill = self:GetActiveWeapon()
	if GetWeaponCategory ( WeaponToFill:GetClass() ) == "Pistol" then
		self:GiveAmmo ( math.random(5,15), WeaponToFill:GetPrimaryAmmoTypeString() )
	elseif GetWeaponCategory ( WeaponToFill:GetClass() ) == "Automatic" then
		self:GiveAmmo ( math.random(5,20), WeaponToFill:GetPrimaryAmmoTypeString() )
	end
	self:EmitSound("items/ammo_pickup.wav")
end

function AddXP (pl, cmd, args)
	if not ValidEntity (pl) then return end
	if pl:Team() == TEAM_SPECTATOR then return end
	
	for _,v in pairs(player.GetAll()) do
		if args[1] == v:Nick() then
			v:AddXP(555)
		end
	end
end
concommand.Add("zs_xp_add", AddXP)

function Addr (pl, cmd, args)
	if not ValidEntity (pl) then return end
	if pl:Team() == TEAM_SPECTATOR then return end
	
	pl:AddRank(1)
	
end
concommand.Add("zs_rank_add", Addr)

util.AddNetworkString( "SendPlayerPerk" )

function meta:SetPerk(key)
	
	if not ValidEntity (self) then return end
	if not key then return end
	
	self.Perk = self.Perk or {} -- just in case
	
	if #self.Perk > 2 then return end
	
	--self.Perk = key
	table.insert(self.Perk,key)
	
	net.Start("SendPlayerPerk")
		net.WriteEntity(self)
		net.WriteString(key)
	net.Broadcast()

	
end

--*insert rage icon here please*
function meta:ValidateXP()
	if self.DataTable and self.DataTable["ClassData"] and self.DataTable["ClassData"]["default"] and self.DataTable["ClassData"]["default"].xp and self.DataTable["ClassData"]["default"].rank then
		local rank = self:GetRank()
		local xp = self:GetXP()
		
		local minxp = self:CurRankXP()
		local maxxp = self:NextRankXP()
		local restore = math.ceil((maxxp-minxp)/2)
		
		if rank == 0 then return end
		
		if xp < minxp then
			print("[XP] Experience for player "..tostring(self).." corrupted. Restoring!")
			self.DataTable["ClassData"]["default"].xp = minxp + restore
		end
		--[[else
			print("Checking experience for player "..tostring(self)..". Experience is fine!")
		end]]		
	end
end
util.AddNetworkString("SendPlayerXP")

function meta:AddXP(amount)
	if #player.GetAll() < XP_PLAYERS_REQUIRED or not ValidEntity(self) or self:IsBot() then return end
	
	if DOUBLE_XP then
		amount = amount*2
	end
	
	if not self.DataTable["ClassData"]["default"] then
		local str = "not ready"
		if self.Ready then
			str = "ready"
		end
		
		--ErrorNoHalt( "CUSTOM ERROR: "..self:Name().." has uninitialized DataTable[ClassData] while "..str.." and thus AddXP failed." )
		
		return
	end	
	
	if type ( self.DataTable["ClassData"]["default"].xp ) == "number" then
		if self.DataTable["ClassData"]["default"].rank and self.DataTable["ClassData"]["default"].rank >= MAX_RANK then return end
		self.DataTable["ClassData"]["default"].xp = self.DataTable["ClassData"]["default"].xp + amount
		
		if self:GetXP() >= self:NextRankXP() then
			self:AddRank(1)
			self:PrintMessage(HUD_PRINTTALK,"Congratulation, you have reached Rank "..self:GetRank())
			self:EmitSound("weapons/physcannon/physcannon_charge.wav")
		end
			
		--- 
		-- FIXME: This function is used extensively throughout the game
		-- My recommendation is that it should use a DT variable instead
		-- 
		net.Start("SendPlayerXP")
			net.WriteDouble(tonumber(self.DataTable["ClassData"]["default"].xp))
		net.Send(self)
	end
end

util.AddNetworkString("SendPlayerRank")

function meta:AddRank (amount)
	if not ValidEntity(self) then return end
	if self:IsBot() then return end
	if not self.DataTable["ClassData"]["default"] then
		local str = "not ready"
		if self.Ready then
			str = "ready"
		end
		
		--ErrorNoHalt( "CUSTOM ERROR: "..self:Name().." has uninitialized DataTable[ClassData] while "..str.." and thus AddRank failed." )
		
		return
	end	
	if type ( self.DataTable["ClassData"]["default"].rank ) == "number" then

		self.DataTable["ClassData"]["default"].rank = self.DataTable["ClassData"]["default"].rank + amount
		
		net.Start("SendPlayerRank")
			net.WriteDouble(tonumber(self.DataTable["ClassData"]["default"].rank))
		net.Send(self)

		if GAMEMODE.RankUnlocks[self:GetRank()] then
			for k,v in pairs(GAMEMODE.RankUnlocks[self:GetRank()])do
				self:UnlockNotify( v )
			end
		end
	end
end

function meta:AddToCounter(stat, amount)
	if not self.DataTable[stat] then
		local str = "not ready"
		if self.Ready then str = "ready" end
		
		--ErrorNoHalt( "CUSTOM ERROR: "..self:Name().." has uninitialized DataTable while "..str.." and thus AddToCounter failed." )
		
		return
	end
	
	-- Numbers only :)
	if type ( self.DataTable[stat] ) == "number" then
		self.DataTable[stat] = self.DataTable[stat] + amount
	end
end

function meta:GetCounter(stat)
	return self.DataTable[stat] or 0
end

--------------------------------------------------------------------------

function meta:UnlockNotify(item)
	self:SendLua('UnlockEffect2("'..item..'")')
end

function meta:UnlockAchievement(stat)
	--Only unlock when having more than 8 players
	if #player.GetAll() < 8 or not self:GetAchievementsDataTable() then
		return false
	end
	
	local statID = util.GetAchievementID(stat)
	
	--Check if already attained
	if self:GetAchievementsDataTable()[statID] == true then
		return false
	end
	
	--YAY! Achievements
	self.DataTable["Achievements"][statID] = true
	self:SendLua('UnlockEffect("'..stat..'")')
	self.DataTable["progress"] = math.floor(self:GetAchvProgress())
	PrintMessageAll(HUD_PRINTTALK,self:Name() .." attained the '"..achievementDesc[statID].Name.."' achievements!")
	--self:AddScore(1)
	
	--Save DB data
	self:SaveAchievement(statID)
	
	--Only check for this when it's not Master of ZS
	if stat ~= "masterofzs" then
		--Check if all achievements are attained (excluding masterofzs)
		local hasAll = true
		for k, v in pairs(self.DataTable["Achievements"]) do
			if not v and k ~= util.GetAchievementID("masterofzs") then
				hasAll = false
			end
		end
		
		--Award Master of ZS when having all
		if hasAll then
			self:UnlockAchievement("masterofzs")
		end
	end
	
	return true
end

function meta:SelectSpawnType(iscrow)
		if iscrow then
			self:SetZombieClass(self.DeathClass or 0)
		end
		self:UnSpectateAndSpawn()
end

function meta:SpawnAsZombieBoss()			
	self:RemoveAllStatus(true, true)
	
	--Some magic from NECROSSIN
	--TODO: Tidy up boss classes
	local curclass = self.DeathClass or self:GetZombieClass()
	
	if curclass == 10 or curclass == 11 then
		curclass = 1
	end
	
	self:SetZombieClass(table.Random(BOSS_CLASS))
	
	self.DeathClass = nil
	self:UnSpectateAndSpawn()
	self.DeathClass = curclass
	
	--Debug
	Debug("[BOSS] ".. tostring(self) .." spawned as boss")
end

function meta:SpawnAsUndeadClass(classId)
	self:RemoveAllStatus(true, true)

	self:SetZombieClass(classId)
	
	self.DeathClass = nil
	self:UnSpectateAndSpawn()
	self.DeathClass = classId
end
	
local function CreateRagdoll(pl)
	if IsValid(pl) then pl:OldCreateRagdoll() end
end

local function SetModel(pl, mdl)
	if not pl:IsValid() then
		return
	end
	
	pl:SetModel(mdl)
	timer.Simple(0, function()
		CreateRagdoll(pl)
	end)
end

meta.OldCreateRagdoll = meta.CreateRagdoll
function meta:CreateRagdoll()
	local status = self.status_overridemodel
	if status and IsValid(status) then
		timer.Simple(0, function()
			if IsValid(self) and IsValid(status) then 
				-- SetModel(self, status:GetModel()) 
				self:SetModel(status:GetModel())
				timer.Simple(0, function()
					CreateRagdoll(self)
				end)
			end 
		end)
		status:SetRenderMode(RENDERMODE_NONE)
	else
		self:OldCreateRagdoll()
	end
end

function meta:UnSpectateAndSpawn()
	self:UnSpectate()
	self:Spawn()
end

function meta:SecondWind(pl)
	if self.Gibbed or self:Alive() or self:Team() ~= TEAM_UNDEAD then return end

	local pos = self:GetPos()
	local angles = self:EyeAngles()
	-- local lastattacker = self:GetLastAttacker()
	local dclass = self.DeathClass
	self.DeathClass = nil
	self.Revived = true
	self:UnSpectateAndSpawn()
	self.Revived = nil
	self.DeathClass = dclass
	-- self:SetLastAttacker(lastattacker)
	self:SetPos(pos)
	self:SetHealth(self:Health() * 0.2)
	self:SetEyeAngles(angles)
	self:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav", 100, 85)
	self:TemporaryNoCollide()
	
end

function meta:SetRandomFace()
	
	local FlexNum = self:GetFlexNum() - 1
	if ( FlexNum <= 0 ) then return end
	
	for i=0, FlexNum-1 do
	
		self:SetFlexWeight( i, math.Clamp( math.Rand(0.1,2), 0, 2 ) )
		
	end
	
	self:SetFlexScale(math.random(-4,4))
	
end

function meta:CalculateViewOffsets()

	local off1, off2 = Vector(0, 0, 64), Vector(0, 0, 28)
	
	if self:Team() ~= TEAM_UNDEAD then 
	
		self:SetViewOffset(off1)
		self:SetViewOffsetDucked(off2)
		
		umsg.Start("ChangeOffset")
			umsg.Entity(self)
			umsg.Vector(off1)
			umsg.Vector(off2)
		umsg.End()
	
	return end
	
	local offset = ZombieClasses[self:GetZombieClass()].ViewOffset
	local offset2 = ZombieClasses[self:GetZombieClass()].ViewOffsetDucked
	
	if offset then
		off1 = offset
	end
	
	if offset2 then
		off2 = offset2
	end
	
	self:SetViewOffset(off1)
	self:SetViewOffsetDucked(off2)
	
	umsg.Start("ChangeOffset")
		umsg.Entity(self)
		umsg.Vector(off1)
		umsg.Vector(off2)
	umsg.End()
	

end

function meta:VoicePush()
	local set = VoiceSets[self.VoiceSet].PushSounds
	if set then
		self:EmitSound(set[math.random(1, #set)])
		self.LastVoice = CurTime()
	end
end

function meta:VoiceQuestion()
	local set

	set = VoiceSets[self.VoiceSet].QuestionSounds
	
	if set then
		self:EmitSound(set[math.random(1, #set)])
		self.LastVoice = CurTime()
	end
end

function meta:VoiceAnswer()
	local set

	set = VoiceSets[self.VoiceSet].AnswerSounds
	
	if set then
		self:EmitSound(set[math.random(1, #set)])
		self.LastVoice = CurTime()
	end
end

function meta:VoiceKillCheer()
	local set = VoiceSets[self.VoiceSet].KillCheer
	if set then
		self:EmitSound(set[math.random(1, #set)])
		self.LastVoice = CurTime()
	end
end

util.AddNetworkString( "CustomChatAdd" )

-- NOTE: Function not network-friendly
-- Pretty awesome Server-to-Client chat messages by Overv
function meta:CustomChatPrint(arg)
if ( type( arg[1] ) == "Player" ) then self = arg[1] end
	
		
		net.Start("CustomChatAdd")
            net.WriteDouble( #arg )
            for _, v in pairs( arg ) do
                if ( type( v ) == "string" ) then
                    net.WriteString( v )
                elseif ( type ( v ) == "table" ) then
                    net.WriteDouble( v.r )
                    net.WriteDouble( v.g )
                    net.WriteDouble( v.b )
                    net.WriteDouble( v.a )
                end
            end
        net.Send(self)

end

---
-- Chat broadcast function which uses PLAYER:CustomChatPrint
-- 
function player.CustomChatPrint( arg )
	local players = player.GetAll()
	
	for i = 1, #players do
		local ply = players[i]
		ply:CustomChatPrint( arg )
	end
end

-- 2 useful functions
function meta:GetHeldObject()
    return self:GetSaveTable().m_hMoveChild
end
 
function meta:HoldingObject()
    local object = self:GetSaveTable().m_hMoveChild
    return object and object:GetClass() == "player_pickup"
end

--[==[---------------------------------------------------------
	Overriding PickUp code
---------------------------------------------------------]==]

meta.BasePickupObject = meta.PickupObject

function meta:PickupObject( ent )
	
	if not ValidEntity(ent) then return end
	
	self:BasePickupObject( ent )
	
	print("Picked up entity"..tostring(ent:GetClass()))

end

meta.BaseDropObject = meta.DropObject

function meta:DropObject( ent )
	
	if not ValidEntity(ent) then return end
	
	self:BaseDropObject( ent )
	
	print("Dropped entity"..tostring(ent:GetClass()))

end

-- -- -- -- -- -- / Entity Meta Table -- -- -- -- -- -- -- -- -- -- -- -- /
local metaEntity = FindMetaTable( "Entity" )

-- Holy fuck. Garry, is it so hard to make a reference for dragged props?!
function metaEntity:IsPickupEntity()

	if not ValidEntity(self) then return end
	
	local status = false
	
	for _, pl in pairs(player.GetAll()) do
		if pl:HoldingObject() then
			if ValidEntity(pl:GetHeldObject()) then
				if (pl:GetHeldObject().ActualProp and pl:GetHeldObject().ActualProp == self) and (self.Pickup and self.Pickup == pl:GetHeldObject()) then
					status = true
				end
			end
		end
	end
	
	return status
end

-- Home made creepy function to return prop owners
function metaEntity:GetCarryOwner()

	if not ValidEntity(self) then return end
	if not self:IsPickupEntity() then return false end
	
	local owner = false
	
	for _, pl in pairs(player.GetAll()) do
		if pl:HoldingObject() then
			if ValidEntity(pl:GetHeldObject()) then
				if (pl:GetHeldObject().ActualProp and pl:GetHeldObject().ActualProp == self) and (self.Pickup and self.Pickup == pl:GetHeldObject()) then
					owner = pl
				end
			end
		end
	end
	
	return owner
end


local keyvalues = {}
 
hook.Add("EntityKeyValue","KVFix",function(e,k,v)
 
    keyvalues[e] = keyvalues[e] or {}
    keyvalues[e][k] = v
end)
 
function metaEntity:GetKeyValues()
    return keyvalues[self] or {}
end


function metaEntity:DamageNails(attacker, inflictor, damage, dmginfo)
	if not self.Nails then 
	    return false
	end
	
	--Cadebreaker warning
	if (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
	    if ( ( attacker.BarricadeWarnTime or 0 ) <= CurTime() ) then
            attacker:Message("Don't break the barricade", 2)
            attacker.BarricadeWarnTime = CurTime() + 4
			damage = damage * 0.25
	    end  
	end
	
	local ent = self
	
	ent._LastAttackerIsHuman = false
	
	if ValidEntity( attacker ) and (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN or attacker.GetOwner and ValidEntity(attacker:GetOwner()) and attacker:GetOwner():IsPlayer() and attacker:GetOwner():Team() == TEAM_HUMAN) then
		ent._LastAttackerIsHuman = true
	end
	
	--Prevent cadebreaking by reducing attack damage dealt by humans
	if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and dmginfo:IsMeleeDamage() and ent.Nails then 
		damage = damage * 0.25
	end
	
	--Hammer can't damage
	if inflictor:GetClass() == "weapon_zs_tools_hammer" then
		damage = 0
	end
	
	local bNailDied = false

	for i=1, #ent.Nails do
		local nail = ent.Nails[i]
		if nail then
			if nail:IsValid() then
				nail:SetNailHealth(nail:GetNailHealth() - damage)
				
				--Check for nail heath
				if nail:GetNailHealth() <= 0 then
					bNailDied = true

					local findcons = nail.constraint
					local numcons = 0
					for _, theent in ipairs(ent.Nails) do
						if theent.constraint == findcons then
							numcons = numcons + 1
						end
					end
					
					if numcons == 1 then
						findcons:Remove()
					else
						nail:Remove()
					end
								
					local toworld = false
					if nail.toworld then
						toworld = true
					end
								
					if ValidEntity ( ent:GetPhysicsObject() ) and not ent:GetPhysicsObject():IsMoveable() then
						if nail.toworld then
							local unfreeze = false
							for num=1, #ent.Nails do
								local nl = ent.Nails[num]
								if nl.toworld then
									if nail ~= nl then
										unfreeze = false
										break
									else
										unfreeze = true
									end
								end
							end
										
							if unfreeze then
								ent:GetPhysicsObject():EnableMotion( true )
							end
						end
					end
								
					if toworld then		
						table.remove(ent.Nails, i)
											
						if #ent.Nails <= 0 then
							ent.Nails = nil							
						end
					else
						for _, entity in ipairs(nail.Ents) do
							if entity.Nails then		
								table.remove(entity.Nails, i)
											
								if #entity.Nails <= 0 then
									entity.Nails = nil							
								end
							end
						end
					end
				else
					if bNailDied == false then
						--Nails prevent prop getting damaged
						dmginfo:SetDamage(20) --Duby: When a nail dies damage the prop! This was cade camping with one prop isn't possible anymore. :P 
					end
				end
	
				break
			else	
				table.remove(ent.Nails, i)
				i = i - 1
			end
		end
	end
	return bNailDied == false
end

meta.OldDrawViewModel = meta.DrawViewModel
meta.OldDrawWorldModel = meta.DrawWorldModel

function meta:DrawViewModel(bDraw)
	self.m_DrawViewModel = bDraw
	self:OldDrawViewModel(bDraw)
end

function meta:DrawWorldModel(bDraw)
	self.m_DrawWorldModel = bDraw
	self:OldDrawWorldModel(bDraw)
end

function meta:RemoveAllStatus(bSilent, bInstant)
	if bInstant then
		for _, ent in ipairs(ents.FindByClass("status_*")) do
			if not ent.NoRemoveOnDeath and ent:GetOwner() == self then
				ent:Remove()
			end
		end
	else
		for _, ent in ipairs(ents.FindByClass("status_*")) do
			if not ent.NoRemoveOnDeath and ent:GetOwner() == self then
				ent.SilentRemove = bSilent
				ent:SetDie()
			end
		end
	end
end

function meta:RemoveStatus(sType, bSilent, bInstant, sExclude)
	local removed

	for _, ent in pairs(ents.FindByClass("status_"..sType)) do
		if ent:GetOwner() == self and not (sExclude and ent:GetClass() == "status_"..sExclude) then
			if bInstant then
				ent:Remove()
			else
				ent.SilentRemove = bSilent
				ent:SetDie()
			end
			removed = true
		end
	end

	return removed
end

function meta:GetStatus(sType)
	local ent = self["status_"..sType]
	if IsValid( ent ) and ent.Owner == self then 
	   return ent 
	end
end

function meta:GiveStatus(sType, fDie)
	local cur = self:GetStatus(sType)
	if cur then
		if fDie then
			cur:SetDie(fDie)
		end
		cur:SetPlayer(self, true)
		return cur
	else
		local ent = ents.Create("status_"..sType)
		if ent:IsValid() then
			ent:Spawn()
			if fDie then
				ent:SetDie(fDie)
			end
			ent:SetPlayer(self)
			return ent
		end
	end
end

function meta:RefreshDynamicSpawnPoint()
	local target = self:GetObserverTarget()
	if self:GetObserverMode() == OBS_MODE_CHASE and target and target:IsValid() and target:IsPlayer() and target:Team() == TEAM_UNDEAD then
		self.ForceDynamicSpawn = target
	else
		self.ForceDynamicSpawn = nil
	end
end

local function nocollidetimer(self, timername)
	if not ValidEntity(self) then return end
	for _, e in pairs(ents.FindInBox(self:WorldSpaceAABB())) do
		if e:IsPlayer() and e ~= self and GAMEMODE:ShouldCollide(self, e) then
			return
		end
	end

	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	timer.Destroy(timername)
end

function meta:TemporaryNoCollide()
	if not ValidEntity(self) then return end
	if self:GetCollisionGroup() ~= COLLISION_GROUP_PLAYER then return end

	for _, e in pairs(ents.FindInBox(self:WorldSpaceAABB())) do
		if e:IsPlayer() and e ~= self and GAMEMODE:ShouldCollide(self, e) then
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

			local timername = "TemporaryNoCollide"..self:UniqueID()
			timer.Create(timername, 0, 0, nocollidetimer, self, timername)

			return
		end
	end

	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
end

util.AddNetworkString( "DoHulls" )

---
-- FIXME: This function does way more than just 'hulls'.
-- Called every PlayerSpawn, (re)setting hulls/offset/mass, sending net data. A disaster.
-- Duby: I will fix this soon, it looks like it will be a pain in the ass though. :O
function meta:DoHulls(classid, teamid)
	teamid = teamid or self:Team()
	classid = classid or -10
	
	if teamid == TEAM_UNDEAD then
		-- classid = classid or -10
		local classtab = ZombieClasses[ classid ]
		local tbl
		if classtab then			
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
			if classtab.ModelScale then
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
			end
			if classtab.StepSize then
				self:SetStepSize(classtab.StepSize)
			elseif self:GetStepSize() ~= DEFAULT_STEP_SIZE then
				self:SetStepSize(DEFAULT_STEP_SIZE)
			end
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
		self:SetModelScale(DEFAULT_MODELSCALE,0)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMass(DEFAULT_MASS)
		end
	end

	net.Start("DoHulls")
		net.WriteEntity(self)
		net.WriteDouble(classid)
		net.WriteDouble(teamid)
	net.Broadcast()

	self:CollisionRulesChanged()
end

function meta:CheckSpeedChange()
	if not ValidEntity(self) then return end
	
	local wep = self:GetActiveWeapon()
	
	if wep and IsValid(wep) then
	
		local iron = false
		
		if wep.GetIronsights and wep:GetIronsights() then
			iron = true
		end
		
		GAMEMODE:WeaponDeployed( self, wep, iron )
		
		return
	end
	
	local speed = 200
	local health = self:Health()
	
	if self:GetPerk() == "_sboost" then
		speed = speed*1.08
	end
	
	if self:GetPerk() == "_sboost2" then
		speed = speed*1.04
	end
	
	local fHealthSpeed = self:GetPerk("_adrenaline") and 1 or math.Clamp ( ( health / 50 ), 0.7, 1 )
	
	if self:IsHolding() then
		-- for _, status in pairs(ents.FindByClass("status_human_holding")) do
		local status = self.status_human_holding
			if status and IsValid(status) and status:GetOwner() == self and status.GetObject and status:GetObject():IsValid() and status:GetObject():GetPhysicsObject():IsValid() then
				speed = math.max(CARRY_SPEEDLOSS_MINSPEED, speed - status:GetObject():GetPhysicsObject():GetMass() * CARRY_SPEEDLOSS_PERKG)
				-- break
			end
		-- end
	else
		speed = math.Round ( speed * fHealthSpeed )
	end
	
	GAMEMODE:SetPlayerSpeed( self, speed )
	
end

function meta:SpawnAsSteroidZombie(int)
end

function meta:SpawnMiniTurret()
	if IsValid(self.MiniTurret) then
		return
		end
	
	local ent = ents.Create("zs_miniturret")
	if ent then
		ent:SetPos(self:GetPos()+vector_up*40)
		ent:SetOwner(self)
		ent:Spawn()
		ent:Activate()	
		self.MiniTurret = ent
	end
end

--Duby: I removed this as we don't have the shop any more.

--[[----------------------------------------------------]]--

--util.AddNetworkString( "BoughtPointsWithCoins" )

--function meta:HasBoughtPointsWithCoins()
 --   local tab = DataTableConnected[self:UniqueID()]
  --  if ( tab ) then
   --     return tab.HasBoughtPointsWithCoins or false
   -- end
    
   -- return false
--end

--function meta:SetBoughtPointsWithCoins( bool )
 --   local tab = DataTableConnected[self:UniqueID()]
  --  if ( not tab ) then
   --     DataTableConnected[self:UniqueID()] = {}    
  --  end
    
  --  tab.HasBoughtPointsWithCoins = bool
--end

--function meta:CanBuyPointsWithCoins()
  --  return not self:HasBoughtPointsWithCoins() and self:GreenCoins() >= 200
--end

--[[----------------------]]--

--function meta:UpdateBoughtPointsWithCoins()
 --   net.Start( "BoughtPointsWithCoins" )
  --      net.WriteBit( self:HasBoughtPointsWithCoins() )
   -- net.Send( self )
--end

--hook.Add( "PlayerReady", "UpdatePlayerBoughtPointsWithCoins", function( pl )
 --   pl:UpdateBoughtPointsWithCoins()
--end )

--concommand.Add( "zs_boughtpointswithcoins", function( pl, cmd, args )
 --   if ( IsValid( pl ) ) then
 --       if ( pl:CanBuyPointsWithCoins() ) then
	--		skillpoints.AddSkillPoints(pl, 300)
  --          pl:TakeGreenCoins(80)
    --    end
     --   pl:SetBoughtPointsWithCoins(true)
   -- end
--end )

--[[----------------------------------------------------]]--

