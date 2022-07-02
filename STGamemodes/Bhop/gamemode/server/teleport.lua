--------------------
-- STBase
-- By Spacetech
--------------------

require("teleport")

//NOTE: Shitty temp code below to avoid halt on require('teleport') as I nowhere near have gmsv_teleport ready for gmod13.
/*local ply = FindMetaTable('Player')
function ply:SetupTeleportHook(b)
	return true
end*/

hook.Add("OnEntityCreated", "Teleport.OnEntityCreated", function(ent)
	if(ent:IsPlayer()) then
		ent:SetupTeleportHook(true)
	end
	
	if ent:GetClass()=='trigger_teleport' and ent.SetupTouchHook then
		ent:SetupTouchHook(true)
	end
end)

hook.Add("EntityRemoved", "Teleport.EntityRemoved", function(ent)
	if(ent:IsPlayer()) then
		if(ent:SetupTeleportHook(false)) then
			for k,v in pairs(player.GetAll()) do
				if(v:SetupTeleportHook(true)) then
					break
				end
			end
		end
	end
	
	if(ent:GetClass()=='trigger_teleport' and ent.SetupTouchHook) then
		ent:SetupTouchHook(false)
	end
end)

hook.Add("ShouldTeleport", "Teleport.ShouldTeleport", function(ply)
	-- if(GAMEMODE:NightmareReset(ply)) then
		-- return false
	-- end
	
	if ply:GetInfoNum('st__telehop',1) == 0 then
		ply:SetLocalVelocity(vector_origin)
	end
	return true
end)

hook.Add("PSTouch",'StartingTouch',function(tp, ent)
	if tp:GetClass()!='trigger_teleport' then return end //Shouldn't be possible this line to trigger
	if ent:IsPlayer() and (not ent:IsWinner()) and tp:IsLevel() then
		ent:IncrementFailCount()
		GAMEMODE:SetInfo(ent, "NoTele", false)
		STAchievements:AddCount(ent, "Water Lover") //Finally trigger due to falling into the water teleports!
	elseif ent:GetClass()=='func_door' then
		tp:SetLevel(true)
	end
end)
