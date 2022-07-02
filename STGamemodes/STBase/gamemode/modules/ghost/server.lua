--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.Ghost:SetGhost(ply, Bool)
	STGamemodes.Store:SetItemInfo(ply, "Misc", "GhostModeEnabled", Bool)
	STGamemodes.Store:SendCatItem(ply, "Misc", "GhostModeEnabled")

	if !ply:Alive() and ply:Team() != TEAM_SPEC then 
		ply:Spawn()
	end 

end

function STGamemodes.Ghost:Spawn(ply, NoFreeze)
	if(!ply:CanGhost()) then
		return
	end
	
	ply:UnSpectate()
	ply:SetMoveType(MOVETYPE_WALK)
	
	if(ply.LastPos and ply.LastEyeAngles) then
		ply:SetPos(ply.LastPos)
		ply:SetEyeAngles(ply.LastEyeAngles)
	end
	
	ply:SetNotSolid(true)
	ply:SetColor(Color(0, 0, 255, 0))
	ply:SetRenderMode(RENDERMODE_TRANSALPHA)
	ply:DrawShadow(false)
	ply:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	ply:SetGravity( 1 )
	
	ply:ChatPrint("You are now in ghost mode")
	
	if(!NoFreeze) then
		ply:Freeze(true)
		timer.Simple(0.5, function()
			if(STValidEntity(ply)) then
				ply:Freeze(false)
			end
		end)
	end
end

concommand.Add("st_ghost_specclip", function(ply)
	if(!ply:IsGhost()) then
		return
	end
	if(ply.NextGhostSpecClip and ply.NextGhostSpecClip >= CurTime()) then
		return
	end
	ply.NextGhostSpecClip = CurTime() + 0.5
	if(ply:GetMoveType() == MOVETYPE_NOCLIP) then
		ply:SetMoveType(MOVETYPE_WALK)
	else
		ply:SetMoveType(MOVETYPE_NOCLIP)
	end
end)
