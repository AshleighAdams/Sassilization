
include( "player_row.lua" )
include( "player_frame.lua" )

surface.CreateFont( "coolvetica", 32, 500, true, false, "ScoreboardHeader" )
surface.CreateFont( "coolvetica", 22, 500, true, false, "ScoreboardSubtitle" )

local texGradient 	= surface.GetTextureID( "gui/center_gradient" )
local texLogo 		= surface.GetTextureID( "gui/gmod_logo" )


local PANEL = {}

function PANEL:Init()

	SCOREBOARD = self

	self.Hostname = vgui.Create( "Label", self )
	self.Hostname:SetText( GetHostName() )
	
	self.Description = vgui.Create( "Label", self )
	self.Description:SetText( GAMEMODE.Name .. " - " .. GAMEMODE.Author )
	
	self.PlayerFrame = vgui.Create( "PlayerFrame", self )
	
	self.PlayerRows = {}

	self:UpdateScoreboard()
	
	// Update the scoreboard every 1 second
	timer.Create( "ScoreboardUpdater", 1, 0, function() self.UpdateScoreboard() end )
	
	self.lblPing = vgui.Create( "Label", self )
	self.lblPing:SetText( "Ping" )
	
	self.lblKills = vgui.Create( "Label", self )
	self.lblKills:SetText( "Kills" )
	
	self.lblDeaths = vgui.Create( "Label", self )
	self.lblDeaths:SetText( "Deaths" )

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:AddPlayerRow( ply )

	local button = vgui.Create( "ScorePlayerRow", self.PlayerFrame:GetCanvas() )
	button:SetPlayer( ply )
	self.PlayerRows[ ply ] = button

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:GetPlayerRow( ply )

	return self.PlayerRows[ ply ]

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 170, 170, 170, 255 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() ) 
	
	// White Inner Box
	draw.RoundedBox( 4, 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4, Color( 230, 230, 230, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4 )
	
	// Sub Header
	draw.RoundedBox( 4, 5, self.Description.y - 3, self:GetWide() - 10, self.Description:GetTall() + 5, Color( 150, 200, 50, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self.Description:GetTall() + 8 ) 
	
	// Logo!
	surface.SetTexture( texLogo )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, 128, 128 ) 
	
	
	
	//draw.RoundedBox( 4, 10, self.Description.y + self.Description:GetTall() + 6, self:GetWide() - 20, 12, Color( 0, 0, 0, 50 ) )

end


/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.Hostname:SizeToContents()
	self.Hostname:SetPos( 115, 16 )
	
	self.Description:SizeToContents()
	self.Description:SetPos( 128, 64 )
	
	local iTall = self.PlayerFrame:GetCanvas():GetTall() + self.Description.y + self.Description:GetTall() + 30
	iTall = math.Clamp( iTall, 100, ScrH() * 0.9 )
	local iWide = math.Clamp( ScrW() * 0.8, 700, ScrW() * 0.6 )
	
	self:SetSize( iWide, iTall )
	self:SetPos( (ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 4 )
	
	self.PlayerFrame:SetPos( 5, self.Description.y + self.Description:GetTall() + 20 )
	self.PlayerFrame:SetSize( self:GetWide() - 10, self:GetTall() - self.PlayerFrame.y - 10 )
	
	local y = 0
	
	local PlayerSorted = {}
	
	for k, v in pairs( self.PlayerRows ) do
	
		table.insert( PlayerSorted, v )
		
	end
	
	table.sort( PlayerSorted, function ( a , b) return a:HigherOrLower( b ) end )
	
	for k, v in ipairs( PlayerSorted ) do
	
		v:SetPos( 0, y )	
		v:SetSize( self.PlayerFrame:GetWide(), v:GetTall() )
		
		self.PlayerFrame:GetCanvas():SetSize( self.PlayerFrame:GetCanvas():GetWide(), y + v:GetTall() )
		
		y = y + v:GetTall() + 1
	
	end
	
	self.Hostname:SetText( GetHostName() )
	
	self.lblPing:SizeToContents()
	self.lblKills:SizeToContents()
	self.lblDeaths:SizeToContents()
	
	self.lblPing:SetPos( self:GetWide() - 50 - self.lblPing:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	self.lblDeaths:SetPos( self:GetWide() - 50*2 - self.lblDeaths:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	self.lblKills:SetPos( self:GetWide() - 50*3 - self.lblKills:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	
	//self.lblKills:SetFont( "DefaultSmall" )
	//self.lblDeaths:SetFont( "DefaultSmall" )

end

/*---------------------------------------------------------
   Name: ApplySchemeSettings
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

	self.Hostname:SetFont( "ScoreboardHeader" )
	self.Description:SetFont( "ScoreboardSubtitle" )
	
	self.Hostname:SetFGColor( Color( 0, 0, 0, 200 ) )
	self.Description:SetFGColor( color_white )
	
	self.lblPing:SetFont( "DefaultSmall" )
	self.lblKills:SetFont( "DefaultSmall" )
	self.lblDeaths:SetFont( "DefaultSmall" )
	
	self.lblPing:SetFGColor( Color( 0, 0, 0, 100 ) )
	self.lblKills:SetFGColor( Color( 0, 0, 0, 100 ) )
	self.lblDeaths:SetFGColor( Color( 0, 0, 0, 100 ) )

end


function PANEL:UpdateScoreboard( force )

	if ( !force && !self:IsVisible() ) then return end

	for k, v in pairs( self.PlayerRows ) do
	
		if ( !k:IsValid() ) then
		
			v:Remove()
			self.PlayerRows[ k ] = nil
			
		end
	
	end
	
	local PlayerList = player.GetAll()	
	for id, pl in pairs( PlayerList ) do
		
		if ( !self:GetPlayerRow( pl ) ) then
		
			self:AddPlayerRow( pl )
		
		end
		
	end
	
	// Always invalidate the layout so the order gets updated
	self:InvalidateLayout()

end

vgui.Register( "ScoreBoard", PANEL, "Panel" )