-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local AdminPanel, ToggleCooldown = nil, 0

--[==[------------------------------------------------
              Closes the Admin Panel
-------------------------------------------------]==]
local function CloseAdminPanel()
	if not IsValid(AdminPanel) then
		return
	end
	
	--Cooldown
	ToggleCooldown = CurTime() + 0.25
	
	--Hide mouse
	gui.EnableScreenClicker(false)
	
	AdminPanel:Remove() 
	AdminPanel = nil
end

--[==[------------------------------------------------
            Confirm an important action
-------------------------------------------------]==]
local function ConfirmAction(Action, Pl, IsBan, BanTime, Reason)
	if Action == nil then
		return
	end
	
	-- Changemap
	if type ( Pl ) == "string" then
		Derma_Query( "You are trying to "..Action.." to "..tostring ( Pl ).." ! Please confirm :", "Warning!","Yes", function()
			RunConsoleCommand ( Action.."_player", tostring ( Pl ) )
			CloseAdminPanel()
		end, "No", function()
			gui.EnableScreenClicker ( false )
		end)

		return
	end
	
	-- For bans only
	if IsBan == true then
		if BanTime ~= nil and Reason ~= nil then
			Derma_Query( "You are trying to ban player "..tostring ( Pl:Name() ).." for "..tostring ( BanTime ).." minutes. (0 minutes means permanent ban) ! Please confirm :", "Warning!","Yes", function()
				RunConsoleCommand ( "ban_player", tostring ( BanTime ), tostring ( Pl:UserID() ), tostring ( Reason ) )
				CloseAdminPanel()
			end, "No", function()
				gui.EnableScreenClicker ( false )
			end)
		end
		
		return
	end	
	
	Derma_Query("You are trying to "..Action.." player "..tostring ( Pl:Name() )..". Please confirm:", "Warning!","Yes", function()
		RunConsoleCommand(Action.."_player", tostring ( Pl:UserID()))
		CloseAdminPanel()
	end, "No", function()
		gui.EnableScreenClicker(false)
	end)
end

--[==[------------------------------------------------
             Creates the Admin Panel
-------------------------------------------------]==]
local function DoAdminPanel()
	if not IsValid(MySelf) or not MySelf:IsAdmin() then
		return
	end
	
	if not IsValid(AdminPanel) then
		AdminPanel = DermaMenu() 
	end
	
	AdminPanel:Hide()
	local PlayersAll = player.GetAll()
	
	timer.Simple(0.01, function()
		if not IsValid(AdminPanel) then
			return
		end

		-- Slap player option
		local SlapMenu, DamageToSlap = AdminPanel:AddSubMenu("Slap Player >", function() CloseAdminPanel() end), { "No damage", "10% health", "30% health", "50 health", "Kill the bastard" }
		for i,j in pairs ( DamageToSlap ) do
			local MenuList = SlapMenu:AddSubMenu ( j )
			local Damage = { [1] = 0, [2] = 10, [3] = 30, [4] = 50, [5] = 100 }
			for k,v in pairs ( PlayersAll ) do
				if IsValid ( v ) then
					MenuList:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).."]", function() RunConsoleCommand ( "slap_player", tostring ( v:UserID() ), Damage[i] ) CloseAdminPanel() end )
				end
			end
		end
	
		-- Slay player option
		local SlayMenu = AdminPanel:AddSubMenu( "Slay Player >", function () CloseAdminPanel() end )
		for k,v in pairs ( PlayersAll ) do
			if IsValid ( v ) then
				local Team = "[TEAM_HUMAN]" if v:Team() == TEAM_UNDEAD then Team = "[TEAM_UNDEAD]" end
				SlayMenu:AddOption ( tostring ( v:Name() ).." - "..Team, function() RunConsoleCommand ( "slay_player", tostring ( v:UserID() ) ) CloseAdminPanel() end )
			end
		end
		
		-- Redeem player option
		local RedeemMenu = AdminPanel:AddSubMenu( "Redeem Player >", function () CloseAdminPanel() end )
		for k,v in pairs ( PlayersAll ) do
			if IsValid ( v ) then
				if v == MySelf or v:Team() == TEAM_UNDEAD then
					RedeemMenu:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).."]", function() RunConsoleCommand ( "redeem_player", tostring ( v:UserID() ) ) CloseAdminPanel() end )
				end
			end
		end
	end)
	
	timer.Simple( 0.03, function()
		if not IsValid(AdminPanel) then
			return
		end
	
		AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )

		--Bring player option
		local BringMenu = AdminPanel:AddSubMenu( "Bring Player >", function () CloseAdminPanel() end )
		for k,v in pairs ( PlayersAll ) do
			if IsValid ( v ) then
				local Team = "[TEAM_HUMAN]" if v:Team() == TEAM_UNDEAD then Team = "[TEAM_UNDEAD]" end
				BringMenu:AddOption ( tostring ( v:Name() ).." - "..Team, function() RunConsoleCommand ( "bring_player", tostring ( v:UserID() ) ) CloseAdminPanel() end )
			end
		end
		
		--GoTo player option
		local GotoMenu = AdminPanel:AddSubMenu( "Teleport to Player >", function () CloseAdminPanel() end )
		for k,v in pairs ( PlayersAll ) do
			if IsValid ( v ) then
				local Team = "[TEAM_HUMAN]" if v:Team() == TEAM_UNDEAD then Team = "[TEAM_UNDEAD]" end
				GotoMenu:AddOption ( tostring ( v:Name() ).." - "..Team, function() RunConsoleCommand ( "goto_player", tostring ( v:UserID() ) ) CloseAdminPanel() end )
			end
		end
	end)

	timer.Simple(0.04, function()
		if not IsValid(AdminPanel) then
			return
		end
	
		AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )

		-- Screen grab
		local RedeemMenu = AdminPanel:AddSubMenu( "Grab Player Screen >", function () CloseAdminPanel() end )
		for k,v in pairs ( PlayersAll ) do
			if IsValid ( v ) then
				RedeemMenu:AddOption ( tostring ( v:Name() ), function() RunConsoleCommand ( "scanplayer", tostring ( v:EntIndex() ) ) CloseAdminPanel() end )
			end
		end

		-- Gag player option
		local RestrictionChatMenu, List = AdminPanel:AddSubMenu( "Restrict Player Chat (Gag) >", function () CloseAdminPanel() end ), { "Gag Player", "Ungag Player" }
		for i,j in pairs ( List ) do	
			local MenuList = RestrictionChatMenu:AddSubMenu ( j )
			for k,v in pairs ( PlayersAll ) do
				if IsValid ( v ) then
					local TypeCmd = "true"
					if string.find ( j, "Ungag" ) then TypeCmd = "false" end
					MenuList:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).."]", function() RunConsoleCommand ( "gag_player", tostring ( v:UserID() ), TypeCmd ) CloseAdminPanel() end )
				end
			end
		end
		
		-- Mute player option
		local RestrictionVoiceMenu, List = AdminPanel:AddSubMenu( "Restrict Player Voice Chat (Mute) >", function () CloseAdminPanel() end ), { "Mute Player", "Unmute Player" }
		for i,j in pairs ( List ) do	
			local MenuList = RestrictionVoiceMenu:AddSubMenu ( j, function() CloseAdminPanel() end )
			for k,v in pairs ( PlayersAll ) do
				if IsValid ( v ) then
					local TypeCmd = "true"
					if string.find ( j, "Unmute" ) then TypeCmd = "false" end
					MenuList:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).."]", function() RunConsoleCommand ( "mute_player", tostring ( v:UserID() ), TypeCmd ) CloseAdminPanel() end )
				end
			end
		end
	end)
		
	timer.Simple(0.05, function()
		if not IsValid(AdminPanel) then
			return
		end	
	
		AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )

		--Kick a player
		local KickMenu = AdminPanel:AddSubMenu( "Kick Player [Use with caution] >", function () CloseAdminPanel() end )
		for k,v in pairs ( PlayersAll ) do
			if IsValid ( v ) then
				KickMenu:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).." - ".. v:SteamID() .."]", function() ConfirmAction ( "kick", v ) end )
			end
		end
		
		--Ban player option
		local BanMenu = AdminPanel:AddSubMenu( "Ban Player [Use with caution] >", function () CloseAdminPanel() end )
		local Time, Reason = { [1] = "5", [2] = "10", [3] = "20", [4] = "50", [5] = "100", [6] = "1337", [7] = "Permaban that sucker!" }, { "Speed Hacking", "Mic/Chat Spamming", "Being an idiot/troll", "Insulting Players", "General Glitching/Exploiting" }
		for i,j in ipairs ( Time ) do
			local TimeToBan = tostring ( j ).." Minutes"
			if string.find ( j, "Permaban" ) then TimeToBan = tostring ( j ) end
			local TimeList = BanMenu:AddSubMenu ( tostring ( TimeToBan ), function()  CloseAdminPanel() end )
			for l,m in ipairs ( PlayersAll ) do
				if IsValid ( m ) then
					local BanTime = tonumber ( j ) if j == "Permaban that sucker!" then BanTime = 0 end
					TimeList:AddOption ( tostring ( m:Name() ).." - ["..GetStringTeam ( m ).." - ".. m:SteamID() .."]", function()
						ConfirmAction("ban", m, true, BanTime, "No information given")
						CloseAdminPanel()
					end )
				end
			end
		end
	end)


	timer.Simple(0.06, function() 
		if not IsValid(AdminPanel) then
			return
		end

		AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )

		
		--Changelevel menu
		local MapMenu = AdminPanel:AddSubMenu( "Change Map >", function () CloseAdminPanel() end )
		for k,v in pairs ( TranslateMapTable ) do
			MapMenu:AddOption ( tostring ( v.Name ), function() ConfirmAction ( "changemap", k ) end )
		end
	end)

	timer.Simple(0.07, function()
		if not IsValid(AdminPanel) then
			return
		end
		
		-- Slay all command - Superadmin only
		if MySelf:IsSuperAdmin() then
			AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )
			AdminPanel:AddOption ( "Slay Everyone [S-Admin]", function ()
				RunConsoleCommand ( "slay_all" )
				CloseAdminPanel()
			end)
			
			-- Swep command
			local WeaponsTab = AdminPanel:AddSubMenu ( "Give Player Weapon [S-Admin] >", function() CloseAdminPanel() end )
			
			for k,v in pairs ( PlayersAll ) do
				local Team = "[TEAM_HUMAN]" if v:Team() == TEAM_UNDEAD then Team = "[TEAM_UNDEAD]" end
				local Slot = WeaponsTab:AddSubMenu( tostring ( v:Name() ).." - "..Team, function() CloseAdminPanel() end )
			
				--Add the weapons to each player
				for i,j in SortedPairs(GAMEMODE.HumanWeapons) do
					Slot:AddOption(i, function()
						RunConsoleCommand("give_weapon", tostring ( v:UserID() ), i )
						CloseAdminPanel()
					end) 
				end
			end
			
			-- Add bots command
			local BotMenu, HowMany = AdminPanel:AddSubMenu ( "Add Bots [S-Admin] >", function() CloseAdminPanel() end ), { [1] = 1, [2] = 2, [3] = 4, [4] = 8, [5] = 12, [6] = 16 }
			for i = 1, 6 do
				BotMenu:AddOption( HowMany[i].." Bots", function() RunConsoleCommand ( "add_bots", tostring ( HowMany[i] ) ) CloseAdminPanel() end )
			end
		end
		
		-- Debug menu
		if MySelf:IsSuperAdmin() then
			local DebugMenu = AdminPanel:AddSubMenu("Debug [S-Admin] >", function()
				CloseAdminPanel()
			end)
			
			--Disable/Enable gravity
			DebugMenu:AddOption("Enable Gravity", function()
				RunConsoleCommand("zs_admin_debug", "gravity", "1")
				CloseAdminPanel()
			end)
		
			DebugMenu:AddOption("Disable Gravity", function()
				RunConsoleCommand("zs_admin_debug", "gravity", "0")
				CloseAdminPanel()
			end)
		
			--Separator
			DebugMenu:AddOption("---------------------------------", function() CloseAdminPanel() end)
		
			--Freeze everything
			DebugMenu:AddOption("Freeze Everything", function()
				RunConsoleCommand("zs_admin_debug", "freeze", "0")
				CloseAdminPanel()
			end)
			
			--UnFreeze everything
			DebugMenu:AddOption("UnFreeze Everything", function()
				RunConsoleCommand("zs_admin_debug", "freeze", "1")
				CloseAdminPanel()
			end)
			
			--Separator
			DebugMenu:AddOption("---------------------------------", function() CloseAdminPanel() end)
						
			--Skip warmup/Start game
			DebugMenu:AddOption("Start round immediately", function()
				RunConsoleCommand("zs_admin_debug","startround")
				CloseAdminPanel()
			end)

			--Unlock all undead classes
			DebugMenu:AddOption("Unlock all Undead species", function()
				RunConsoleCommand("zs_admin_debug","unlockspecies")
				CloseAdminPanel()
			end)
				
			DebugMenu:AddOption("All Talk (On)", function()
				RunConsoleCommand("zs_admin_debug", "alltalk", "1")
				CloseAdminPanel()
			end)	
			
			DebugMenu:AddOption("All Talk (Off)", function()
				RunConsoleCommand("zs_admin_debug", "notalk", "0")
				CloseAdminPanel()
			end)
			
				
			--Unleash Undead Boss
			DebugMenu:AddOption("Unleash Undead Boss", function()
				RunConsoleCommand("zs_admin_debug","unleashboss")
				CloseAdminPanel()
			end)
			
			--Skip to Intermission
			DebugMenu:AddOption("Start intermission in 5 seconds", function()
				RunConsoleCommand("zs_admin_debug","roundtime5")
				CloseAdminPanel()
			end)
		end
	end)

	--Finally open the panel
	timer.Simple(0.25, function() 
		if not IsValid(AdminPanel) then
			return
		end
	
		--Enable mouse
		gui.EnableScreenClicker(true)
		
		--Set the panel's pos
		input.SetCursorPos(w * 0.35, h * 0.6)
	
		--Open
		if AdminPanel ~= nil then
			AdminPanel:Open()
		end
	end)
end

local ToggleCooldown = 0

--[==[------------------------------------------------
              Called on KEY_C pressed
-------------------------------------------------]==]
local function OnKeyPressed()
	--Don't display when in class menu
	if IsValid(ClassMenu) and ClassMenu:IsVisible() then
		return
	end
	
	--Cooldown failsafe
	if ToggleCooldown > CurTime() then
		return
	end
	
	--Pop-up the admin panel
	DoAdminPanel()
end
hook.Add("OnContextMenuOpen", "ContextKeyPressedHook", OnKeyPressed)

--[==[------------------------------------------------
              Called on KEY_C released
-------------------------------------------------]==]
local function OnKeyReleased()
	--Remove admin panel and disable mouse
	CloseAdminPanel()
end
hook.Add("OnContextMenuClose", "ContextKeyReleasedHook", OnKeyReleased )

Debug("[MODULE] Loaded admin panel")