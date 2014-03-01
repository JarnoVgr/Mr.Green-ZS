-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Global table
stats = {}

-- Add the shared file to download
AddCSLuaFile( "sh_utils.lua" )

-- Include all files inside this folder
for k, sFile in pairs ( file.Find( "zombiesurvival/gamemode/server/stats/*.lua","lsv" ) ) do
	if string.match( sFile, "(%.lua)$" ) then
		if not string.find( sFile, "sv_server_stats" ) then include( sFile ) end
	end
end

-- Called when player got data from SQL
function GM:OnPlayerReadySQL( pl )
end

-- Bool to 1/0
function stats.BoolToBin( bBool )
	if bBool == true then return 1 else return 0 end
end

-- Convert value to string/number/whatever
function stats.Sanitize( Value )
	if not Value then return end
	if Value == "true" then return true elseif Value == "false" then return false end
	return tonumber( Value ) or tostring( Value )	
end

-- Valid steam id
function stats.IsSteamID( SteamID )
	return ( SteamID and string.find( SteamID, "STEAM" ) and not string.find( SteamID, "PENDING" ) )
end

-- Updates a SQL table
function stats.GetUpdateTableQuery( Table, Content, Condition )
	if not Table or not Content then return end
	
	-- Our query string -- Firstly, set the table we want to update
	local sQuery = [[UPDATE ]]..tostring( Table )..[[ SET ]]
	
	-- No content
	if ( table.Count( Content ) == 0 ) then
		return
	end
	
	-- Parse content table
	local iIndex = 0
	for k,v in pairs ( Content ) do
		if ( v ) then
			iIndex = iIndex + 1
			sQuery = sQuery..( k )..[[ = ]]..( ( type( v ) == "string" and [["]]..( v )..[["]] ) or ( tostring( v ) ) )..( ( iIndex == table.Count( Content ) and " " ) or " , " )
		end
	end
	
	-- Parse condition table
	local iIndex = 0
	if Condition then
		sQuery = sQuery..Condition
	end
	
	return sQuery
end

function stats.GetInsertTableQuery( Table, Content )
	if not Table or not Content then return end
	
	-- Our query string -- Firstly, set the table we want to update
	local sQuery = [[INSERT INTO ]]..tostring( Table )..[[ ( ]]
	local sValues = " ( "
	
	-- No content
	if ( table.Count( Content ) == 0 ) then
		return sQuery.." ) VALUES ( )"
	end
	
	-- Parse content table
	local iIndex = 0
	for k,v in pairs ( Content ) do
		if ( v ) then
			iIndex = iIndex + 1
			
			sQuery = sQuery..( k )..( ( iIndex == table.Count( Content ) and " ) " ) or " , " )
			sValues = sValues..( ( type( v ) == "string" and [["]]..( v )..[["]] ) or ( tostring( v ) ) )..( ( iIndex == table.Count( Content ) and " ) " ) or " , " )
		end
	end
	
	-- Parse condition table
	sQuery = sQuery.."VALUES"..sValues
	
	return sQuery
end

-- Insert data from txt files to DB
local function InsertTextDataToSQL()

	-- Parse all the data files inside that folder
	for k, sFile in pairs( file.Find( "zombiesurvival/*.txt","DATA" ) ) do
		if string.find( sFile, "-" ) then
			local Content = file.Read( "zombiesurvival/"..sFile, "DATA" )
			
			-- Not empty
			if Content then
				local Table = util.KeyValuesToTable( Content )
				
				-- Get user steamID
				if Table then
					local steamID = Table.id
					if steamID and string.find( steamID, "STEAM" ) then
					
						-- Bought items
						if Table.shopitems then
							for sItem, bBought in pairs( Table.shopitems ) do
								if util.GetItemTableByKey( sItem ) then
									if tobool( bBought ) then
										mysql.Query( [[INSERT INTO zs_player_shop_items ( steamid, itembought ) VALUES ( ']]..tostring( steamID )..[[' , ]]..tostring( util.GetItemTableByKey( sItem ).ID )..[[ )]] )
									end
								end
							end
						end
						
						-- Unlocked achievements
						if Table.achievements then
							for sName, bUnlocked in pairs ( Table.achievements ) do
								if tobool( bUnlocked ) then
									mysql.Query( [[INSERT INTO zs_player_achievements ( steamid, achievements ) VALUES ( ']]..tostring( steamID )..[[' , ]]..tostring( util.GetAchievementTableByKey( sName ).ID )..[[ )]] )
								end
							end
						end
						
						-- Insert steamID first into other stats
						mysql.Query( [[INSERT INTO zs_player_stats ( steamid ) VALUES ( ']]..steamID..[[' )]] )
						
						-- Add the rest
						for k,v in pairs ( statsData ) do
							local Value = [["]]..tostring( Table[k] )..[["]]
							if string.find( v.Type, "int" ) then Value = Table[k] end
							if Table[k] then
								mysql.Query( [[UPDATE zs_player_stats SET ]]..tostring( k )..[[ = ]]..tostring( Value )..[[ WHERE steamid = ']]..steamID..[[']] )
							end
						end		
						
						-- Insert steamID first into class data
						mysql.Query( [[INSERT INTO zs_player_classes ( steamid ) VALUES ( ']]..steamID..[[' )]] )
						
						-- Insert classes data (if present)
						if Table.classdata then
							for k,v in pairs ( Table.classdata ) do
								for i, j in pairs ( v ) do
									local Class = k
									if k == "berseker" then Class = "berserker" end
									mysql.Query( [[UPDATE zs_player_classes SET ]]..tostring( Class.."_"..i )..[[ = ]]..tostring( j )..[[ WHERE steamid = ']]..steamID..[[']] )
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Callback for shopitems structure
function stats.ItemsCallback( Table, Result, sError )
	for k,v in pairs ( Table ) do 
		shopData[ tonumber( v.id ) ] = { ID = tonumber( v.id ), Key = v.key, Name = v.name, Desc = v.description, Valid = v.valid, Cost = tonumber( v.cost ), AdminOnly = tobool( v.adminonly ), Sell = tonumber( v.sellable ), Requires = tonumber( v.requires ) or 0 }
	end
end

-- Callback for achievements structure
function stats.AchievementsCallback( Table, Result, sError )
	for k,v in pairs ( Table ) do
		achievementDesc[ tonumber( v.id ) ] = { ID = tonumber( v.id ), Key = v.key, Name = v.name, Desc = v.description, Image = v.image }
	end
end

-- Callback for stats structure
function stats.StatsCallback( Table, Status, sError )
	if ( Status == true ) and ( sError == 0 ) and ( #Table > 0 ) then
		for i = 1, #Table do
			if Table[i].Field ~= "id" then
				statsData[Table[i].Field] = { Type = Table[i].Type, Default = Table[i].Default, Key = Table[i].Field }
			end
		end
	else
		ErrorNoHalt( "[SQL: "..os.date().."] Critical error! Couldn't receive stats table from SQL Server. Possible error: "..tostring( sError ).."\n" ) 
	end
end

-- Get the shopitems from SQL
function stats.GetShopItemsSQL()
	mysql.Query( "SELECT * FROM zs_shopitems", stats.ItemsCallback )
end

-- Get achievements from SQL
function stats.GetAchievementsSQL()
	mysql.Query( "SELECT * FROM achievements WHERE game = ZS", stats.AchievementsCallback )
end

-- Get stats structure from SQL
function stats.GetStatsSQL()
	mysql.Query( "DESCRIBE zs_player_stats", stats.StatsCallback )
end

-- Get bought stop items from SQL
function stats.QueryBoughtItemsSQL( SteamID, fCallback )
	if stats.IsSteamID( SteamID ) then
		mysql.Query( "SELECT * FROM zs_player_shop_items WHERE steamid = '"..tostring( SteamID ).."'", fCallback )
		--mysql.Query( [[SELECT * FROM zs_player_shop_items WHERE steamid = "]]..tostring( SteamID )..[["]], fCallback )
	end
end

-- Get unlocked achievements from SQL
function stats.QueryUnlockAchievementsSQL( SteamID, fCallback )
	if stats.IsSteamID( SteamID ) then
		mysql.Query( "SELECT * FROM zs_player_achievements WHERE steamid = '"..tostring( SteamID ).."'", fCallback )
		--mysql.Query( [[SELECT * FROM zs_player_achievements WHERE steamid = "]]..tostring( SteamID )..[["]], fCallback )
	end
end

-- Get free stats from SQL
function stats.QueryFreeStatsSQL( SteamID, fCallback )
	if stats.IsSteamID( SteamID ) then
		mysql.Query( "SELECT * FROM zs_player_stats WHERE steamid = '"..tostring( SteamID ).."' LIMIT 1", fCallback )
		--mysql.Query( [[SELECT * FROM zs_player_stats WHERE steamid = STEAM_0:0:13286202]], fCallback )
	end
end

-- Get class data from SQL
function stats.QueryClassDataSQL( SteamID, fCallback )
	if stats.IsSteamID( SteamID ) then
		mysql.Query( "SELECT * FROM zs_player_classes WHERE steamid = '"..tostring( SteamID ).."' LIMIT 1", fCallback )
		--mysql.Query( [[SELECT * FROM zs_player_classes WHERE steamid = "]]..tostring( SteamID )..[["]], fCallback )
	end
end

-- Hook to database connect
hook.Add( "OnConnectSQL", "GetDataFromSQL", function()
	-- Get items 
	--shopData = {}
	--stats.GetShopItemsSQL()
	
	-- Get achievements
	--achievementDesc = {}
	--stats.GetAchievementsSQL()
	
	--disabled these functions above for easy editing
	
	-- Get stats
	statsData = {}
	stats.GetStatsSQL()
end )

-- Read player stats/information on auth
hook.Add( "PlayerAuthed", "ReadPlayerSQLData", function( pl, SteamID, UniqueID )
	if IsValid( pl ) then
		pl:ReadDataSQL()
	end
end )

-- Save information on disconnect
hook.Add( "PlayerDisconnected", "SavePlayerSQLData", function( pl )
	if IsValid( pl ) then
		pl:WriteDataSQL()
	end
end )
	
		
	