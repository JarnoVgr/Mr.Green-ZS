-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Global vars 
GM.UndeadSpawnPoints = {}
GM.HumanSpawnPoints = {}
DataTableConnected = {}

--[==[--------------------------------------------------------------
      Called everytime a player connects for first time
---------------------------------------------------------------]==]
function GM:PlayerInitialSpawn( pl )

	pl:SetCanZoom( false )

	-- Bots are always ready, human players need to wait
	if pl:IsBot() then pl.Ready = true else pl.Ready = false end
	
	pl:SetZombieClass(0)
	pl:SetHumanClass(1)
	
	-- Substract one point from the most chosen class table to compensate for the setzombie/human class above
	local HumanClassName, ZombieClassName = HumanClasses[1].Name, ZombieClasses[1].Name
	self.TeamMostChosenClass[ HumanClassName ] = self.TeamMostChosenClass[ HumanClassName ] - 1 
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
	
	for k,v in pairs (self.SkillShopAmmo) do
		pl.AmmoMultiplier[k] = pl.AmmoMultiplier[k] or 1
	end
	
	pl.LastRTD = 0 
	pl.StuckTimer = 0
	
	pl:SetCustomCollisionCheck(true)
	-- pl:SetNoCollideWithTeammates(true)
	-- pl:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		
	-- Used to control how many weapons you are allowed to pickup
	-- pl.CurrentWeapons = { Automatic = 0, Pistol = 0, Melee = 0, Tools = 0, Others = 0, Explosive = 0, Admin = 0 }
	pl.CurrentWeapons = { Automatic = 0, Pistol = 0, Melee = 0, Tool1 = 0, Tool2 = 0, Misc = 0, Admin = 0 }
	
	pl.AutoRedeem = util.tobool(pl:GetInfoNum("_zs_autoredeem",1)) or true
	pl.IsFreeman = false
	
	local balance = team.NumPlayers (TEAM_HUMAN) / team.NumPlayers (TEAM_UNDEAD)
	local ID = pl:UniqueID() or "UNCONNECTED"
	
	-- Team
	local iTeam = TEAM_SPECTATOR
	
	if pl:IsBot() then
		iTeam = TEAM_HUMAN
	end

	-- Send toxic fumes positions to client since I can't seem to get the spawnpoints clientside
	timer.Simple(2, function()
		SentToxicFumesPosition(pl)
	end)
	
	-- Setup a table for connected players for good reasons
	if not DataTableConnected[ID] then
		DataTableConnected[ID] = { IsDead = false, SuicideSickness = false, Health = false, HumanClass = false, AlreadyGotWeapons = false } 
	end
	
	-- Case 3: If player has connected as human and passed the class menu then reconnected then set him as human again with same class and health
	if pl:ConnectedAlreadyGotWeapons() and not pl:ConnectedIsDead() then
		iTeam = TEAM_HUMAN
	end

	--Case 1: If the player disconnected while being in a team, it will correctly set him to the proper team.
	--[[if pl:ConnectedIsDead() then
		iTeam = TEAM_UNDEAD
	end]]

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

	Debug ( "[INIT-SPAWN] "..tostring ( pl ).." finished Initial Spawn Function!" ) 
end

--[==[-----------------------------------------------------------------
     Mainly for debug purposes -- record everything in logs
------------------------------------------------------------------]==]
local function PlayerConnected ( pl, ip )
	Debug ( "[CONNECTED] Player "..tostring ( pl ).." Connected. IP is "..tostring ( ip ) )
end
hook.Add ( "PlayerConnect", "Connected", PlayerConnected )

--[==[------------------------------------------------
     Main spawn function - called on spawn
-------------------------------------------------]==]
function GM:PlayerSpawn(pl)
	-- Player must receive data from server before he can spawn
	if not pl.Ready then
		pl:KillSilent()
		Debug("[SPAWN] "..tostring ( pl ).." is not Ready. Blocking spawn and killing him silently. Alive: "..tostring(pl:Alive()))
		return
	end

	--Predicting spawn, don't erase
	pl:SetDeaths(PREDICT_SPAWN)
	

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
			pl.PlayerModel = table.Random(PlayerModels)
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

		--Check if we can be THE Gordon Freeman
		if pl:Team() ~= TEAM_SPECTATOR and ((not self.IsSantaHere and math.random(1,7) == 1 and pl:Team() == TEAM_SURVIVORS) or pl.IsSanta) and not pl.IsFreeman then
			--Only display message when being human
			if pl:Team() == TEAM_SURVIVORS then
				pl:ChatPrint("You're now THE Santa Claus!")
			end

			--Set global
			self.IsSantaHere = true
			
			--Set model for player
			pl.IsSanta = true
			pl.PlayerModel = "santa"
		end
	end
	
	Debug("[PLAYER MODEL] ".. tostring(pl:Name()) .." test: ".. pl.PlayerModel .."")
		
	if pl:Team() == TEAM_SPECTATOR then
		self:OnFirstHumanSpawn(pl)
		return
	end
	
	-- Return his original color to normal
	if not FIRSTAPRIL then
		pl:SetColor(Color(255,255,255,255))
	else
		umsg.Start("MakeBody")
		umsg.End()
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

	--pl:SendLua("GAMEMODE:SwitchMaterials("..pl:Team()..")")
		
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
	
	--Reset the Ammo-Regeneration Timer and send it to the client
	pl:SetAmmoTime(AMMO_REGENERATE_RATE, true)
		
	-- Change his player model and set up his voice set
	pl:SetModel(player_manager.TranslatePlayerModel(pl.PlayerModel))
	pl.VoiceSet = VoiceSetTranslate[ string.lower(player_manager.TranslatePlayerModel(pl.PlayerModel)) ] or "male"
	
	pl.SelectedSuit = pl:GetInfo("_zs_defaultsuit") or "none"
	pl.SelectedHat = pl:GetInfo("_zs_equippedhats") or "none"
	--[[pl.SelectedSuit = "none"
	pl.SelectedHat = "none"]]
	
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
	
	--Reapply loadout to prevent spawn bug
	--Disabled because it allows a weapon exploit at spawn (dropping all weapons quick and then getting them again)
	--[[timer.Simple(2,function()
		if ValidEntity(pl) then
			if #pl:GetWeapons() < 1 then
				CalculatePlayerLoadout(pl)
			end
		end
	end)]]
	
	self:SendSalesToClient(pl)
	
	-- GAMEMODE:SendRanks( { pl },player.GetAll() )
	-- GAMEMODE:SendXP( { pl },player.GetAll() )
	
	--Blood color
	pl:SetBloodColor(BLOOD_COLOR_RED)

	--Delay use of Supply Crate
	pl.NextSupplyUse = WARMUPTIME+60
	pl:SendLua("MySelf.NextSupplyTime = ".. pl.NextSupplyUse) --Uses ServerTime clientside

	--
	self:ProceedCustomSpawn(pl)

	--Set hat and suit
	if (pl.SelectedHat ~= "none") or pl:IsBot() then
		self:SpawnHat(pl, pl.SelectedHat)
	end
	if (pl.SelectedSuit ~= "none") or pl:IsBot() then
		self:SpawnSuit(pl, pl.SelectedSuit)
	end

	--Hands test
	local oldhands = pl:GetHands()
	if ( IsValid( oldhands ) ) then
		oldhands:Remove()
	end

	local hands = ents.Create( "zs_hands" )
	if ( IsValid( hands ) ) then
		hands:DoSetup( pl )
		hands:Spawn()
	end	
	
	--Log
	Debug("[SPAWN] ".. tostring(pl:Name()) .." spawned as human")
end

--[==[------------------------------------------------
	Called everytime a zombie spawns
-------------------------------------------------]==]
function GM:OnZombieSpawn(pl)
	if pl:Team() ~= TEAM_UNDEAD then
		return
	end
	
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
	
	if pl.SpawnAsCrow then
		pl:SetZombieClass(9)
		pl.DeathClass = 0
		pl.SpawnAsCrow = false
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

	-- pl:CalculateViewOffsets()
	pl:DoHulls(Class, TEAM_UNDEAD)
	
	--Attach crabs to zombos
	--pl:SetHeadcrabBodyGroup()
	
	--Set the zombies model
	pl:SetModel(Tab.Model)
	
	--
	if not pl.Loadout then
		pl.Loadout = {}
	end
	
	--Fix late spawners
	if #pl.Loadout <=1 then
		timer.Simple(1,function()
			if ValidEntity(pl) then
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
	
	local col = pl:GetInfo( "cl_playercolor" )
	pl:SetPlayerColor(Vector(col))

	pl:SetWeaponColor(Vector(col))

	if Tab.OnSpawn then
		Tab.OnSpawn(pl)
	end
		
	-- Set the zombie's walk and crouch speed
	self:SetPlayerSpeed(pl, Tab.Speed)
	pl:SetCrouchedWalkSpeed(Tab.CrouchWalkSpeed or 0.80)

	--Check for spawnprotection
		
	pl:UnSpectate()		
	-- Prevent health pickups and/or machines
	pl:SetMaxHealth(1) 
	
	--pl:SetBloodColor(BLOOD_COLOR_YELLOW)
	pl:SetBloodColor(BLOOD_COLOR_RED)

	--Alert players they can change zombie class
	--TODO: Alert once
	if not pl:IsCrow() and Class == 0 and math.random(1,3) == 1 then
		pl:Message("Press F3 to play with a different Undead specie", 3)
	end

	Debug ( "[SPAWN] "..tostring ( pl:Name() ).." spawned as a Zombie." )
end

-- Human's dynamic spawn

function GM:ProceedCustomSpawn(pl)

	if not IsValid(pl) then return end
	if pl:IsZombie() then return end
	if pl.Redeemed then return end
	
	local newspawn = self:GetNiceHumanSpawn(pl)
	
	if not util.tobool(pl:GetInfoNum("_zs_humanspawn",0)) then return end
	if self:IsRetroMode() then return end
	
	if newspawn then
		pl:SetPos(newspawn:GetPos())
	end
	
end



--[==[------------------------------------------------
	    Called on player disconnect
-------------------------------------------------]==]
function GM:PlayerDisconnected( pl )
	if not ValidEntity(pl) then
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
	
	--Case 1: Disconnect as human
	if pl:Team() == TEAM_HUMAN then 
		DataTableConnected[ID] = { HasBoughtPointsWithCoins = DataTableConnected[ID].HasBoughtPointsWithCoins, IsDead = true, SuicideSickness = false, 
		    HumanClass = pl:GetHumanClass(), Health = pl:Health(), AlreadyGotWeapons = false }
	--Case 2: Disconnect as zombie
	elseif pl:Team() == TEAM_UNDEAD then
		DataTableConnected[ID] = { HasBoughtPointsWithCoins = DataTableConnected[ID].HasBoughtPointsWithCoins, IsDead = true, 
		    SuicideSickness = false, HumanClass = pl:GetHumanClass(), Health = pl:Health(), AlreadyGotWeapons = false }
		
		if pl.Suicided then
			DataTableConnected[ID].SuicideSickness = true
		end
	end
	
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
	
	-- Case 1: Medic
	if Class == 1 then
		Speed = HumanClasses[Class].Speed + ( HumanClasses[Class].Speed * (HumanClasses[1].Coef[3] * (pl:GetTableScore ("medic","level") + 1 ) ) / 100 )
	end
	
	-- Case 2: Berserker
	if Class == 2 then
		--Speed = HumanClasses[Class].Speed + ( HumanClasses[Class].Speed * (HumanClasses[3].Coef[2] * (pl:GetTableScore ("berserker","level") + 1 ) ) / 100 )
	end
	
	-- Case 3: Without bonus
	if ( Class ~= 1 ) or pl:IsBot() then
		Speed = HumanClasses[Class].Speed
	end
	
	Speed = 200
	
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
	
	local Class = pl:GetZombieClass()
	local Tab = ZombieClasses[Class]
	local MaxHealth = 0
	
	-- Case 1: Normal case
	MaxHealth = math.Clamp(Tab.Health, 0, Tab.Health)
	
	local allplayers = player.GetAll()
	local numplayers = #allplayers
	
	-- Case 2: if there are only 2 zombies double their HP
	local desiredzombies = math.max(1, math.ceil(numplayers * UNDEAD_START_AMOUNT_PERCENTAGE))
	if not pl:IsBossZombie() and not pl:IsCrow() then
		if (team.NumPlayers(TEAM_UNDEAD) <= (desiredzombies+1) and team.NumPlayers(TEAM_HUMAN) >= 4) then
			local IncreaseHealth = Tab.Health*(UNDEAD_START_AMOUNT_PERCENTAGE)*desiredzombies+10*(team.NumPlayers(TEAM_HUMAN))
			MaxHealth = math.Clamp(Tab.Health + IncreaseHealth , Tab.Health, math.min(Tab.Health*1.9,510) )
			pl:RemoveStatus("champion")
		end
	end
		
	if pl:GetZombieClass() == 0 then
		if GAMEMODE:IsRetroMode() then
			MaxHealth = math.Clamp(MaxHealth, 100, 125 )
		else
			MaxHealth = math.Clamp(Tab.Health, 0, Tab.Health)
		end
	else
		if GAMEMODE:IsRetroMode() then
			MaxHealth = math.Clamp(Tab.Health, 0, Tab.Health)
		end
	end
	
	--Case 4: Boss zombos
	if pl:IsBossZombie() then
	   local humanCount = team.NumPlayers(TEAM_SURVIVORS)
	   local zombieCount = team.NumPlayers(TEAM_UNDEAD)
	   
	   MaxHealth = (humanCount * 1400) * math.Clamp( humanCount / zombieCount, 0.5, 1.5)
	end

	--Set
	pl:SetMaximumHealth(math.Round(MaxHealth))
	pl:SetHealth(MaxHealth)
end


function CalculatePlayerHealth ( pl )
	if pl:Team() ~= TEAM_HUMAN then return end

	local Class = pl:GetHumanClass()
	local ClassHealth = HumanClasses[Class].Health
	local MaxHealth, Health = 100, 100
	
	-- Case 1: Commando
	if Class == 2 then
	-- 	MaxHealth = ClassHealth + ( ClassHealth * ( ( HumanClasses[2].Coef[2] * ( pl:GetTableScore ("commando","level") + 1 ) ) / 100 ) )
	-- 	Health = MaxHealth
	end
	
	-- Case 2: Without bonus or bot
	if Class ~= 2 or pl:IsBot() then
	-- 	MaxHealth = ClassHealth
	-- 	Health = MaxHealth
	end
	
	-- Case 3: If player got hurt and reconnected as human
	if pl:ConnectedHealth() ~= false then
		Health = pl:ConnectedHealth()
		DataTableConnected[ pl:UniqueID() or "UNCONNECTED" ].Health = false
	end
	
	if pl:GetPerk("_kevlar") then
		MaxHealth, Health = 110, 110
	end
	
	if pl:GetPerk("_kevlar2") then
		MaxHealth, Health = 120, 120
	end
	
	-- Actually set the health
	pl:SetHealth ( Health )
	pl:SetMaximumHealth ( MaxHealth )
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

--[==[------------------------------------------------
    Send toxic fumes positions to the client
-------------------------------------------------]==]
function SentToxicFumesPosition ( pl )
	if not ValidEntity ( pl ) then return end
	
	-- Don't set up the toxic fumes
	if not TOXIC_SPAWN then return end
	
	-- Get the zombie spawn points (or toxic points)
	local SpawnPoints = ToxicPoints
	
	-- Replace it in order
	table.Resequence ( SpawnPoints )
			
	-- We are done here
	if #SpawnPoints == 0 then return end
	
	-- Split the usermessage in 2 parts
	local MaximumPoints = SpawnPoints
	local Split = 3
	if #MaximumPoints <= 3 then
		Split = 1
	end
	
	-- Send the parts
	local Start, End = 1, math.Round( #MaximumPoints / Split )
	local Max = End
	if End == 1 and #MaximumPoints > 1 then
		End = End + 1 
	end
	
	---
	-- TODO: Use net messages (without split)
	-- 
	for i = 1, Split do
		umsg.Start( "ReceiveToxicPositions", pl )
			umsg.Short ( Start )
			umsg.Short ( End )
			for j = Start, End do
				umsg.Vector ( MaximumPoints[j]:GetPos() ) 
			end
		umsg.End()
			
		Start = End + 1
		if Start > #MaximumPoints then break end
		if i == Split - 1 then End = #MaximumPoints else End = Start + Max end
	end
	
	Debug ( "[SPAWN] Succesfully sent toxic fumes positions to player - "..tostring ( pl ) )
end

util.AddNetworkString("OnReadySQL")

hook.Add("OnPlayerReadySQL", "UpdateDataTableJoin", function( pl )
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
	
	Debug("[SPAWN] "..tostring(pl).." is Ready. Spawning him.")
	
	--Spawn the player
	if not ENDROUND then 
		pl:Spawn() 
	end
end)

--When localplayer is valid on clientside
function GM:PlayerReady(pl)
	pl.IsClientValid = true
end

--[==[------------------------------------------------------
             Adds spawn points for players 
-------------------------------------------------------]==]
local function SetSpawnPoints()

	-- some other spawn points
	local SpawnTable = { 
		Human = { "info_player_combine", "info_player_terrorist" }, 
		Zombie = { "info_player_rebel", "info_player_counterterrorist", "info_player_undead" }
	}
	
	-- Default spawn angle
	local angSpawn = Angle ( 0,0,0 )
	
	-- default gamemode spawn points
	GAMEMODE.UndeadSpawnPoints = ents.FindByClass("info_player_zombie")
	GAMEMODE.HumanSpawnPoints = ents.FindByClass("info_player_human")
	
	-- Add all the old ZS spawns.
	for _, spawn in pairs(ents.FindByClass("gmod_player_start")) do
		if spawn.BlueTeam then
			table.insert(GAMEMODE.HumanSpawnPoints, spawn)
		else
			table.insert(GAMEMODE.UndeadSpawnPoints, spawn)
		end
	end
	
	-- add human and undead spawns to the table
	for k, v in pairs ( SpawnTable ) do
		if k == "Human" then
			for i = 1, #k do
				table.Add ( GAMEMODE.HumanSpawnPoints, ents.FindByClass( tostring ( v[i] ) ) )
			end
		end
		
		if k == "Zombie" then
			for i = 1, #k do
				table.Add ( GAMEMODE.UndeadSpawnPoints, ents.FindByClass( tostring ( v[i] ) ) )
			end
		end
	end
	
	--If there aren't any of above, add the original ones
	if #GAMEMODE.HumanSpawnPoints <= 0 then
		GAMEMODE.HumanSpawnPoints = ents.FindByClass("info_player_start")
	end
	
	--If there aren't any of above, add the original ones
	if #GAMEMODE.UndeadSpawnPoints <= 0 then
		GAMEMODE.UndeadSpawnPoints = ents.FindByClass("info_player_start")
	end
	
	--Add angles to spawn
	for k,v in pairs ( GAMEMODE.HumanSpawnPoints ) do
		local vPos = v if IsEntityValid(v) then vPos = v:GetPos() end
		GAMEMODE.HumanSpawnPoints[k] = { vPos, angSpawn }
	end		
	
	--Add angles to spawn
	for k,v in pairs ( GAMEMODE.UndeadSpawnPoints ) do	
		local vPos = v if IsEntityValid(v) then vPos = v:GetPos() end
		GAMEMODE.UndeadSpawnPoints[k] = { vPos, angSpawn }
	end
	
	--??
	if OBJECTIVE and Objectives[1].ZombieSpawns then 
		GAMEMODE.UndeadSpawnPoints = {}
		print("Cleared spawns")
		Objectives[1].ZombieSpawns()
		print("Loaded new")
		
		for k,v in pairs ( SpawnPoints ) do
			GAMEMODE.UndeadSpawnPoints[k] = { [1] = v[1], [2] = v[2] }
		end
		print("Done")
		Objectives[1].VerifiedSpawns = true
	end
	
	--Resequence normal table
	if SpawnPoints then
		for k,v in pairs ( SpawnPoints ) do
			GAMEMODE.UndeadSpawnPoints[k] = { [1] = v[1], [2] = v[2] }
		end
	end
	
	--Position and angles table for humans
	GAMEMODE.HumanPositions, GAMEMODE.HumanAngles = {}, {}
	for k,v in pairs ( GAMEMODE.HumanSpawnPoints ) do GAMEMODE.HumanPositions[k] = GAMEMODE.HumanSpawnPoints[k][1] GAMEMODE.HumanAngles[k] = GAMEMODE.HumanSpawnPoints[k][2] end
	
	--Position and angles table for zombos
	GAMEMODE.ZombiePositions, GAMEMODE.ZombieAngles = {}, {}
	for k,v in pairs ( GAMEMODE.UndeadSpawnPoints ) do GAMEMODE.ZombiePositions[k] = GAMEMODE.UndeadSpawnPoints[k][1] GAMEMODE.ZombieAngles[k] = GAMEMODE.UndeadSpawnPoints[k][2] end
		
	-- readd gasses
	
	for _, spawn in pairs(GAMEMODE.UndeadSpawnPoints) do
			local gasses = ents.FindByClass("zombiegasses")
			local numgasses = #gasses
			if 4 < numgasses then
				break
			elseif math.random(1, 4) == 1 or numgasses < 1 then
				local spawnpos = spawn[1]-- spawn:GetPos()
				local nearhum = false
				for _, humspawn in pairs(GAMEMODE.HumanSpawnPoints) do
					if humspawn[1]:Distance(spawnpos) < 272 then
						nearhum = true
						break
					end
				end
				if not nearhum then
					for _, humspawn in pairs(gasses) do
						if humspawn:GetPos():Distance(spawnpos) < 128 then
							nearhum = true
							break
						end
					end
				end
				if not nearhum then
					local ent = ents.Create("zombiegasses")
					if ent:IsValid() then
						ent:SetPos(spawnpos)
						ent:Spawn()
					end
				end
			end
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

	if string.find(mapname, "_obj_", 1, true) or string.find(mapname, "objective", 1, true) then
	-- 	self:SetDynamicSpawning(false)
	end

	-- Add all the old ZS spawns from GMod9.
	for _, oldspawn in pairs(ents.FindByClass("gmod_player_start")) do
		if oldspawn.BlueTeam then
			table.insert(htab, oldspawn)
		else
			table.insert(ztab, oldspawn)
		end
	end

	-- You shouldn't play a DM map since spawns are shared but whatever. Let's make sure that there aren't team spawns first.
	if #htab == 0 then
		htab = ents.FindByClass("info_player_start")
		htab = table.Add(htab, ents.FindByClass("info_player_deathmatch")) -- Zombie Master
	end
	if #ztab == 0 then
		ztab = ents.FindByClass("info_player_start")
		ztab = table.Add(ztab, ents.FindByClass("info_zombiespawn")) -- Zombie Master
	end
	-- print("Prepare")
	team.SetSpawnPoint(TEAM_ZOMBIE, ztab)
	-- PrintTable(team.GetSpawnPoint(TEAM_ZOMBIE))
	team.SetSpawnPoint(TEAM_HUMAN, htab)
	-- PrintTable(team.GetSpawnPoint(TEAM_HUMAN))
	team.SetSpawnPoint(TEAM_SPECTATOR, htab)
	
end

-- hook.Add ( "InitPostEntity", "SetupSpawnPoints", SetupSpawnPoints )

function GM:SetRetroMode(mode)
	self.RetroMode = mode
	SetGlobalBool("retromode", self.RetroMode)
end

function GM:IsRetroMode()
	return self.RetroMode
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
	if pl:Team() == TEAM_HUMAN then Filter = team.GetPlayers ( TEAM_HUMAN ) else Filter = team.GetPlayers ( TEAM_UNDEAD ) end
	
	-- Hull trace spawnpoints
	for i = 1, #tbPoints do
		if i < 5 then
		
			-- Stuck bool
			-- local bStuck = IsStuck ( vPos, HULL_PLAYER[1], HULL_PLAYER[2], Filter )
			
			-- Point is clear
			if not bStuck then return vPos, angSpawn end
				
			-- Point is not clear
			if bStuck then pl.SpawnRetryCounter = pl.SpawnRetryCounter + 1 local iRandom = math.random ( 1,#tbPoints ) vPos, angSpawn = tbPoints[iRandom], tbAngles[iRandom] end
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

		-- Stuck bool
		bStuck, bIsVisible = IsStuck ( vPos, HULL_PLAYER[1], HULL_PLAYER[2], Filter ), VisibleToHumans ( vPos, pl )
			
		-- Point is clear
		if not bStuck then if not bIsVisible then return vPos, angSpawn end end
				
		-- Point is not clear
		if bStuck or bIsVisible then pl.SpawnRetryCounter = pl.SpawnRetryCounter + 1 local iRandom = math.random ( 1,#tbPoints ) vPos, angSpawn = tbPoints[iRandom], tbAngles[iRandom] end
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
	if pl:IsZombie() then tbPoints, tbAngles = GAMEMODE.ZombiePositions, GAMEMODE.ZombieAngles else tbPoints, tbAngles = GAMEMODE.HumanPositions, GAMEMODE.HumanAngles end
	
	-- don't compute for spectators - random spot or center of map
	if pl:Team() == TEAM_SPECTATOR then pl:SetPos ( table.Random ( tbPoints ) or Vector ( 0,0,0 ) ) return end
	
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

--[==[------------------------------------------------------
      Returns the correct spawnpoint for the plr
-------------------------------------------------------]==]
local function DoSelectSpawn ( pl )
	if not ValidEntity ( pl ) then return end
	
	-- we can't do this right now
	if not pl.Ready then return end
	
	-- sort out the tables
	local SpawnTable = {}
	if pl:Team() == TEAM_UNDEAD then SpawnTable = GAMEMODE.UndeadSpawnPoints else SpawnTable = GAMEMODE.HumanSpawnPoints end
	
	-- debug - ignore this
	Debug ( "[SELECT-SPAWN] Trying to select spawn for "..tostring ( pl ) )
	
	-- return the proper spawn point
	if not pl:IsZombie() then
		GAMEMODE:SelectSpawn ( pl, SpawnTable, pl:Team() )
	end
	
	--------------------------------------
	
	local spawninplayer = false
	local tab = {}
	local epicenter
	
	
	if pl:IsZombie() then -- If we're a bit in the wave then we can spawn on top of heavily dense groups with no humans looking at us.
		local dyn = pl.ForceDynamicSpawn
		if dyn then
			pl.ForceDynamicSpawn = nil
			if GAMEMODE:DynamicSpawnIsValid(dyn) then
				return dyn
			else
				epicenter = dyn:GetPos() -- Ok, at least skew our epicenter to what they tried to spawn at.
				tab = table.Copy(team.GetSpawnPoint(TEAM_UNDEAD))
				local dynamicspawns = GAMEMODE:GetDynamicSpawns(pl)
				if #dynamicspawns > 0 then
					spawninplayer = true
					table.Add(tab, dynamicspawns)
				end
			end
		else
			tab = table.Copy(team.GetSpawnPoint(TEAM_UNDEAD))
			local dynamicspawns = GAMEMODE:GetDynamicSpawns(pl)
			if #dynamicspawns > 0 then
				spawninplayer = true
				table.Add(tab, dynamicspawns)
			end
		end
	end
	-------------------------------------
	return #tab > 0 and tab[math.random(1, #tab)] or pl --pl
end
-- hook.Add ( "PlayerSelectSpawn", "DoSelectSpawn", DoSelectSpawn )


local playermins = Vector(-17, -17, 0)
local playermaxs = Vector(17, 17, 4)
local LastSpawnPoints = {}

function GM:PlayerSelectSpawn(pl)
	local spawninplayer = false
	local teamid = pl:Team()
	local tab = {}
	local epicenter
	-- print("Prepared")
	if teamid == TEAM_UNDEAD then-- If we're a bit in the wave then we can spawn on top of heavily dense groups with no humans looking at us.
		-- print("Undead")
		local dyn = pl.ForceDynamicSpawn
		if dyn then
			-- print("GotDynSpawn")
			pl.ForceDynamicSpawn = nil
			if self:DynamicSpawnIsValid(dyn) then
				-- print("Return zombie")
				return dyn
			else
				
				epicenter = dyn:GetPos() -- Ok, at least skew our epicenter to what they tried to spawn at.
				tab = table.Copy(team.GetSpawnPoint(TEAM_UNDEAD))
				-- print("ZombieSpawns:-------")
				-- PrintTable(tab)
				local dynamicspawns = self:GetDynamicSpawns(pl)
				-- print("DynamicZombieSpawns:-------")
				-- PrintTable(dynamicspawns)
				-- print("-------")
				if #dynamicspawns > 0 then
					spawninplayer = true
					table.Add(tab, dynamicspawns)
				end
			end
		else
			-- print("NoDynSpawn")
			tab = table.Copy(team.GetSpawnPoint(TEAM_UNDEAD))
			-- print("ZombieSpawns_NoTarget:-------")
			-- PrintTable(tab)
			local dynamicspawns = self:GetDynamicSpawns(pl)
			-- print("DynamicZombieSpawns_NoTarget:-------")
			-- PrintTable(dynamicspawns)
			-- print("-------")
			if #dynamicspawns > 0 then
				spawninplayer = true
				table.Add(tab, dynamicspawns)
			end
		end
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