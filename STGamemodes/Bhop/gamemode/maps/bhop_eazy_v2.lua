--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(4768, 1860, 48))

hook.Add( "PostKeyValues", "RemoveWindowsBhopEasy", function()
	for k,v in pairs( ents.FindByClass("func_breakable") ) do 
		if Vector(4968, 1968, 120):Distance(v:GetPos()) <= 1280 then 
			v:Remove() 
		end 
	end 
end )

-- Teleport for the glitchy area at the end.
STGamemodes.TouchEvents:Setup(Vector(6368, 1728, -320), Vector(6624, 2256, -160), function(ply) 
	ply:SetPos(Vector(4768, 1992, 56)) 
	ply:SetEyeAngles(Angle(0, 270, 0)) 
end)

-- Prevents players from exploiting the ladder below the breaking floor in the spawn.
STGamemodes.TouchEvents:Setup(Vector(-512, -64, 248), Vector(-384, 64, 312), function(ply)
	ply:SetLocalVelocity(Vector(0, 0, -250))
end)