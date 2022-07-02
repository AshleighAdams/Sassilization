--------------------
-- STBase
-- By Spacetech
--------------------
-- STChatBox v2.6
--------------------

STGamemodes.ChatBox = {}
STGamemodes.ChatBox.Chat = {}
STGamemodes.ChatBox.ChatFont = "STGamemodes.ChatFont"
STGamemodes.ChatBox.ChatLabelDefault = "Chat"
STGamemodes.ChatBox.ChatLabel = STGamemodes.ChatBox.ChatLabelDefault

STGamemodes.ChatBox.MaxLines = 10
STGamemodes.ChatBox.FadeOutTime = 10

STGamemodes.ChatBox.XOrigin = 80
STGamemodes.ChatBox.YOrigin = ScrH() - 145
timer.Create("Chatbox.ResetPositions", 15, 0, function()
	if ScrH() > 100 then 
		STGamemodes.ChatBox.YOrigin = ScrH() - 145 
	end 
end )

STGamemodes.ChatBox.ColorChat = Color(255, 255, 255, 255)
STGamemodes.ChatBox.ColorConsole = Color(217, 0, 25, 255)

STGamemodes.ChatBox.TeamPrefixColor = Color(0, 255, 0, 255)
STGamemodes.ChatBox.DeadPrefixColor = Color(125, 125, 125, 255)

surface.CreateFont(STGamemodes.ChatBox.ChatFont, {font="Tahoma",size=16, weight=1000, antialias=true})

local Red = Color(255, 0, 0, 255)
function STGamemodes.ChatBox:AddChatManual(ply, Name, Text, NameColor, TextColor, Rank, Time, TeamOnly, PlayerIsDead)
	local Prefix, PrefixColor = "", false
	if(TeamOnly) then
		Prefix = "(TEAM) "
		PrefixColor = self.TeamPrefixColor
	end
	if(PlayerIsDead and !GAMEMODE.NoDeadTag) then
		Prefix = Prefix.."(DEAD) "
		PrefixColor = self.DeadPrefixColor
	end
	table.insert(self.Chat, {
		Prefix = Prefix,
		Name = Name,
		Text = Text,
		PrefixColor = PrefixColor,
		NameColor = NameColor,
		TextColor = TextColor,
		Rank = Rank,
		Time = Time or os.clock(),
	})
	if(ply) then
		if(ply:Team() == TEAM_SPEC) then
			NameColor = color_white
		end
		if(ply:IsMod() or ply:IsSuperAdmin()) then
			chat.AddText(Red, STGamemodes.GetPrefix(ply).." ", NameColor, Name, color_white, ": ", TextColor, Text)
		elseif(TeamOnly) then
			chat.AddText(self.TeamPrefixColor, "(TEAM) ", NameColor, Name, color_white, ": ", TextColor, Text)
		elseif(PlayerIsDead and !GAMEMODE.NoDeadTag) then
			chat.AddText(self.DeadPrefixColor, "(DEAD) ", NameColor, Name, color_white, ": ", TextColor, Text)
		else
			chat.AddText(NameColor, Name, color_white, ": ", TextColor, Text)
		end
	else
		if(Name and NameColor) then
			chat.AddText(NameColor, Name, color_white, ": ", TextColor, Text)
		else
			if(STGamemodes.OnConsoleChat) then
				STGamemodes:OnConsoleChat(Text)
			end
			chat.AddText(TextColor, Text)
		end
	end
end

function STGamemodes.ChatBox:AddChat(ply, Text, TeamOnly, PlayerIsDead)
	if(string.Trim(Text) == "") then
		return
	end
	if(STValidEntity(ply)) then
		self:AddChatManual(ply, ply:CName(), Text, team.GetColor(ply:Team()), self.ColorChat, ply.GetRank and ply:GetRank() or "", nil, TeamOnly, PlayerIsDead)
	else
		if(string.find(string.lower(Text), "connected", 1, true) or string.find(string.lower(Text), "dropped", 1, true)) then
			return
		end
		if(string.find(string.lower(Text), "joined the game", 1, true) or string.find(string.lower(Text), "left the game", 1, true)) then
			return
		end
		self:AddChatManual(nil, nil, Text, nil, self.ColorConsole)
	end
end

function STGamemodes.ChatBox:GetTopY()
	if(!self.CacheTopY) then
		surface.SetFont(self.ChatFont)
		self.CacheTopY = STGamemodes.ChatBox.YOrigin - (select(2, surface.GetTextSize(" ")) * STGamemodes.ChatBox.MaxLines)
	end
	return self.CacheTopY
end

function STGamemodes.ChatBox:DrawText(X, Y, Red, Green, Blue, Alpha, Text)
	surface.SetTextPos(X + 1, Y + 1)
	surface.SetTextColor(0, 0, 0, Alpha)
	surface.DrawText(Text)
	surface.SetTextPos(X, Y)
	surface.SetTextColor(Red, Green, Blue, Alpha)
	surface.DrawText(Text)
end

function STGamemodes.ChatBox:DrawLine(X, Y, Rank, Prefix, Name, Text, PrefixColor, NameColor, TextColor, Alpha)
	local TWidth, THeight = surface.GetTextSize(Text)
	
	if(Rank and Name) then
		if(RepMat and RepMat[Rank]) then
			surface.SetDrawColor(255, 255, 255, Alpha)
			surface.SetMaterial(RepMat[Rank])
			surface.DrawTexturedRect(X - 36, Y + 1, 32, 16)
		end
		
		if(Prefix != "" and PrefixColor) then
			self:DrawText(X, Y, PrefixColor.r, PrefixColor.g, PrefixColor.b, Alpha, Prefix)
			X = X + select(1, surface.GetTextSize(Prefix))
		end
		
		Name = Name..": "
		self:DrawText(X, Y, NameColor.r, NameColor.g, NameColor.b, Alpha, Name)
		
		X = X + select(1, surface.GetTextSize(Name))
	end
	
	self:DrawText(X, Y, TextColor.r, TextColor.g, TextColor.b, Alpha, Text)
	
	return Y - THeight
end

function STGamemodes.ChatBox:HUDPaint()
	if(STGamemodes.PreChatBoxHUDPaint) then
		STGamemodes:PreChatBoxHUDPaint()
	end
	local X = STGamemodes.ChatBox.XOrigin
	local Y = STGamemodes.ChatBox.YOrigin
	local Lines = 0
	local Count = table.Count(self.Chat)
	local k, v = 0, 0
	
	surface.SetFont(self.ChatFont)
	for i=0,Count do
		k = Count - i
		v = self.Chat[k]
		if(v and Lines < self.MaxLines) then
			Y = self:DrawLine(X, Y, v.Rank, v.Prefix, v.Name, v.Text, v.PrefixColor, v.NameColor, v.TextColor, v.Alpha)
			Lines = Lines + 1
		else
			table.remove(self.Chat, k)
		end
	end
end
hook.Add("HUDPaint", "STGamemodes.ChatBox.HUDPaint", function() STGamemodes.ChatBox:HUDPaint() end)

function STGamemodes.ChatBox:Think()
	for k,v in pairs(self.Chat) do
		if(!v.Alpha) then
			v.Alpha = 255
		end
		if(self.Chatting) then
			if(v.Alpha != 255) then
				v.Alpha = 255
			end
			if(v.Fade) then
				v.Fade = false
			end
			v.FadeTime = CurTime() + self.FadeOutTime
		else
			if(v.Fade) then
				if(v.Alpha != 0) then
					v.Alpha = math.Clamp(v.Alpha - 2, 0, 255)
				end
			end
			if(!v.FadeTime) then
				v.FadeTime = CurTime() + self.FadeOutTime
				v.FadeAmount = 1
			end
			if(v.FadeTime <= CurTime()) then
				v.Fade = true
			end
		end
	end
end
hook.Add("Think", "STGamemodes.ChatBox.Think", function() STGamemodes.ChatBox:Think() end)

local PANEL = {}

function PANEL:Init()
	self.Bool = true
	
	self:SetZPos(-1000)
	
	self:SetPos(40, ScrH() - 125)
	
    self:SetSize(ScrW() * 0.4, 22)
	
	local X = 5
	
	self.ChatLabel = vgui.Create("DLabel", self)
	self.ChatLabel:SetPos(X, 3)
	self.ChatLabel:SetFont(STGamemodes.ChatBox.ChatFont)
	self.ChatLabel:SetText(STGamemodes.ChatBox.ChatLabelDefault)
	
	self.ChatLabel:SizeToContents()
	
	X = X + self.ChatLabel:GetWide()
	
	self.TextEntry = vgui.Create("DTextEntry", self)
	self.TextEntry:SetPos(X, 2)
	self.TextEntry:SetSize(self:GetWide() - X - 3, self:GetTall() - 3)
	self.TextEntry:SetAllowNonAsciiCharacters(true)
	self.TextEntry.OnKeyCodeTyped = function(TextEntry, Code)
		local Text = TextEntry:GetValue()
		if(Code == KEY_ENTER) then
			if(Text and Text != "") then
				if(STGamemodes.ChatBox.ChatLabel == "Command") then
					Text = "/"..Text
				elseif(STGamemodes.ChatBox.ChatLabel == "Admin") then
					Text = "@"..Text
				elseif(STGamemodes.ChatBox.ChatLabel == "Dev/Mod") then
					Text = "\\"..Text
				end
				if(STGamemodes.ChatBox.ChatLabel == "Team") then
					RunConsoleCommand("say_team", Text)
				else
					RunConsoleCommand("say", Text)
				end
			end
			self:ToggleVisible(false)
		elseif(Code == KEY_BACKSPACE) then
			if(STGamemodes.ChatBox.ChatLabel != STGamemodes.ChatBox.ChatLabelDefault and TextEntry:GetCaretPos() == 0) then
				STGamemodes.ChatBox.ChatLabel = STGamemodes.ChatBox.ChatLabelDefault
				TextEntry:OnTextChanged()
			elseif(Text == "") then
				self:OnKeyCodePressed(KEY_ESCAPE)
				return true
			end
		elseif(Code == KEY_TAB) then
			TextEntry:SetCaretPos(TextEntry:GetCaretPos())
			//Sassafrass
			self:CompleteName(TextEntry:GetValue(), TextEntry:GetCaretPos())
			return true
		elseif(Code == KEY_ESCAPE) then
			self:OnKeyCodePressed(Code)
			return true
		end
	end
	self.TextEntry.OnTextChanged = function(TextEntry)
		self:OnChatChange(TextEntry:GetValue())
	end
end

function PANEL:CalcResize()
	self.ChatLabel:SizeToContents()
	self.TextEntry:MoveRightOf(self.ChatLabel)
	self.TextEntry:SetWide(self:GetWide() - self.ChatLabel:GetWide() - 8)
end

function PANEL:OnChatChange(Text)
	local Sub = string.sub(string.Trim(Text), 1, 1)
	local ChatLabel = STGamemodes.ChatBox.ChatLabel
	if(Sub == "/") then
		STGamemodes.ChatBox.ChatLabel = "Command"
	elseif(Sub == "@") then
		STGamemodes.ChatBox.ChatLabel = "Admin"
	elseif(Sub == "\\") then
		STGamemodes.ChatBox.ChatLabel = "Dev/Mod"
	end
	if(STGamemodes.ChatBox.ChatLabel != self.ChatLabel.ChatLabel) then
		self.ChatLabel.ChatLabel = STGamemodes.ChatBox.ChatLabel
		self.ChatLabel:SetText(STGamemodes.ChatBox.ChatLabel..": ")
		self.TextEntry:SetText("")
		self:CalcResize()
	end
end

function PANEL:CompleteName(Text, Pos)
	local reverse = Text:reverse();
	local startIndex = Text:len() - (reverse:find(" ", Text:len()-Pos+1) or Text:len()+1) + 2;
	local str = Text:sub( startIndex, Text:find(" ", Pos) );
	local pl = STGamemodes.FindByPartial( str )
	if( STValidEntity(pl) ) then
		local leftStr = Text:sub( 0, startIndex-1 )
		local rightStr = Text:sub( Text:find( " ", startIndex ) or Text:len()+1 )
		local name = pl:GetNWString("FakeName") // fakename autocomplete
		if( name == "") then
			name = pl:Name()
		end
		self.TextEntry:SetText( leftStr .. name .. rightStr )
		self.TextEntry:SetCaretPos( (leftStr..name):len() )
	end
end

function PANEL:SetInput(Text)
	self.TextEntry:SetText(Text)
	self.TextEntry:SetCaretPos(string.len(Text))
end

function PANEL:SetTeamChat(TeamOnly)
	self.TeamOnly = TeamOnly
end

function PANEL:ToggleVisible(Bool)
	if(self.Bool == Bool) then
		return
	end
	
	self.Bool = Bool
	STGamemodes.ChatBox.Chatting = Bool
	
	if(self.TeamOnly) then
		STGamemodes.ChatBox.ChatLabel = "Team"
	else
		STGamemodes.ChatBox.ChatLabel = STGamemodes.ChatBox.ChatLabelDefault
	end
	
	self:OnChatChange("")
	
	if(Bool) then
		if(STGamemodes.ChatBox.Remembered and STGamemodes.ChatBox.Remembered == 2) then
			RestoreCursorPosition()
		end
	else
		if(!STGamemodes.ChatBox.Remembered) then
			STGamemodes.ChatBox.Remembered = 1
		elseif(STGamemodes.ChatBox.Remembered == 1) then
			STGamemodes.ChatBox.Remembered = 2
		end
		RememberCursorPosition()
	end
	
	self:SetKeyboardInputEnabled(Bool)
	self:SetMouseInputEnabled(Bool)
	
	self:SetVisible(Bool)
	
	if(Bool) then
		self:MakePopup()
		self:SetFocusTopLevel(true)
		self.TextEntry:RequestFocus()
		self:SetPos(40, ScrH() - 125)
		--timer.Simple(0.1, RunConsoleCommand, "gameui_preventescapetoshow")
	else
		self.TextEntry:SetText("")
		--timer.Simple(0.1, RunConsoleCommand, "gameui_allowescapetoshow")
	end
end

function PANEL:OnKeyCodePressed(Code)
	if(Code == KEY_ESCAPE) then
		self:ToggleVisible(false)
	end
end

function PANEL:Paint()
	draw.RoundedBox(4, 0, 0, self.ChatLabel:GetWide() + 6, self:GetTall(), Color(0, 0, 0, 200))
end

vgui.Register("STGamemodes.ChatBox.Panel", PANEL, "EditablePanel")

function GM:StartChat()
	return true
end

function GM:ChatText(Index, Name, Text, Filter)
	if(tonumber(Index) == 0) then
		STGamemodes.ChatBox:AddChat(false, Text)
	end
	return true
end

function GM:OnPlayerChat(ply, Text, TeamOnly, PlayerIsDead)
	if(bTeamOnly) then
		if(STValidEntity(ply) and STValidEntity(LocalPlayer())) then
			if(ply:Team() != TEAM_SPEC and LocalPlayer():Team() != TEAM_SPEC) then
				if(ply:Team() != LocalPlayer():Team()) then
					return
				end
			end
		end
	end
	STGamemodes.ChatBox:AddChat(ply, Text, TeamOnly, PlayerIsDead)
	return true
end

function STGamemodes.ChatBox:PlayerBindPress(ply, bind, pressed)
	if(!self.Panel or !self.Panel:IsValid()) then
		self.Panel = vgui.Create("STGamemodes.ChatBox.Panel")
		self.Panel:ToggleVisible(false)
	end
	if(bind == "messagemode" or bind == "messagemode2") then
		self.Panel:SetTeamChat(bind == "messagemode2")
		self.Panel:ToggleVisible(true)
		return true
	end
end
hook.Add("PlayerBindPress", "STGamemodes.ChatBox.PlayerBindPress", function(ply, bind, pressed) return STGamemodes.ChatBox:PlayerBindPress(ply, bind, pressed) end)

usermessage.Hook("STGamemodes.ChatBox.AddChat", function(um)
	local ply = um:ReadEntity()
	local Text = um:ReadString()
	local Col = um:ReadVector()
	
	if(!STValidEntity(ply)) then
		return
	end
	
	local NameColor = team.GetColor(ply:Team())
	local TextColor = Color(Col.x, Col.y, Col.z, 255)
	
	STGamemodes.ChatBox:AddChatManual(ply, ply:CName(), Text, NameColor, TextColor, ply:GetRank())
end)

usermessage.Hook("STGamemodes.ChatBox.Me", function(um)
	local Text = um:ReadString()
	
	STGamemodes.ChatBox:AddChatManual(nil, nil, Text, nil, Color(235,225,203,255))
end)

usermessage.Hook("STGamemodes.ChatBox.AddCustomChat", function(um)
	local Name = um:ReadString()
	local Text = um:ReadString()
	local NameColor = um:ReadVector()
	local TextColor = um:ReadVector()
	
	NameColor = Color(NameColor.x, NameColor.y, NameColor.z, 255)
	TextColor = Color(TextColor.x, TextColor.y, TextColor.z, 255)
	
	STGamemodes.ChatBox:AddChatManual(nil, Name, Text, NameColor, TextColor, "guest")
end)

usermessage.Hook("STGamemodes.ChatBox.ConsoleMessage", function(um)
	local Text = um:ReadString()
	local Col = um:ReadVector()
	chat.AddText(Color(Col.x, Col.y, Col.z, 255), Text)
end)
