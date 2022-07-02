--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(5427.705078125, -461.46255493164, 153.9122467041))
STGamemodes.Weapons:Add(Vector(7718.2109375, -307.98052978516, 240.03125))

function STGamemodes:MassNPCRelationship(ply, Disposition)
	for k,v in pairs(ents.FindByClass("npc_*")) do
		if(v and IsValid(v) and v.AddEntityRelationship) then
			v:AddEntityRelationship(ply, Disposition, 99)
		end
	end
end

function STGamemodes:OnPlayerSpawn(ply, SpecGhost)
	if(SpecGhost) then
		self:MassNPCRelationship(ply, D_LI)
	else
		self:MassNPCRelationship(ply, D_HT)
	end
end

function STGamemodes:OnPlayerDeath(ply)
	self:MassNPCRelationship(ply, D_LI)
end

STGamemodes.KeyValues:AddChange( "turret_door_trap", "dmg", "100" )
STGamemodes.KeyValues:AddChange( "turret1", function(ent) ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS) end, " " )
STGamemodes.KeyValues:AddChange( "turret2", function(ent) ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS) end, " " )

-- Turret Red Room
STGamemodes.TouchEvents:Setup(Vector(5723, 747, 207), Vector(5688, 613, 230), function(ply)
	ply:Kill()
end)

-- Window near breaking floor
STGamemodes.TouchEvents:Setup( Vector(1261, 394, 229), Vector(1453, 396, 340), function(ply)
	ply:Kill()
end)

-- Turrets near breaking floor
STGamemodes.TouchEvents:Setup(Vector(1115, 313, 208), Vector(1220, 320, 400), function(ply)
	ply:SetPos( Vector(1150, 140, 208))
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)
STGamemodes.TouchEvents:Setup(Vector(1216, 320, 208), Vector(1220, 394, 400), function(ply)
	ply:SetPos( Vector(1150, 140, 208))
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)

-- Window near second pusher
STGamemodes.TouchEvents:Setup(Vector(3360, 394, 229), Vector(3693, 396, 340), function(ply)
	ply:SetPos( Vector(3154.4719238281, 151.7243347168, 207.03125) )
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)

-- Window at left or right
STGamemodes.TouchEvents:Setup(Vector(5438, 394, 229), Vector(5764, 396, 340), function(ply)
	ply:SetPos( Vector(5389.8334960938, 154.72100830078, 207.03125) )
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)

-- Solid Box on first water pit
STGamemodes.TouchEvents:Setup( Vector(1446, -66, 141), 30, function(ply)
	ply:Kill()
end)

-- Barrels and Snipers are not to be hid from.
STGamemodes.TouchEvents:Setup(Vector(366, -84, 64), Vector(722, 1, 187), function(ply)
	ply:SetPos( Vector(455.46844482422, 333.78399658203, 64.03125) )
	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
end)
