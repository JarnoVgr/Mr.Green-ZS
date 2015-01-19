-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Global vars 
GM.UndeadSpawnPoints = {}
GM.HumanSpawnPoints = {}
DataTableConnected = {}


--[==[--------------------------------------------------------------
      Called everytime a player connects for first time
---------------------------------------------------------------]==]
function GM:PlayerInitialSpawn(pl)
	if MAPCODER_CLIENT_ACTIVE then
		--Map data
		net.Start("mapData")
		net.WriteBit(true)
		net.Send(pl)
	end
	
	--TODO: Move this
	if GasDump then
		timer.Simple(4,function()
			RunConsoleCommand("stopsound")
		end)
	end
	
	pl:SetCanZoom(false)

	-- Bots are always ready, human players need to wait
	if pl:IsBot() then
		pl.Ready = true
	else
		pl.Ready = false
	end
	
	pl:SetZombieClass(0)
	pl:SetHumanClass(1)
	
	-- Substract one point from the most chosen class table to compensate for the setzombie/human class above
	--local HumanClassName, ZombieClassName = HumanClasses[1].Name, ZombieClasses[1].Name
	
	local ZombieClassName = ZombieClasses[1].Name --Duby: I altered this as I removed the classes code. 
	self.TeamMostChosenClass[ ZombieClassName ] = self.TeamMostChosenClass[ ZombieClassName ] - 1
	
	pl.BrainsEaten = 0
	pl.NextShove = 0
	pl.ZombiesKilled = 0
	pl.NextPainSound = 0
	pl.ZomAnim = 2
	pl.HighestAmmoType = "pistol"
	pl.DamageDealt = {}
	pl.DamageDealt[TEAM_UNDEAD] = 0
	pl.DamageDealt[TEAM_HUMAN] = 0
	pl.VoiceSet = "male" 
	pl.LastHurt = 0
	pl.LastHit = 0
	pl.LastVoice = 0
	pl.HighestAmmoType = "pistol"
	
	pl.RecBrain = 0
	pl.BrainDamage = 150
	pl.MaxHealth = 100
	pl.Suicided = false
	pl.FreshRedeem = false
	pl.Gibbed = false
	
	pl.DataTable = pl.DataTable or {}
	pl.Redeems = 0
	pl.PropKills = 0
	pl.TookHit = false
	pl.HeadCrabKills = 0
	pl.MeleeKills = 0
	pl.LastHumanTime = nil
	pl.ZombieAdminsKilled = 0
	pl.Screamlist = {}
	pl.ScreensFucked = 0
	pl.Headshots = 0
	pl.GreencoinsGained = {}
	pl.GreencoinsGained[TEAM_UNDEAD] = 0
	pl.GreencoinsGained[TEAM_HUMAN] = 0
	pl.HealingDone = 0
	pl.Assists = 0
	pl.Hornyness = 0
	pl.WeaponTable = {}
	pl.NextHold = 0
	pl.WalkSpeed = 200
	
	pl.ReviveCount = 0
	
	-- Small table for enabling some skillshots
	pl.MultiKills = {}
	-- Filter specific weapons
	pl.MultiKills.Grenade = {}
	pl.MultiKills.Crossbow = {}
	pl.MultiKills.Mine = {}
	pl.MultiKills.Pistol = {}
	
	pl.Loadout = pl.Loadout or {}
	pl.Perk = pl.Perk or {}
	
	pl.SupplyCart = {}
	pl.SupplyCart.Weapons = {}
	pl.SupplyCart.Ammo = {}
	
	pl.GotWeapon = {}
	pl.GotWeapon.Pistol = false
	pl.GotWeapon.Automatic = false
	pl.GotWeapon.Melee = false
	
	pl.AmmoMultiplier = {}
	
	pl.LastRTD = 0 
	pl.StuckTimer = 0
	
	pl:SetCustomCollisionCheck(true)
	-- pl:SetNoCollideWithTeammates(true)
	-- pl:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		
	-- Used to control how many weapons you are allowed to pickup
	pl.CurrentWeapons = { Automatic = 0, Pistol = 0, Melee = 0, Tool1 = 0, Misc = 0, Admin = 0 }
	
	pl.AutoRedeem = util.tobool(pl:GetInfoNum("_zs_autoredeem",1)) or true
	pl.IsFreeman = false
	
	local balance = team.NumPlayers(TEAM_HUMAN) / team.NumPlayers(TEAM_UNDEAD)
	local ID = pl:UniqueID() or "UNCONNECTED"
	
	-- Team
	local iTeam = TEAM_SPECTATOR
	
	if pl:IsBot() then
		iTeam = TEAM_HUMAN
	end
	
	-- Setup a table for connected players for good reasons
	if not DataTableConnected[ID] then
		DataTableConnected[ID] = { IsDead = false, SuicideSickness = false, Health = false, HumanClass = false, AlreadyGotWeapons = false } 
	end
	
	-- Case 3: If player has connected as human and passed the class menu then reconnected then set him as human again with same class and health
	if pl:ConnectedAlreadyGotWeapons() and not pl:ConnectedIsDead() then
		iTeam = TEAM_HUMAN
	end


	if not pl:IsBot() then
		if DataTableConnected[ID].IsDead then
			pl.SpawnedTime = CurTime()
			iTeam = TEAM_UNDEAD
		end
	end
	
	--Case 2: If passed 5 minutes or lasthuman or endround or more than 50% players zombie, place him as undead
	if (CurTime() > ROUNDTIME * 0.25) or LASTHUMAN or (GetInfliction() >= 0.5 and team.NumPlayers(TEAM_UNDEAD) > 2) or ENDROUND then
		iTeam = TEAM_UNDEAD
		DataTableConnected[ID].IsDead = true
	end
		
	-- Set the player's team
	pl:SetTeam(iTeam)
	
	pl:SetZombieClass(0)
	
	--Call PlayerReady if player is a bot
	if pl:IsBot() then
		pl:SetHumanClass(1)
		self:PlayerReady(pl)
	end
	
	--log
	--[[if (iTeam ~= TEAM_SPECTATOR) then
		log.PlayerJoinTeam( pl, iTeam )
		log.PlayerRoleChange( pl, pl:GetClassTag() )
	end]]
	
	skillpoints.SetupSkillPoints(pl)
		
	if OBJECTIVE then
		self:UpdateObjStageOnClients(pl)
	end
	
	self:CalculateInfliction()
	self:OnPlayerReady(pl)


	Debug("[INIT-SPAWN] ".. tostring(pl) .." finished Initial Spawn Function")
end
util.AddNetworkString("mapData")

--[==[-----------------------------------------------------------------
     Mainly for debug purposes -- record everything in logs
------------------------------------------------------------------]==]
local function PlayerConnected ( pl, ip )
	Debug("[CONNECTED] ".. tostring(pl) .." connecting from "..tostring(ip))
end
hook.Add("PlayerConnect", "Connected", PlayerConnected)

--[==[------------------------------------------------
     Main spawn function - called on spawn
-------------------------------------------------]==]
function GM:PlayerSpawn(pl)
	--Block when player isn't ready yet
	if not pl.Ready then
		pl:KillSilent()
		--Debug("[SPAWN] "..tostring ( pl ).." is not Ready. Blocking spawn and killing him silently. Alive: "..tostring(pl:Alive()))
		return
	end

	--Predicting spawn, don't erase
	pl:SetDeaths(PREDICT_SPAWN)
	
	-------------------------BEGIN DUBY'S FIX
	pl:ManipulateBonePosition(math.Rand(1, 1) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(4, 4) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine
	pl:ManipulateBonePosition(math.Rand(5, 5) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--arm left
	pl:ManipulateBonePosition(math.Rand(9, 9) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand left
	pl:ManipulateBonePosition(math.Rand(2, 2) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(3, 3) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--spine upwards
	pl:ManipulateBonePosition(math.Rand(16, 16) , Vector( math.Rand( 0, 0), math.Rand(0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(15, 15) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right
	pl:ManipulateBonePosition(math.Rand(20, 20) , Vector( math.Rand( 0, 0), math.Rand( 0, 0), math.Rand( 0, 0)) )	--hand right

	local Bone = pl:LookupBone("ValveBiped.Bip01_Spine4")
	if Bone then
		pl:ManipulateBoneAngles( Bone, Angle(0,0,0)  )
		pl:ManipulateBoneScale( Bone, Vector(1,1,1)  )
	end
	
	local Bone = pl:LookupBone("ValveBiped.Bip01_L_UpperArm")
	if Bone then
		pl:ManipulateBoneAngles( Bone, Angle(0,0,0)  )
	end
	
	--[[local Bone = pl:LookupBone("ValveBiped.Bip01_Spine1")
	if Bone then
	 	pl:ManipulateBoneAngles( Bone, Angle(0,0,-90)  )
	end]]
	
	--[[local Bone = pl:LookupBone("ValveBiped.Bip01_Spine")
	if Bone then
		pl:ManipulateBoneAngles( Bone, Angle(0,0,-90)  )
	end]]
	
	for i = 0, pl:GetBoneCount() - 1 do
		--pl:ManipulateBoneScale( Bone, Vector(1.4,1.4,1.4)  )
		pl:ManipulateBoneScale(i, Vector(1,1,1))
	end

	pl:SetRenderMode(RENDERMODE_NORMAL)
	pl:SetColor(Color(225,225,225,225))
	-------------------------END DUBY'S FIX


	
	--Set model based on preferences
	if pl:IsBot() then
		--Random model
		pl.PlayerModel = table.Random(PlayerModels)
	else
		--Get preferred model
		local DesiredPlayerModelName = pl:GetInfo("cl_playermodel")
		if #DesiredPlayerModelName > 0 and DesiredPlayerModelName ~= "none" then
			pl.PlayerModel = string.lower(DesiredPlayerModelName)
		else
			--pl.PlayerModel = table.Random(PlayerModels)
			pl.PlayerModel = "kleiner"
		end
			
		--Check if in PlayerModels list
		if table.HasValue(PlayerModels, pl.PlayerModel) or (pl:IsAdmin() and table.HasValue(PlayerAdminModels, pl.PlayerModel)) then
			--Get custom player color
			local PlayerModelColor = pl:GetInfo("cl_playercolor")
			
			--Set player color
			pl:SetPlayerColor(Vector(PlayerModelColor))
			
			--Set weapon color
			pl:SetWeaponColor(Vector(PlayerModelColor))
		else
			pl.PlayerModel = table.Random(PlayerModels)
			Debug("[PLAYER MODEL] ".. tostring(pl:Name()) .." wanted to spawn as ".. DesiredPlayerModelName ..". Which doesn't exist.")
		end
		
		--Check if we can be THE Gordon Freeman
		if pl:Team() ~= TEAM_SPECTATOR and ((not self.IsGordonHere and pl:HasBought("gordonfreeman") and math.random(1,5) == 1 and pl:Team() == TEAM_SURVIVORS) or pl.IsFreeman) then
			--Only display message when being human
			if pl:Team() == TEAM_SURVIVORS then
				pl:ChatPrint("You're now THE Gordon Freeman!")
			end

			--Set global
			self.IsGordonHere = true
			
			--Set model for player
			pl.IsFreeman = true
			pl.PlayerModel = "gordon"
		end

		--Check if we can be Santa Claus
		if CHRISTMAS and pl:Team() ~= TEAM_SPECTATOR and ((not self.IsSantaHere and math.random(1,7) == 1 and pl:Team() == TEAM_SURVIVORS) or pl.IsSanta) and not pl.IsFreeman then
			--Only display message when being human
			if pl:Team() == TEAM_SURVIVORS then
				pl:ChatPrint("You're now THE Santa Claus!")
				pl:ChatPrint("Ho ho ho!")
			end
			

			--Set global
			self.IsSantaHere = true
			
			--Set model for player
			pl.IsSanta = true
			pl.PlayerModel = "santa"
		end
	end

	if HALLOWEEN and pl:Team() ~= TEAM_SPECTATOR then
		pl:ChatPrint("HAPPY HALLOWEEN!!!")
	end
			
	
	if pl:Team() == TEAM_SPECTATOR then
		self:OnFirstHumanSpawn(pl)
		return
	end

	-- Unlock or unfreeze if neccesary and make him able to walk
	pl:UnLock()
	pl:Freeze(false)
		
	pl.StartTime = pl.StarTime or CurTime()
	pl.IsSecondSpawn = true
	pl.SpawnTime = CurTime()
		
	pl.TookHit = false
	pl.CheatDeathCooldown = 0
	pl.IsRegenerating = false
		
	pl.NextSpawn = nil
	pl.Gibbed = nil
		
	pl.LastHealth = pl:Health()
		
	--Disable walk
	pl:SetCanWalk(false)

	--Set no-collide with team
	--This shit glitchy as hell
	pl:SetNoCollideWithTeammates(true)
		
	--Setup spawn functions
	if pl:Team() == TEAM_HUMAN then
		self:OnHumanSpawn(pl)
	elseif pl:Team() == TEAM_UNDEAD then
		self:OnZombieSpawn(pl)
		pl:StopAllLuaAnimations()
	end
end

--[==[---------------------------------------------------------
   Called right when the human classes menu appears
---------------------------------------------------------]==]
function GM:OnFirstHumanSpawn(pl)
	-- Kill them and make them stay still
	pl:KillSilent()
	
	pl.HumanClassMenuSent = true
	
	Debug("[SPAWN] Sending Human Class Menu to "..tostring(pl))
end

--[==[------------------------------------------------
	Called everytime a human spawns
-------------------------------------------------]==]
function GM:OnHumanSpawn(pl)
	if not pl:IsHuman() then
		return
	end

	--TODO: Move notices to map specific files
	--Gas Dump Obj Map special notices.
	if GasDump then
		timer.Simple(10,function() 
			pl:Message("The horde nest is bellow the building.", 1)
		end)

		timer.Simple(11,function() 
			pl:Message("You need to blow it up..", 1)
		end)

		timer.Simple(13,function() 
			pl:Message("These zombies are stronger..", 2)
		end)

		timer.Simple(15,function() 
			pl:Message("But you are prepared.", 2)
		end)
	end
	
	--Special messages for pub as these nitwhits find it hard to play this map.
	if PUB then
		timer.Simple(15,function() 
			pl:Message("This is your last stand against the horde", 1)
		end)

		timer.Simple(17,function() 
			pl:Message("Make sure you barricade downstairs!", 1)
		end)

		timer.Simple(20,function() 
			pl:Message("See you on the other side", 1)
		end)
	end
	
	--Spawn protection
	pl:GodEnable()
	timer.Simple(5, function() 
		if IsValid(pl) then
			pl:GodDisable() 
		end
	end)
	
	local ID = pl:UniqueID() or "UNCONNECTED"
	
	--Time the player spawned
	pl.SpawnedTime = CurTime()
	
	--Case 1: If the player already got the class menu as human and disconnected then set his same class back and/or hp
	if pl:ConnectedAlreadyGotWeapons() and pl:ConnectedHumanClass() ~= false then
		DataTableConnected[ID].HumanClass = false
	end
	
	--Strip weapons from real players
	if not pl:IsBot() then
		pl:StripWeapons()
	end
	
	-- Change his player model and set up his voice set
	local plModel = player_manager.TranslatePlayerModel(pl.PlayerModel)
	pl:SetModel(plModel)
	pl.VoiceSet = VoiceSetTranslate[string.lower(plModel)] or "male"
	
	pl.SelectedSuit = pl:GetInfo("_zs_defaultsuit") or "none"
	pl.SelectedHat = pl:GetInfo("_zs_equippedhats") or "none"

	
	pl.ReviveCount = 0
			
	--Calculate player's speed
	self:SetPlayerSpeed(pl, CalculatePlayerSpeed(pl))

	--Set crouch speed
	pl:SetCrouchedWalkSpeed(0.65)
	
	--Set jump power
	if pl:GetJumpPower() ~= 200 then
		pl:SetJumpPower(200) 
	end
	
	--Calculate maximum health for human
	CalculatePlayerHealth(pl)
	
	--
	pl:DoHulls()
			
	--Apply loadout
	CalculatePlayerLoadout(pl)

	--Blood color
	pl:SetBloodColor(BLOOD_COLOR_RED)

	--Delay use of Supply Crate
	pl.NextSupplyUse = WARMUPTIME+60
	pl:SendLua("MySelf.NextSupplyTime = ".. pl.NextSupplyUse) --Uses ServerTime clientside

	--
	self:ProceedCustomSpawn(pl)

	--Set hat and suit
	if pl.SelectedHat ~= "none" or pl:IsBot() then
		self:SpawnHat(pl, pl.SelectedHat)
	end
	if pl.SelectedSuit ~= "none" or pl:IsBot() then
		self:SpawnSuit(pl, pl.SelectedSuit)
	end

	--Hands test
	local OldHans = pl:GetHands()
	if IsValid(OldHans) then
		OldHans:Remove()
	end

	--Hands for c_model usage
	local Hands = ents.Create("zs_hands")
	if IsValid(Hands) then
		Hands:DoSetup(pl)
		Hands:Spawn()
	end	

	--Auto-enable flashlight
	pl:Flashlight(true)
	
	--Log
	Debug("[SPAWN] ".. tostring(pl:Name()) .." spawned as a Survivor")
end


--[==[------------------------------------------------
	Called everytime a zombie spawns
-------------------------------------------------]==]
function GM:OnZombieSpawn(pl)
	if pl:Team() ~= TEAM_UNDEAD then
		return
	end

	--Spawn protection
	pl:GodEnable()
	timer.Simple(2, function()
		if IsValid(pl) then
			pl:GodDisable()
		end
	end)
	
	local ID = pl:UniqueID() or "UNCONNECTED"
	
	--Set a random human class if they connect as zombie and there is no human class
	if pl:ConnectedIsDead() and pl.ClassHuman == nil then
		pl:SetHumanClass(1)
	end
	
	--Manages class spawn
	if pl.DeathClass then
		pl:SetZombieClass(pl.DeathClass)
		pl.DeathClass = nil
	end
	
	--Enable the suicide system on the player if he had it
	if pl:ConnectedHasSuicideSickness() then
		pl.Suicided = true
		DataTableConnected[ID].SuicideSickness = false
	end
	
	local Class = pl:GetZombieClass()
	local Tab = ZombieClasses[Class]
		
	-- Calculate zombie's health
	CalculateZombieHealth(pl)

	pl:DoHulls(Class, TEAM_UNDEAD)
	
	--Attach crabs to zombos
	pl:SetHeadcrabBodyGroup()
	
	--Set the zombies model
	pl:SetModel(Tab.Model)

	pl.NoBounty = false
	
	--
	if not pl.Loadout then
		pl.Loadout = {}
	end
	
	--Fix late spawners
	if #pl.Loadout <=1 then
		timer.Simple(1,function()
			if IsValid(pl) then
				pl:SendLua("LateSpawnLoadout()")
			end
		end)
	end

	--Set jump power
	if pl:GetJumpPower() ~= (Tab.JumpPower or 200) then
		pl:SetJumpPower(Tab.JumpPower or 200) 
	end
	
	--
	if pl.Revived then
		pl.ReviveCount = pl.ReviveCount + 1
	else
		pl.ReviveCount = 0
	end
	
	--
	if not pl.Revived then
		-- SpawnProtection(pl)
		pl.NoExplosiveDamage = CurTime() + 1.5 
	end
	
	pl:StripWeapons()
	
	--Give zombie SWEP
	if Tab.SWEP then
		pl:Give(Tab.SWEP)
		pl:SelectWeapon(Tab.SWEP)
	end
	
	--Set skin color
	local col = pl:GetInfo( "cl_playercolor" )
	pl:SetPlayerColor(Vector(col))
	pl:SetWeaponColor(Vector(col))

	--Call class spawn function
	if Tab.OnSpawn then
		Tab.OnSpawn(pl)
	end
		
	-- Set the zombie's walk and crouch speed
	self:SetPlayerSpeed(pl, Tab.Speed)
	pl:SetCrouchedWalkSpeed(Tab.CrouchWalkSpeed or 0.80)

	--TODO: Move to map specific file
	if GasDump then
		self:SetPlayerSpeed(pl, Tab.Speed*1.4)
	end
		
	pl:UnSpectate()		
	-- Prevent health pickups and/or machines
	pl:SetMaxHealth(1) 
	
	pl:SetBloodColor(BLOOD_COLOR_RED)

	--Alert players they can change zombie class
	if Class == 0 and pl:GetRank() <= 5 and math.random(1,3) == 1 then
		pl:Message("Press F3 to play with a different Undead specie", 3)
	end

	--Auto enable zombie vision at first spawn
	if pl.m_ZombieVision == nil or pl.m_ZombieVision == true then
		timer.Simple(0.3,function()
			pl.m_ZombieVision = true
			pl:SendLua("gamemode.Call(\"ToggleZombieVision\", "..tostring(pl.m_ZombieVision)..")")
		end)
	end

	Debug("[SPAWN] ".. tostring(pl:Name()) .." spawned as an Undead")
end

-- Human's dynamic spawn

function GM:ProceedCustomSpawn(pl)
	if not IsValid(pl) or pl:IsZombie() or pl.Redeemed then
		return
	end
	
	local newspawn = self:GetNiceHumanSpawn(pl)
	
	if not util.tobool(pl:GetInfoNum("_zs_humanspawn",0)) then
		return
	end

	if newspawn then
		pl:SetPos(newspawn:GetPos())
	end
end



--[==[------------------------------------------------
	    Called on player disconnect
-------------------------------------------------]==]
function GM:PlayerDisconnected( pl )
	if not IsValid(pl) then
		return
	end
	
	-- Save greencoins and stats
	pl:SaveGreenCoins()
	
	-- Clean up sprays
	table.remove(Sprays,pl:UserID())
	SendSprayData()
	
	--Log
	Debug ( "[DISCONNECT] "..tostring ( pl ).." disconnected from the server. IP is "..tostring(pl:IPAddress()).." | SteamID: "..tostring(pl:SteamID()))
	
	--Player saved data
	local ID = pl:UniqueID() or "UNCONNECTED"
	if DataTableConnected[ID] == nil then
		return
	end
		if pl.Suicided then
			DataTableConnected[ID].SuicideSickness = true
		end
	--end
	
	--Delay calculation
	timer.Simple(2, function()
		self:CalculateInfliction()
	end)
end

--[==[------------------------------------------------
   Used to calculate player speed on spawn
-------------------------------------------------]==]
function CalculatePlayerSpeed ( pl )
	local Class = pl:GetHumanClass()
	local Speed = 0
	-- Case 3: Without bonus
	if  pl:IsBot() then --This was changed as it worked off the medic class speeds. Which don't exist any more! 
	Speed = 190
	end
	Speed = 190
	
	return Speed, Speed
end

--[==[------------------------------------------------
     Loadout Director - Called on h spawn
-------------------------------------------------]==]
function CalculatePlayerLoadout ( pl )
	if pl:Team() ~= TEAM_HUMAN then
		return
	end

	local Class = pl:GetHumanClass()
	local ToGive = {}
	
	if pl.Loadout then
		if #pl.Loadout > 0 then
			--PrintTable(pl.Loadout)
			ToGive = table.Copy(pl.Loadout)
		else
			--PrintTable(pl.Loadout)
			ToGive = {"weapon_zs_usp","weapon_zs_melee_keyboard"}
			pl.Loadout = table.Copy(ToGive)
		end
	else
		--PrintTable(pl.Loadout)
		ToGive = {"weapon_zs_usp","weapon_zs_melee_keyboard"}
		pl.Loadout = table.Copy(ToGive)
	end
	
	if  pl:IsBot() then --This was changed as it worked off the medic class speeds. Which don't exist any more! 
		ToGive = { "weapon_zs_tools_hammer","weapon_zs_melee_keyboard" }
	end
		
	--Actually give the weapons
	for k,v in pairs(ToGive) do
		pl:Give(tostring(v))
	end
	
	if ARENA_MODE then
		pl:Give(table.Random(GAMEMODE.ArenaWeapons))
		pl:GiveAmmo(650,"ar2")
		pl:GiveAmmo(650,"smg1")
		pl:GiveAmmo(650,"buckshot")
		pl:GiveAmmo(650,"pistol")
		pl:GiveAmmo(650,"357")
		end
		
		if GasDump then
		pl:Give(table.Random(GAMEMODE.GasDump))	
		pl:GiveAmmo(30,"buckshot")
		pl:GiveAmmo(200,"ar2")
	else
		--Check if bought Magnum (give 1/3rd chance)
		if pl:HasBought("magnumman") and math.random(1,3) == 1 then
			--Strip previous pistol
			local Pistol = pl:GetPistol()
			if Pistol then
				pl:StripWeapon(Pistol:GetClass())
			end
			--Give new magnum
			pl:Give("weapon_zs_magnum")

			--Override old pistol for auto-deploy (selecting)
			ToGive[1] = "weapon_zs_magnum"
		end
	end

	 --IMORTAL PRO perk. Duby: Lets see how this works out. 
	
	--if pl:GetPerk("_imortalpro") and math.random(1,2) == 1 then
	if pl:GetPerk("_imortalpro") then
			--Strip previous pistol
			local Pistol = pl:GetPistol()
			local Auto = pl:GetAutomatic()
			if Pistol then
				pl:StripWeapon(Pistol:GetClass()) --We remove their pistol as its the price they pay for having the pulse smg!
			end
			if Auto then
				pl:StripWeapon(Auto:GetClass())
			end
		pl:Give("weapon_zs_pulsesmg")
		ToGive[1] = "weapon_zs_pulsesmg"
		else
		ToGive[1] = "weapon_zs_smg" --Life ain't fair. (O)_(O) 	
		end	
	if ToGive and #ToGive > 0 then
		pl:SelectWeapon(tostring(ToGive[1]))
	end
end

function CalculateZombieHull ( pl )
	if pl:Team() ~= TEAM_UNDEAD then return end

	local Tab = ZombieClasses[ pl:GetZombieClass() ]
	
	local HullTab
	
	if Tab.Hull then
		HullTab = Tab.Hull
	else
		HullTab = {Vector ( -16, -16, 0 ), Vector ( 16, 16, 72 )}
	end
	
	ChangeHullSize(pl,HullTab)
end

function CalculateHumanHull ( pl )
	if pl:Team() ~= TEAM_HUMAN then return end

	local Tab = {Vector ( -16, -16, 0 ), Vector ( 16, 16, 72 )}
	
	ChangeHullSize(pl,Tab)
end
-- TODO: Use spawn prediction on client instead
function ChangeHullSize(pl,tab)
if not IsValid(pl) then return end
if pl:IsBot() then return end
if not tab then tab = {Vector ( -16, -16, 0 ), Vector ( 16, 16, 72 )} end

	pl:SetHull( tab[1],tab[2] )
	
	umsg.Start("ChangeHullSize")
	umsg.Entity(pl)
	umsg.Vector(tab[1])
	umsg.Vector(tab[2])
	umsg.End()
end

function CalculateZombieHealth(pl)
	if pl:Team() ~= TEAM_UNDEAD then
		return
	end
	
	local classId = pl:GetZombieClass()
	local Tab = ZombieClasses[classId]
	local MaxHealth = Tab.Health
	
	--if GetInfliction() <= 0.6 then --Duby: Lets make the health for normal zombies increased later in the game. 
	--	if IsCommonZombie() or IsCommonZombie2() then
		--	pl:SetHealth(MaxHealth*1.5)
	--	end
	--end
	
	-- Case 2: if there are only 2 zombies double their HP
	
	if not pl:IsBossZombie() then
		local allPlayers = player.GetAll()
		local numPlayers = #allPlayers

		local desiredzombies = math.max(1, math.ceil(numPlayers * UNDEAD_START_AMOUNT_PERCENTAGE))
		if (team.NumPlayers(TEAM_UNDEAD) <= (desiredzombies+1) and team.NumPlayers(TEAM_HUMAN) >= 4) then
			local IncreaseHealth = Tab.Health*(UNDEAD_START_AMOUNT_PERCENTAGE)*desiredzombies+10*(team.NumPlayers(TEAM_HUMAN))
			MaxHealth = math.Clamp(Tab.Health + IncreaseHealth, Tab.Health, math.min(Tab.Health*2.0,510) )
		end
	end
	MaxHealth = math.Round(MaxHealth)

	--Set health
	pl:SetMaximumHealth(MaxHealth)
	pl:SetHealth(MaxHealth)
	
	if GasDump then
		pl:SetMaximumHealth(MaxHealth*1.5)
		pl:SetHealth(MaxHealth*1.5)
	end
end


function CalculatePlayerHealth(pl)
	if pl:Team() ~= TEAM_HUMAN then
		return
	end

	local MaxHealth, Health = 100, 100
	
	-- Case 3: If player got hurt and reconnected as human
	if pl:ConnectedHealth() ~= false then
		Health = pl:ConnectedHealth()
		DataTableConnected[pl:UniqueID() or "UNCONNECTED"].Health = false
	end
	
	--First kevlar upgrade
	--if pl:GetPerk("_kevlar") then
		--MaxHealth, Health = 110, 110
	--end
	
	--Second kevlar upgrade
	if pl:GetPerk("_kevlar2") then
		MaxHealth, Health = 130, 130
	end
	
	--Third kevlar upgrade
	--if pl:GetPerk("_kevlar3") then
	--	MaxHealth, Health = 105, 105
	--end
	
	-- Actually set the health
	pl:SetHealth(Health)
	pl:SetMaximumHealth(MaxHealth)
end

--[==[----------------------------------------------------
     Execute PlayerReady when client is ready
-----------------------------------------------------]==]
concommand.Add( "PostPlayerInitialSpawn", function(sender, command, arguments)
	if not sender.PostPlayerInitialSpawn then
		Debug("[SPAWN] PostPlayerInitialSpawn ConCommand called. It's still needed.")
		sender.PostPlayerInitialSpawn = true
		gamemode.Call("PlayerReady", sender)
	end
end)

util.AddNetworkString("OnReadySQL")

hook.Add("OnPlayerReadySQL", "UpdateDataTableJoin", function(pl)
	if not IsValid(pl) then 
		return 
	end
	
	--Check for client validity
	if not pl.IsClientValid then 
		return 
	end
	
	--Player received all data
	pl.Ready = true
	
	GAMEMODE:SendTitle(player.GetAll(), {pl})
	GAMEMODE:SendTitle({pl}, player.GetAll())
	
	-- Send gc amount
	GAMEMODE:SendCoins(pl)

	-- Send shop items and ClassData
	stats.SendShopData(pl, pl)
	stats.SendAchievementsData(pl, pl)
	stats.SendClassDatastream(pl)
	
	pl.TotalUpgrades = 0
	
	--Calculate the total upgrade each player has
	for upgrades,price in pairs(shopData) do
		if pl:HasBought(upgrades) then
			if price.Cost > 2500 then
				pl.TotalUpgrades = pl.TotalUpgrades + 1
			end
		end
	end
	
	--Send nr of shopitems
	GAMEMODE:SendUpgradeNumber(pl)
	
	--Send SQL ready status
	net.Start("OnReadySQL")
	net.Send(pl)
	
	--Debug("[SPAWN] "..tostring(pl).." is Ready. Spawning him.")
	
	--Spawn the player
	if not ENDROUND then 
		pl:Spawn() 
	end
end)

--When localplayer is valid on clientside
function GM:PlayerReady(pl)
	pl.IsClientValid = true
	if not pl.Ready and not mysql.IsConnected() then
		pl:CheckDataTable()
		gamemode.Call("OnPlayerReadySQL", pl)
		Debug("[SQL] Failed to retrieve SQL player table for ".. tostring(pl))
	end
end

function GM:SetupSpawnPoints()
	local ztab = {}
	ztab = ents.FindByClass("info_player_undead")
	ztab = table.Add(ztab, ents.FindByClass("info_player_zombie"))
	ztab = table.Add(ztab, ents.FindByClass("info_player_rebel"))
	
	local htab = {}
	htab = ents.FindByClass("info_player_human")
	htab = table.Add(htab, ents.FindByClass("info_player_combine"))

	local mapname = string.lower(game.GetMap())
	-- Terrorist spawns are usually in some kind of house or a main base in CS_  in order to guard the hosties. Put the humans there.
	if string.sub(mapname, 1, 3) == "cs_" or string.sub(mapname, 1, 3) == "zs_" then
		ztab = table.Add(ztab, ents.FindByClass("info_player_counterterrorist"))
		htab = table.Add(htab, ents.FindByClass("info_player_terrorist"))
	else -- Otherwise, this is probably a DE_, ZM_, or ZH_ map. In DE_ maps, the T's spawn away from the main part of the map and are zombies in zombie plugins so let's do the same.
		ztab = table.Add(ztab, ents.FindByClass("info_player_terrorist"))
		htab = table.Add(htab, ents.FindByClass("info_player_counterterrorist"))
	end


	--Add deprecated GMod9 Zombie Survival spawns
	for _, oldspawn in pairs(ents.FindByClass("gmod_player_start")) do
		if oldspawn.BlueTeam then
			table.insert(htab, oldspawn)
		else
			table.insert(ztab, oldspawn)
		end
	end

	--You shouldn't play a DM map since spawns are shared but whatever. Let's make sure that there aren't team spawns first.
	if #htab == 0 then
		htab = ents.FindByClass("info_player_start")
		htab = table.Add(htab, ents.FindByClass("info_player_deathmatch")) -- Zombie Master
	end
	if #ztab == 0 then
		ztab = ents.FindByClass("info_player_start")
		ztab = table.Add(ztab, ents.FindByClass("info_zombiespawn")) -- Zombie Master
	end
	
	team.SetSpawnPoint(TEAM_ZOMBIE, ztab)
	team.SetSpawnPoint(TEAM_HUMAN, htab)
	team.SetSpawnPoint(TEAM_SPECTATOR, htab)
end

--[==[------------------------------------------------------------------------------------------------
                      Selects a location for the human/spectator to spawn
-------------------------------------------------------------------------------------------------]==]
function GM:ProcessHumanSpawn( pl, tbPoints, tbAngles )

	-- Get random points for first time
	local iRandom = math.random ( 1, #tbPoints )
	local vPos, angSpawn = tbPoints[iRandom], tbAngles[iRandom]
	
	-- Filters
	local Filter = {} 
	if pl:Team() == TEAM_HUMAN then
		Filter = team.GetPlayers(TEAM_HUMAN)
	else
		Filter = team.GetPlayers(TEAM_UNDEAD)
	end
	
	--Hull trace spawnpoints
	for i = 1, #tbPoints do
		if i < 5 then
		
			--Stuck bool
			--local bStuck = IsStuck ( vPos, HULL_PLAYER[1], HULL_PLAYER[2], Filter )
			local bStuck = false
			
			--Point is clear
			if not bStuck then
				return vPos, angSpawn
			--Point is not clear
			elseif bStuck then
				pl.SpawnRetryCounter = pl.SpawnRetryCounter + 1
				local iRandom = math.random ( 1,#tbPoints )
				vPos, angSpawn = tbPoints[iRandom], tbAngles[iRandom]
			end
		end
	end
	
	return vPos, angSpawn
end 

--[==[------------------------------------------------------------------------------------------------
                             Selects a location for the undead to spawn
-------------------------------------------------------------------------------------------------]==]

function GM:ProcessZombieSpawn( pl, tbPoints, tbAngles )
	
	-- Get random points for first time
	local iRandom = math.random ( 1, #tbPoints )
	local vPos, angSpawn, bStuck, bIsVisible = tbPoints[iRandom], tbAngles[iRandom]
	
	-- Filters
	local Filter = {} 
	if pl:Team() == TEAM_HUMAN then Filter = team.GetPlayers ( TEAM_HUMAN ) else Filter = team.GetPlayers ( TEAM_UNDEAD ) end
	
	-- Hull trace spawnpoints
	for i = 1, 2 do
		--Stuck bool
		bStuck, bIsVisible = IsStuck ( vPos, HULL_PLAYER[1], HULL_PLAYER[2], Filter ), VisibleToHumans ( vPos, pl )
			
		-- Point is clear
		if not bStuck and not bIsVisible then
			return vPos, angSpawn
		end
				
		-- Point is not clear
		if bStuck or bIsVisible then
			pl.SpawnRetryCounter = pl.SpawnRetryCounter + 1
			local iRandom = math.random(1, #tbPoints)
			vPos, angSpawn = tbPoints[iRandom], tbAngles[iRandom]
		end
	end
	
	return vPos, angSpawn
end 

--[==[----------------------------------------------------------------------------------
                     Selects location for the player to spawn
------------------------------------------------------------------------------------]==]
function GM:SelectSpawn ( pl, SpawnTable, Team )
	if SpawnTable == nil then return end
	if not pl:IsPlayer() then return end
	
	--  select only the team in the args
	if pl:Team() ~= Team then return end
	
	-- Table with position, angles
	local tbPoints, tbAngles = {}, {}
	if pl:IsZombie() then
		tbPoints, tbAngles = GAMEMODE.ZombiePositions, GAMEMODE.ZombieAngles
	else
		tbPoints, tbAngles = GAMEMODE.HumanPositions, GAMEMODE.HumanAngles
	end
	
	-- don't compute for spectators - random spot or center of map
	if pl:Team() == TEAM_SPECTATOR then
		pl:SetPos(table.Random(tbPoints) or Vector( 0,0,0 ))
		return
	end
	
	-- There are no spawnpoints
	local Count = #tbPoints
	if Count == 0 then return end
	
	-- Retry counter
	if pl.SpawnRetryCounter == nil then pl.SpawnRetryCounter = 0 end
	
	-- Get spawnpoints
	local vSpawn, aAngle = table.Random ( tbPoints ), table.Random ( tbAngles )
	-- if pl:IsZombie() then vSpawn, aAngle = GAMEMODE:ProcessZombieSpawn( pl, tbPoints, tbAngles ) else vSpawn, aAngle = GAMEMODE:ProcessHumanSpawn( pl, tbPoints, tbAngles ) end
	if not pl:IsZombie() then vSpawn, aAngle = GAMEMODE:ProcessHumanSpawn( pl, tbPoints, tbAngles ) end
	
	-- Zombies use positions while human use entities
	if type ( vSpawn ) == "Vector" then pl:SetPos ( vSpawn ) pl:SetAngles ( aAngle or Angle ( 0,0,0 ) ) end
	
	-- Spawnpoint found!
	Debug ( "[SPAWN] Spawnpoint found for "..tostring ( pl:Name() ).." after "..tostring ( pl.SpawnRetryCounter ).." retries. Spawn point is "..tostring ( vSpawn ).."." )
	pl.SpawnRetryCounter = 0
end



local playermins = Vector(-17, -17, 0)
local playermaxs = Vector(17, 17, 4)
local LastSpawnPoints = {}

function GM:PlayerSelectSpawn(pl)
	local teamid = pl:Team()
	local tab = {}
	
	--Undead spawn
	if teamid == TEAM_UNDEAD then
		local dyn = pl.ForceDynamicSpawn
		if dyn then
			pl.ForceDynamicSpawn = nil
			if self:DynamicSpawnIsValid(dyn) then
				return dyn
			end
			--local epicenter = dyn:GetPos()
		end

		--Use Dynamic spawns when available
		local DynamicSpawns = self:GetDynamicSpawns(pl)
		if #DynamicSpawns > 0 then
			table.Add(tab, DynamicSpawns)
		else
			tab = table.Copy(team.GetSpawnPoint(TEAM_UNDEAD))
		end
	--Human spawn
	else
		tab = team.GetSpawnPoint(teamid)
	end

	local result = tab and #tab > 0 and tab[math.random(1, #tab)] or pl
	
	-- print("Result "..tostring(result))
	-- PrintTable(tab)
	--return LastSpawnPoints[teamid] or #tab > 0 and tab[math.random(1, #tab)] or pl
	return result
end


Debug ( "[MODULE] Loaded Player-Spawn File." )