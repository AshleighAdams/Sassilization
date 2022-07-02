--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Weapons:Add(Vector(1408, -896, 28))

-- Prevents players from miraculously being spawned on the third stage.
hook.Add("PlayerSpawn", "PlayerMover", function(ply)
	timer.Simple(0.5, function()
		if ply:GetPos():Distance(Vector(-482, -48, 100)) > 144 then
			ply:SetPos(Vector(-482, -48, 65))
		end
	end)
end)