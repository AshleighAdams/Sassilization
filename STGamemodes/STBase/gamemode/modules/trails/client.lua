--------------------
-- STBase
-- By Spacetech
--------------------

local ConVar = CreateClientConVar( "st_trails", "1", true, false )
STGamemodes.EnableTrails = (ConVar:GetInt() == 1)

if(file.Exists("DisableTrails.txt", "DATA")) then
	file.Delete("DisableTrails.txt") -- Delete the file, we no longer want to do this.
	RunConsoleCommand( "st_trails", "0" )
	STGamemodes.EnableTrails = false 
end

local CheckTimer = 0
local r, g, b, a
concommand.Add("st_enabletrails", function(ply, cmd, args)
	if(ConVar:GetInt() == 1) then
		STGamemodes.EnableTrails = false
		RunConsoleCommand( "st_trails", "0" )
		ply:ChatPrint("Trails: Disabled")
		CheckTimer = CurTime()-1
	else
		STGamemodes.EnableTrails = true
		RunConsoleCommand( "st_trails", "1" )
		ply:ChatPrint("Trails: Enabled")
		CheckTimer = CurTime()-1
	end
	STGamemodes.Store.RefreshSettings = true
end)

hook.Add("Think", "Trails.Think", function()
	if(CheckTimer >= CurTime()) then
		return
	end
	CheckTimer = CurTime() + 1
	for k,v in pairs(ents.FindByClass("env_spritetrail")) do
		local p, p2 = v:GetParent()
		if p and p:IsValid() then 
			p2 = p:GetParent() 
			if p2 and p2:IsValid() and p2:IsPlayer() then 
				if (GetDrawingPlayers() and STGamemodes.EnableTrails) or p2 == LocalPlayer() then
					local col = v:GetColor()
					if(col.a != 255) then
						col.a = 255
						v:SetColor(col)
					end
				else 
					local col = v:GetColor()
					col.a = 0
					v:SetColor(col) 
				end  
			end 
		end 
	end
end)
