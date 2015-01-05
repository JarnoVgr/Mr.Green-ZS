--[[
 *  DBug - 2013 Illuminati Productions
 *
 *  This product is licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *  
]]

--For zs_hands bug
DBUG_PROFILER = true

if ( SERVER ) then AddCSLuaFile(); end

local prefix = SERVER and "sv_" or "cl_"

if not ConVarExists( prefix .. "dbug_max_results" ) then CreateConVar( prefix .. "dbug_max_results", "10", FCVAR_NONE ); end
if not ConVarExists( prefix .. "dbug_draw_hud") and CLIENT then CreateConVar( prefix .. "dbug_draw_hud", "0", FCVAR_NONE ); end
if not ConVarExists( prefix .. "dbug_hooks" ) then CreateConVar( prefix .. "dbug_hooks", "1", FCVAR_NONE ); end
if not ConVarExists( prefix .. "dbug_timers" ) then CreateConVar( prefix .. "dbug_timers", "1", FCVAR_NONE ); end
if not ConVarExists( prefix .. "dbug_hook_auto_dump" ) then CreateConVar( prefix .. "dbug_hook_auto_dump", "0", FCVAR_NONE ); end
if not ConVarExists( prefix .. "dbug_timer_auto_dump" ) then CreateConVar( prefix .. "dbug_timer_auto_dump", "0", FCVAR_NONE ); end

--[[Variables]]

local DBug = {};

DBug.logData = {
	["Hooks"] = {},
	["Timers"] = {},
}

DBug.percLogData = {
	["Hooks"] = {},
	["Timers"] = {},
}

DBug.tTime = {
	["Hooks"] = 0,
	["Timers"] = 0,
}

DBug.hookTime = 0;
DBug.timerTime = 0;

DBug.maxResults = 0;
DBug.shouldDraw = false;

--[[Functions]]

MsgN("[DBug] Client logger initalizing .. ");

--[[
	Called 1 second after the script has loaded.
	This function implants little stubs of 
	logging code in all of hooked functions
]]
function DBug.ImplantDetours()
	MsgN("[DBug] Implanting detours .. ")

	if GetConVarNumber(prefix .. "dbug_hooks") == 1 then 
		for name, hooks in pairs( hook.GetTable() ) do 
			for hname, func in pairs( hooks ) do 
				local l_name = name .. "_" .. hname;

				hook.GetTable()[ name ][ hname ] = DBug.AttachTimer( func, l_name, "Hooks" )
			end
		end
	end

	MsgN("[DBug] Detours implanted, finished initalizing!")
end

--[[
	Called every second, profiles all of the logged 
	Data from the hooked function and timer detours
]]
function DBug.HookProfile()
	DBug.tTime = { Hooks = 0, Timers = 0 }
	
	DBug.percLogData = { Hooks = {}, Timers = {} }

	for name, _ in pairs( DBug.tTime ) do 
		for _, data in pairs( DBug.logData[ name ] ) do
			DBug.tTime[ name ] = DBug.tTime[ name ] + ( data.runTime or 0 )
		end
	end

	local hD, tD = GetConVarNumber(prefix .. "dbug_hook_auto_dump" ), GetConVarNumber(prefix .. "dbug_timer_auto_dump");

	if ( hD ~= 0 and DBug.tTime[ "Hooks" ] > hD ) or ( tD ~= 0 and DBug.tTime[ "Timers" ] > tD ) then
		DBug.DumpLog(nil, nil, {
			"/nomsg",
			"/log",
			"/all"
		})
	end

	for name, time in pairs( DBug.tTime ) do 
		for _name, data in pairs( DBug.logData[ name ] ) do 
			DBug.percLogData[ name ][ _name ] = {
				usage = math.Round( ( ( ( data.runTime or 0 ) / time ) * 100 ) * 100.0 ) / 100.0,
				loc = data.loc
			}
		end
	end

	--Putting this here as it seems to be quite expensive
	DBug.maxResults = GetConVarNumber( prefix .. "dbug_max_results" )
	DBug.shouldDraw = tobool( GetConVarNumber( prefix .. "dbug_draw_hud" ) )

	--Clear the time table so hooks that run ocasionally don't continuing "take up processing power"
	DBug.logData = { Hooks = {}, Timers = {} };
end

--[[
	Called only on the client, obviously.
	Draws DBug information to the HUD
]]
local iLastY = 0
function DBug.Draw()
	if DBug.shouldDraw ~= true then
		return
	end

	local x, y = 0, 150;

	draw.RoundedBox( 10, x, y, math.Round(ScrW()*0.3), iLastY, Color(0, 0, 0, 180) );

	for _type, time in pairs( DBug.tTime ) do 
		draw.SimpleText( _type .. " (" .. time .. "ms)" , "default", 10 + x + 1, 10 + y + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
		draw.SimpleText( _type .. " (" .. time .. "ms)" , "default", 10 + x + 1, 10 + y - 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
		draw.SimpleText( _type .. " (" .. time .. "ms)" , "default", 10 + x - 1, 10 + y - 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
		draw.SimpleText( _type .. " (" .. time .. "ms)" , "default", 10 + x - 1, 10 + y + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );

		draw.SimpleText( _type .. " (" .. time .. "ms)" , "default", 10 + x, 10 + y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );

		x = x + 30;
		y = y + 20;

		local count = 0;
		for name, data in SortedPairsByMemberValue( DBug.percLogData[ _type ], "usage", true ) do 

			if ( count >= DBug.maxResults ) then break; end
			if ( !data.usage || !name ) then continue; end

			local col = data.usage * 2.55;

			draw.SimpleText( "%" .. data.usage , "default", 10 + x, 10 + y, Color( col, 255 - col, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
			
			--Border effect
			draw.SimpleText( name , "default", 75 + x + 1, 10 + y + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
			draw.SimpleText( name , "default", 75 + x + 1, 10 + y - 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
			draw.SimpleText( name , "default", 75 + x - 1, 10 + y + 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
			draw.SimpleText( name , "default", 75 + x - 1, 10 + y - 1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );

			--Actual text
			draw.SimpleText( name , "default", 75 + x, 10 + y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );

			y = y + 10;
			count = count + 1;

		end

		y = y + 10;

		x = x - 30;
	end

	if y ~= iLastY then
		iLastY = y
	end
end

--[[
	Called by the console, dumps the top dbug_max_results into
	The console scren.
]]
function DBug.DumpLog( ply, cmd, args )
	print("DumpLog1")
	if SERVER then
		if ply and ply:IsPlayer() then
			if not ply:IsAdmin() then
				return
			end
		end
	end

	print("DumpLog2")

	--Arg cloud, contains all arguments passed to the function in a nice format

	local argCloud = {};

	for _, arg in pairs( args ) do argCloud[ arg ] = true; end

	--Create folders and files if logging is enabled

	local pr, obj = 0;
	if ( argCloud[ "/log" ] ) then

		if ( !file.IsDir( prefix .. "dbug", "DATA" ) ) then file.CreateDir( prefix .. "dbug", "DATA" ); end

		while ( file.Exists( prefix .. "dbug/profile_" .. pr .. ".txt", "DATA" ) ) do 

			pr = pr + 1;

		end

		--Create the file

		file.Write( prefix .. "dbug/profile_" .. pr .. ".txt", " == DBug profile, created @ " .. os.date() .. " == \n\n" );

		--Open the file (this is such a gay method..)
		fobj = file.Open( prefix .. "dbug/profile_" .. pr .. ".txt", "a", "DATA" );

		if ( !fobj ) then
			ErrorNoHalt( "File object invalid!" )
			return
		end
	end

	--Log to the console screen, a file both or neither

	local lFunction = function( str, col )

		if ( !argCloud[ "/nomsg" ] ) then MsgC( col, str.. '\n' ); end
		if ( argCloud[ "/log" ] ) then 

			fobj:Write( str .. '\n');

		end

	end

	// Itterate through the dara

	local val = argCloud[ "/time" ] and "runTime" or "usage"
	for _type, time in pairs( DBug.tTime ) do 

		lFunction( _type .. " (" .. DBug.tTime[ _type ]  .. "ms): \n", CLIENT and Color( 255, 255, 0, 255 ) or Color( 0, 175, 255, 255 ) );

		local count = 0;
		
		for name, data in SortedPairsByMemberValue( argCloud[ "/time" ] and DBug.logData[ _type ] or DBug.percLogData[ _type ] , val, true ) do 

			if ( count >= DBug.maxResults && !argCloud[ "/all" ] ) then break; end
			if ( !data[ val ] || !name ) then continue; end

			local col = DBug.percLogData[ _type ][ name ].usage * 2.55

			lFunction( "\t" .. ( !argCloud[ "/time" ] and "%" or "" ) .. data[ val ] .. "\t\t" .. data.loc .. "\t\t" .. name, Color( col , 255 - col, 0, 255 )  );

			count = count + 1;

		end 

	end

	// GC

	if ( fobj ) then fobj:Close(); end

end

/**
	Attaches some code that records the amount of the time the original
	function took to complete.
*/

function DBug.AttachTimer( func, name, _type )
	local f = function( ... )

		local start = SysTime();

		local ret = func( ... );

		DBug.logData[ _type ][ name ] = { runTime = SysTime() - start, loc = debug.getinfo( func ).source };

		return ret;
	end

	return f;
end

--Timer detour
if GetConVarNumber(prefix .. "dbug_timers") == 1 then 
	local oTC = timer.Create;
	timer.Create = function( name, delay, reps, func )
		oTC( name, delay, reps, DBug.AttachTimer( func, name, "Timers" ) );
	end
end

--Hook adding detour

if GetConVarNumber(prefix .. "dbug_hooks") == 1 then 
	local oHA = hook.Add

	hook.Add = function( _type, name, func )
		if type(name) ~= "string" then
			print("Hook.Add. Expected string. Got: ".. type(name) .." - Name is: ".. tostring(name))
		end

		oHA( _type, name, DBug.AttachTimer( func, _type .. "_" .. name, "Hooks" ) )
	end
end

--Hooks
if CLIENT then
	hook.Add("HUDPaint", "DBugHUD", DBug.Draw)
end

--Console Commands
concommand.Add( prefix .. "dbug_dump", DBug.DumpLog )

--Timers & Clean-up
timer.Simple( 1, DBug.ImplantDetours )
timer.Create( "DBugProfileTimer", 1, 0, DBug.HookProfile )