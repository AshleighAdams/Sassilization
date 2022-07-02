--------------------
-- STBase
-- By Spacetech
--------------------

hook.Add("PrePlayerDraw", "BrianAngleFix", function(ply)
	if ply:IsValid() and ply:Alive() and string.match(ply:GetModel(), "brian.mdl") then
		ply:SetRenderAngles(ply:GetAngles())
	end
end)

-- Credit to Sonic.
hook.Add("OnEntityCreated", "BrianPosFix", function(ent)
	if ent:IsPlayer() then -- We want to define this for each player that gets created.
		ent.BuildBonePositions = function(self, NumBones, NumPhysBones)
			if string.match(ent:GetModel(), "brian.mdl") then
				local pos, ang = ent:GetBonePosition(0)
				ent:InvalidateBoneCache() -- Not sure if needed, wiki suggests doing it after calling GetBonePosition.
				ent:SetBonePosition(0, ent:GetPos() + Vector(0, 0, 36), ang)
			end
		end
	end
end)
