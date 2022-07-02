--------------------
-- STBase
-- By Spacetech
--------------------

hook.Add("OnRoundChange", "PlayerTeleporter", function()
	timer.Simple(60, function()
		for k,v in pairs(ents.FindInBox(Vector(-1226, 7640, -124), Vector(-942, 8074, -34))) do
			if v and v:IsValid() and v:IsPlayer() then
				v:SetPos(Vector(-1031.5, 7616, -123.9688))
				v:SetEyeAngles(Angle(0, -90, 0))
			end
		end
	end)
end)

STGamemodes.KeyValues:AddChange( "Heli", "dmg", "10" )
STGamemodes.KeyValues:AddChange( "spawn_koule_1", "OnEntitySpawned", "placka_1,Break,,4,-1" )
STGamemodes.KeyValues:AddChange( "spawn_koule_2", "OnEntitySpawned", "placka_2,Break,,3.7,-1" )
STGamemodes.KeyValues:AddChange( "spawn_koule_3", "OnEntitySpawned", "placka_3,Break,,3.3,-1" )
STGamemodes.KeyValues:AddChange( "car_fall", "massScale", "5" )
STGamemodes.KeyValues:AddChange( "t_easy_kill", "origin", "-4389.78 -14509 636.5" )
STGamemodes.KeyValues:AddChange( "m3", "origin", "-343 6957 319.31" )

-- Kill volume for the car hangar on the shooting cars trap.
STGamemodes.TouchEvents:Setup(Vector(-872, 4812, -136), Vector(236, 5088, 65), function(ply)
	ply:Kill()
end)

-- Kill volume for the bottom of the map.
STGamemodes.TouchEvents:Setup(Vector(-2917, -15685, -1304), Vector(1128, 14022, -1240), function(ply)
	ply:Kill()
end)