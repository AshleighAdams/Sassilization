--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.KeyValues:AddChange( "Push_02", "OnStartTouch", "Breakable_02,Break,,0,-1" )
STGamemodes.KeyValues:AddChange( "object_03", "forceclosed", "1" )

-- Prevents runners from surfing on the sides of the funnel in the suction room trap.
STGamemodes.TouchEvents:Setup(Vector(-320, 776, -48), Vector(-128, 928, 16), function(ply)
	ply:Freeze(true)
	timer.Simple(2.5, function() if ply:IsValid() then ply:Freeze(false) end end)
end)

-- Kill volumes for the blowing window traps.
STGamemodes.TouchEvents:Setup(Vector(2144, 3976, -16), Vector(2424, 4224, 113), function(ply)
	ply:Kill()
end)
 
STGamemodes.TouchEvents:Setup(Vector(3096, 4352, -184), Vector(3776, 4648, 9), function(ply)
	ply:Kill()
end)

-- Prevents players from jumping on the bookcases of the shooting books trap, thus skipping it.
STGamemodes.TouchEvents:Setup(Vector(3056, 3184, 217), Vector(3072, 3520, 277), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, 0))
end)

-- Prevents deaths from prespeeding and getting through the barrier separating them from the gun room.
STGamemodes.TouchEvents:Setup(Vector(3792, 4768, 144), Vector(3904, 4776, 264), function(ply)
	if ply:Team() == TEAM_DEATH then
		ply:SetLocalVelocity(Vector(0, -300, 0))
	end
end)