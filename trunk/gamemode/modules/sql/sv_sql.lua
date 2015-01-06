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
["no_connection"] = "[SQL] Unable to connect to database host",
["module_loaded"] = "[SQL] Successfully loaded SQL module",
["module_not_loaded"] = "[SQL] Couldn't load SQL module",
["connection_on"] = "[SQL] Successfully connected to the DB",
["verified"] = "[SQL] Database verified",
}

if file.Exists("bin/gmsv_tmysql4_*.dll", "LUA") then
	-- Try to load module
	require( "tmysql4" )
	mysql.bLoaded = true
else
	Debug(mysql.Warnings["module_not_loaded"])
	mysql.bLoaded = false
end



-- Returns if sql module has loaded
mysql.IsModuleActive = function()
	return mysql.bLoaded
	--return true
end

-- Returns if its connected
mysql.IsConnected = function()
	return mysql.bConnected
end


--Default to true
mysql.safeGame = true

mysql.escape = function(Str)
	return mysql.Database:Escape(Str)
end

-- Replace forbidden chars with *
mysql.ReplaceEscape = function( sText, Char )
	if not sText or not Char then return end

	-- Deluvas; Using string explode.
	local tbText = string.Explode ( "", sText )
	
	-- Replace lua patterns first
	for k,v in pairs(tbText) do
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
	local Login = {
		Host = "ares.limetric.com",
		User = "mrgreen_gczs",
		Pass = "WG0gcZSr",
		Database = "mrgreen_gc",
		Port = 3306
	}

	Debug("[SQL] Connecting to ".. Login.Host ..":".. Login.Port .."...")
	
	local ErrorStr
	mysql.Database, ErrorStr = tmysql.initialize(Login.Host, Login.User, Login.Pass, Login.Database, Login.Port, nil, CLIENT_INTERACTIVE)
	if ErrorStr then
		Debug( "[SQL] TMySQL returned error: ".. errorStr )
		return
	end

	Debug( mysql.Warnings["connection_on"] )
	
	-- Check connection
	mysql.CheckConnection()
	timer.Simple( 1, function()
		if not mysql.IsConnected() then 
			Debug( mysql.Warnings["no_connection"] )
			mysql.safeGame = false
		else 
			gamemode.Call( "OnConnectSQL" )
			Debug( mysql.Warnings["connection_on"] )
		end
	end)
end

-- Check connection
mysql.CheckConnection = function()
	Debug( "[SQL] Verificating database..." )
	mysql.Query( "SELECT * FROM whitelist WHERE comment LIKE 'Deluvas%' LIMIT 0,1", mysql.CheckCallback)
end	

-- Connection callback
mysql.CheckCallback = function(Table, Status, sError)
	if Status then
		Debug(mysql.Warnings["verified"])
		mysql.bConnected = true

		return
	end

	Debug(mysql.Warnings["no_connection"])
	mysql.bConnected = false
end		

-- Query
mysql.Query = function( sQuery, fCallback, bDebug )
	-- Check for module
	if not mysql.IsModuleActive() or not mysql.Database then
		Debug( "[SQL] ".. mysql.Warnings["module_no_load_query"] )
		return
	end

	--Query
	mysql.Database:Query(sQuery, function(Results)
		if type(Results) ~= "table" or not Results[1] or type(Results[1]) ~= "table" then
			print("[SQL] No result for query: ".. sQuery)
			WriteSQLLog("No result for query: ".. sQuery)
			return
		end

		if Results[1].errorid then
			WriteSQLLog("Query error #".. Results[1].errorid ..": ".. sQuery)
			print("[SQL] Query error (#".. Results[1].errorid .."):".. sQuery)
			PrintTable(Results)
		end

		if not fCallback then
			return
		end

		fCallback(Results[1].data or {}, Results[1].status or false, Results.errorid or 0, Results[1].affected or 0)
	end)
end

-- Implementation
hook.Add("Initialize", "ConnectToDB", function()
	Debug("[SQL] Timer activated")
	timer.Simple(1, function()
		Debug("[SQL] Calling mysql.Connect")
		mysql.Connect()
	end)
end)

-- On connect event
timer.Simple(0.1, function()
	if GAMEMODE then
		GAMEMODE.OnConnectSQL = function()
		end
	end
end)

-- --  Database error log functions -- -- 
function WriteSQLLog( str )
	local content = "--- GreenCoins MySQL log ---"
	if (file.Exists("mysqllog.txt","DATA")) then
		content = file.Read("mysqllog.txt","DATA")
	end
	
	print("MySQL log message: "..str)
	
	local date = os.date()
	content = content.."\n"..date..": "..str
	
	file.Write("mysqllog.txt", content)
end