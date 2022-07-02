--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:GoTeam(Team)
	if(!self or !self:IsValid()) then
		return
	end
	if(!Team) then
		return
	end
	local CurrentTeam = self:Team()
	if(CurrentTeam == Team) then
		return
	end
	self:KillTrail()
	self:SetTeam(Team)
	self:Spawn()
end
