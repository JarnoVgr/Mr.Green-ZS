-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Expand player metatable
local metaPlayer = FindMetaTable( "Player" )
if not metaPlayer then return end

function metaPlayer:HasSteamID()
	return stats.IsSteamID( self:SteamID() )
end

-- Backwards compatibility
function metaPlayer:GotSQLData()
	return self.GotClassData and self.GotShopItemsData and self.GotAchievementsData and self.GotStatsSQL
end

-- Backwards compatibility
function metaPlayer:GetDataTable()
	return self.DataTable
end

-- Backwards compatibility
function metaPlayer:GetItemsDataTable()
	if ( self.DataTable ) then
		return self.DataTable.ShopItems
	end
end

-- Backwards compatibility
function metaPlayer:GetAchievementsDataTable()
	if ( self.DataTable ) then
		return self.DataTable.Achievements
	end
end

-- Check data table beforehand
function metaPlayer:CheckDataTable()
	if not self.DataTable then
		self.DataTable = {}
	end

	if not self.DataTable.ClassData then
		self.DataTable.ClassData = {}
	end

	--[[if not self.DataTable.ClassData.default then
		self.DataTable.ClassData.default = {}
	end]]

	if not self.DataTable.ShopItems then
		self.DataTable.ShopItems = {}
	end

	if not self.DataTable.Achievements then
		self.DataTable.Achievements = {}
	end
end

-- Read everything from SQL
function metaPlayer:ReadDataSQL()

	-- Primary data

	self:ReadStatsSQL()

	self:ReadClassSQL()
	
	-- Secondary data
	self:ReadItemsSQL()

	self:ReadAchievementsSQL()

	
	-- Waiting for reading data...
	local UserID = self:UserID()
	hook.Add( "Think", "SQLPlayerReadyThink".. UserID, function()
		if not IsValidSpecial(self) then
			--Remove hook
			hook.Remove("Think", "SQLPlayerReadyThink".. UserID)
			
			return
		end
		
		if not self:GotSQLData() or not self.IsClientValid then
			return
		end
		
		gamemode.Call("OnPlayerReadySQL", self)
		Debug("[SQL] Successfully got SQL player table for "..tostring(self))
					
		--Datatable @ join
		if not self.JoinDataTable then
			self.JoinDataTable = table.Copy(self.DataTable)
		end
					
		--Remove hook
		hook.Remove("Think", "SQLPlayerReadyThink".. UserID)
	end)
	
end

-- Write everything to the SQL
function metaPlayer:WriteDataSQL()
	--Extra check. Write only when having received data.

	if not self:GotSQLData() then
		return
	end
	
	self:SaveStatsSQL()
	self:SaveClassDataSQL()
end

-- Local function, don't bother, I'll be fine! (Shakira)
local GetTableByID = function( Table, ID, Key )
	for k,v in pairs ( Table ) do
		if tonumber( v[Key] ) == ID then
			return v
		end
	end
end

-- Reads shop data 
function metaPlayer:ReadItemsSQL()
	if not( shopData and table.Count( shopData ) > 0 ) or not self:HasSteamID() then
		return
	end
	
	-- Check data table struct
	self:CheckDataTable()
	
	-- Get bought items
	stats.QueryBoughtItemsSQL( self:SteamID(), function( Table, Status, sError )
		if not IsValidSpecial( self ) then
			return
		end

		-- Convert data
		for k,v in pairs ( shopData ) do
			self.DataTable.ShopItems[v.ID] = ( GetTableByID( Table, v.ID, "itembought" ) ~= nil )
		end
		
		-- Status identifier
		self.GotShopItemsData = true
	end )
end

-- Write shop items
function metaPlayer:SaveShopItem( ID )
	if not ID then return end

	-- Check for steamID first
	local SteamID = self:SteamID()
	if not stats.IsSteamID( SteamID ) then 
		WriteSQLLog( "[SHOPITEMS] Couldn't save shop item with index "..tostring( ID ).." because a steamID for "..tostring( self ).." couldn't be found" )
		return 
	end
	
	-- Get player datatable
	local DataTable = self:GetDataTable()
	if not DataTable then 
		return 
	end
	
	-- Item doesn't exist
	if not shopData[ID] then 
		WriteSQLLog( "[SHOPITEMS] Couldn't save item "..tostring( ID ).." for "..tostring( self ).." because item doesn't exist in the general DB" )
		return
	end
	
	-- Check for entry
	mysql.Query( [[ SELECT * FROM zs_player_shop_items WHERE steamid = ']]..tostring( SteamID )..[[' AND itembought = ]]..tostring( ID ), function( Table, Status, sError )
		if Table then
			if not Table[1] then
				mysql.Query( [[ INSERT INTO zs_player_shop_items ( steamid, itembought ) VALUES( ']]..tostring( SteamID )..[[',]]..tostring( ID )..[[ ) ]], function ( a,b,c )
					WriteSQLLog( "[SHOPITEMS] Query insert "..( ( not tonumber( c ) and "FAILED" ) or ( tonumber( c ) and "SUCCEDED"  ) ).." with item id: "..tostring( ID ).." and player steam: "..tostring( SteamID ) )
				end )
			end
		end
	end )
end

-- Reads achievement data
function metaPlayer:ReadAchievementsSQL()
	if not( achievementDesc and table.Count( achievementDesc ) > 0 ) or not self:HasSteamID() then
		return
	end
	
	-- Check data table struct
	self:CheckDataTable()
	
	-- Get  achievements
	stats.QueryUnlockAchievementsSQL( self:SteamID(), function( Table, Status, sError )
		if not IsValidSpecial( self ) then
			return
		end

		-- Convert data
		for k,v in pairs ( achievementDesc ) do
			self.DataTable.Achievements[k] = ( GetTableByID( Table, k, "achievements" ) ~= nil )
		end
		
		-- Status identifier
		self.GotAchievementsData = true
	end )
end

-- Write achievements
function metaPlayer:SaveAchievement( ID )

	-- Check for steamID first
	local SteamID = self:SteamID()
	if not stats.IsSteamID( SteamID ) then 
		WriteSQLLog( "[ACHIEVS] Couldn't save achievement with index "..tostring( ID ).." because a steamID for "..tostring( self ).." couldn't be found" )
		return 
	end
	
	-- Item doesn't exist
	if not achievementDesc[ID] then 
		WriteSQLLog( "[ACHIEVS] Couldn't save achievement id: "..tostring( ID ).." for "..tostring( self ).." because achievement doesn't exist in the general DB" )
		return
	end
	
	-- Get player datatable
	local DataTable = self:GetDataTable()
	if not DataTable then 
		return 
	end
	
	-- Check for entry
	mysql.Query( [[ SELECT * FROM zs_player_achievements WHERE steamid = ']]..tostring( SteamID )..[[' AND achievements = ]]..tostring( ID ), function( Table, Status, sError )
		if Table then
			if not Table[1] then
				mysql.Query( [[ INSERT INTO zs_player_achievements ( steamid, achievements ) VALUES( ']]..tostring( SteamID )..[[',]]..tostring( ID )..[[ ) ]], function ( a,b,c )
					WriteSQLLog( "[ACHIEVS] Query insert "..( ( not tonumber( c ) and "FAILED" ) or ( tonumber( c ) and "SUCCEDED"  ) ).." with achievement id: "..tostring( ID ).." and player steam: "..tostring( SteamID ) )
				end )
			end
		end
	end )
end

-- Reads general stats from SQL db
function metaPlayer:ReadStatsSQL()
	if not ( statsData and table.Count( statsData ) > 0 ) or not self:HasSteamID() then
		return
	end
	
	-- Check data table structure
	self:CheckDataTable()
	
	-- Callback function for general stats
	stats.QueryStatsCall = function( Table, Status, sError )
		if not( IsValidSpecial( self ) and self:HasSteamID() ) then
			return
		end

		-- Log errors 
		if ( sError ~= 0 ) or ( Status ~= true ) then -- ASSERT
			ErrorNoHalt( "[SQL: "..os.date().."] Error when getting general stats data for "..tostring( self )..": "..tostring( sError ).."\n" ) 
			return
		end
		
		if ( Table and #Table > 0 ) then
			if ( #Table > 1 ) then
				ErrorNoHalt( "[SQL: "..os.date().."] Warning. Duplicate general stats entry for steamID: "..tostring( self:SteamID() ).."\n" )
			end
			
			for k,v in pairs( statsData ) do
				self.DataTable[k] = stats.Sanitize( Table[1][k] )
				
				-- Round numbers
				if ( type( self.DataTable[k] ) == "number" ) then
					self.DataTable[k] = math.Round( self.DataTable[k] )
				end
			end
			
			-- Translate title and hat
			self.Title, self.SelectedHat = self.DataTable.title or "", self.DataTable.hat or "none"
			if self.Title == "Guest" then self.Title = "" end
			
			-- Old greencoins
			if ( self.DataTable["coins"] ) then
				if tonumber( self.DataTable["coins"] ) > 0 then
					self.EarnedGreenCoins = tonumber( self.DataTable["coins"] )
					self.DataTable["coins"] = 0
				end
			end
			
			-- Status identifier
			self.GotStatsSQL = true
		else
			self:WriteBlankStatsSQL()
		end
	end
	-- Call query
	stats.QueryFreeStatsSQL( self:SteamID(), stats.QueryStatsCall )
end

-- Saves player general stats
function metaPlayer:SaveStatsSQL()
	if not self:HasSteamID() then 
		return 
	end
	
	-- Nothing to save -- ASSERT
	if not( self.DataTable and table.Count( self.DataTable ) - 3 == table.Count( statsData ) ) or not self.GotStatsSQL then
		ErrorNoHalt( "[SQL: "..os.date().."] Failed to save general stats data for: "..tostring( self ).." because data table incomplete or tried to save before reading!\n" ) 
		return
	end
	
	-- Convert data to sql format
	local Stats = { timeplayed = math.max( 0, math.floor( ( self.DataTable["timeplayed"] or 0 ) + CurTime() - ( self.StartTime or CurTime() ) ) ), name = mysql.ReplaceEscape( self:Name(), "*" ), title = mysql.ReplaceEscape( ( self.Title or "Guest" ), "*" ), hat = self.SelectedHat or "none" }
	Stats.lastip, Stats.lastlog = self:IPAddress(), tostring( os.date( "%X" ).." | "..os.date( "%x" ) )
	
	local StatsTable = {}
	for k, v in pairs ( self.DataTable ) do
		if ( v ) and ( type( v ) ~= "table" ) then
			StatsTable[k] = v
			if Stats[k] then StatsTable[k] = Stats[k] end
		end
	end
		
	-- Finally query
	local sQuery = stats.GetUpdateTableQuery( "zs_player_stats", StatsTable, [[WHERE steamid = ']]..self:SteamID()..[[']] )
	
	if ( sQuery ) then
		mysql.Query( sQuery, function ( Table, Status, sError )
			if not IsValidSpecial( self ) then
				return
			end
			
			-- Log errors
			if ( sError ~= 0 ) or ( Status ~= true ) then -- ASSERT
				ErrorNoHalt( "[SQL: "..os.date().."] Error when saving general stats data for "..tostring( self )..": "..tostring( sError ).."\n" ) 
				return
			end
		end )
	end
end

-- Read class data
function metaPlayer:ReadClassSQL()
	if not( classData and table.Count( classData ) > 0 ) or not self:HasSteamID() then
		return
	end
	
	-- Check data table structure
	self:CheckDataTable()

	-- Callback for class data
	stats.QueryClassDataCall = function( Table, Status, sError )
		if not( IsValidSpecial( self ) and self:HasSteamID() ) then
			return
		end

		-- Log errors
		if ( sError ~= 0 ) or ( Status ~= true ) then -- ASSERT
			ErrorNoHalt( "[SQL: "..os.date().."] Error when reading class data for "..tostring( self )..": "..tostring( sError ).."\n" ) 
			return
		end

		-- Read the sql table
		if ( Table and #Table > 0 ) then
			if #Table > 1 then
				ErrorNoHalt( "[SQL: "..os.date().."] Warning. Duplicate class-data entry for steamID: "..tostring( self:SteamID() ).."\n" )
			end
			
			-- Convert data
			for k,v in pairs( classData ) do
				for i,j in pairs( Table[1] ) do
					if ( string.find( i, k ) ) then
						local Key = string.Replace( i, k.."_", "" )
						
						-- Convert to datatable format							
						self.DataTable.ClassData[k] = self.DataTable.ClassData[k] or {}
						self.DataTable.ClassData[k][Key] = tonumber( j )
					end
				end
			end
			
			-- Status identifier
			self.GotClassData = true
		else
			self:WriteBlankClassDataSQL()
		end
	end
	
	-- Run query
	stats.QueryClassDataSQL( self:SteamID(), stats.QueryClassDataCall )
end

-- Write class data
function metaPlayer:SaveClassDataSQL()
	if not self:HasSteamID() or not( classData and table.Count( classData ) > 0 ) then 
		return 
	end
	
	-- Nothing to save  -- ASSERT
	if not( self.DataTable and self.DataTable.ClassData and table.Count( self.DataTable.ClassData ) == table.Count( classData ) ) or not self.GotClassData then
		ErrorNoHalt( "[SQL: "..os.date().."] Failed to save class data for: "..tostring( self ).." because data table incomplete or tried to save before reading!\n" ) 
		return
	end
	
	-- Status
	local Result, Index = -1, 0
	
	-- No jointable
	if not( self.JoinDataTable and table.Count( self.JoinDataTable ) > 2 ) then
		ErrorNoHalt( "[SQL: "..os.date().."] Failed to save class data for: "..tostring( self ).." because join table data wasn't valid!\n" ) 
		return
	end
	
	-- Can't compare with jointable
	local JoinTable = self.JoinDataTable.ClassData
	if not( JoinTable and table.Count( JoinTable ) == table.Count( self.DataTable.ClassData ) ) then
		ErrorNoHalt( "[SQL: "..os.date().."] Failed to save class data for: "..tostring( self ).." because join class data table wasn't the same length as current table!\n" ) 
		return
	end
	
	-- Save data
	for Class, Table in pairs ( self.DataTable.ClassData ) do
		if ( Table and classData[Class] ) then	
			Index = Index + 1
			
			if ( table.Count( Table ) == table.Count( classData[Class] ) ) then
				local aTemp = {}
				
				if ( JoinTable[Class] ) then
					for k,v in pairs( Table ) do
						if ( JoinTable[Class][k] ) then
							if ( JoinTable[Class][k] < v ) then
								aTemp[Class.."_"..k] = v
							end
						end
					end
				end
				
				-- Get update query
				local UpdateQ = stats.GetUpdateTableQuery( "zs_player_classes", aTemp, [[ WHERE steamid = ']]..self:SteamID()..[[']] )
	
				if ( UpdateQ ) then
					mysql.Query(UpdateQ, function(Table, Status, sError, nIndex) 
						if not IsValidSpecial( self ) then
							return
						end
						
						-- Notify
						if ( Status ~= true ) or ( sError ~= 0 ) then
							if ( Result < 0 ) then
								ErrorNoHalt( "[SQL: "..os.date().."] Error when saving class data (in-for) for "..tostring( self )..": "..tostring( sError ).."\n" ) 
								Result = 0
							end
						else
							if ( Status == true ) and ( nIndex == table.Count( self.DataTable.ClassData ) ) then
								if ( Result < 0 ) then
									Result = 1
								end
							end
						end					
					end, 1, Index )
				end
			else
				ErrorNoHalt( "[SQL: "..os.date().."] Length error when saving class data for "..tostring( self )..", class: "..tostring( Class ).."\n" )
			end
		end
	end
end

-- Write blank player stats in SQL
function metaPlayer:WriteBlankStatsSQL()
	mysql.Query( [[SELECT steamid FROM zs_player_stats WHERE steamid = ']]..tostring( self:SteamID() )..[[']], function ( Table, Status, sError )
		if not( IsValidSpecial( self ) and self:HasSteamID() ) then
			return
		end
		
		-- Log errors
		if ( sError ~= 0 ) or ( Status ~= true ) then -- ASSERT
			ErrorNoHalt( "[SQL: "..os.date().."] Error when checking general stats *blank* data for "..tostring( self )..": "..tostring( sError ).."\n" ) 
			return
		end
		
		-- Try to read data again
		if ( Table and #Table > 0 ) then
			stats.QueryFreeStatsSQL( self:SteamID(), stats.QueryStatsCall )
			return 
		end
		
		-- Update a few fields
		local tbDefault = { steamid = self:SteamID(), lastip = self:IPAddress(), name = self:Name(), lastlog = os.date( "%X" ).." | "..os.date( "%x" ) }
		local sQuery = stats.GetInsertTableQuery( "zs_player_stats", tbDefault )
		
		-- Insert data
		if ( sQuery ) then
			mysql.Query( sQuery, function ( Table, Status, sError )
				if not( IsValidSpecial( self ) and self:HasSteamID() ) then
					return
				end

				-- Log errors
				if ( sError ~= 0 ) or ( Status ~= true ) then -- ASSERT
					ErrorNoHalt( "[SQL: "..os.date().."] Error when writting general stats *blank* data for "..tostring( self )..": "..tostring( sError ).."\n" ) 
					return
				end
				
				-- Try and read the data again
				stats.QueryFreeStatsSQL( self:SteamID(), stats.QueryStatsCall )
			end )
		end
	end )
end

-- Write blank class data
function metaPlayer:WriteBlankClassDataSQL()
	mysql.Query( [[SELECT steamid FROM zs_player_classes WHERE steamid = ']]..tostring( self:SteamID() )..[[']], function ( Table, Status, sError )
		if not( IsValidSpecial( self ) and self:HasSteamID() ) then
			return
		end
		
		-- Log errors
		if ( sError ~= 0 ) or ( Status ~= true ) then -- ASSERT
			ErrorNoHalt( "[SQL: "..os.date().."] Error when checking *blank* class data for "..tostring( self )..": "..tostring( sError ).."\n" ) 
			return
		end
		
		-- Try to read data again
		if ( Table and #Table > 0 ) then
			stats.QueryClassDataSQL( self:SteamID(), stats.QueryClassDataCall )
			return 
		end
		
		-- Build query
		local Query = stats.GetInsertTableQuery( "zs_player_classes", { steamid = self:SteamID() } )
		
		-- New blank entry
		mysql.Query( Query, function ( Table, Status, sError )
			if not IsValidSpecial( self ) then
				return
			end
			
			-- Log errors
			if ( sError ~= 0 ) or ( Status ~= true ) then -- ASSERT
				ErrorNoHalt( "[SQL: "..os.date().."] Error when *blank* class data for "..tostring( self )..": "..tostring( sError ).."\n" ) 
				return
			end
			
			-- Read data
			stats.QueryClassDataSQL( self:SteamID(), stats.QueryClassDataCall )
		end )
	end )
end

