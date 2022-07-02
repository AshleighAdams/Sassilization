--------------------
-- STBase
-- By Spacetech
--------------------

timer.Simple(1, function() concommand.Remove("changeteam") end)

SetGlobalString("ServerName", GetHostName())

hook.Add("SetupMove", "InfAngleGuard", function(ply, cmd)
	local ang = cmd:GetMoveAngles()

	if not (ang.p >= 0 or ang.p <= 0) or not (ang.y >= 0 or ang.y <= 0) or not (ang.r >= 0 or ang.r <= 0) then
		cmd:SetMoveAngles(Angle(0, 0, 0))
		ply:SetEyeAngles(Angle(0, 0, 0))
	end
end)

-------------------------------------------------
-- Lasers
-------------------------------------------------

function CorrectBeam(a, b)
	if(!IsValid(a) or !IsValid(b)) then
		-- print("Incorrect Beam", a, b)
		return
	end
	-- print("Corrected", a, b)
	
	local v1, v2 = a:GetPos(), b:GetPos()
	local trace = util.TraceLine({start=v1, endpos=v2})
	
	if trace.StartSolid then
		local npos = v1 + ((v2 - v1) * (trace.FractionLeftSolid + 0.005) )
		a:SetPos(npos)
	end
end

-- function GM:EntityRemoved(ent)
	-- print("EntityRemoved", ent)
-- end

function CorrectLasers()
	local laser = ents.FindByClass("env_laser")
	-- PrintTable(laser)
	for k,v in ipairs(laser) do
		local e = v:GetKeyValues()
		
		local name = e["LaserTarget"]
		local endent = ents.FindByName(name)[1]
		
		-- print("StartName:", name, "| endent:", endent)
		CorrectBeam(v, endent)
	end
	
	laser = ents.FindByClass("env_beam")
	
	for k,v in ipairs(laser) do
		local e = v:GetKeyValues()
		
		local sname = e["LightningStart"]
		local ename = e["LightningEnd"]
		
		local sent = ents.FindByName(sname)[1]
		local eent = ents.FindByName(ename)[1]
		
		CorrectBeam(sent, eent)
	end
end
