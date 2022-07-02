--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(-8560.0012345678, 699.0012345678, -472.94125))

hook.Add("PostKeyValues", "KeyValueChanger", function()
	for k,v in pairs(ents.FindInSphere(Vector(-1032, -2696, -455), 512)) do
		if(v:GetClass() == "trigger_teleport") then
			STGamemodes.KeyValues:AddChange( v, "target", "level_redcorridor7" )
		end
	end
end)

--[[ GMod 13
hook.Add("OnPlayerHitGround", "PlayerTeleporter", function(ply)
	if(!IsValid(ply)) then return end
	local ent = ply:GetGroundEntity()
	if(IsValid(ent) and string.find(ent:GetName(), "reda3da")) then
		ply:SetPos(Vector(-1031, -1130, -424))
	end
end) ]]