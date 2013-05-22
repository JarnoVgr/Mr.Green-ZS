-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local surface = surface
local draw = draw
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer

--[==[------------------------------------------------
            Confirm an important action
-------------------------------------------------]==]
local function ConfirmAction ( Action, Pl, IsBan, BanTime, Reason ) 
	if Action == nil then return end
	
	-- Changemap
	if type ( Pl ) == "string" then
		Derma_Query( "You are trying to "..Action.." to "..tostring ( Pl ).." ! Please confirm :", "Warning!","Yes", function() RunConsoleCommand ( Action.."_player", tostring ( Pl ) ) CloseAdminPanel() end, "No", function() gui.EnableScreenClicker ( false ) end )
		return
	end
	
	-- For bans only
	if IsBan == true then
		if BanTime ~= nil and Reason ~= nil then
			Derma_Query( "You are trying to ban player "..tostring ( Pl:Name() ).." for "..tostring ( BanTime ).." minutes. (0 minutes means permanent ban) ! Please confirm :", "Warning!","Yes", function() RunConsoleCommand ( "ban_player", tostring ( BanTime ), tostring ( Pl:UserID() ), tostring ( Reason ) ) CloseAdminPanel() end, "No", function() gui.EnableScreenClicker ( false ) end )
		end
		
		return
	end	
	
	Derma_Query( "You are trying to "..Action.." player "..tostring ( Pl:Name() ).." ! Please confirm :", "Warning!","Yes", function() RunConsoleCommand ( Action.."_player", tostring ( Pl:UserID() ) ) CloseAdminPanel() end, "No", function() gui.EnableScreenClicker ( false ) end )
end

--[==[------------------------------------------------
             Creates the Admin Panel
-------------------------------------------------]==]
local AdminPanel, ToggleCooldown = nil, 0
function DoAdminPanel()
	if not ValidEntity ( MySelf ) then return end
	
	if AdminPanel == nil then
		AdminPanel = DermaMenu() 
	end
	
	AdminPanel:Hide()
	local PlayersAll = player.GetAll()
	
	timer.Simple ( 0.01, function()
		if AdminPanel == nil then return end
	
	-- Slay player option
	local SlayMenu = AdminPanel:AddSubMenu( "Slay Players >", function () CloseAdminPanel() end )
	for k,v in pairs ( PlayersAll ) do
		if ValidEntity ( v ) then
			local Team = "[TEAM_HUMAN]" if v:Team() == TEAM_UNDEAD then Team = "[TEAM_UNDEAD]" end
			SlayMenu:AddOption ( tostring ( v:Name() ).." - "..Team, function() RunConsoleCommand ( "slay_player", tostring ( v:UserID() ) ) CloseAdminPanel() end )
		end
	end
	
	-- Redeem player option
	local RedeemMenu = AdminPanel:AddSubMenu( "Redeem Player >", function () CloseAdminPanel() end )
	for k,v in pairs ( PlayersAll ) do
		if ValidEntity ( v ) then
			if v == MySelf or v:Team() == TEAM_UNDEAD then
				RedeemMenu:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).."]", function() RunConsoleCommand ( "redeem_player", tostring ( v:UserID() ) ) CloseAdminPanel() end )
			end
		end
	end

	AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )

	-- Screen grab
	local RedeemMenu = AdminPanel:AddSubMenu( "Grab Player Screen >", function () CloseAdminPanel() end )
	for k,v in pairs ( PlayersAll ) do
		if ValidEntity ( v ) then
			RedeemMenu:AddOption ( tostring ( v:Name() ), function() RunConsoleCommand ( "scanplayer", tostring ( v:EntIndex() ) ) CloseAdminPanel() end )
		end
	end
	
	-- Bring player option
	AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )
	local BringMenu = AdminPanel:AddSubMenu( "Bring Player >", function () CloseAdminPanel() end )
	for k,v in pairs ( PlayersAll ) do
		if ValidEntity ( v ) then
			local Team = "[TEAM_HUMAN]" if v:Team() == TEAM_UNDEAD then Team = "[TEAM_UNDEAD]" end
			BringMenu:AddOption ( tostring ( v:Name() ).." - "..Team, function() RunConsoleCommand ( "bring_player", tostring ( v:UserID() ) ) CloseAdminPanel() end )
		end
	end
	
	-- GoTo player option
	local GotoMenu = AdminPanel:AddSubMenu( "Teleport to Player >", function () CloseAdminPanel() end )
	for k,v in pairs ( PlayersAll ) do
		if ValidEntity ( v ) then
			local Team = "[TEAM_HUMAN]" if v:Team() == TEAM_UNDEAD then Team = "[TEAM_UNDEAD]" end
			GotoMenu:AddOption ( tostring ( v:Name() ).." - "..Team, function() RunConsoleCommand ( "goto_player", tostring ( v:UserID() ) ) CloseAdminPanel() end )
		end
	end
	
	-- Mute player option
	local RestrictionVoiceMenu, List = AdminPanel:AddSubMenu( "Voice Chat Restrictions >", function () CloseAdminPanel() end ), { "Mute Player", "Unmute Player" }
	for i,j in pairs ( List ) do	
		local MenuList = RestrictionVoiceMenu:AddSubMenu ( j, function() CloseAdminPanel() end )
		for k,v in pairs ( PlayersAll ) do
			if ValidEntity ( v ) then
				local TypeCmd = "true"
				if string.find ( j, "Unmute" ) then TypeCmd = "false" end
				MenuList:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).."]", function() RunConsoleCommand ( "mute_player", tostring ( v:UserID() ), TypeCmd ) CloseAdminPanel() end )
			end
		end
	end
	
	end )
	
	timer.Simple ( 0.03, function()
		if AdminPanel == nil then return end
	
	-- Gag player option
	local RestrictionChatMenu, List = AdminPanel:AddSubMenu( "Chat Restrictions >", function () CloseAdminPanel() end ), { "Gag Player", "Ungag Player" }
	for i,j in pairs ( List ) do	
		local MenuList = RestrictionChatMenu:AddSubMenu ( j )
		for k,v in pairs ( PlayersAll ) do
			if ValidEntity ( v ) then
				local TypeCmd = "true"
				if string.find ( j, "Ungag" ) then TypeCmd = "false" end
				MenuList:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).."]", function() RunConsoleCommand ( "gag_player", tostring ( v:UserID() ), TypeCmd ) CloseAdminPanel() end )
			end
		end
	end
	
	-- Changelevel menu
	AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )
	local MapMenu = AdminPanel:AddSubMenu( "Change Map >", function () CloseAdminPanel() end )
	for k,v in pairs ( TranslateMapTable ) do
		MapMenu:AddOption ( tostring ( v.Name ), function() ConfirmAction ( "changemap", k ) end )
	end
	
	-- Safe kick a player
	local SafeKickMenu = AdminPanel:AddSubMenu( "Safe Kick [Use with caution] >", function () CloseAdminPanel() end )
	for k,v in pairs ( PlayersAll ) do
		if ValidEntity ( v ) then
			SafeKickMenu:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).."]", function() ConfirmAction ( "safekick", v ) end )
		end
	end
	
	-- Kick player option
	local KickMenu = AdminPanel:AddSubMenu( "Kick [Use with caution] >", function () CloseAdminPanel() end )
	for k,v in pairs ( PlayersAll ) do
		if ValidEntity ( v ) then
			local Team = "[TEAM_HUMAN]" if v:Team() == TEAM_UNDEAD then Team = "[TEAM_UNDEAD]" end
			KickMenu:AddOption ( tostring ( v:Name() ).." - "..Team, function() ConfirmAction ( "kick", v ) end )
		end
	end
	
	end )
	
	timer.Simple ( 0.05, function() 
		if AdminPanel == nil then return end
		
	-- Ban player option
	local BanMenu = AdminPanel:AddSubMenu( "Ban [Use with caution] >", function () CloseAdminPanel() end )
	local Time, Reason = { [1] = "5", [2] = "10", [3] = "20", [4] = "50", [5] = "100", [6] = "1337", [7] = "Permaban that sucker!" }, { "Speed Hacking", "Mic/Chat Spamming", "Being an idiot/troll", "Insulting Players", "General Glitching/Exploiting" }
	for i,j in ipairs ( Time ) do
		local TimeToBan = tostring ( j ).." Minutes"
		if string.find ( j, "Permaban" ) then TimeToBan = tostring ( j ) end
		local TimeList = BanMenu:AddSubMenu ( tostring ( TimeToBan ), function()  CloseAdminPanel() end )
		for l,m in ipairs ( PlayersAll ) do
			if ValidEntity ( m ) then
				local BanTime = tonumber ( j ) if j == "Permaban that sucker!" then BanTime = 0 end
				TimeList:AddOption ( tostring ( m:Name() ).." - ["..GetStringTeam ( m ).."]", function() ConfirmAction ( "ban", m, true, BanTime, "Other reason." ) CloseAdminPanel() end )
			end
		end
	end
	
	end ) 
	
	timer.Simple ( 0.06, function()
		if AdminPanel == nil then return end	
	
	-- Slap player option
	local SlapMenu, DamageToSlap = AdminPanel:AddSubMenu( "Slap Player >", function () CloseAdminPanel() end ), { "No damage", "10% health", "30% health", "50 health", "Kill the bastard" }
	for i,j in pairs ( DamageToSlap ) do
		local MenuList = SlapMenu:AddSubMenu ( j )
		local Damage = { [1] = 0, [2] = 10, [3] = 30, [4] = 50, [5] = 100 }
		for k,v in pairs ( PlayersAll ) do
			if ValidEntity ( v ) then
				MenuList:AddOption ( tostring ( v:Name() ).." - ["..GetStringTeam ( v ).."]", function() RunConsoleCommand ( "slap_player", tostring ( v:UserID() ), Damage[i] ) CloseAdminPanel() end )
			end
		end
	end
	
	end )
	
	timer.Simple ( 0.08, function()
		if AdminPanel == nil then return end
		
	-- Slay all command - Superadmin only
	if MySelf:IsSuperAdmin() then
		AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )
		AdminPanel:AddOption ( "Slay everyone [S-Admin] >", function () RunConsoleCommand ( "slay_all" ) CloseAdminPanel() end )
		
		-- Swep command
		local WeaponsTab = AdminPanel:AddSubMenu ( "Give weapons [S-Admin] >", function() CloseAdminPanel() end )
		
		for k,v in pairs ( PlayersAll ) do
			local Team = "[TEAM_HUMAN]" if v:Team() == TEAM_UNDEAD then Team = "[TEAM_UNDEAD]" end
			local Slot = WeaponsTab:AddSubMenu ( tostring ( v:Name() ).." - "..Team, function() CloseAdminPanel() end )
		
			-- Add the weapons to each player
			for i,j in pairs ( GAMEMODE.HumanWeapons ) do
				Slot:AddOption ( i, function() RunConsoleCommand ( "give_weapon", tostring ( v:UserID() ), i ) CloseAdminPanel() end ) 
			end
		end
		
		-- Add bots command
		local BotMenu, HowMany = AdminPanel:AddSubMenu ( "Add Bots [S-Admin] >", function() CloseAdminPanel() end ), { [1] = 1, [2] = 2, [3] = 4, [4] = 8, [5] = 16 }
		for i = 1, 5 do
			BotMenu:AddOption ( HowMany[i].." Bots", function() RunConsoleCommand ( "add_bots", tostring ( HowMany[i] ) ) CloseAdminPanel() end )
		end
	end
	
	-- Fun menu
	AdminPanel:AddOption ( "---------------------------------", function () CloseAdminPanel() end )
	local FunMenu = AdminPanel:AddSubMenu( "Fun Menu [Use with caution] >", function () CloseAdminPanel() end )
	
	-- Fun - disable/ enable gravity
	FunMenu:AddOption ( "Enable Gravity", function() RunConsoleCommand ( "do_fun", "gravity", "1" ) CloseAdminPanel() end )
	FunMenu:AddOption ( "Disable Gravity", function() RunConsoleCommand ( "do_fun", "gravity", "0" ) CloseAdminPanel() end )
	
	-- Fun - Freeze/Unfreeze everything xD
	FunMenu:AddOption ( "Freeze Everything", function() RunConsoleCommand ( "do_fun", "freeze", "0" ) CloseAdminPanel() end )
	FunMenu:AddOption ( "UnFreeze Everything", function() RunConsoleCommand ( "do_fun", "freeze", "1" ) CloseAdminPanel() end )
	
	-- Finally, ravebreak by Clavus
	FunMenu:AddOption ( "Ravebreak", function() RunConsoleCommand ( "do_fun", "ravebreak", "1" ) CloseAdminPanel() end )
	
	end )
	
	-- finally open the panel
	timer.Simple ( 0.1, function() 
		if AdminPanel == nil then return end
	
		-- enable mouse
		gui.EnableScreenClicker ( true )
		
		-- set the panel's pos
		input.SetCursorPos( w * 0.35, h * 0.6 )
	
		-- open
		if AdminPanel ~= nil then AdminPanel:Open() end
	
	end )
end

--[==[------------------------------------------------
              Closes the Admin Panel
-------------------------------------------------]==]
function CloseAdminPanel()
	if not ValidEntity ( MySelf ) then return end
	if AdminPanel == nil then return end
	
	-- cooldown
	ToggleCooldown = CurTime() + 0.25
	
	-- hide mouse
	gui.EnableScreenClicker ( false )
	
	AdminPanel:Remove() 
	AdminPanel = nil
end

--[==[------------------------------------------------
              Called on KEY_C pressed
-------------------------------------------------]==]
local function OnKeyPressed ()
	if not ValidEntity ( MySelf ) then return end
	if not MySelf:IsAdmin() then return end
	if ClassMenu ~= nil and ClassMenu:IsValid() and ClassMenu:IsVisible() then return end
	
	-- cooldown failsafe
	if ToggleCooldown > CurTime() then return end
	
	-- pop-up the admin panel
	DoAdminPanel()
end
hook.Add( "OnContextMenuOpen", "KeyPressedHook", OnKeyPressed )

--[==[------------------------------------------------
              Called on KEY_C released
-------------------------------------------------]==]
local function OnKeyReleased ()
	if not ValidEntity ( MySelf ) then return end
	if not MySelf:IsAdmin() then return end
	
	-- remove admin panel and disable mouse
	CloseAdminPanel()
end
hook.Add( "OnContextMenuClose", "KeyReleasedHook", OnKeyReleased )

Debug ( "[MODULE] Loaded client-side admin panel module." )