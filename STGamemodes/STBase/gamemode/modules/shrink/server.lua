--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.ShrinkScale(ply, Scale)
	if table.HasValue(STGamemodes.InvalidPlayerModels, ply:GetModel()) then return end
	
	umsg.Start("STGamemodes.Shrink")
		umsg.Entity(ply)
		umsg.Short(Scale)
	umsg.End()
end
