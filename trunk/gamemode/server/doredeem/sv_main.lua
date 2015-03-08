-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--Include all files inside this folder
for k, sFile in pairs(file.Find("zombiesurvival/gamemode/server/doredeem/*.lua","lsv")) do
	if not string.find(sFile, "main") then
		include(sFile)
	end
end

function GM:ProceedRedeemSpawn(pl)
	if not IsValid(pl) or pl:IsZombie() then
		return
	end
	
	local NewSpawn = self:GetNiceHumanSpawn(pl)

	if NewSpawn then
		pl:SetPos(NewSpawn:GetPos())
	end
end
util.AddNetworkString( "PlayerRedeemed" )

-- Redeem code goes here
local PlayersRedeemed = {}
function GM:OnPlayerRedeem(pl, causer)
	--Redeem effect
	local effectdata = EffectData()
	effectdata:SetOrigin(pl:GetPos())
	util.Effect("redeem", effectdata)

	--Send status to everybody
	net.Start("PlayerRedeemed")
	net.WriteEntity(pl)
	net.Broadcast()
	
	--
	pl:RemoveAllStatus(true, true)
	
	--Check if it wasn't an admin redeem
	if not IsValid(causer) then
		local Text = pl:Name() .." redeemed"
		for _,v in pairs(player.GetAll()) do
			v:ChatPrint(Text)
		end
	
		pl.Redeems = pl.Redeems + 1
		
		if not pl:IsBot() then
			pl:AddToCounter("redeems", 1)
			pl:UnlockAchievement("payback")
			if pl.Redeems >= 3 then
				pl:UnlockAchievement("dealwiththedevil")
			end
			if pl:GetScore("redeems") >= 100 then
				pl:UnlockAchievement("stuckinpurgatory")
			end
		end
	end

	-- Resets last damage table
	pl:ClearLastDamage()
	
	--Clear assist 
	pl.AttackerAssistant, pl.Shooters = nil, nil
	
	--Redeem time
	pl.LastRedeemTime = CurTime()

	--Reset the human's weapon counter to 0, for all categories
	pl.CurrentWeapons = { Automatic = 0, Pistol = 0, Melee = 0, Tool1 = 0, Tool2 = 0, Misc = 0, Admin = 0 }
	-- Reset check time for ammo regen
	pl.ServerCheckTime = nil
	pl:SetHumanClass(1)
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
	
	pl:DrawViewModel(true)
	skillpoints.SetupSkillPoints(pl)
	
	--Comebacks
	if not pl._ComebackUsed then
		--Comeback primary weapon
		if pl:GetPerk("_comeback") then
			--Strip current automatic gun
			if pl:GetAutomatic() then
				pl:StripWeapon(pl:GetAutomatic():GetClass())
			end
				
			local wep = table.Random({"weapon_zs_aug","weapon_zs_m3super90","weapon_zs_famas","weapon_zs_sg552"})

			pl:Give(wep)
			pl:SelectWeapon(wep)
			pl._ComebackUsed = true
		end
		
		--Comeback pistol
		if pl:GetPerk("_comeback2") then
			--Strip current pistol
			if pl:GetPistol() then
				pl:StripWeapon(pl:GetPistol():GetClass())
			end
				
			local wep = table.Random({"weapon_zs_deagle","weapon_zs_elites"})
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
	
	--Give average SP
	local Humans = team.GetPlayers(TEAM_HUMAN)
	local TotalSkillPoints, ValidPlayers = 0, 0
	for i=1,#Humans do
		local target = Humans[i]
		if not IsValid(target) or not target:Alive() then
			continue
		end

		local Points = skillpoints.GetSkillPoints(target)
		if not Points or Points <= 0 then
			continue
		end

		TotalSkillPoints = TotalSkillPoints + Points
		ValidPlayers = ValidPlayers + 1
	end

	if ValidPlayers > 0 then
		local AverageSP = math.Round(TotalSkillPoints / ValidPlayers)
		if AverageSP > 0 then
			skillpoints.AddSkillPoints(pl, AverageSP)
		end
	end
	
	--Give SP for redeeming
	--[[if CurTime() > (WARMUPTIME+240) then
		skillpoints.AddSkillPoints(pl, math.max(20,math.Round(600*GetInfliction())))
	end]]
	
	--Process
	self:ProceedRedeemSpawn(pl)
	
	--Output
	Debug("[REDEEM] ".. tostring(pl) .." redeemed")
end