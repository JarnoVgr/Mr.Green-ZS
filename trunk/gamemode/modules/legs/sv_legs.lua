-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
--
-- This particular file contains code by blackops7799

function WeaponBoolSetHoldType()
	for k,v in pairs (player.GetAll()) do
		if v:GetActiveWeapon():IsValid() and v:Alive() and v:GetActiveWeapon().HoldType == "normal" then
			v:GetActiveWeapon():SetNWBool("NormType",true)
		end
	end
end
--hook.Add("Think", "SetHoldingBools", WeaponBoolSetHoldType)

	legvar1 = CreateConVar( "zs_legs_enabled", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
	legvar2 = CreateConVar( "zs_legs_shadow_fix", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
	legvar3 = CreateConVar( "zs_legs_vehicle", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

	local function SpawnLegs(ply)
		local legs = ents.Create("player_legs")
		if (ValidEntity(legs)) then
			if ply:InVehicle() then
				legs:SetPos(ply:GetPos())
			else
				--legs:SetPos(ply:GetPos() + ply:GetForward()*-26)
				legs:SetPos(ply:GetPos() - ply:GetForward()*16)
			end
			--legs:SetAngles( Angle(0,(ply:GetAngles().y),0) )
			legs:SetParent(ply)
			legs:SetModel(ply:GetModel())
			legs:Spawn()
			legs:SetOwner(ply)
			legs:DrawShadow(false)
			print("Spawned Legs..")
			ply.LegsEnt = legs
		end
	end

	local function PlayerSpawn()

		if legvar1:GetInt() != 1 then return end

		for k, ply in pairs(player.GetAll()) do

			if !ply.LegsEnt then
				if ply:IsValid() then
					if ply:Alive() then
						if ply:InVehicle() then
							if legvar3:GetInt() != 0 then
								SpawnLegs(ply)
							end
						else
							SpawnLegs(ply)
						end

						if legvar2:GetInt() != 0 then
							if !ply:InVehicle() then
								local legs2 = ents.Create("player_shadow")
								if (ValidEntity(legs2)) then
									legs2:SetPos(ply:GetPos() + ply:GetForward()*-20)
									--legs2:SetAngles( Angle(0,(ply:GetAngles().y),0) )
									legs2:SetParent(ply)
									legs2:SetModel(ply:GetModel())
									legs2:Spawn()
									legs2:SetOwner(ply)
									legs2:DrawShadow(false)
									ply.LegsEnt2 = legs2
								end
							end
						end
					else
						if ply.LegsEnt and ply.LegsEnt:IsValid() then
							ply.LegsEnt:Remove()
							ply.LegsEnt = nil
							ply.LegsInCar = false
						end
					end
				end
			end
		end

	end
--	hook.Add("Think","LegSpawn",PlayerSpawn)

	--[[local function PlayerEnteredVehicle( ply, vehicle, role )
		if ply.LegsEnt and ply.LegsEnt:IsValid() then
			ply.LegsEnt:Remove()
		end
		if ply.LegsEnt2 and ply.LegsEnt2:IsValid() then
			ply.LegsEnt2:Remove()
		end
	end 
	hook.Add("PlayerEnteredVehicle","VehicleLegz",PlayerEnteredVehicle)]]

	--[[local function PlayerLeaveVehicle( ply, vehicle, role )
		if ply.LegsEnt and ply.LegsEnt:IsValid() then
			ply.LegsEnt:Remove()
		end
		if ply.LegsEnt2 and ply.LegsEnt2:IsValid() then
			ply.LegsEnt2:Remove()
		end
	end 
	hook.Add("PlayerLeaveVehicle","VehicleLegz",PlayerLeaveVehicle)]]

	--Just some commands I used when I was testing.
	--[[

	local function ResetLegs(ply, cmd, args)
		ply.LegsEnt = nil
		ply.LegsEnt2 = nil

	end
	concommand.Add( "legs_reset", ResetLegs )

	local function RemoveLegs(ply, cmd, args)
		for k, ent in pairs(ents.GetAll()) do
			if ent.LegsEnt and ent.LegsEnt2 then
				ent:Remove()
				print("Removed legs")
				ResetLegs(ply)
			end

		end
	end
	concommand.Add( "legs_remove", RemoveLegs )

	]]


	local function RemoveLegs(ply, cmd, args)
		print("MoveType = "..ply:GetMoveType())
	end
	concommand.Add( "zs_legs_movetype", RemoveLegs )