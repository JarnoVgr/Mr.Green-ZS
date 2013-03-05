-- Mr Green Community -- SQL Management. Script by Deluvas on 10:14 AM Monday, July 26, 2010.

-- Global table
mysql = {}

-- Lua patterns
mysql.LuaPatterns = { "%", "&", "(", ")", "+", "]", "[", "^", "?" }

-- Valid chars
mysql.ValidChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789><! "

-- Warnings
mysql.Warnings = { 
["connect_module_not_loaded"] = "[SQL] Couldn't connect to the database because SQL module was not found/initialized!",
["module_no_load_query"] = "[SQL] Couldn't query server because module not loaded.",
["no_connection"] = "[SQL] The module isn't connected to any host!",
["module_loaded"] = "[SQL] Successfully loaded SQL module",
["module_not_loaded"] = "[SQL] Couldn't load SQL module!",
["connection_on"] = "[SQL] Successfully connected to the DB",
}

-- Try to load module
mysql.bLoaded = require( "tmysql" )
if mysql.bLoaded then print( mysql.Warnings["module_loaded"] ) end
if not mysql.bLoaded then print( mysql.Warnings["module_not_loaded"] ) end

-- Returns if sql module has loaded
mysql.IsModuleActive = function()
	return mysql.bLoaded
end

-- Returns if its connected
mysql.IsConnected = function()
	return mysql.bConnected
end

-- Replace forbidden chars with *
mysql.ReplaceEscape = function( sText, Char )
	if not sText or not Char then return end

	-- Deluvas; Using string explode.
	local tbText = string.Explode ( "", sText )
	
	-- Replace lua patterns first
	for k,v in pairs ( tbText ) do
		for i,j in ipairs ( mysql.LuaPatterns ) do
			if v == j then 
				sText = string.Replace( sText, v, Char )
			end			
		end
	end
	
	-- Explode again
	tbText = string.Explode( "", sText )
	
	-- Now replace forbidden chars
	for k,v in pairs( tbText ) do
		if not string.find ( mysql.ValidChars, v ) then
			sText = string.Replace( sText, v, Char ) 
		end
	end
	
	return sText
end

-- Connect function
mysql.Connect = function()
	local Login = { Host = "87.238.175.104", User = "admin_gcaccount", Pass = "X0efU6hO", Database = "admin_source", Port = 3306 }
	
	-- Check for module and try to connect
	if not mysql.IsModuleActive() then print( mysql.Warnings["connect_module_not_loaded"] ) return end
	tmysql.initialize( Login.Host, Login.User, Login.Pass, Login.Database, Login.Port, 2, 2 )
	
	-- Check connection
	mysql.CheckConnection()
	timer.Simple( 1, function()
		if not mysql.IsConnected() then 
			print( mysql.Warnings["no_connection"] ) 
		else 
			gamemode.Call( "OnConnectSQL" )
			print( mysql.Warnings["connection_on"] ) 
		end
	end )
end

-- Check connection
mysql.CheckConnection = function()
	mysql.Query( "SELECT * FROM whitelist WHERE comment LIKE 'Deluvas%'", mysql.CheckCallback )
	print( "[SQL] Checking connection with the DB... Pending..." )
end	

-- Connection callback
mysql.CheckCallback = function( Result, Status, sError )
	mysql.bConnected = ( type( Result ) == "table" and Result )
end		

-- Default callback
mysql.DefaultCallback = function( Result, Status, sError )
end

-- Query
mysql.Query = function( sQuery, fCallback, bDebug )

	-- Check for module
	if not mysql.IsModuleActive() then
		print( mysql.Warnings["module_no_load_query"] )
		return
	end
	
	-- No callback
	if not fCallback then
		fCallback = mysql.DefaultCallback
	end
	
	-- Query
	tmysql.query( sQuery, fCallback, 1 )
end

-- Implementation
hook.Add( "Initialize", "ConnectToDB", function()
	timer.Simple( 0.8, function()
		mysql.Connect()
	end )
end )

-- On connect event
timer.Simple( 0.1, function()
	if GAMEMODE then
		GAMEMODE.OnConnectSQL = function()
		end
	end
end )



