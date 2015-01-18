
--[==[------------------------------------
	Print message to all players
------------------------------------]==]

HUD_PRINTADMINCHAT = 77 -- custom printtype
function PrintMessageAll( printtype, text )

	if (printtype == HUD_PRINTADMINCHAT) then
		for k,v in pairs(player.GetAll()) do
			if (v:IsAdmin()) then
				v:PrintMessage(HUD_PRINTTALK,text)
			end
		end	
	else
		for k,v in pairs(player.GetAll()) do
			v:PrintMessage(printtype,text)
		end
	end
	
end

local clientCommandList = {      -- list of all client commands I added
"\nLIST OF COMMANDS FOR CLIENTS\n",
"BOOM \t\t\t\t- If you're a Chemical Zombie, you explode - OBSOLETE",
"!commandlist / !cmdhelp \t- Prints this list of commands in console",
"!options \t\t\t- Opens settings menu where you can toggle screeneffects",
"!help	\t\t\t- Opens help and information menu",
"!shop  \t\t\t- Opens the Mr. Green shop",
"!class	\t\t\t- Opens zombie class selection menu",
"!score or not achievements \t- opens achievement menu",
"!server \t\t\t- Opens server info panel",
"!rules \t\t\t\t- Opens rules panel",
"!donate \t\t\t- Opens donate panel",
"!autoredeem \t\t\t- Switch autoredeem on/off.",
"!kill	\t\t\t- Suicide",
"!thetime \t\t\t- Display current system time",
"!steamid \t\t\t- Displays your Steam ID",
"!unique	\t\t\t- Displays your unique ID",
"!mapcycle \t\t\t- Prints the mapcycle in your console",
"!stopsounds \t\t\t- Stops all sounds and music that's currently playing",
"!rtd \t\t\t\t- Roll The Dice! See how much lady luck loves you.",
"!nextmap \t\t\t- Displays the next map",
"!currentmap \t\t\t- Displays the current map",
"!jetboom \t\t\t- Easter egg",
"!mrgreen \t\t\t- Easter egg",
"!ywa \t\t\t\t- Easter egg",
"!clavus \t\t\t- Easter egg",
"!mayco \t\t\t\t- Easter egg",
"!ratman \t\t\t- Easter egg",
"!prismaa \t\t\t- Easter egg",
"!deluvas \t\t\t- Easter egg",
"!Damien \t\t\t- Easter egg",
"!Duby \t\t\t- Easter egg",
"!GheiiBen \t\t\t- Easter egg",
"!Pufulet \t\t\t- Easter egg",
"!Rob \t\t\t- Easter egg",
"!Box \t\t\t- Easter egg",
"!Reiska \t\t\t- Easter egg",
}
			

			
local adminCommandList = {      -- list of all admin commands I added
"\nLIST OF ADMIN-ONLY COMMANDS\n",
"!slay <player name> \t\t- slays the specified player",
"!slap <player name> <amount> \t- slaps the specified player with the <amount> of damage",
"!bring <player name> \t\t- brings the specified player",
"!goto <player name> \t\t- goto the specified player, use noclip if there's no space",
"!kick <player name> \t\t- kick the specified player",
"!sweplist \t\t\t- Prints the list of available sweps in the console",
"!changemap <map name> \t\t- Changes map",
"!swep <player name> <weapon name> \t- Gives the specified player the specified weapon.",
"!ammo+ <player name> \t\t- Gives the specified player 100 ammo for the weapon he/she is holding.",
"!hp+ <player name> \t\t- Restores 25 health for the specified player",
"!redeem <player name> \t\t- Redeemes the specified player (if zombie)",
"!ip <player name> \t\t- Displays the specified player's IP address",
"!randomslay \t\t\t- randomly slays a player, could be used in case there is no zombie",
"!ravebreak \t\t\t- ONLY USE WHEN IT'S FUNNY"}

--[==[-----------------------------------------
				CHATCOMMANDS
-----------------------------------------]==]

local function CommandSay(pl, text, teamonly)
	if text:sub(1,1) == "!" then
		if (text == "!kill" or text == "!suicide" or text == "!boom") then
			if pl:Alive() and not ENDROUND and GAMEMODE:CanPlayerSuicide(pl) then
				pl:Kill()
			else
				--Heads up!
				local suicidenote = { "You can't suicide now.","Suicide is not the answer."}
				if math.random(1,3) == 1 then
					pl:Message(suicidenote[math.random(1,#suicidenote)], 2)
				end
			end

			return ""
		--Print list of available commands
		elseif (text == "!commandlist" or text == "!commands" or text == "!cmdhelp") then
			pl:PrintMessage(HUD_PRINTCONSOLE, "\n\nList of commands on the Mr. Green server\n")
			pl:PrintMessage(HUD_PRINTCONSOLE, "-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- /\n")
			for _, mrgreencmd in pairs(clientCommandList) do		
				pl:PrintMessage(HUD_PRINTCONSOLE, mrgreencmd.."\n")	 	 	
			end

			if pl:IsAdmin() then
				for _, mrgreencmd in pairs(adminCommandList) do		
					pl:PrintMessage(HUD_PRINTCONSOLE, mrgreencmd.."\n")	 	 	
				end
			end
			pl:PrintMessage(HUD_PRINTCONSOLE, "\n-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- /\n\n")
			pl:PrintMessage(HUD_PRINTTALK, "List of commands printed in console.")
			return ""
		--Simulate an action
		elseif (text:sub(1,4) == "/me ") then
			PrintMessageAll(HUD_PRINTTALK,pl:Name().." "..text:sub(5,string.len(text)))
			return ""
		elseif (text == "!nextmap") then
			if ENDROUND then
				PrintMessageAll(HUD_PRINTTALK,"Player "..pl:Name().." needs glasses")
			else
				PrintMessageAll(HUD_PRINTTALK,"The next map is "..GAMEMODE:GetMapNext())
			end
			return ""
		elseif (text == "!thetime") then
			pl:PrintMessage(HUD_PRINTTALK,"The server time is "..os.date("%X")..". The date is "..os.date("%x")..".")
			return ""
		elseif (text == "!currentmap") then
			PrintMessageAll(HUD_PRINTTALK, "The current map is ".. game.GetMap())
			return ""
		elseif (text == "!mapcycle" or text == "!maplist") then
			server_RunCommand(pl, "zs_print_mapcycle")
			return ""
		--[[if (text == "!reportbug") then
			server_RunCommand(pl, "open_bugpanel")
			return ""
		end]]
		elseif (text:sub(1,4) == "!rtd") then
			server_RunCommand(pl, "zs_rollthedice")
			return ""
		-- Level stats! :D
		elseif (text == "!levelstats") then
			server_RunCommand(pl, "zs_showlevel")
			return ""
		elseif (text == "!stopsounds") then
			server_RunCommand(pl, "stopsounds")
			pl:PrintMessage(HUD_PRINTTALK,"Stopped sounds.")
			return ""
		elseif (text == "!help" or text == "!info") then
			if not ENDROUND then
				pl:SendLua("MakepHelp()")
			else
				pl:PrintMessage(HUD_PRINTTALK,"Can't open help screen at intermission.")
			end
			return ""
		elseif (text == "!achievements" or text == "!score") then
			--[[if not ENDROUND then
			pl:SendLua("MakepHelp("..(#HELP_TXT+1)..")")
			end]]
			pl:PrintMessage(HUD_PRINTTALK,"Command currently not available.")
			return ""
		elseif (text == "!server") then
			--[[if not ENDROUND then
			pl:SendLua("MakepHelp(5)")
			end]]
			pl:PrintMessage(HUD_PRINTTALK,"Command currently not available.")
			return ""
		elseif (text == "!rules") then
			--[[if not ENDROUND then
			pl:SendLua("MakepHelp(2)")
			end]]
			pl:PrintMessage(HUD_PRINTTALK,"Command currently not available.")
			return ""
		elseif (text == "!donate") then
			--[[if not ENDROUND then
				pl:SendLua("MakepHelp(5)")
			end]]
			pl:PrintMessage(HUD_PRINTTALK,"Command currently not available.")
			return ""
		elseif (text == "!shop") then
			if not ENDROUND then
				server_RunCommand(pl, "open_shop")
			end
			return ""
		elseif (text == "!autoredeem") then
			if pl.AutoRedeem then
				server_RunCommand(pl, "zs_autoredeem", 0)
			else
				server_RunCommand(pl, "zs_autoredeem", 1)
			end
			return ""
		elseif (text:sub(1,5) == "!ppon" or text:sub(1,6) == "!ppoff" or text == "!options" or text == "!grainoff" or text == "!grainon") then
			pl:SendLua("MakepOptions()")
			return ""
		elseif (text == "!jetboom") then
			pl:PrintMessage( HUD_PRINTCENTER, "JetBoom: as great in programming as he is unfriendly." )
			
			elseif (text == "!Damien") then
			pl:PrintMessage( HUD_PRINTCENTER, "CheeseCake HACKS!!!! xD." )
			
			elseif (text == "!Duby") then
			pl:PrintMessage( HUD_PRINTCENTER, "The duel elite master will lead the dubyans!" )
			
			elseif (text == "!GheiiBen") then
			pl:PrintMessage( HUD_PRINTCENTER, "You cannot take control! Unless you press the gheiiBen ;)" )
			
			elseif (text == "!Pufulet") then
			pl:PrintMessage( HUD_PRINTCENTER, "I am the best and you know it. Lil Scrub suck on my turtle!" )
			
			elseif (text == "!Rob") then
			pl:PrintMessage( HUD_PRINTCENTER, "hahahaha Pufulets updates make me laugh!" )
			
			elseif (text == "!Box") then
			pl:PrintMessage( HUD_PRINTCENTER, "I am a Box within a box within a box within a box." )
			
			elseif (text == "!Reiska") then
			pl:PrintMessage( HUD_PRINTCENTER, "Ha the Dubyans will never stop me! Vodka will fuel me to victory!" )
			
		elseif (text == "!clavus") then
			pl:PrintMessage( HUD_PRINTCENTER, "Undead overlord!" )
		elseif (text == "!ywa") then
			pl:PrintMessage( HUD_PRINTCENTER, "Ywa FTW!" )
		elseif (text == "!mayco") then
			pl:PrintMessage( HUD_PRINTCENTER, "Mayco: Your friendly neighbourhood admin! He likes ducks and potatoes!" )
		elseif (text == "!mrgreen") then
			pl:PrintMessage( HUD_PRINTCENTER, "WWW.MRGREENGAMING.COM -- Your multiplayer community!" )
		elseif (text == "!ratman") then
			pl:PrintMessage( HUD_PRINTCENTER, "RatMan: ClavusElite's little bro..." )
		elseif (text == "!prismaa") then
			pl:PrintMessage( HUD_PRINTCENTER, "CRY SOME MOREEEEE" )
		elseif (text == "!deluvas") then
			pl:PrintMessage( HUD_PRINTCENTER, "EEENUUUF Deluvas is ENUUFF!" )
		elseif (text == "!hundred2") then
			pl:PrintMessage( HUD_PRINTCENTER, "Old ZS Veteran and ducttape enthousiast." )
		elseif (text == "!chainsaw") then
			pl:PrintMessage( HUD_PRINTCENTER, "GIVE HIM SOME ICETEA OR DIE!" )
		elseif (text == "!corby") then
			pl:PrintMessage( HUD_PRINTCENTER, "CRYPTIC METAPHOR! (from Gears of Awesome)" )
		elseif (text == "!necrossin") then
			pl:PrintMessage( HUD_PRINTCENTER, "There is nothing to hate, but the Hate itselves!" )
		elseif (text == "!howler") then
			pl:PrintMessage( HUD_PRINTCENTER, "Ywa sure likes 'em" )
		elseif (text == "!chicken") then
			pl:PrintMessage( HUD_PRINTCENTER, "CHICKEN SHIT. FAILED TO DELIVER! Poor Ywa D:" )
		elseif (text == "!requirements") then
			pl:PrintMessage( HUD_PRINTCENTER, "Requirements are supposed to be hard! Stop whining :O!" )
		elseif (text == "!steamid") then
			pl:PrintMessage( HUD_PRINTTALK, "Your Steam ID is "..pl:SteamID() )
		elseif (text == "!uniqueid") then
			pl:PrintMessage( HUD_PRINTTALK, "Your Unique ID is "..pl:UniqueID() )
		elseif (text == "!entowner") then
			if not pl:Team() == TEAM_HUMAN or not pl:Alive() then
				return ""
			end
			
			local trmine = pl:GetEyeTrace()
			if not trmine.Hit then
				return ""
			end

			if trmine.Entity:IsValid() and trmine.Entity:GetClass() == "mine" then
				pl:PrintMessage(HUD_PRINTTALK, "This entity belongs to ".. trmine.Entity:GetOwner():Name() ..".")
			end
		else
			local tbString = string.Explode( " ", text )

			if tbString[1] == "!votemute" or tbString[1] == "!votegag" or tbString[1] == "!zsvotemute" or tbString[1] == "!zsvotegag" then
				return Vote(pl,text)
			end
		end
	end

	--Open help menu on question
	if (string.lower(text:sub(1,6)) == "how to" or string.lower(text:sub(1,10)) == "how do you" or string.lower(text:sub(1,11)) == "how did you" or string.lower(text:sub(1,8)) == "how do i") then
		if not ENDROUND then
			if not pl.IsAsked then
				pl:SendLua("MakepHelp()")
				pl.IsAsked = true
			end
		end
	end
	
	--MEDIC required
	if (text == "medic!") and pl:Health() <= 65 and pl:Team() == TEAM_HUMAN and pl:Alive() then
		for _,medic in pairs(player.GetAll()) do
			if pl:Team() == TEAM_HUMAN and medic:Team() == TEAM_HUMAN and medic:Alive() and pl ~= medic then
				medic:Message(pl:Name() .." needs immediate healing", 1, "white")
			end
		end
	end

	--WHAT DOES THE SCOUT SAY ABOUT HIS HORNYNESS LEVEL?
	local tocheck = string.lower(text)
	local hornytab = { "fuck", "horny", "ass", "bitch", "penis", "kitty", "pussy", "suck", "cock", "billy", "slut", "oh shi", "cum", "juice", "dick", "sex", "tits", "boobs", "titties" }	
	for k, v in pairs(hornytab) do
		if string.find(tocheck,v) then
			pl.Hornyness = pl.Hornyness + 1
		end
	end

	--Check for voice commands	
	if pl:Team() == TEAM_HUMAN then
		local set = pl.VoiceSet or "male"
		pl.ChatScream = pl.ChatScream or 0
		if pl.ChatScream < CurTime() or pl:IsSuperAdmin() then
			for k, v in pairs (VoiceSets[set].ChatSounds) do
				if string.find(string.lower(text),k) then
					pl:EmitSound(v[math.random(1,#v)])
					pl.LastVoice = CurTime()
					pl.ChatScream = CurTime() + 10 -- 10 secs before we're allowed another scream, prevents spam
					break
				end	
			end
		end
	end
end
hook.Add("PlayerSay", "ChatCommands1", CommandSay)

--List of weapons available for admins
local weaponList = { "map_tool", "dev_points", "admin_map_tool", "weapon_zs_mac10", "weapon_zs_grenadelauncher", "weapon_zs_barricadekit", "weapon_zs_turretplacer","weapon_zs_shotgun","weapon_zs_syringe","weapon_zs_melee_crowbar", "weapon_zs_classic", "weapon_zs_melee_keyboard", "weapon_zs_usp", "weapon_zs_p228", "weapon_zs_combatknife",       -- list all weapons you can give
"weapon_zs_glock3", "weapon_zs_deagle", "weapon_zs_fiveseven", "weapon_zs_elites", "weapon_zs_magnum","weapon_zs_tmp", "weapon_zs_mp5", "weapon_zs_p90","weapon_zs_smg", "weapon_zs_ump",
"weapon_zs_crossbow", "weapon_zs_scout", "weapon_zs_aug", "weapon_zs_galil", "weapon_zs_ak47", "weapon_zs_m4a1",
"weapon_zs_m3super90", "weapon_zs_m1014", "weapon_zs_m249","weapon_zs_mine", "weapon_zs_sg552", "weapon_zs_famas", "weapon_zs_tools_torch", "weapon_zs_tools_supplies", "weapon_zs_tools_remote",
"weapon_zs_pulserifle", "weapon_zs_pulsesmg", "weapon_zs_melee_keyboard", "weapon_zs_melee_katana", "weapon_zs_melee_sledgehammer", "weapon_zs_melee_pot", "weapon_zs_melee_axe", "weapon_zs_melee_keyboard", "weapon_zs_melee_fryingpan", "weapon_zs_melee_shovel", "weapon_zs_tools_hammer", "weapon_zs_melee_plank","weapon_zs_grenadelauncher","weapon_zs_boomstick","weapon_zs_melee_combatknife","weapon_zs_pickup_flare","weapon_zs_pickup_gascan","weapon_zs_pickup_gascan2","weapon_zs_pickup_gasmask","weapon_zs_pickup_propane","weapon_zs_tools_plank"}

--List of weapons only available to superadmins
local restrictedweaponList = { "dev_points", "admin_tool_remover", "admin_tool_sprayviewer", "admin_tool_igniter", "admin_tool_canister", "weapon_physgun", "admin_exploitblocker", "admin_maptool", "weapon_physcannon" }
		
local function AdminSay(pl, text, teamonly)
	if not pl:IsAdmin() then 
		return
	end
	
	if (text:sub(1,3) == "@@@") then
		text = string.gsub(text,"@@@","")
		PrintMessageAll( HUD_PRINTCENTER, text )
		return ""
	elseif (text:sub(1,2) == "@@") then
		text = string.gsub(text,"@@","")
		PrintMessageAll( HUD_PRINTTALK, text )
		return ""
	elseif (text:sub(1,1) == "@") then
		text = string.gsub(text,"@","")
		PrintMessageAll( HUD_PRINTADMINCHAT, "(ADMINCHAT) "..pl:Name()..": "..text )
		return ""
	end
	if text == "!mapmanager" and pl:IsSuperAdmin() then
		pl:SendLua("OpenMapManager()")
		return ""
		end
	local sep = string.Explode(" ",text)
	
	if (text == "!sweplist") then   -- prints the list of available weapons
		pl:PrintMessage(HUD_PRINTCONSOLE, "\n\nList of weapons spawnable for the !swep command:\n")
		pl:PrintMessage(HUD_PRINTCONSOLE, "-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- \n")
		for _, swep in pairs(weaponList) do		
			pl:PrintMessage(HUD_PRINTCONSOLE, swep.."\n")	 	 	
		end
		if pl:IsSuperAdmin() then
			for _, swep in pairs(restrictedweaponList) do		
				pl:PrintMessage(HUD_PRINTCONSOLE, swep.."\n")	 	 	
			end
		end
		pl:PrintMessage(HUD_PRINTTALK, "List of weapons printed in console.")
		return ""	
	elseif(text == "!randomslay") then
		local theList = team.GetPlayers(TEAM_HUMAN)
		
		local unluckydude = theList[math.random(1,#theList)]
		if IsValid(unluckydude) then
			unluckydude:Kill()
			
			PrintMessageAll(HUD_PRINTTALK,"The condemned player for The Undead is..."..unluckydude:Nick())
		end
		return ""
	elseif (sep[1] == "!nametrack") then
		pl:PrintMessage(HUD_PRINTTALK, "Checking player names, reporting changes in 15 seconds.")
		StartNameTrack(pl)
		timer.Simple(15,function()
			EndNameTrack(pl)
		end)
		return ""
	elseif (text == "!admin" or text == "!menu") then
		-- pl:SendLua("MakepHelp("..(#HELP_TEXT+4)..")")
		return ""
		elseif text == "!fuckme" then
			pl:SendLua("StalkerFuck(5)")
			return ""
	elseif text == "!mapmanager" and pl:IsSuperAdmin() then
		pl:SendLua("OpenMapManager()")
		return ""
	elseif text == "!remove" and pl:IsSuperAdmin() then
		server_RunCommand(pl, "mrgreen_admin_remove")
		return ""
	elseif text == "!exploitblocker" and pl:IsSuperAdmin() then
		pl:Give("admin_exploitblocker")
		return ""
	elseif text == "!maptool" and pl:IsSuperAdmin() then
		pl:Give("admin_maptool")
		return ""	
	elseif text == "!DubyIsSexy" then
		--if LASTHUMAN or ENDROUND then
			if not Raving then
				RaveBreak()
			else
				pl:Message("You're already raving dude")
		--	end
			return text
		--else
		--	pl:Message("RaveBreak not available at this time")
		--	return ""
		end
		
	elseif (text:sub(1,5) == "!asay") then
		text = string.gsub(text,"!asay","")
		for k,pl in pairs (player.GetAll()) do
			pl:CustomChatPrint( {nil, Color(255,15,15),text} )
		end
	
		return ""
	end

	--Super Admin only commands	
	if pl:IsSuperAdmin() then
		if text == "!endround" then
			if not ENDROUND then
				gamemode.Call( "OnEndRound", TEAM_HUMAN )
			end
			
			return ""
		elseif (sep[1] == "!achievement" or sep[1] == "!unlock") then
			if sep[2] and pl:GetAchievementsDataTable()[tostring(sep[2])] ~= nil then
				pl:UnlockAchievement(sep[2])
			else
				pl:ChatPrint("Specify a valid achievement to unlock.")
			end

			return ""
		elseif text == "!fuckme" then
			pl:SendLua("StalkerFuck(5)")
			return ""
		elseif text == "!testunlock" then
			pl:SendLua("UnlockEffect(0, \"Unlock Title\", \"This is the description\")")
			return ""
		elseif text == "!testachievement" then
			pl:SendLua("UnlockEffect(1, \"masterofzs\")")
			return ""
		elseif text == "!testlevelup" then
			pl:SendLua("UnlockEffect(2, 22)")
			return ""
		elseif text == "!ornament" then
			for k, v in pairs(ents.FindByClass("prop_dynamic_ornament")) do
				print(k..": Pos = "..tostring(v:GetPos()).."; Parent = "..v:GetParent():GetClass())
			end

			return ""
		elseif text == "!redeemall" then
			for k, v in pairs(team.GetPlayers(TEAM_UNDEAD)) do
				server_RunCommand (pl, "redeem_player",v:UserID() )
			end

			return ""
		elseif text == "!slayall" then
			for k, v in pairs(player.GetAll()) do
				if v ~= pl then
					server_RunCommand (pl, "slay_player",v:UserID() )
				end
			end

			return ""
			
			--[[
			elseif text == "!alltalk" then
			for k, v in pairs(player.GetAll()) do
				if v ~= pl then
					RunConsoleCommand ( "sv_alltalk", "1" )
				end
			end

			return ""
			
			elseif text == "!notalk" then
			for k, v in pairs(player.GetAll()) do
				if v ~= pl then
					RunConsoleCommand ( "sv_alltalk", "0" )
				end
			end

			return ""
			]]--
		--end
		end
	end

	if (#sep > 1 and text:sub(1,1) == "!") then
		if (sep[1] == "!changemap" or sep[1] == "!changelevel") then
			server_RunCommand(pl, "change_map",sep[2] )
			return ""		
		end
		
		--[==[------ Player targeted commands -------]==]
		
		local target = GetPlayerByName(sep[2])
		if (target == -1) then
			pl:Message("Target player not found")
			return ""
		elseif (target == -2) then
			pl:Message("Multiple targets found, please refine your request")
			return ""
		end
		
		--Kick command
		if(sep[1] == "!kick") then
			if pl:IsValid() and pl:IsPlayer() and (pl:Team() == TEAM_UNDEAD or pl:Team() == TEAM_HUMAN) then
				server_RunCommand(pl, "kick_player",target:UserID() )
				pl:PrintMessage( HUD_PRINTTALK, "Player "..target:Name().." was kicked.")
			else
				pl:PrintMessage( HUD_PRINTTALK, "Player "..target:Name().." is invalid (glitched) and can't be kicked.")
			end
			return ""
		--IP/Host output command
		elseif (sep[1] == "!ip") or (sep[1] == "!host") then
			pl:PrintMessage(HUD_PRINTTALK, "Player "..target:Nick().." IP address is ".. target:IPAddress())
			pl:Message(target:Nick().."'s IP address is ".. target:IPAddress())
			return ""
		end
		
		-- Check if he's alive
		if not target:Alive() or not target:IsValid() then
			pl:Message("Target player is dead")
			return ""
		end
		
		--Redeem command
		if (sep[1] == "!redeem" and target:Team() == TEAM_UNDEAD) then	
			if (target == pl and not pl:IsSuperAdmin()) then
				pl:Message("You cannot redeem yourself")
			else
				server_RunCommand (pl, "redeem_player", target:UserID())
				if not LASTHUMAN or not ENDROUND then
					pl:Message(target:GetName() .." redeemed")
				else
					pl:Message("You can't redeem ".. target:GetName() .." at this moment")
				end
				target:Message("You are redeemed by ".. pl:GetName())
			end
			return ""
		--Slay command
		elseif(sep[1] == "!slay") then
			server_RunCommand (pl, "slay_player", target:UserID() )
			pl:PrintMessage( HUD_PRINTTALK, "Player "..target:Name().." was killed.")
			target:PrintMessage( HUD_PRINTTALK, "Admin "..pl:Name().." killed you.")
			return ""
		elseif(sep[1] == "!mute") then
			target:Mute()
			PrintMessageAll(HUD_PRINTTALK, "Admin ".. pl:Name() .." muted player "..tostring(target:Name())..".")
			return ""
		elseif(sep[1] == "!unmute") then
			target:UnMute()
			PrintMessageAll(HUD_PRINTTALK, "Admin ".. pl:Name() .." unmuted player "..tostring(target:Name())..".")
			return ""
		elseif(sep[1] == "!gag") then
			target:Gag()
			PrintMessageAll(HUD_PRINTTALK, "Admin ".. pl:Name() .." gagged player "..tostring(target:Name())..".")
			return ""
		elseif(sep[1] == "!ungag") then
			target:UnGag()
			PrintMessageAll(HUD_PRINTTALK, "Admin ".. pl:Name() .." ungagged player "..tostring(target:Name())..".")
			return ""
		elseif sep[1] == "!changeclass" and pl:IsSuperAdmin() then
			local classId = tonumber(sep[3])
			if type(classId) ~= "number" or not ZombieClasses[classId] then
				pl:Message("Class doesn't exist")
				return ""
			end

			--Set class
			target:SpawnAsUndeadClass(classId)

			PrintMessageAll(HUD_PRINTTALK, "Admin ".. pl:Name() .." changed "..tostring(target:Name()).."'s class.")
			return ""
		elseif(sep[1] == "!slap") then
			local slapdam = 10
			if sep[3] then
				slapdam = tonumber(sep[3])
			end
			if slapdam == nil then 
				slapdam = 5
			end
			target:TakeDamage(slapdam)
			target:EmitSound("ambient/voices/citizen_punches2.wav")
			target:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),math.random(0,10)):GetNormal()*math.random(300,500))
			pl:Message("Slapped "..target:Name().." with "..slapdam.." damage")
			target:Message("Admin "..pl:Name().." slapped you with "..slapdam.." damage")
			return ""		
		elseif sep[1] == "!bring" then
			server_RunCommand (pl, "bring_player", target:UserID() )
			return ""
		elseif sep[1] == "!goto" then
			server_RunCommand (pl, "goto_player", target:UserID() )
			return ""
		elseif sep[1] == "!ammo+" and pl:IsSuperAdmin() then
			pl:Message(target:Name().." was given 100 ammo for his current weapon")
			if (target ~= pl) then
				target:Message(pl:Name().." has given you 100 ammo for your current weapon")
			end
			local ammotype = target:GetActiveWeapon():GetPrimaryAmmoType()
			if ammotype == "none" then 
				ammotype = "pistol" 
			end
			target:GiveAmmo(100,ammotype)
			return ""
		-- Give hp command
		elseif (sep[1] == "!hp+" or sep[1] == "!hp") and pl:IsSuperAdmin() then
			local healthToSet = math.min(target:GetMaxHealth(),target:Health()+25)
			pl:Message("Player "..target:Name().." restored to ".. healthToSet .." health")
			if (target ~= pl) then
				target:Message(pl:Name().." has set your health to ".. healthToSet)
			end
			target:SetHealth(math.Clamp(healthToSet,1,target:GetMaxHealth()))
			return ""
		-- Give frag command
		elseif sep[1] == "!sp" and pl:IsSuperAdmin() and target:Team() == TEAM_SURVIVORS then
			local amountToGive = 250
			skillpoints.AddSkillPoints(target, amountToGive)
			pl:Message(target:GetName() .." received ".. amountToGive .." SP")
			target:ChatPrint("You received ".. amountToGive .." SP from ".. pl:GetName())
			return ""
		elseif sep[1] == "!swep" then -- gives the admin the ability to appoint a swep to a player     
			local weaponToGive = nil
			
			if sep[3] then
				local tab = {}
				table.Add(tab,weaponList)
				if pl:IsSuperAdmin() then
					table.Add(tab,restrictedweaponList)
				end
				for k, v in pairs(tab) do
					if (string.find(string.lower(v),string.lower(sep[3]))) then
						if weaponToGive ~= nil then 
							weaponToGive = nil
							break
						end
						weaponToGive = v
					end
				end
			end
			
			if not pl:IsSuperAdmin() and target == pl then
				pl:Message("Only Super Admins can give other admins or themselves weapons")
				return ""
			end
			
			if (weaponToGive ~= nil) then
				target:Give(weaponToGive)
				--pl:ChatPrint(target:GetName().." was given "..weaponToGive)
				--target:ChatPrint("You received "..weaponToGive.." from (ADMIN) "..pl:GetName())
				target:Message("You received ".. weaponToGive .." from ".. pl:GetName())
				pl:Message(target:GetName() .." was given ".. weaponToGive)
			else
				pl:Message("Multiple or invalid weapon specified")
			end
			return ""
		elseif (sep[1] == "!debug") then
			local str = "***DEBUG***\nName: "..target:Name().."\nSteamID: "..target:SteamID().."\nUniqueID: "..target:UniqueID().."\nUserID: "..target:UserID()
			str = str.."\nModel: "..target:GetModel().."\nPosition: "..tostring(target:GetPos()).."\nTeam: "..team.GetName(target:Team()).."\n***END DEBUG***"
			pl:PrintMessage(HUD_PRINTCONSOLE,str)
			pl:Message("Debug information printed to console")
			return ""
		end
		
	end
	
end
hook.Add("PlayerSay", "ChatCommands2", AdminSay)