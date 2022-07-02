--------------------
-- STBase
-- By Spacetech
--------------------

local Team = TEAM_SPEC
timer.Create("TeamChange", 0.2, 0, function()
	if(IsValid(LocalPlayer()) and Team != LocalPlayer():Team()) then
		Team = LocalPlayer():Team()
		if(STGamemodes.OnTeamChanged) then
			STGamemodes:OnTeamChanged(Team)
		end
	end
end)

function STGamemodes.Message(Title, Message)
	local Panel = vgui.Create("STGamemodes.VGUI.Message")
	Panel:SetInfo(Title, Message)
	Panel:MakePopup()
end

local Pos, Distance, Weapon

function STGamemodes:SetPlayerColor(ply, alpha)
	local col = ply:GetColor()
	col.a = alpha
	ply:SetColor(col)
	if alpha < 255 then
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
	//else
	//	ply:SetRenderMode(RENDERMODE_NORMAL) //Is this even needed? Probably not.
	end
	
	Weapon = ply:GetActiveWeapon()
	if(STValidEntity(Weapon)) then
		Weapon:SetColor(col)
		if alpha < 255 then
			Weapon:SetRenderMode(RENDERMODE_TRANSALPHA)
		//else
		//	Weapon:SetRenderMode(RENDERMODE_NORMAL) //Is this even needed? Probably not.
		end
	end
end

local Changed = false

function STGamemodes:DistanceCloaking()
	if(!STGamemodes.HideDistance) then
		STGamemodes.HideDistance = 256
	end
	if(!LocalPlayer():Alive() or LocalPlayer():GetNWString("ScoreboardStatus", LocalPlayer().ScoreboardStatus or "") == "Winner") then
		if(Changed) then
			Changed = false
			for k,v in pairs(player.GetAll()) do
				if(v.AlphaChanged) then
					v.AlphaChanged = false
					self:SetPlayerColor(v, 255)
				end
			end
		end
		return
	end
	Changed = true
	Pos = LocalPlayer():GetPos()
	for k,v in pairs(player.GetAll()) do
		if(v != LocalPlayer() and (!STGamemodes.TeamCloaking or v:Team() == LocalPlayer():Team())) then
			Distance = Pos:Distance(v:GetPos())
			if(Distance < self.HideDistance and v:GetNWString("ScoreboardStatus", v.ScoreboardStatus or "") != "Winner") then
				v.AlphaChanged = true
				self:SetPlayerColor(v, ((Distance <= 32) and 0) or math.Clamp(((255 / self.HideDistance) * Distance) - 32, 0, 255))
			elseif(v.AlphaChanged) then
				v.AlphaChanged = false
				self:SetPlayerColor(v, 255)
			end
		end
	end
end
