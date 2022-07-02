--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Ghost = {}

function STGamemodes.PlayerMeta:IsGhost()
	if !self:IsPlayer() then return end 
	if SERVER then 
		return self.Ghost 
	else 
		local col = self:GetColor()
		if(col.r == 0 and col.g == 0 and col.b == 255 and (col.a == 0 or col.a == 180)) then
			return true
		end
		return false 
	end 
end

function STGamemodes.PlayerMeta:CanGhost()
	if(STGamemodes.GhostDisabled) then
		return false
	end
	return STGamemodes.Store:GetItemInfo(self, "Misc", "Ghost Mode") and STGamemodes.Store:GetItemInfo(self, "Misc", "GhostModeEnabled")
end
