--------------------
-- STBase
-- By Spacetech
--------------------

local DrownDamage = 20

function PerPlayerWater(ply)
	if(!ply.Air) then
		ply.Air = 100
	end
	if(ply.Air <= 0) then
		ply:EmitSound(table.Random(STGamemodes.DrownSounds))
		
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(DrownDamage)
		dmginfo:SetDamageType(DMG_GENERIC) -- DMG_DROWN isn't shown on the HUD?
		dmginfo:SetInflictor(game.GetWorld())
		dmginfo:SetAttacker(game.GetWorld())
		ply:TakeDamageInfo(dmginfo)
	else
		ply.Air = ply.Air - 10
	end

	umsg.Start("DrowningMsg", ply)
		umsg.Long(ply.Air)
	umsg.End()
end

function WaterBreathing()
	for k,v in pairs(player.GetAll()) do
		if (v and STValidEntity(v) and v:Alive()) then
			if(v:WaterLevel() > 2) then
				PerPlayerWater(v)
			elseif(v.Air != 100) then
				v.Air = 100
			end
		end
	end
end
timer.Create("WaterBreathing", 1, 0, WaterBreathing )

function ResetAir( ply )
	ply.Air = 100 
	umsg.Start("DrowningMsg", ply)
		umsg.Long(ply.Air)
	umsg.End()
end 
hook.Add( "OnPlayerDeath", "ResetAir", ResetAir )
