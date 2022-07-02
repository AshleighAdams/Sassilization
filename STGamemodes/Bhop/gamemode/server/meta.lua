--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:GoTeam(Team, Override)
	if(!self or !self:IsValid()) then
		return
	end
	if(!Team) then
		return
	end
	local CurrentTeam = self:Team()
	if(CurrentTeam == Team and !Override) then
		return
	end

	if Team == TEAM_SPEC then gamemode.Call( "OnSpec", self ) end 

	self:KillTrail()
	self:SetTeam(Team)
	self:Spawn()
end
