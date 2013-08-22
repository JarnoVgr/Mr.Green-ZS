-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
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

-- Include all files inside this folder
for k, sFile in pairs ( file.Find( "zombiesurvival/gamemode/server/doredeem/*.lua","lsv" ) ) do
	if not string.find( sFile, "main" ) then include( sFile ) end
end


function GM:ProceedRedeemSpawn(pl)

	if not IsValid(pl) then return end
	if pl:IsZombie() then return end
	
	local newspawn = self:GetNiceHumanSpawn(pl)
	
	if not util.tobool(pl:GetInfoNum("_zs_humanspawnrdm",0)) then return end
	
	if newspawn then
		pl:SetPos(newspawn:GetPos())
	end
	
end
util.AddNetworkString( "PlayerRedeemed" )
-- Redeem code goes here
local PlayersRedeemed = {}
function GM:OnPlayerRedeem( pl, causer )

	--Redeem effect
	local effectdata = EffectData()
	effectdata:SetOrigin( pl:GetPos() )
	util.Effect( "redeem", effectdata )

	--Send status to everybody
	net.Start("PlayerRedeemed")
		net.WriteEntity(pl)
	net.Broadcast()
	
	--
	pl:RemoveAllStatus(true,true)
	
	--Check if it wasn't an admin redeem
	if not IsValid(causer) then
		for k,v in pairs( player.GetAll() ) do
			v:ChatPrint( pl:Name().." redeemed" )
		end
	
		pl.Redeems = pl.Redeems + 1
		
		if not pl:IsBot() then
			pl:AddScore( "redeems",1 )
			pl:UnlockAchievement( "payback" )
			if pl.Redeems >= 3 then
				pl:UnlockAchievement( "dealwiththedevil" )
			end
			if pl:GetScore("redeems") >= 100 then
				pl:UnlockAchievement( "stuckinpurgatory" )
			end
		end
	end
	
	-- Clear poison in aura status
	pl.IsInAura = false
	
	-- Resets last damage table
	pl:ClearLastDamage()
	
	-- Clear assist 
	pl.AttackerAssistant, pl.Shooters = nil, nil
	
	-- Redeem time
	pl.LastRedeemTime = CurTime()

	-- Reset the human's weapon counter to 0, for all categories
	-- pl.CurrentWeapons = { Automatic = 0, Pistol = 0, Melee = 0, Tools = 0, Others = 0, Explosive = 0, Admin = 0 }
	pl.CurrentWeapons = { Automatic = 0, Pistol = 0, Melee = 0, Tool1 = 0, Tool2 = 0, Misc = 0, Admin = 0 }
	-- Reset check time for ammo regen
	pl.ServerCheckTime = nil
	pl:SetHumanClass ( 1 )
	pl:StripWeapons()
	pl:SetTeam(TEAM_HUMAN)
	pl.FreshRedeem = true
	
	table.insert(PlayersRedeemed, pl)
	if #PlayersRedeemed == 0 then
		for k,pl in pairs (PlayersRedeemed) do
			if k == 1 then
				pl.FirstRedeem = true
			end
		end
	end
	
	pl.Redeemed = true
	pl:Spawn()
	pl.Redeemed = nil
	
	pl:DrawViewModel( true )
	pl:SetFrags(0)
	
	if pl:GetPerk("_comeback") then
		if not pl._ComebackUsed then
			if pl:GetPistol() then
				pl:StripWeapon(pl:GetPistol():GetClass())
			end
			local wep = table.Random({"weapon_zs_classic","weapon_zs_fiveseven"})
			pl:Give(wep)
			pl:SelectWeapon(wep)
			pl._ComebackUsed = true
		end
	end
	
	pl.DeathClass = nil
	pl.LastAttacker = nil
	pl:SetZombieClass (0)
	pl.RecBrain = 0
	pl.BrainDamage = 0
	
	-- if the map has info_player_redeem then spawn him there
	local RedeemPoints = ents.FindByClass("info_player_redeem")
	if #RedeemPoints > 1 then 
		for k,v in pairs(RedeemPoints) do
			if ValidEntity(v) then
				pl:SetPos(v:GetPos())
			end
		end
	end
	
	--Give SP for redeeming
	if CurTime() > WARMUPTIME then
		skillpoints.AddSkillPoints(pl,math.Round(1100*GetInfliction()))
	end
	
	--Process
	self:ProceedRedeemSpawn(pl)
	
	--Output
	Debug("[REDEEM] ".. tostring(pl) .." redeemed")
end