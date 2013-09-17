--[==[-------------------------------
Green-Coins system
sv_greencoins.lua
Server
--------------------------------]==]

AddCSLuaFile("sh_greencoins.lua")
AddCSLuaFile("cl_greencoins.lua")

include( 'sh_greencoins.lua' )

--  Debug setting
local DEBUG = false
local GC_SUPERSECRET_ZSCODE = "wutL0l44xW"

-- Deluvas; lol :V
function GM:GetFirstKey( iCode )
	return GC_SUPERSECRET_ZSCODE
end

-- --  Metatable expanding -- -- 
local meta = FindMetaTable("Player")
if meta then

	function meta:GiveGreenCoins( amount, hash )
		if self:IsBot() then return end
		
		-- Loaded module or not
		if not mysql.IsModuleActive() or not self.GCData then return end
		
		-- No current amount
		if not self.GCData["amount_current"] then return end
		
		if amount > 100 then
			WriteSQLLog( "Player "..self:Name().." ("..self:SteamID()..") received "..amount.." GC. Exploit?" )
		end
		
		self.EarnedGreenCoins = self.EarnedGreenCoins + amount
		self.GCData["amount_current"] = self.GCData["amount_current"] + amount
		GAMEMODE:SendCoins(self, amount)
	end
	
	function meta:TakeGreenCoins( amount, hash )
		if self:IsBot() then return end
		
		-- Loaded module or not
		if not mysql.IsModuleActive() or not self.GCData then return end
		
		-- No current amount
		if not self.GCData["amount_current"] then return end
		
		self.EarnedGreenCoins = self.EarnedGreenCoins - amount
		self.GCData["amount_current"] = self.GCData["amount_current"] - amount
		GAMEMODE:SendCoins(self)
	end
	
	-- Save GC
	function meta:SaveGreenCoins()
		if not self.Ready then return end
		if self:IsBot() then return end
				
		-- Loaded module or not
		if not mysql.IsModuleActive() then return end
		
		local query = "SELECT * FROM green_coins WHERE steam_id = '"..self:SteamID().."' AND valid = 1 LIMIT 0,1"
		
		--  we send a table with player data, so player doesnt have to be valid afterwards for the data to save
		SQLQuery( query, SaveGreenCoinsStep1Callback, {ent = self, name = self:Name(), steamid = self:SteamID(), earned = self.EarnedGreenCoins} )
	end
end

---
-- NOTE: Used on PlayerAssist, HumanDeath, ZombieDeath
-- 
function GM:SendCoins(pl, amount)
	if not pl.GCData then return end
	umsg.Start("SendGC",pl)
		umsg.Long(pl.GCData["amount_current"])
	umsg.End()	
	
	--  coin effect
	if amount then
		umsg.Start("CoinEffect",pl)
			umsg.Short(amount)
		umsg.End()
	end
end

-- Load limit ends here
if not mysql.IsModuleActive() then return end

--[==[ -- Database structure --
FIELD				TYPE
------------------------------------------
id					int(16) PRIMARY KEY
steam_id			varchar(32)
amount_current		int(16)
steam_name			varchar(32)
last_edit			datetime
created_on			datetime
valid				int(1)
]==]

-- --  Database functions -- -- 

-- function ConnectToGCDatabase()
	-- local host = "87.238.175.104"
	-- local username = "admin_gcaccount" --  account doesn't have permission to delete or drop tables
	-- local password = "X0efU6hO" --  FOR YO EYES ONLY
	-- local database = "admin_source"
	-- local port = 3306
	
	-- --  tmysql.initialize(host, user, pass, database, [port], [number of connections], [number of threads])
	-- tmysql.initialize(host, username, password, database, port, 1, 1)
-- end
-- -- hook.Add("Initialize","ConnectToGCDB",ConnectToGCDatabase)

local function SQLReceive(callbackarg, result, status, err)
	if (type(err) == "number" and err == 0) then
		if DEBUG then
			if type(result) == "number" or type(result) == "string" then
				Debug("[SQL] Number received")
				Debug("[SQL] "..tostring(result))
			elseif type(result) == "table" then
				Debug("[SQL] Table received")
				PrintTable(result)
			end
		end
	else
		WriteSQLLog("ERROR WHEN ATTEMPTING QUERY (SQLRec) callbackarg: "..tostring(callbackarg).."; status: "..tostring(status).."; error: "..tostring(err))
	end
end

function SQLQuery( query, callback, callbackarg )
	
	if callback == nil then 
		callback = SQLReceive
	end
	
	local time = 0
	if DEBUG then
		time = SysTime()
		Debug("[SQL] Query start at "..time..", query: '"..query.."'")
	end
	
	tmysql.query(query, callback, 1, callbackarg)
	
	return result
end

-- --  Game functions -- -- 

local function CreateGreenCoinsEntry( pl )
	if not IsValid(pl) then return end

	local name = tmysql.escape(pl:Name())
	local steamid = pl:SteamID()
	local currentdate = os.date("%Y-%m-%d %H:%M:%S")
	local query = "INSERT INTO green_coins (steam_id, amount_current, steam_name, last_edit, created_on, valid) VALUES ('"..steamid.."', 0, '"..name.."', '"..currentdate.."', '"..currentdate.."', 1)"
	
	--  callback is RetrieveGreenCoins so the player data gets refreshed instantly
	SQLQuery( query, RetrieveGreenCoins, pl )
	
end

--  GC retrieving
local function RetrieveGreenCoinsCallback(pl, result, status, err)
	if not IsValid(pl) then return end
	
	if (type(err) == "number" and err == 0) then

		if (#result == 0) then
			if DEBUG then
				Debug("[SQL] No record found for "..pl:SteamID().."! Creating one...")
			end
			CreateGreenCoinsEntry( pl )
			return
		end
	
		pl.GCData = result[1]
		pl.GCData["amount_current"] = math.max(0,pl.GCData["amount_current"] + pl.EarnedGreenCoins)
		GAMEMODE:SendCoins(pl)
		
		if DEBUG then
			Debug("[SQL] Retrieve result table:")
			PrintTable(result)
		end
	else
		WriteSQLLog("ERROR WHEN ATTEMPTING QUERY (RGCC) pl: "..pl:Name().."; status: "..tostring(status).."; error: "..tostring(err))
	end
end

function RetrieveGreenCoins( pl )

	if not IsValid(pl) then return end
	if pl:IsBot() then return end
	pl.EarnedGreenCoins = pl.EarnedGreenCoins or 0
	
	local steamid = pl:SteamID()
	local query = "SELECT * FROM green_coins WHERE steam_id = '"..steamid.."' AND valid = 1"
	SQLQuery( query, RetrieveGreenCoinsCallback, pl )
end
hook.Add("PlayerInitialSpawn","RetrieveGreenCoins",RetrieveGreenCoins)

function SendGCOnSpawn( pl )
	GAMEMODE:SendCoins( pl )
end
hook.Add( "PlayerReady","SendGC",SendGCOnSpawn )

--  GC saving
local function SaveGreenCoinsStep2Callback(pltab, result, status, err)
	if (type(err) == "number" and err == 0) then
		local pl = pltab.ent
		if IsValid(pl) then
			pl.EarnedGreenCoins = 0
			GAMEMODE:SendCoins(pl)
			
			--Saved!
		end
	else
		WriteSQLLog("ERROR WHEN ATTEMPTING QUERY (SGCS2C) pl: "..pltab.name.."; status: "..tostring(status).."; error: "..tostring(err))
	end
end

-- I'll make a local functions table, don't worry.
function SaveGreenCoinsStep1Callback(pltab, result, status, err)
	
	if (type(err) == "number" and err == 0) then
	
		local pl = pltab.ent
		local query = ""
		if (#result == 0) then
			CreateGreenCoinsEntry( pltab.ent )
			return
		end
		
		local currentdate = os.date("%Y-%m-%d %H:%M:%S")
		if IsValid(pl) then
			--  this resets pl.GCData["amount_current"], but we saved the amount of earned GC in another var
			pl.GCData = result[1]
			pl.EarnedGreenCoins = pl.EarnedGreenCoins or 0
			pl.GCData["amount_current"] = math.max(0,pl.GCData["amount_current"] + pl.EarnedGreenCoins)
			query = "UPDATE green_coins SET amount_current = "..pl.GCData["amount_current"]..", steam_name = '"..tmysql.escape(pl:Name()).."', last_edit = '"..currentdate.."' WHERE steam_id = '"..pl:SteamID().."' AND valid = 1"
		else
			local tab = result[1]
			tab["amount_current"] = math.max(0,tab["amount_current"]+ pltab.earned)
			query = "UPDATE green_coins SET amount_current = "..tab["amount_current"]..", steam_name = '"..tmysql.escape(pltab.name).."', last_edit = '"..currentdate.."' WHERE steam_id = '"..pltab.steamid.."' AND valid = 1"
		end
		
		SQLQuery( query, SaveGreenCoinsStep2Callback, pltab )
	else
		WriteSQLLog("ERROR WHEN ATTEMPTING QUERY (SGCS1C) pl: "..pltab.name.."; status: "..tostring(status).."; error: "..tostring(err))
	end
end

--  Save GC at intervals
NextGCSaveTime = 0
local function SaveInterval()
	if (NextGCSaveTime < CurTime() and not ENDROUND) then
		NextGCSaveTime = CurTime()+120 --  save every two minutes
		
		for k, pl in pairs(player.GetAll()) do
			if IsValid(pl) and pl.GCData then
				pl:SaveGreenCoins()
			end
		end
	end
end
hook.Add("Think","GCSaving",SaveInterval)

--  Check if a game connection was requested
local function GameConnectionCallback( pl, result, status, err )

	if not IsValid(pl) then return end
	if (type(err) == "number" and err == 0) then
		
		if (#result == 0) then
			return
		end
		
		print("Game connection requested for "..pl:Name().."!")
		pl:PrintMessage(HUD_PRINTCONSOLE,"Game connection requested. Opening menu!")
		
		local conrequest = result[1]
		pl.ConnectionRequest = true
		pl.ForumIDRequested = tonumber(conrequest["forum_id"])
		umsg.Start("ConnectionRequest",pl)
			umsg.Long(pl.ForumIDRequested)
			umsg.String(conrequest["forum_name"])
		umsg.End()
		
	else
		WriteSQLLog("ERROR WHEN ATTEMPTING QUERY (GCC) pl: "..pl:Name().."; status: "..tostring(status).."; error: "..tostring(err))
	end
end

function CheckGameConnection( pl )
	if not (IsValid(pl) and pl:IsPlayer() and not pl:IsBot() and pl.Ready and not pl.GameCChecked) then return end
	local query = "SELECT * FROM game_connections WHERE game_id_type = 'STEAM' AND game_id = '"..pl:SteamID().."' AND status = 'PENDING' AND valid = 1"
	SQLQuery( query, GameConnectionCallback, pl )
	pl.GameCChecked = true
end
hook.Add("PlayerSpawn","CheckGameConnection",CheckGameConnection)

local function ConfirmStep3Callback( pl, result, status, err )
	if (type(err) == "number" and err == 0) then
		--  refresh
		RetrieveGreenCoins(pl)
	else
		WriteSQLLog("ERROR WHEN ATTEMPTING QUERY (CS3C) pl: "..pl:Name().."; status: "..tostring(status).."; error: "..tostring(err))
	end
end

local function ConfirmStep2Callback( pl, result, status, err )
	if (type(err) == "number" and err == 0) then
		pl:ChatPrint("Connection with forum account succesful!")
		pl.ForumIDRequested = nil
		pl.EarnedGreenCoins = 0
		local currentdate = os.date("%Y-%m-%d %H:%M:%S")
		
		--  Invalidate the old record
		local query = "UPDATE green_coins SET valid = 0, last_edit = '"..currentdate.."' WHERE steam_id = '"..pl:SteamID().."' AND ISNULL(forum_id) AND valid = 1"
		SQLQuery( query, ConfirmStep3Callback, pl )
	else
		WriteSQLLog("ERROR WHEN ATTEMPTING QUERY (CS2C) pl: "..pl:Name().."; status: "..tostring(status).."; error: "..tostring(err))
	end
end

local function ConfirmStep1Callback( pl, result, status, err )
	if (type(err) == "number" and err == 0) then
		local old_gc = 0
		local currentdate = os.date("%Y-%m-%d %H:%M:%S")
		if(#result > 0) then
			old_gc = result[1]["amount_current"]
		end
		old_gc = old_gc + (pl.EarnedGreenCoins or 0)
		
		--  Connect the IDs and GC in one record
		local query = "UPDATE green_coins SET steam_id = '"..pl:SteamID().."', amount_current = amount_current + "..old_gc..", last_edit = '"..currentdate.."' WHERE forum_id = "..pl.ForumIDRequested.." AND valid = 1"
		SQLQuery( query, ConfirmStep2Callback, pl )
	else
		WriteSQLLog("ERROR WHEN ATTEMPTING QUERY (CS1C) pl: "..pl:Name().."; status: "..tostring(status).."; error: "..tostring(err))
	end
end

local function ConnectionAnswerCallback( pl, result, status, err )

	if not IsValid(pl) then return end
	if (type(err) == "number" and err == 0) then
		
		local currentdate = os.date("%Y-%m-%d %H:%M:%S")
		if pl.ConnectionAccepted then
			--  First: game connection confirmed, retrieve his old data.
			local query = "SELECT * FROM green_coins WHERE steam_id = '"..pl:SteamID().."' AND ISNULL(forum_id) AND valid = 1"
			SQLQuery( query, ConfirmStep1Callback, pl )
		end
	else
		WriteSQLLog("ERROR WHEN ATTEMPTING QUERY (CAC) pl: "..pl:Name().."; status: "..tostring(status).."; error: "..tostring(err))
	end
end

function ConnectionRequestAnswer( pl, command, args )

	if not pl.ConnectionRequest or not args[1] then return end

	local status = ""
	local currentdate = os.date("%Y-%m-%d %H:%M:%S")
	if (args[1] == "yes") then
		status = "CONFIRMED"
		pl.ConnectionAccepted = true
		print("REQUEST CONFIRMED")
	elseif (args[1] == "no") then
		status = "REJECTED"
		pl.ConnectionAccepted = false
		print("REQUEST REJECTED")
	else
		return
	end

	pl.ConnectionRequest = false

	local query = "UPDATE game_connections SET status = '"..status.."', last_edit = '"..currentdate.."' WHERE game_id_type = 'STEAM' AND game_id = '"..pl:SteamID().."' AND status = 'PENDING' AND valid = 1"
	SQLQuery( query, ConnectionAnswerCallback, pl )

end
concommand.Add("game_conn_answer",ConnectionRequestAnswer)

-- --  Database error log functions -- -- 

function WriteSQLLog( str )
	
	local content = "--- Green-Coins MySQL log ---"
	if (file.Exists("mysqllog.txt","DATA")) then
		content = file.Read("mysqllog.txt","DATA")
	end
	
	print("MySQL log message: "..str)
	
	local date = os.date()
	content = content.."\n"..date..": "..str
	
	file.Write("mysqllog.txt", content)
end