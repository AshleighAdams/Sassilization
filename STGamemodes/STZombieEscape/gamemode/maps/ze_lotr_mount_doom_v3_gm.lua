--[[-------------------------------------------------------------------
		Map Fixes
---------------------------------------------------------------------]]
hook.Add("OnRoundChange", "FixRingCollisions", function()

	-- Fix ring collision
	local fix1 = ents.FindByName("fix1")[1] -- func_movelinear
	if IsValid(fix1) then
		--fix1:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER) I don't think this works? :S
	end
	
	/*local elanillo = ents.FindByName("elanillo")[1] -- func_physbox_multiplayer
	if IsValid(elanillo) then
		elanillo:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end*/
	
end)

GM:IgnoreMessages({
	"mat_colorcorrection 1"
})