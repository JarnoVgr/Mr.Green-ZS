--Duby: This is the new module for guns for kills. This was created by Josh 'Acecool' Moser and adapted for Mr.Green zs by me. 
-- Gun Race Weapon Upgrader - Josh 'Acecool' Moser
-- Put this file into: addons/acecool/lua/autorun/server/sv_gun_race.lua
--
AddCSLuaFile("cl_kill_rewards.lua")

--
-- Referencing original help-topic:
-- http:--facepunch.com/showthread.php?t=1376370
--

--Duby: Thank you very much josh acecool for helping me with this script and modifying it for the needs of Mr.Green zombies survival! :)
--
-- Setting it up as table... Auto-refresh compatible, Will not reset table using auto-refresh!
--
if ( !gun_race ) then
	-- Functions Table
	gun_race = { };

	-- Data Table -- Stores frags based on SteamID of player...
	gun_race.__data = { };
end


--
-- Config - This will be allowed to update using autorefresh
--
gun_race.config = {
	-- If debug_mode is on, it'll output to server-console what is happening...
	debug_mode 				= true;

	-- Should all old weapons be removed? false if they should keep their old weapon upgrades unless they die!
	remove_previous_weapons = true;

	-- If you want all weapons to be removed ( uses StripWeapons; NOT GOOD TO USE ON TTT, it'll remove Traitor Weapons too... )
	remove_all_weapons 		= false;

	-- Should players start from scratch if they die?
	reset_kills_on_death	= true;

	-- If you modified your game-mode and PlayerLoadout isn't called in PlayerSpawn, this will inject the call...
	inject_player_spawn 	= false;

	--
	-- Table of weapons to give, key is number of kills == -- If done in order, on PlayerLoadout you could go through
	-- 	the table looking for the correct index, OR set the key the player is at when they get an upgrade...
	--
	-- Upgrades table, follow the pattern... [ X ] is frags needed to upgrade.
	-- The value on the right can be a table, or a string...
	
	
	weapon_upgrades = {
		[ 0 ] 	= { };
		[ 5 ] 	= { "weapon_zs_alyx" };
		[ 10 ] 	= { "weapon_zs_p90"};
		[ 25 ] 	= { "weapon_zs_ak47" };
		[ 45 ] 	= { "weapon_zs_m249" };

	};
};


--
-- So that Player can be output...
--
local META_PLAYER = FindMetaTable( "Player" );
function META_PLAYER:__tostring( )
	return "Player " .. self:Nick( ) .. " [ " .. self:SteamID( ) .. " ] ";
end


--
-- Debug Output...
--
function gun_race.log( _msg, _color )
	if ( gun_race.config.debug_mode ) then
		--MsgC( _color || Color( 0, 255, 255 ), "[AcecoolDev:Gun-Race] " .. _msg .. "\n" );
		MsgC( _color || Color( 0, 255, 255 ), "[G4K Debug System:] " .. _msg .. "\n" );
	end
end


--
-- Local function to reduce repetitive code...
--
function gun_race:ProcessUpgrades( _p, _frags )
	if ( !IsValid( _p ) ) then return; end

	-- If we upgrade their weapons... do it..
	if  ( self.config.weapon_upgrades[ _frags ] ) then
		-- Debug output...
		gun_race.log( "Processing Weapon Upgrades for Frag-Count: " .. tostring( _frags ) .. " on " .. tostring( _p ) );

		-- If we remove all weapons...
		if ( self.config.remove_all_weapons ) then
			-- Debug Output
			gun_race.log( "Removing ALL weapons from " .. tostring( _p ), Color( 255, 255, 0, 255 ) );

			-- Remove all weapons...
			
			_p:StripWeapons( );

		else
			-- If we do not remove all weapons, should we remove previous weapons?
			if ( self.config.remove_previous_weapons ) then
				-- Debug Output
				gun_race.log( "Only Removing Upgrade Weapons from " .. tostring( _p ), Color( 255, 255, 0, 255 ) );

				-- Process...
				for k, _weapons in pairs( self.config.weapon_upgrades ) do
					-- Remove weapons from table or if string...
					if ( istable( _weapons ) ) then
						for key, _w in pairs( _weapons ) do
						local holdingItem = _p:GetMisc() --Check the 4th item they are holding. 
						--local holdingItem2 = _p:GetAutomatic() --Check the secondary weapon they are holding. 
						--if ARENA_MODE then return end --If the map is fridge of doom then ignore this system. :P 
						if holdingItem and IsValid(holdingItem) then
						if _p:GetPerk("_comeback") then --If they have the comeback perk then don't give them any more weapons. (They have good enough weapons with this perk anyway.)
							return
							end
							_p:StripWeapon(holdingItem:GetClass())

							end 
						--if holdingItem2 and IsValid(holdingItem2) then
							--_p:StripWeapon(holdingItem2:GetClass())
							--end	
						end
					end
				end
			end
		end

		-- Give upgrade weapons
		local _weapons = self.config.weapon_upgrades[ _frags ];
		if ( istable( _weapons ) ) then
			for k, v in pairs( _weapons ) do
				-- Debug output
				gun_race.log( "Gave " .. tostring( _p ) .. " " .. tostring( v ), Color( 0, 255, 0, 255 ) );

				-- Give weapon from table of weapons

				_p:Give( v );
				_p:PrintMessage ( HUD_PRINTCENTER, "You Have Received A New Weapon!" )
			end
		elseif ( isstring( _weapons ) ) then
			-- Debug output
			gun_race.log( "Gave " .. tostring( _p ) .. " " .. _weapons, Color( 0, 255, 0, 255 ) );

			-- Give weapon from STRING
			_p:Give( _weapons );
			--_p:PrintMessage ( HUD_PRINTTALK, "[G4K] You have just recieved a new weapon!" )
			_p:PrintMessage ( HUD_PRINTCENTER, "You Have Received A New Weapon!" )
			--surface.PlaySound("beep22.wav")
		else
			-- Debug output
			gun_race.log( "_weapons from the upgrade-table doesn't appear to be a table, or a string!", Color( 255, 0, 0, 255 ) );
		end

		-- Update the player index...
		_p.__UpgradeIndex = _frags;
	end
end

--
-- This will run on death, and it'll update the UpgradeIndex which we use for Respawn gives, this handles the instantaneous upgrades
--
hook.Add( "PlayerDeath", "RunUpgrades:PlayerDeath", function( _victim, _inflictor, _attacker )
	-- Check for upgrades:
	if ( IsValid( _attacker ) && _attacker:IsPlayer( ) ) then
	if _attacker:Alive() and _attacker:IsHuman() then
		-- Grab Frag count, or use 0 as default...
		local _frags = gun_race.__data[ _attacker:SteamID( ) ] || 0;

		-- Add kill
		gun_race.__data[ _attacker:SteamID( ) ] = _frags + 1;
		
		-- Debug output
		gun_race.log( "Victim: " .. tostring( _victim ) .. " killed by: " .. tostring( _p ) .. " and killer now has " .. tostring( _frags ) .. " frags!" );

		-- Check to see if upgrade is available...
		gun_race:ProcessUpgrades( _attacker, _frags + 1 );
	end

	-- If we are to reset kills on death, and victim is valid player; Should be a given, but a simple check to ensure this wasn't a hook.Call somewhere else
	if ( gun_race.config.reset_kills_on_death && IsValid( _victim ) && _victim:IsPlayer( ) ) then
		-- Debug output
		gun_race.log( "Reset Frags on: " .. tostring( _victim ) );

		gun_race.__data[ _victim:SteamID( ) ] = 0;
		_victim.__UpgradeIndex = 0;
	end
			end
end );


--
-- Inject PlayerLaodout into PlayerSpawn?
--
hook.Add( "PlayerSpawn", "ShouldInjectGunRace:PlayerSpawn", function( _p )
	if ( !IsValid( _p ) || !_p.__EnableWeaponSystems ) then return; end

	-- If we need to inject PlayerLoadout...
	if ( gun_race.config.inject_player_spawn ) then
		-- Debug output
		gun_race.log( "PlayerSpawn > PlayerLoadout Injection Active and performed on: " .. tostring( _p ) );

		-- Give it a time buffer, just in case PlayerSpawn or other called hooks strip weapons...
		timer.Simple( 1, function( )
			-- Call Loadout...
			hook.Call( "PlayerLoadout", GAMEMODE, _p );
		end );
	end
end );


--
-- Initialize, only when the player becomes valid...
--
hook.Add( "OnEntityCreated", "EnablePlayerWeaponSystems", function( _ent )
	if ( IsValid( _ent ) && _ent:IsPlayer( ) ) then
		_ent.__EnableWeaponSystems = true;
		timer.Simple( 1, function( )
			hook.Call( "PlayerLoadout", GAMEMODE, _ent );
		end );
	end
end );


--
-- This will run on top of the default, so we only have to deal with upgrades
--
hook.Add( "PlayerLoadout", "RunUpgrades:PlayerLoadout", function( _p )
	if ( !IsValid( _p ) || !_p.__EnableWeaponSystems ) then return; end

	-- Initialize Frag Index...
	if ( !_p.__UpgradeIndex ) then _p.__UpgradeIndex = 0; end

	-- Debug Output
	gun_race.log( "PlayerLoadout called on: " .. tostring( _p ) );

	-- Process Potential Weapon Upgrades... USES UpgradeIndex from player instead of frags...
	gun_race:ProcessUpgrades( _p, _p.__UpgradeIndex );
end );