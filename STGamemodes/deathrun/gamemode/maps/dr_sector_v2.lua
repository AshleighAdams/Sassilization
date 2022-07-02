--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Remove(Vector(1086, -2251, -255))
 
STGamemodes.TouchEvents:Setup(Vector(7672, -5116, -448), 1000, function(ply) 
	if ply:Team() == TEAM_RUN then 
		ply:Give('weapon_crowbar') 
		GAMEMODE:TimerEndRoundStart() 
	end 
end )

STGamemodes.TouchEvents:Setup(Vector(768, -240, -130), Vector(424, -42, -54), function(ply) 
	ply:Kill() 
end )

STGamemodes.TouchEvents:Setup(Vector(5169, -3600, -236), Vector(5251, -3643, -150), function(ply) 
	ply:Kill() 
end )