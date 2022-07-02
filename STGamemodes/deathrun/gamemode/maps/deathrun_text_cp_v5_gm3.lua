--------------------
-- STBase
-- By Spacetech
--------------------

--[[ -- Removes a breakable floor that is rumored to crash the server.
hook.Add("OnRoundChange", "EntityDestroyer", function()
	for k,v in pairs(ents.FindByName("trap_end")) do
		v:Remove()
	end
end) ]]

hook.Add( "DoPlayerDeath", "CheckParentedThingy", function( ply )
	local ent = ents.FindByName( "bird" )[1]
	if ent and ent:IsValid() and ent:GetParent() == ply then
		ent:Remove()
	end
end )