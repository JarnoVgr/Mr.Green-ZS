----------------------------------------------------------------------------------------------
	hook.Add( "Initialize", "OnInitialize", function()
		irc:Connect(IRC_RELAY_SERVER)
	end)

	hook.Add( "irc.OnConnect", "OnConnect", function() 
		irc:Register( IRC_RELAY_NICK )
	end)

	local reconnectTries = 3

	hook.Add( "irc.OnConnectError", "OnConnectError", function( errorid )
		Debug("[IRC] Error connecting to ".. IRC_RELAY_SERVER ..". Attempting reconnect")
		
		if ( reconnectTries > 0 ) then
			timer.Simple( 1, function() 
				irc:Connect( IRC_RELAY_SERVER )
			end )
			reconnectTries = reconnectTries - 1
		end
	end )

	hook.Add( "irc.OnRegisterTimeout", "OnRegisterTimeout", function()
		Debug("[IRC] Timeout when connecting to ".. IRC_RELAY_SERVER ..". Attempting reconnect")
			
		if ( reconnectTries > 0 ) then
			timer.Simple(1, function() 
				irc:Connect( IRC_RELAY_SERVER )
			end)
			reconnectTries = reconnectTries - 1
		end
	end )

	hook.Add( "irc.OnWelcome", "OnWelcome", function( response ) 
		Debug("[IRC] Looks like we've received a warm welcome")

		--Join idle channel
		if IRC_IDLE_CHANNEL then
			irc:Join(IRC_IDLE_CHANNEL)
		end

		--Join relay channel
		irc:Join(IRC_RELAY_CHANNEL)

		--Output fancy map name
		if TranslateMapTable[ game.GetMap() ] then
			irc:Say( string.format( "5*** Travelled to %s", TranslateMapTable[ game.GetMap() ].Name ), IRC_RELAY_CHANNEL )
		end
	end )

	hook.Add( "irc.OnUserJoin", "OnUserJoin", function( user, channel ) 
		if channel ~= IRC_RELAY_CHANNEL then
			return
		end

		player.CustomChatPrint( { nil, 
			Color( 0, 255, 0 ), "(IRC) ",
			Color( 191,196,22 ), string.format( "%s ", user.Name ), 
			Color( 255,255,255 ), string.format( "has joined %s", channel )
		} )
	end )

	hook.Add( "irc.OnPublicMessage", "OnPublicMessage", function( message, user, channel ) 
		if channel ~= IRC_RELAY_CHANNEL then
			return
		end

		player.CustomChatPrint( { nil, 
			Color( 0, 255, 0 ), "(IRC) ",
			Color( 191,196,22 ), string.format( "%s: ", user.Name ), 
			Color( 255,255,255 ), string.format( "%s", message ) 
		} )
	end )

	hook.Add( "irc.OnUserPart", "OnUserJoin", function( user, channel ) 
		if channel ~= IRC_RELAY_CHANNEL then
			return
		end

		player.CustomChatPrint( { nil, 
			Color( 0, 255, 0 ), "(IRC) ",
			Color( 191,196,22 ), string.format( "%s ", user.Name ), 
			Color( 255,255,255 ), string.format( "has left %s", channel )
		} )
	end )

	hook.Add( "irc.OnUserQuit", "OnUserQuit", function( user, reason ) 
		if channel ~= IRC_RELAY_CHANNEL then
			return
		end

		player.CustomChatPrint( { nil, 
			Color( 0, 255, 0 ), "(IRC) ",
			Color( 191,196,22 ), string.format( "%s ", user.Name ), 
			Color( 255,255,255 ), " has quit" 
		} )
	end )

	hook.Add( "PlayerSay", "irc.PlayerSay", function(pl, text, team) 
		if team then
			return
		end
		
		irc:Say( string.format( " 07%s: %s", pl:Name(), text ), IRC_RELAY_CHANNEL )
	end )

	hook.Add( "PlayerDisconnected", "irc.PlayerDisconnected", function(pl)
		if not IsValid(pl) then
			return
		end
		
		irc:Say( string.format( "2*** %s left [%i/%i]", pl:Name(), #player.GetAll(), game.MaxPlayers() ), IRC_RELAY_CHANNEL )
	end )

	hook.Add( "PlayerInitialSpawn", "irc.PlayerConnected", function(pl)
		if not IsValid(pl) then
			return
		end

		irc:Say( string.format( "3*** %s joined [%i/%i]", pl:Name(), #player.GetAll(), game.MaxPlayers() ), IRC_RELAY_CHANNEL )	
	end )