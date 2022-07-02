--------------------
-- STBase
-- By Spacetech
--------------------

local texHeader = surface.GetTextureID("sassilization/scoreboardHeader2")
local texBack = surface.GetTextureID("gui/center_gradient")
local texGrad = surface.GetTextureID("gui/gradient")

local texCoins = surface.GetTextureID("sassilization/hud/coins")

local playercount = 0

surface.CreateFont("bScoreboardHead", {font="coolvetica",size=48, weight=500, antialias=true})
surface.CreateFont("bScoreboardSub", {font="coolvetica",size=24, weight=500, antialias=true})
surface.CreateFont("bScoreboardText", {font="Tahoma",size=12, weight=1000, antialias=true})
surface.CreateFont("sScoreboardHeader", {font="Segoe UI",size=16, weight=400, antialias=true})
surface.CreateFont("sScoreboardServerName", {font="Frutiger",size=20, weight=700, antialias=true})
surface.CreateFont("sScoreboardText", {font="Segoe UI",size=18, weight=400, antialias=true})
surface.CreateFont("sScoreboardServer", {font="Segoe UI Italic",size=32, weight=600, antialias=true})

if(GM.Scoreboard) then
	GM.Scoreboard:Remove()
end
if(GAMEMODE) then
	if(GAMEMODE.Scoreboard) then
		GAMEMODE.Scoreboard:Remove()
	end
end

hook.Add("PlayerBindPress", "STGamemodes.Scoreboard.PlayerBindPress", function(ply, bind)
	local Bind = string.Trim(string.lower(bind))
	if(string.find(Bind, "invprev")) then
		if(GAMEMODE.Scoreboard and GAMEMODE.Scoreboard:IsValid() and GAMEMODE.Scoreboard:IsVisible()) then
			GAMEMODE.Scoreboard:AddScroll(1)
			return true
		end
	elseif(string.find(Bind, "invnext")) then
		if(GAMEMODE.Scoreboard and GAMEMODE.Scoreboard:IsValid() and GAMEMODE.Scoreboard:IsVisible()) then
			GAMEMODE.Scoreboard:AddScroll(-1)
			return true
		end
	end
end)

function GM:CreateScoreboard()
	if(self.Scoreboard and self.Scoreboard:IsValid()) then
		self.Scoreboard:Remove()
	end
	self.Scoreboard = vgui.Create("Scoreboard")
	return true
end

function GM:ScoreboardShow()
	if(!self.Scoreboard or !self.Scoreboard:IsValid()) then
		self.Scoreboard = vgui.Create("Scoreboard")
	end
	self.Scoreboard:SetVisible(true)
	self.Scoreboard:SetKeyboardInputEnabled(true)
	self.Scoreboard:RequestFocus()
	self.Scoreboard.m_fCreateTime = SysTime()
	return true
end

function GM:ScoreboardHide()
	if(self.Scoreboard and self.Scoreboard:IsValid()) then
		self.Scoreboard:SetVisible(false)
	end
	return true
end

local PANEL = {}

function PANEL:Init()	
	self:SetZPos( 1000 )
	
	self:SetSize( ScrW(), ScrH() )
	self:SetPos( 0, 0 )
	self.Scroll = 0
	
	self.PlayerList = vgui.Create( "Panel", self )
	self.PlayerList:SetWide( 768 )
	self.PlayerList.OnMouseWheeled = function( panel, dlta )
		self:OnMouseWheeled( dlta )
	end
	
	self.Players = vgui.Create( "PlayerList", self.PlayerList )
	self.Players.OnMouseWheeled = function( panel, dlta )
		self:OnMouseWheeled( dlta )
	end

	self:SetVisible( false )
	
end

function PANEL:OnMouseWheeled( dlta )	
	
	if !self:IsVisible() then return false end
	
	return self:AddScroll( dlta )
	
end

function PANEL:AddScroll( dlta )

	if self.PlayerList:GetTall() > self.Players:GetTall() then return end
	
	local OldScroll = self:GetScroll()

	dlta = dlta * playercount
	self:SetScroll( self:GetScroll() + dlta )
	
	return OldScroll == self:GetScroll()
	
end

function PANEL:SetScroll( scrll )
	
	self.Scroll = math.Clamp( scrll, self.PlayerList:GetTall()-self.Players:GetTall(), 0 )
	
	self.Players:SetPos( 0, self.Scroll )
	
end

function PANEL:GetScroll()
	
	return self.Scroll
	
end

function PANEL:GetTeamCheck(Team1, Team2)
	if(SCOREBOARD_ORDER) then
		if(SCOREBOARD_ORDER[Team1] != nil and SCOREBOARD_ORDER[Team2] != nil) then
			return SCOREBOARD_ORDER[Team1] > SCOREBOARD_ORDER[Team2]
		end
	end
	return Team1 > Team2
end

function PANEL:GetScoreInfo()
	
	local Info = {}
	
	for id,pl in pairs( player.GetAll() ) do
	
		local _team = pl:Team()
		local _frags = pl:Frags()
		local _Timer = pl:GetNetworkedFloat("Timer", 0)
		local _deaths = pl:Deaths()
		local _ping = pl:Ping()
		local _score = "N/A"

		if TIMERASSCORE then 
			if _Timer and _Timer > 0 and !pl:IsWinner() then 
				_score = STGamemodes:SecondsToFormat(math.floor(CurTime()-_Timer))
			else 
				local _Timer = pl:GetNWFloat("WinTime", 0)
				if _Timer and _Timer > 0 and pl:IsWinner() then 
					_score = STGamemodes:SecondsToFormat(math.floor(_Timer)) 
				end 
			end 
		else 
			_score = _frags - _deaths 
		end 
		
		local PlayerInfo = {}
		PlayerInfo.Dough = STFormatNum(pl:GetMoney())
		PlayerInfo.Score = _score
		PlayerInfo.Ping = _ping
		PlayerInfo.Name = pl:CName()
		PlayerInfo.Rank = pl:GetRank()
		
		if(pl:Team() == TEAM_SPEC) then
			Status = "Spectating"
		elseif(pl:Alive()) then
			Status = pl:GetNWString("ScoreboardStatus", pl.ScoreboardStatus or "Playing")
		else
			Status = "Dead"
		end
		
		PlayerInfo.Status = Status
		PlayerInfo.Team = _team
		PlayerInfo.PlayerObj = pl
		
		local insertPos = #Info+1
		for idx,info in pairs(Info) do
			if(self:GetTeamCheck(PlayerInfo.Team, info.Team)) then
				insertPos = idx
				break
			elseif(PlayerInfo.Team == info.Team) then
				if(PlayerInfo.Rank and info.Rank) then
					if(PlayerInfo.Rank > info.Rank) then
						insertPos = idx
						break
					elseif(PlayerInfo.Rank == info.Rank) then
						if(PlayerInfo.Name < info.Name) then
							insertPos = idx
							break
						end
					end
				else
					if(PlayerInfo.Name < info.Name) then
						insertPos = idx
						break
					end
				end
			end
		end
		
		table.insert(Info, insertPos, PlayerInfo)
		
	end
	
	for id,pl in pairs(UserCP and UserCP.NewPlayers) do
		
		if !(STValidEntity( pl.actual ) and (pl.actual:IsPlayer() and !pl.actual:IsFake())) then
			pl.actual = nil
		end
		
		local PlayerInfo = {}
		PlayerInfo.Dough = STFormatNum(pl.actual and pl.actual:GetMoney() or pl.dough)
		PlayerInfo.Score = 0
		PlayerInfo.Ping = pl.actual and pl.actual:Ping() or 0
		PlayerInfo.Name = pl.actual and pl.actual:CName() or pl.name
		PlayerInfo.Rank = pl.actual and pl.actual:GetRank() or pl.rank
		PlayerInfo.Status = pl.status.display or ""
		PlayerInfo.Team = TEAM_FORUMS
		
		local insertPos = #Info+1
		table.insert(Info, insertPos, PlayerInfo)
	
	end
	
	playercount = #Info
	
	return Info
	
end

function PANEL:Paint()
	
	-- Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	//self:DrawBackgroundBlur()
	
	if (GAMEMODE.ScoreDesign == nil) then
	
		GAMEMODE.ScoreDesign = {}
		GAMEMODE.ScoreDesign.HeaderY = 145 // 128
		GAMEMODE.ScoreDesign.Height = ScrH() - GAMEMODE.ScoreDesign.HeaderY

	end
	
	local alpha = 255
	
	local ScoreboardInfo = self:GetScoreInfo()
	
	self.xOffset = ScrW() * 0.1
	//self.yOffset = 64
	self.scrWidth = ScrW()
	self.scrHeight = ScrH() - 64
	self.boardWidth = 618 //768
	self.boardHeight = self.scrHeight
	self.colWidth = 48
	
	self.boardHeight = GAMEMODE.ScoreDesign.Height
	
	self.xOffset = (self.scrWidth - self.boardWidth) * 0.5
	//self.yOffset = (self.scrHeight - self.boardHeight) * 0.5
	//self.yOffset = self.yOffset - self.scrHeight * 0.25
	
	local txWidth, txHeight
	
	self.yOffset = self.boardHeight
	
	surface.SetFont("sScoreboardHeader")
	for index,plinfo in pairs(ScoreboardInfo) do
		txWidth, txHeight = surface.GetTextSize( plinfo.Name )
		self.yOffset = self.yOffset + txHeight
	end
	
	self.yOffset = (ScrH() / 2) - (self.yOffset / 2) - (self.scrHeight - self.boardHeight) * 0.2
	
	self.yOffset = math.Clamp( self.yOffset, 32, self.scrHeight )		
	
	// Background
	-- surface.SetDrawColor( 56, 84, 100, 255 )
	-- surface.DrawRect( self.xOffset, self.yOffset, self.boardWidth, self.boardHeight+10)
	draw.RoundedBox( 4, self.xOffset, self.yOffset, self.boardWidth, self.boardHeight+10, Color(56, 84, 100, 255) )
	
	surface.SetTexture(texHeader)
	surface.SetDrawColor(255,255,255,255)
	render.SetScissorRect(self.xOffset, self.yOffset, self.xOffset + self.boardWidth, self.yOffset + self.boardHeight - 1, true)
	surface.DrawTexturedRect(self.xOffset, self.yOffset, 1024, 512)
	render.SetScissorRect(0, 0, 0, 0, false)

	surface.SetDrawColor(Color(0, 0, 0, 75))
	surface.DrawRect(self.xOffset, self.yOffset+GAMEMODE.ScoreDesign.HeaderY, self.boardWidth, self.boardHeight-GAMEMODE.ScoreDesign.HeaderY)

	surface.SetTexture(texBack)
	surface.SetDrawColor(255,255,255,150)
	surface.DrawTexturedRect(self.xOffset+self.boardWidth*0.10, self.yOffset+GAMEMODE.ScoreDesign.HeaderY, self.boardWidth*0.80, self.boardHeight-GAMEMODE.ScoreDesign.HeaderY)
		
	y = self.yOffset+GAMEMODE.ScoreDesign.HeaderY - 22
	
	surface.SetDrawColor( 40, 64, 77, 240 )
	surface.DrawRect( self.xOffset, y, self.boardWidth, 22 )
	
	local ServerName = GAMEMODE:GetGameDescription()
	surface.SetFont("sScoreboardServerName")
	local x2,y2 = surface.GetTextSize(ServerName)
	draw.SimpleText(ServerName, "sScoreboardServerName", self.xOffset + 585 , self.yOffset+92+24/2-y2/2, color_white, 2)

	surface.SetFont("sScoreboardHeader")

	local textcolor = Color(255, 255, 255, 145)
	surface.SetTextColor(textcolor)

	local txWidth, txHeight = surface.GetTextSize("W")
	y = y + (22/2 - txHeight/2)-1

	surface.SetTextPos(self.xOffset + 5, y)											surface.DrawText("Rep")
	surface.SetTextPos(self.xOffset + 43, y)										surface.DrawText("Player")
	surface.SetTextPos(self.xOffset + self.boardWidth - (self.colWidth*8) + 8, y)	surface.DrawText("Dough")


	draw.SimpleText(TIMERASSCORE and "Time" or "Score", "sScoreboardHeader", self.xOffset + self.boardWidth - (self.colWidth*5.6) + 4, y, textcolor, 1)
	draw.SimpleText("Status", "sScoreboardHeader", self.xOffset + self.boardWidth - (self.colWidth*4), y, textcolor, 1)
	draw.SimpleText("Ping", "sScoreboardHeader", self.xOffset + self.boardWidth - (self.colWidth*2.5), y, textcolor, 1)
	draw.SimpleText("Team", "sScoreboardHeader", self.xOffset + self.boardWidth - (self.colWidth*1) - 4, y, textcolor, 1)
	
	y = self.yOffset+GAMEMODE.ScoreDesign.HeaderY
	
	local yPosition = y
	
	self.Players:Update( ScoreboardInfo )
	self.PlayerList:SetPos( self.xOffset, yPosition )
	local tall = math.Max( GAMEMODE.ScoreDesign.Height - yPosition + self.yOffset, txHeight + 4 )
	if tall != self.PlayerList:GetTall() then
		self.PlayerList:SetTall(tall)
	end
	
	if self.PlayerList:GetTall() >= self.Players:GetTall() then
		self.Players:SetPos( 0, 0 )
	end
	
	yPosition = yPosition + self.Players:GetTall()
	
	GAMEMODE.ScoreDesign.Height = (GAMEMODE.ScoreDesign.Height * 2) + (yPosition-self.yOffset)
	GAMEMODE.ScoreDesign.Height = math.Clamp( GAMEMODE.ScoreDesign.Height / 3, 0, ScrH() - GAMEMODE.ScoreDesign.HeaderY )
	GAMEMODE.ScoreDesign.VisiHeight = yPosition
end

function PANEL:PaintOver()
		
	-- surface.SetDrawColor(Color(90, 90, 90, 80))
	-- local y = self.yOffset + GAMEMODE.ScoreDesign.HeaderY - 22
	-- local yy = self.yOffset + self.boardHeight
	-- local x = self.xOffset + self.boardWidth
	-- surface.DrawLine(self.xOffset + self.colWidth, y, self.xOffset + self.colWidth, yy)
	-- surface.DrawLine(x - (self.colWidth*9.8)+4, y, x - (self.colWidth*9.8)+4, yy)
	-- surface.DrawLine(x - (self.colWidth*6.8)+4, y, x - (self.colWidth*6.8)+4, yy)
	-- surface.DrawLine(x - (self.colWidth*5.6)+4, y, x - (self.colWidth*5.6)+4, yy)
	-- surface.DrawLine(x - (self.colWidth*3.5)+4, y, x - (self.colWidth*3.5)+4, yy)
	-- surface.DrawLine(x - (self.colWidth*1.75) - 4, y, x - (self.colWidth*1.75)-4, yy)
end

vgui.Register( "Scoreboard", PANEL, "Panel" )

local PANEL = {}

function PANEL:Init()
	
	self:SetWide( self:GetParent():GetWide() )
	self.ScoreboardInfo = {}
	
end

function PANEL:Update( info )
	
	self.ScoreboardInfo = info
	
end

function PANEL:Paint()
	
	self.xOffset = 0
	self.yOffset = 32
	self.scrWidth = ScrW()
	self.scrHeight = ScrH() - 64
	self.boardWidth = 618  //768
	self.boardHeight = self.scrHeight
	self.colWidth = 48
	local yPosition = 0
	
	local bgWhite = 160
	local ForumsA = 100
	local textcolor = Color( 0, 0, 0, 240 )
	for index,plinfo in pairs(self.ScoreboardInfo) do
			

		
		if (plinfo.PlayerObj == LocalPlayer()) then
			surface.SetDrawColor( 255, 255, 255, 125 )
		elseif !plinfo.PlayerObj then
			-- surface.SetDrawColor( 100, 50, 50, 125 )
			surface.SetDrawColor( 20, 120, 120, ForumsA )
			textcolor = Color( 220, 220, 220, 240 )
			if ForumsA == 100 then 
				ForumsA = 75
			else 
				ForumsA = 100
			end 
		else
			surface.SetDrawColor(Color(bgWhite, bgWhite, bgWhite, 125))
		end

		surface.DrawRect(self.xOffset, yPosition, self.boardWidth, 22)
		surface.SetFont( "sScoreboardText" )
		surface.SetTextColor( 0, 0, 0, 255 ) 

		surface.SetTextPos( self.xOffset + 16, yPosition )
		txWidth, txHeight = surface.GetTextSize( plinfo.Name )
			
		local px, py = self.xOffset + 5, yPosition

		if plinfo.Rank and plinfo.Rank != "guest" then
			local mat = RepMat[plinfo.Rank]
			surface.SetMaterial(mat)
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect(px, py+4, 32, 16)
		end

		py = py + (22/2 - txHeight/2)
		
		px = self.xOffset + 43
		draw.SimpleText( STGamemodes.Truncate(plinfo.Name or "", self.boardWidth - (self.colWidth*8) - px + 4, "sScoreboardText"), "sScoreboardText", px, py, textcolor )
		
		px = self.xOffset + self.boardWidth - (self.colWidth*8) + 12
		surface.SetTexture(texCoins)
		surface.SetDrawColor(Color(255, 255, 255))
		surface.DrawTexturedRect(px - 2, yPosition + 3, 16, 16)
		draw.SimpleText( plinfo.Dough or "", "sScoreboardText", px + 16, py, textcolor )
		
		px = self.xOffset + self.boardWidth - (self.colWidth*5.6) + 4	//6.8 STARTS
		draw.SimpleText(plinfo.Score or "", "sScoreboardText", px, py, textcolor, 1)

		px = self.xOffset + self.boardWidth - (self.colWidth*4) //5.6 is start
		draw.SimpleText( plinfo.Status or "", "sScoreboardText", px, py, textcolor, 1 )
		
		px = self.xOffset + self.boardWidth - (self.colWidth*2.5)	//3.5 is start	
		draw.SimpleText( plinfo.Ping or "", "sScoreboardText", px, py, textcolor, 1 )
		
		py = yPosition

		if(plinfo.Team) then
			surface.SetFont("bScoreboardText")
			txWidth, txHeight = surface.GetTextSize( team.GetName(plinfo.Team) )
			px = (self.xOffset + self.boardWidth) - (self.colWidth*1)
			draw.RoundedBox( 4, px-txWidth/2-6, py + (22/2 - txHeight/2)-1, txWidth+4, txHeight+2, team.GetColor( plinfo.Team ) )
			
			local Col = Color( 255, 255, 255, 255 )
			
			draw.SimpleText( team.GetName(plinfo.Team), "bScoreboardText", px-txWidth/2-4, py+(22/2-txHeight/2), Col )
		end
		
		yPosition = yPosition + 22
		
		if (bgWhite == 160) then
			bgWhite = 190
		else
			bgWhite = 160
		end
	end

	if self:GetTall() != yPosition then
		self:SetTall( yPosition )
	end
	
end

vgui.Register( "PlayerList", PANEL, "Panel" )
