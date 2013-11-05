-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local umsg = umsg

--[==[----------------------------------------------------
   Run the base function with SetPlayerSpeed
----------------------------------------------------]==]
--timer.Simple ( 0.5, function()
--	local BaseSetPlayerSpeed = GM.SetPlayerSpeed
	function GM:SetPlayerSpeed( pl, walk, run, max )
		if not ValidEntity ( pl ) then return end
		if not pl:IsPlayer() then return end
		
		-- Check for nulls
		run, max = run or walk, max or walk
		
		-- Damn you Garry!
		if ( walk == 0 ) then walk = 1 end
		if ( run == 0 ) then run = 1 end
		if ( max == 0 ) then max = 1 end --@NECROSSIN: It was a typo, you need glasses :<
		
		-- Call the base function
		--BaseSetPlayerSpeed ( pl, walk )
		
		-- Do other stuff
		pl.WalkSpeed = walk
		pl:SetWalkSpeed( walk )
		pl:SetRunSpeed( run )
		pl:SetMaxSpeed ( max )
	end
--end )

--[==[---------------------------------------------
                Debug usermessages
---------------------------------------------]==]
umsg.BaseStart = umsg.Start
--[==[function umsg.Start ( strLocation, eTo )
	if strLocation == nil then return end
	
	-- Base usermessage function
	umsg.BaseStart ( strLocation, eTo )
	
	-- Only debug with the convar on
	-- if GetConVarNumber ( "debug_usermessages" ) == 0 then return end
	
	-- Debug 
	local To = "every player."
	if eTo ~= nil then To = tostring ( eTo ) end
	-- Debug ( "[USERMESSAGE-START] Sending usermessage to function "..tostring ( strLocation ).." to: "..tostring ( To ) )
	print( "[USERMESSAGE-START] Sending usermessage to function "..tostring ( strLocation ).." to: "..tostring ( To ) )
end]==]

--[==[---------------------------------------------
                Debug usermessages
---------------------------------------------]==]
umsg.BaseEnd = umsg.End
--[==[function umsg.End ()
	-- Base end function
	umsg.BaseEnd()
	
	-- Only debug with the convar on
	-- if GetConVarNumber ( "debug_usermessages" ) == 0 then return end
	
	-- Debug
	-- Debug ( "[USERMESSAGE-END] Ending usermessage." )
	print ( "[USERMESSAGE-END] Ending usermessage." )
end]==]

--[==[-------------------------------------------------
             Debug server-side effects
--------------------------------------------------]==]
util.BaseEffect = util.Effect
--[==[function util.Effect ( strName, eData, bOverride, bIgnorePrediction )
	if strName == nil or eData == nil then return end
	
	-- Debug
	if GetConVarNumber ( "debug_effects" ) ~= 0 then Debug ( "[EFFECT] Spawning effect: "..tostring ( strName )..". Override is "..tostring ( bOverride )..". Ignoring Prediction: "..tostring ( bIgnorePrediction ) ) end
	
	-- Base function
	util.BaseEffect ( strName, eData, bOverride, bIgnorePrediction )
end]==]

--[==[---------------------------------------------------
      Used to call drop/strip weapon on client
----------------------------------------------------]==]
function ClientDropWeapon( self, Class )
	if not ValidEntity(self) or not self:IsPlayer() or not self.Ready then
		return
	end

	-- Send it to client
	umsg.Start("OnWeaponDropped", self)
	umsg.End()
end

--[==[----------------------------------------------------------------
     Used to send umgs from and to for classes (by Clavus)
----------------------------------------------------------------]==]
function UpdatePlayerClass ( from, to, class, var )
	if var == nil or class == nil then return end

	local tab = {}
	
	if #from > 5 then
		for k = 1, math.ceil( #from / 5 ) do
			tab[k] = {}
			for nr = 1,5 do
				if #from >= 5 * ( k - 1 ) + nr then
					tab[k][nr] = from [ 5 * ( k - 1 ) + nr ]
				else 
					break
				end
			end
		end
	else
		tab[1] = table.Copy( from )
	end
	
	for key, subt in pairs( tab ) do
		umsg.Start( class, to )
			umsg.Short( #subt )
			for k, v in pairs( subt ) do
				umsg.Entity( v )
				umsg.Short( v[ tostring ( var ) ] )
			end	
		umsg.End()
	end
end

--[==[--------------------------------------------------------------------------------
              Called when a player is being howlered (screamed upon)
----------------------------------------------------------------------------------]==]
function GM:OnPlayerHowlered ( pl, iIntensity )
	if not IsEntityValid ( pl ) or iIntensity == nil then
		return
	end
	
	-- Disorient the player
	pl:SendLua( "StalkerFuck("..( iIntensity )..")" )
	
	-- Play a help sound/scream
	pl:EmitSound ( table.Random ( VoiceSets[ pl.VoiceSet or 1 ].Frightened ) )
end

--[==[-------------------------------------------------------
          Returns a player by steamID
---------------------------------------------------------]==]
function GetPlayerBySteamID( SteamID )
	for k,v in pairs ( player.GetAll() ) do
		if v:SteamID() == SteamID then
			return v
		end
	end
end

