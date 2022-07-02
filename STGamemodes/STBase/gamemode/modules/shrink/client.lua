--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes:SetShrink( ply, scale )
	ply:ManipulateBoneScale(ply:LookupBone("ValveBiped.Bip01_Head1"), Vector(scale, scale, scale))  
	-- ply.BuildBonePositions = function()
	-- 	print("Build Bones") 
	-- 	local BoneID = ply:LookupBone("ValveBiped.Bip01_Head1")
	-- 	if !BoneID then return end
		
	-- 	local BoneMatrix = ply:GetBoneMatrix(BoneID)
	-- 	if !BoneMatrix then return end
		
	-- 	BoneMatrix:Scale(Vector(scale, scale, scale))
	-- 	ply:SetBoneMatrix(BoneID, BoneMatrix)
	-- end
	-- ply:InvalidateBoneCache()
end

function STGamemodes.Shrink(um)
	STGamemodes:SetShrink( um:ReadEntity(), um:ReadShort() )
end
usermessage.Hook("STGamemodes.Shrink", STGamemodes.Shrink)
