-- A script to allow players to unstick themselves. Don't take credit, etc etc.
-- THIS REVISION IS EVEN MORE BETTER
-- 4:30 AM SUCK IT SUCKAS
-- By Rejax

if SERVER then 
	util.AddNetworkString( "StuckMessage" )
	AddCSLuaFile()
end

if CLIENT then

	local m = {}
		m[1] = "Trying to free you!"
		m[2] = "Couldn't find a place to put you! Make sure you're aiming at away from a wall, and try again in 10 seconds!"
		m[3] = "You should be unstuck! You can try again in 10 seconds!"
		m[4] = "You must be alive to use this command!"
		m[5] = "Aim away from any walls, at a spot which is clear!\nProcess begins in 3 seconds!"
		m[6] = "Cooldown period still active! Wait a bit!"
		m[7] = { "Player '", "' used the UnStuck command! Investigate possible misuse." }
		m[8] = "Make sure you're aiming away from all other entities!\nie: Not trying to go through walls"
		
	net.Receive( "StuckMessage", function()
	
		local fl = net.ReadFloat()
		local ply = net.ReadEntity()

		if not ply:IsPlayer() then
			chat.AddText( Color( 200, 100, 100 ), "[UNSTUCK] ", Color( 255, 255, 255 ), m[fl] )
		else
			chat.AddText( Color( 255, 100, 100 ), "[UNSTUCK ADMIN] ", Color( 255, 255, 255 ), m[fl][1], ply:Nick(), m[fl][2] )
		end
		
	end)

end

if SERVER then

	local function SendMessage( ply, num, pent )
		net.Start( "StuckMessage" )
			net.WriteFloat( num )
			if pent then
				net.WriteEntity( pent )
			end
		net.Send( ply )
	end

	local function FindNewPos( ply )
		
		local pos = ply:GetShootPos()
		local ang = ply:GetAimVector()
		local forward = ply:GetForward()
		local center = Vector( 0, 0, 30 )
		local realpos = ( (pos + center ) + (forward * 75) )
		
		local chprop = ents.Create( "prop_physics" )
		
			chprop:SetModel( "models/props_c17/oildrum001.mdl" )
			chprop:SetPos( realpos )
			chprop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			chprop:SetOwner( ply )
			chprop:SetNoDraw( true )
			chprop:DrawShadow( false )
			chprop:DropToFloor()
			chprop:Spawn()
			local p = chprop:GetPhysicsObject()
				if IsValid( p ) then
					p:EnableMotion( false )
				end
		
		local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = chprop:GetPos()
				tracedata.filter = ply	
		local trace = util.TraceLine(tracedata)
			
			timer.Create( "CheckUseAblePos", 3, 1, function()
		
				ply:Freeze( false )
			
				if IsValid( chprop:GetGroundEntity() ) then
					local gent = chprop:GetGroundEntity()
					gent:SetCollisionGroup( COLLISION_GROUP_WEAPON )
						timer.Simple( 3, function()
							gent:SetCollisionGroup( COLLISION_GROUP_NONE )
						end)
				end
		
				if chprop:IsInWorld() then
					
					if trace.Entity == chprop then
						ply:SetPos( chprop:GetPos() )
						SendMessage( ply, 3 )
					else
						SendMessage( ply, 8 )
					end
				else
				
					SendMessage( ply, 2 )
				end
			
				chprop:Remove()
			
			end)
			
	end

	local function UnStuck( ply )

		if ply:GetMoveType() == MOVETYPE_OBSERVER or not ply:Alive() then return end
	
		ply:Freeze( true )

		FindNewPos( ply )
	
		SendMessage( ply, 1 )
	
		for k,v in pairs( player.GetAll() ) do
			if v:IsAdmin() or v:IsSuperAdmin() or v:IsUserGroup( "mod" ) then
				SendMessage( v, 7, ply )
			end
		end
	
	end

	hook.Add("PlayerSay", "playersaystuck", function(ply, text)

		if ( text == "!unstuck" or text == "!stuck" ) then
		
			if ply.UnStuckCooldown == nil then
				ply.UnStuckCooldown = CurTime() - 1
			end
			
			if (ply.UnStuckCooldown < CurTime()) then
		
				if ply:Alive() then 
					ply.UnStuckCooldown = CurTime() + 14
					SendMessage( ply, 5 )
					UnStuck( ply )
				else
					SendMessage( ply, 4 )
				end
			
			else
				SendMessage( ply, 6 )
			end
			
		return ""
		end
	end)
 
end