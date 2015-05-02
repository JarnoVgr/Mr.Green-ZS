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
		--Comeback pistol
		if pl:GetPerk("_comeback2") then
			--Strip current pistol
			if pl:GetPistol() then
				pl:StripWeapon(pl:GetPistol():GetClass())
			end
				
			local wep = table.Random({"weapon_zs_famas","weapon_zs_sg552"})
			pl:Give(wep)
			pl:SelectWeapon(wep)
			pl._ComebackUsed = true
		end
	end
	
		noclass = {"weapon_zs_usp","weapon_zs_melee_fryingpan"}
		
		--Medic Stages
		medicstage1 = {"weapon_zs_p228","weapon_zs_melee_combatknife","weapon_zs_medkit"}
		
		--Support stages
		support = {"weapon_zs_usp","weapon_zs_melee_combatknife","weapon_zs_tools_plank","weapon_zs_tools_hammer"}
		
		--Commando stages
		commando = {"weapon_zs_fiveseven","weapon_zs_melee_combatknife","weapon_zs_grenade"}
		
		--Engineer stages
		engineer = {"weapon_zs_pulsepistol","weapon_zs_turretplacer","weapon_zs_mine"}
		
		--Berserker stages
		berserker = {"weapon_zs_classic","weapon_zs_melee_plank","weapon_zs_special_vodka"}
		
		--Sharpshooter stages
		sharpshooter = {"weapon_zs_musket","weapon_zs_classic","weapon_zs_melee_fryingpan","weapon_zs_tools_supplies"}
	
	--{{ZS HUMAN CLASSES}}--
		if pl:Team() == TEAM_SURVIVORS then
			if pl:GetPerk("_medic") then
				pl:ChatPrint("You are a Medic")

				for k,v in pairs(medicstage1) do
					pl:Give(tostring(v))
				end
					if pl:GetPerk("_medigun") then --Medical gun perk
						pl:Give("weapon_zs_medigun")
					end
				end			
		end
		
		if pl:Team() == TEAM_SURVIVORS then
			if pl:GetPerk("_support2") then
				pl.Loadout = table.Copy(support)
				pl:ChatPrint("You are a Support class")
				for k,v in pairs(support) do
					pl:Give(tostring(v))
				end	
				--if pl:GetPerk("_supportweapon") then --Medical gun perk
					--	pl:Give("weapon_zs_chipper")
					--end
				
				end
		end		
		
		if pl:Team() == TEAM_SURVIVORS then		
			if pl:GetPerk("_engineer") then
				pl:ChatPrint("You are an Engineer")
				pl.Loadout = table.Copy(engineer)
				for k,v in pairs(engineer) do
					pl:Give(tostring(v))
				end
				if pl:GetPerk("_pulsesmg") then
					pl:Give("weapon_zs_pulsesmg")
				end
				if pl:GetPerk("_combat") then
					pl:SpawnMiniTurret()
				end
				
				if pl:GetPerk("_remote") then
					pl:Give("weapon_zs_tools_remote")
				end
				end
		end
		
		if pl:Team() == TEAM_SURVIVORS then		
			if pl:GetPerk("_commando") then
				pl:ChatPrint("You are a Commando")
				pl.Loadout = table.Copy(commando)
				for k,v in pairs(commando) do
					pl:Give(tostring(v))				
				end		
				--if pl:GetPerk("_arsanal") then --Medical gun perk
					--	pl:Give("weapon_zs_defender")
					--end		
				end
		end
		
		if pl:Team() == TEAM_SURVIVORS then		
			if pl:GetPerk("_berserker") then
				pl:ChatPrint("You are a Berserker")
				pl.Loadout = table.Copy(berserker)
				for k,v in pairs(berserker) do
					pl:Give(tostring(v))
				end
				if pl:GetPerk("_slinger") then
					pl:Give("weapon_zs_melee_hook")
				end
				end
		end
		
				if pl:Team() == TEAM_SURVIVORS then		
			if pl:GetPerk("_sharpshooter") then
				pl:ChatPrint("You are a SharpShooter")
				pl.Loadout = table.Copy(sharpshooter)
				for k,v in pairs(sharpshooter) do
					pl:Give(tostring(v))
				end
				if pl:GetPerk("_lethal") then
					pl:StripWeapon(pl:GetAutomatic():GetClass())
					pl:Give("weapon_zs_scout")
					end
				end
		end
		
		for k,v in pairs(commando) do --If you don't have a class selected give them this... The commando <3
					pl:Give(tostring(v))
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

	--Process
	self:ProceedRedeemSpawn(pl)
	
	--Output
	Debug("[REDEEM] ".. tostring(pl) .." redeemed")
end