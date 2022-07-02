--------------------
-- STBase
-- By Spacetech
--------------------

GM.RunnerWeapon = "weapon_crowbar"

hook.Add("OnRoundChange", "EntityDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(-2192, -1828, 0), 192)) do
		if(v:GetClass() == "weapon_deagle") then
			v:Remove()
		end
	end
end)

STGamemodes.KeyValues:AddChange( "last_destination_02", "origin", "-4055 -3023 -64" )

STGamemodes.TouchEvents:Setup(Vector(-2328, -1856, -72), Vector(-2284, -1792, -71), function(ply)
	ply:Give("weapon_deagle")
	if ply:Team() == TEAM_RUN then GAMEMODE:TimerEndRoundStart() end 
end)

-- Death spawn camping prevention.
STGamemodes.TouchEvents:Setup(Vector(-4032, -3232, -80), Vector(-3984, -2816, 80), function(ply)
	if ply:Team() == TEAM_RUN then
		ply:SetLocalVelocity(Vector(320, 0, 0))
	end
end)
	
-- Runner spawn camping prevention.
STGamemodes.TouchEvents:Setup(Vector(-3536, -2976, -80), Vector(-3488, -2816, 80), function(ply)
	if ply:Team() == TEAM_DEATH then
		ply:SetLocalVelocity(Vector(-320, 0, 0))
	end
end)