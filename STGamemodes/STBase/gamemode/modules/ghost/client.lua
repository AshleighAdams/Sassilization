--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes.Ghost.PlayerBindPress(ply, bind)
	if(!LocalPlayer():IsGhost()) then
		return
	end
    if(bind == "+use") then
		RunConsoleCommand("st_ghost_specclip")
		return true
	end
end
hook.Add("PlayerBindPress", "STGamemodes.Ghost.PlayerBindPress", STGamemodes.Ghost.PlayerBindPress)

timer.Create("STColorGhosts", 1, 0, function() 
	if LocalPlayer().IsGhost and !LocalPlayer():IsGhost() and
		LocalPlayer():GetObserverMode() != OBS_MODE_ROAMING then
		return
	end 

	for k,v in pairs(player.GetAll()) do
		if v.IsGhost and v:IsGhost() then
			v:SetColor(Color(0, 0, 255, 180))
			//v:SetRenderMode(RENDERMODE_TRANSALPHA) //Probably not needed as I set this serverside when they go into ghost mode.
		end
	end
end )

function STGamemodes.Ghost.PlayerFootstep(ply, pos, foot, sound, volume, rf) 
	if ply:IsGhost() then
		return true
	end
end 
hook.Add("PlayerFootstep", "STGamemodes.Ghost.PlayerFootstep", STGamemodes.Ghost.PlayerFootstep)
