AddCSLuaFile()

if SERVER then
	
	print"-- Loaded screen capturing!"
	
	util.AddNetworkString( "RequestScreen" )
	util.AddNetworkString( "ReceiveScreen" )
	util.AddNetworkString( "ReceiveSecondScreen" )
	util.AddNetworkString( "SendScreenToAdmin" )
	util.AddNetworkString( "SendSecondScreenToAdmin" )
	
	//Use target:EntIndex() as argument
	local function RequestScreen( pl, cmd, args )
		
		if !IsValid( pl ) then return end
		if !pl:IsAdmin() then return end
		if not args then return end
		
		local id = tonumber(args[1])
		local target
		
		if id then
			for _, guy in pairs( player.GetAll() ) do
				if IsValid( guy ) and Entity( id ) == guy then
					target = guy
					break
				end
			end
		end
		
		if IsValid( target ) then
			net.Start( "RequestScreen" )
				net.WriteEntity( pl ) //Who should get the results?
			net.Send(target)
		else
			pl:ChatPrint("Can't find a player with specified ID!")
		end
		
	end
	concommand.Add("scanplayer",RequestScreen)
	
	local tempdata
	local templen
	
	net.Receive( "ReceiveSecondScreen", function( len, target )
		
		local datalen = net.ReadInt( 32 )
		local screendata = net.ReadData( datalen or 60000 )
		
		tempdata = screendata
		templen = datalen
		
	end)
	
	net.Receive( "ReceiveScreen", function( len, target )
		
		local split = net.ReadBit()
		local datalen = net.ReadInt( 32 )
		local sendto = net.ReadEntity()
		local screendata = net.ReadData( datalen or 60000 )
		
		timer.Simple(0.5, function()
		
			net.Start( "SendScreenToAdmin" )
				net.WriteEntity( target )
				net.WriteInt( datalen, 32 )
				net.WriteData( screendata, datalen )
			net.Send( sendto )
			
			if tempdata then
				
				net.Start( "SendSecondScreenToAdmin" )
					net.WriteInt( templen, 32 )
					net.WriteData( tempdata, templen )
				net.Send( sendto )
				
				tempdata = nil
				templen = nil
				
			end
			
		end)
		
		
		
	end)
end

if CLIENT then
	
	//Split if data is bigger than this. net message can hold up to 64000, so i leave some space for other vars
	local splitlen = 60000
	
	net.Receive( "RequestScreen", function( len )
		
		local sendback = net.ReadEntity()
		
		local data = render.Capture( {format = "jpeg", x = 0, y = 0, w = ScrW(), h = ScrH(), quality = 12 } ) //I suggest to avoid setting quality bigger than 15, otherwise it has 20% chance of not working on huge screens
		local len = string.len( data )
		
		local seconddata
		local secondlen
		
		if len > splitlen then

			seconddata = string.sub( data, splitlen, len )
			secondlen = string.len( seconddata )
						
			data = string.sub( data, 1, splitlen - 1 )
			len = splitlen - 1
			
		end
		
		net.Start( "ReceiveScreen" )
			net.WriteBit( seconddata and 1 or 0 )
			net.WriteInt( len, 32 )
			net.WriteEntity( sendback )
			net.WriteData( data, len )
		net.SendToServer()
		
		if seconddata and secondlen then
			net.Start( "ReceiveSecondScreen" )
			net.WriteInt( secondlen, 32 )
			net.WriteData( seconddata, secondlen )
			net.SendToServer()
		end
		
	end)
	
	local tempdata
	
	net.Receive( "SendSecondScreenToAdmin", function( len )
		
		local datalen = net.ReadInt( 32 )
		local screendata = net.ReadData( datalen or 60000 )
		
		tempdata = screendata
		
	end)
	
	net.Receive( "SendScreenToAdmin", function( len )
		
		local target = net.ReadEntity()
		local len = net.ReadInt( 32 )
		local data = net.ReadData( len or 60000 )
		
		if not file.Exists( "suspected","DATA" ) then
			file.CreateDir( "suspected" )
		end
		
		timer.Simple(0.5, function()
			
			if tempdata then
				data = data..tempdata
				tempdata = nil
			end
			
			if IsValid( target ) then
				
				local path = "suspected/player_"..string.Replace( string.sub(target:SteamID(), 9), ":", "-" )..".txt"
				
				local f = file.Open( path, "wb", "DATA" )
				f:Write( data )
				f:Close()
				
				print("Received screen image for player "..tostring(target:Name()))
				print("SteamID is "..tostring(target:SteamID()))
				
			end
		
		end)
	end)	

end