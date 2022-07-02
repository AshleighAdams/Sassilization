--------------------
-- STBase
-- By Spacetech
--------------------

if(GAMEMODE and GAMEMODE.HUDPanel) then
	GAMEMODE.HUDPanel:Remove()
end

GM.HUDPanel = false

function GM:Initialize()
	-- timer.Create("ST.Gamemodes.ClearDecals", 30, 0, RunConsoleCommand, "r_cleardecals")
end

function GM:ShutDown()
	-- if(Jukebox.Panel and Jukebox.Panel:IsValid()) then
	-- 	Jukebox.Panel:StopSong(true)
	-- 	Jukebox.Panel:Remove()
	-- end
end

function GM:OnSpawnMenuOpen()
	RunConsoleCommand("lastinv")
end

function GM:SpawnMenuOpen()
	return true
end

function GM:SpawnMenuEnabled()
	return true
end

function GM:ContextMenuOpen()
	return true
end

function GM:HUDShouldDraw(Name)
	if(table.HasValue(self.HideHUD, Name)) then
		return false
	end
	if(STValidEntity(LocalPlayer()) and LocalPlayer():IsGhost() and Name == "CHudHealth") then
		return false
	end
	return true
end

function GM:CheckName(Name)
	for k,v in pairs(player.GetAll()) do
		if(v:IsFake() and v:GetName() == Name) then
			return v:CName()
		end
	end
	return Name
end

function GM:AddDeathNotice(Victim, Team1, Inflictor, Attacker, Team2)
	if(Team2 and Team2 == TEAM_DEAD) then
		if(Team1 == TEAM_RUN) then
			Team2 = TEAM_DEATH
		else
			Team2 = TEAM_RUN
		end
	end
	return self.BaseClass:AddDeathNotice(self:CheckName(Victim), Team1, Inflictor, self:CheckName(Attacker), Team2)
end

local NameTagUp = Vector(0, 0, 12)
local NameTagCol = Color(20, 20, 20, 150)
local NameTagTeamCol = Color(100, 200, 100, 150)

function GM:PaintTag(Name, ToScreen, Percent, Team)
	NameTagCol.a = 150 * Percent
	NameTagTeamCol.a = 150 * Percent

	if Team then Name = "[TEAM] ".. Name end 
	
	surface.SetFont("TabLarge")
	local TWidth, THeight = surface.GetTextSize(Name)
	
	draw.RoundedBox(4, ToScreen.x - (TWidth * 0.5) - 4, ToScreen.y - (THeight * 0.5) - 2, TWidth + 8, THeight + 4, Team and NameTagTeamCol or NameTagCol)
	surface.SetTextColor(0, 0, 0, !Team and (100 * Percent) or 100)
	surface.SetTextPos(ToScreen.x - (TWidth * 0.5) + 1, ToScreen.y - (THeight * 0.5) + 1)
	surface.DrawText(Name)
	
	surface.SetTextColor(255, 255, 255, 255 * Percent)
	surface.SetTextPos(ToScreen.x - (TWidth * 0.5), ToScreen.y - (THeight * 0.5))
	surface.DrawText(Name)
end

function GM:NameTagPaint()
	if !GetDrawingPlayers() and GAMEMODE and (GAMEMODE.Name == "Bunny Hop" or GAMEMODE.Name == "Climb") then return end 
	surface.SetFont("TabLarge")
	local Pos = LocalPlayer():EyePos()
	for k,v in pairs(player.GetAll()) do
		if(STValidEntity(v) and LocalPlayer() != v) then
			if(v:Alive() or ((LocalPlayer():IsGhost() or LocalPlayer():GetObserverMode() == OBS_MODE_ROAMING) and v:IsGhost())) then
			
				local col = v:GetColor()
				if v:Alive() and col.a == 20 and LocalPlayer():Team() != v:Team() then
					return
				end
				
				if(LocalPlayer():IsMod() or LocalPlayer():Team() != TEAM_RUN or v:Team() != TEAM_DEATH) then
					local Distance = v:EyePos():Distance(Pos)
					local Dist = (self.PaintTeam and LocalPlayer():Team() == v:Team()) and 2000 or 640
					if(Distance <= Dist) then
						local Eyes = v:LookupAttachment("anim_attachment_head")
						if(Eyes) then
							local Attachment = v:GetAttachment(Eyes)
							if(Attachment) then
								-- local tr = util.TraceLine({start = Pos, endpos = Attachment.Pos, mask = MASK_SOLID_BRUSHONLY})
								-- if(tr.Fraction == 1) then
									self:PaintTag(v:CName(), (Attachment.Pos + NameTagUp):ToScreen(),  math.Min((Dist - Distance + 200) / Dist, 1), self.PaintTeam and LocalPlayer():Team() == v:Team() )
								-- end
							end
						end
					end
				end
			end
		end
	end
end

function GM:SprayInfoPaint()
	for _, ent in pairs( ents.FindByClass( "info_spray" ) ) do
		local owner = ent:GetOwner()
		if (STValidEntity(owner) and owner:IsPlayer()) and ent:GetPos():Distance(LocalPlayer():EyePos()) < 120 then
			local pos = ent:GetPos():ToScreen()
			text = owner:CName()
			draw.SimpleText( text, font, pos.x+1, pos.y+1, Color(0,0,0,120),1 )
			draw.SimpleText( text, font, pos.x+2, pos.y+2, Color(0,0,0,50),1 )
			draw.SimpleText( text, font, pos.x+0, pos.y+0, self:GetTeamColor( owner ),1 )
			text = owner:SteamID()
			draw.SimpleText( text, font, pos.x+1, pos.y+18, Color(0,0,0,120),1 )
			draw.SimpleText( text, font, pos.x+2, pos.y+19, Color(0,0,0,50),1 )
			draw.SimpleText( text, font, pos.x+0, pos.y+17, self:GetTeamColor( owner ),1 )
		end
	end
end

STGamemodes.NotRed = 255
STGamemodes.LastFlash = CurTime()

local GhostMessage = {"You are a ghost!", "Press E to toggle noclip"}
local MarqTop = {"Press F1 for Help", "Press F2 to open the Store", "Press F3 to play", "Press F4 to open the Jukebox"}
local MarqBottom = {}

function GM:DrawMiddleInfo(Text)
	surface.SetFont("MenuLarge")
	
	local TWidth, THeight = surface.GetTextSize(Text)
	
	local width, height = TWidth + 10, 26
	local x, y = ((ScrW() / 2) - (width / 2)), 36
	
	surface.SetDrawColor(54, 77, 106, 200)
	surface.DrawRect(x, y, width, height)
	
	surface.SetDrawColor(154, 177, 206, 180)
	surface.DrawOutlinedRect(x - 1, y - 1, width, height)
	
	surface.SetTextPos(x + 5, y + 6)
	surface.SetTextColor(255, 255, 255, 255)
	surface.DrawText(Text)
end

function GM:HUDPaint()
	if RENDERSHIT then 
		local rend = render.Capture({format="jpeg", quality=40, x=0, y=x, w=ScrW(), h=ScrH()})
		file.Write("test.txt", rend) 
		RENDERSHIT = false 
	end 
	if(!STValidEntity(LocalPlayer())) then
		return
	end
	
	self:HUDDrawPickupHistory()
	self:DrawDeathNotice(0.85, 0.04)
	self:NameTagPaint()
	-- self:SprayInfoPaint()
	
	local NotRed = STGamemodes.NotRed
	if(STGamemodes.LastFlash <= CurTime() - 1) then
		STGamemodes.LastFlash = CurTime()
		if(STGamemodes.NotRed == 255) then
			STGamemodes.NotRed = 0
		else
			STGamemodes.NotRed = 255
		end
	end
	
	local Y = 5
	local Spacing = 25
	
	local ScreenWidth = ScrW()
	local ScreenHeight = ScrH()
	local Divide = ScreenWidth / 2
	
	local Team = LocalPlayer():Team()
	local SpecPlayer = LocalPlayer():GetObserverTarget()
	
	STGamemodes.Marquee:Draw("Top", 0, 0, MarqTop)
	
	if(self.RoundEndTime) then
		if((self.RoundEndTime - CurTime()) >= 0) then
			self:DrawMiddleInfo("Round Ends in "..tostring(math.Round(self.RoundEndTime - CurTime())).." seconds")
		end
	end
	
	if(LocalPlayer():IsGhost()) then
		STGamemodes.Marquee:Draw("Bottom", 0, ScrH() - 32, GhostMessage, true)
	elseif(!LocalPlayer():Alive()) then
		if(SpecPlayer and SpecPlayer:IsValid() and SpecPlayer:Alive() and SpecPlayer:Team() != TEAM_SPEC) then
			STGamemodes.Marquee:Draw("Bottom", 0, ScrH() - 32, {"You are currently spectating "..SpecPlayer:CName()}, true, true)
		elseif(LocalPlayer():GetObserverMode() != OBS_MODE_ROAMING) then
			local Players = STGamemodes:GetPlayers(TEAM_BOTH)
			local PlayerCount = table.Count(Players)
			if(PlayerCount > 0) then
				if(self.LastChangeSpec or 0 <= CurTime()) then
					RunConsoleCommand("st_spectator")
					self.LastChangeSpec = CurTime() + 1
				end
			end
		end
		if(self.DeadTime and LocalPlayer():Team() != TEAM_SPEC) then
			if(!self.DeathTimer) then
				self.DeathTimer = CurTime() + self.DeadTime
			end
			self:DrawMiddleInfo("You will respawn in "..tostring(math.Round(self.DeathTimer - CurTime())).." seconds")
		end
	elseif(self.DeathTimer) then
		self.DeathTimer = false
	end
	
	local ply = false 
	if LocalPlayer():Alive() and !LocalPlayer():IsWinner() then 
		ply = LocalPlayer() 
	else
		if SpecPlayer and SpecPlayer:IsValid() and SpecPlayer:Alive() and SpecPlayer:Team() != TEAM_SPEC and !SpecPlayer:IsWinner() then 
			ply = SpecPlayer 
		end 
	end 

	
	if(ply and ply:IsValid()) then
		local Timer, Text = ply:GetNetworkedFloat("Timer", 0), ""
		if ply != LocalPlayer() then 
			Text = ply:Name().."'s " 
		end 
		if Timer and Timer > 0 then 
			self:DrawMiddleInfo(Text.."Time: "..STGamemodes:SecondsToFormat(CurTime() - Timer, true)) 
		end 
	end
	
	if(self.OnHUDPaint) then
		self:OnHUDPaint()
	end
end

function GM:PostRenderVGUI()
	if(self.HUDPanel) then
		return
	end
	
	-- self:CreateHUD() For snoipa <3
	timer.Simple(2, function() self:CreateHUD() end)
	
	GAMEMODE.PostRenderVGUI = function() end
end

function GM:CreateHUD()
	if(self.HUDPanel and ValidPanel(self.HUDPanel)) then
		self.HUDPanel:Remove()
	end
	self.HUDPanel = vgui.Create("STGamemodes.VGUI.HUD")
	self.HUDPanel:SetPos(0, ScrH() - self.HUDPanel:GetTall())
	self.HUDPanel:SetVisible(true)
end

function GM:GUIMousePressed()
end

function GM:GUIMouseReleased()
end

usermessage.Hook("STGamemodesPS", function(um)
	local sound = um:ReadString()

	surface.PlaySound(sound)
end)

function STGamemodes.StartAct( um )
	local String = um:ReadString()
	local Command = string.Explode( " ", String )
	RunConsoleCommand( Command[1], Command[2] )
end
usermessage.Hook( "STGamemodes.StartAct", function(um) STGamemodes.StartAct( um ) end )

local ConVar = CreateClientConVar( "st__drawplayers", "1", true, false )
local tHop = CreateClientConVar( 'st__telehop', '1', true, true)

function GetDrawingPlayers(b)
	if b then 
		return (ConVar:GetBool() and GAMEMODE and (GAMEMODE.Name == "Climb" or GAMEMODE.Name == "Bunny Hop"))
	end 
	return ConVar:GetBool() 
end 

function GetTelehopStatus(b)
	if b then
		return (tHop:GetBool() and GAMEMODE and (GAMEMODE.Name == 'Bunny Hop'))
	end
	return tHop:GetBool()
end


function STGamemodes.DrawPlayers(ply)
	if GAMEMODE and (GAMEMODE.Name == "Climb" or GAMEMODE.Name == "Bunny Hop") then
		local Bool = GetDrawingPlayers()
		if Bool then
			return false
		elseif ply != LocalPlayer() then 
			return true
		end
	elseif GAMEMODE then 
		hook.Remove("PrePlayerDraw", "HidePlayers")
	end 
end

function STGamemodes.HidePlayers(ply, cmd, args)
	local Bool = !GetDrawingPlayers()
	if Bool then
		ply:ChatPrint("Players: Enabled")
		RunConsoleCommand("st__drawplayers", "1")
	else
		ply:ChatPrint("Players: Disabled")
		RunConsoleCommand("st__drawplayers", "0")
	end
	STGamemodes.Store.RefreshSettings = true
end
concommand.Add("st_hideplayers", STGamemodes.HidePlayers)

function STGamemodes.ToggleTeleHop(ply,cmd,args)
	local bool = !GetTelehopStatus()
	if bool then
		ply:ChatPrint("Telehopping: Enabled")
		RunConsoleCommand("st__telehop",'1')
	else
		ply:ChatPrint('Telehopping: Disabled')
		RunConsoleCommand('st__telehop','0')
	end
	STGamemodes.Store.RefreshSettings = true
end
concommand.Add('st_togtelehop',STGamemodes.ToggleTeleHop)

hook.Add("PrePlayerDraw", "HidePlayers", STGamemodes.DrawPlayers)