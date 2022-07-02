--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.PlayerMeta:GoTeam(Team)
	if(!self or !self:IsValid()) then
		return
	end
	if(self:Team() == Team) then
		return
	end
	self:KillTrail()
	self:SetTeam(Team)
	self:Spawn()
end
