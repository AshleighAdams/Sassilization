--------------------
-- STBase
-- By Spacetech
--------------------

local HeadUp = Vector(0, 0, 90)
STGamemodes.Spectater = {}

function STGamemodes.Spectater:SetTeams(Teams)
	self.Teams = Teams
end

function STGamemodes.Spectater:GetTeam(Num)
	if(!self.Teams) then
		return
	end
	if(Num) then
		return STGamemodes:TeamAliveNum(self.Teams)
	end
	return STGamemodes:TeamAlive(self.Teams)
end

concommand.Add("st_spectator", function(ply)
	if(!ply.LastChangeSpec) then
		ply.LastChangeSpec = CurTime() - 5
	end
	if(ply.LastChangeSpec + 1 >= CurTime()) then
		return
	end
	ply.LastChangeSpec = CurTime()
	STGamemodes.Spectater:Next(ply, 1)
end)

function STGamemodes.Spectater:Spawn(ply, SpecPlayer)
	if(!IsValid(ply) or !self.Teams) then
		return
	end
	if(ply:Team() == TEAM_CONNECTING or ply:Team() == TEAM_UNASSIGNED) then
		ply:SetTeam(TEAM_SPEC)
	end
	if(!ply:Alive() and !ply:IsGhost()) then
		ply:StripWeapons()
		local Players = self:GetTeam(true)
		-- if(Players == 0) then
		-- 	ply.SpecType = OBS_MODE_ROAMING
		-- else
		if(!ply.SpecType) then
			ply.SpecType = OBS_MODE_CHASE
		end
		ply:Spectate(ply.SpecType)
		ply:SetMoveType(MOVETYPE_OBSERVER)
		self:Next(ply, 0, SpecPlayer)
	else
		ply:Spectate(OBS_MODE_NONE)
		ply:SetMoveType(MOVETYPE_WALK)
		ply:UnSpectate()
	end
end

function STGamemodes.Spectater:Next(ply, Direction, Specific)
	if(!self.Teams) then
		return
	end
	
	if(ply:Alive() or (!GAMEMODE.SpecFix and ply:GetVar("SpawnDelay", 0) != 0) or ply:IsGhost()) then
		return
	end
	
	local Start = ply.Spectating
	if(!Start) then
		Start = 0
	end
	
	local Players = STGamemodes:TeamAlive(self.Teams) // STGamemodes:GetPlayers(self.Teams)
	
	Start = Start + Direction
	
	local PlayerCount = table.Count(Players)
	if(PlayerCount > 0) then
		if(Start > PlayerCount) then
			Start = 1
		elseif(Start < 1) then
			Start = PlayerCount
		end
		ply.Spectating = Start
		local SpecPlayer = Specific or Players[Start]
		if(SpecPlayer and SpecPlayer:IsValid()) then
			if(ply.SpecType != OBS_MODE_IN_EYE and ply.SpecType != OBS_MODE_CHASE) then
				if(!ply:IsAdmin() or ply.SpecType != OBS_MODE_ROAMING) then
					ply.SpecType = OBS_MODE_CHASE
					ply:Spectate(ply.SpecType)
				end
			end
			ply:SpectateEntity(SpecPlayer)
		end
	elseif(ply.SpecType != OBS_MODE_CHASE) then
		ply.SpecType = OBS_MODE_CHASE
		ply:Spectate(ply.SpecType)
	end
end

function STGamemodes.Spectater:KeyPress(ply, key)
	if(key == IN_ATTACK) then
		self:Next(ply, 1)
	elseif(key == IN_ATTACK2) then
		self:Next(ply, -1)
	elseif(key == IN_JUMP) then
		self:NextType(ply)
	end
end

function STGamemodes.Spectater:NextType(ply)
	local Type = ply.SpecType or OBS_MODE_IN_EYE
	local Players = self:GetTeam(true)
	if Players and Players > 0 then
		if(Type == OBS_MODE_CHASE) then
			Type = OBS_MODE_IN_EYE
		elseif(Type == OBS_MODE_IN_EYE) then
			if(ply:IsAdmin()) then
				Type = OBS_MODE_ROAMING
			else
				Type = OBS_MODE_CHASE
			end
		elseif(Type == OBS_MODE_ROAMING) then
			Type = OBS_MODE_CHASE
		end
	else
		Type = OBS_MODE_CHASE
	end
	ply.SpecType = Type
	ply:Spectate(ply.SpecType)
end
