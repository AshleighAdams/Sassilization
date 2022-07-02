--------------------
-- STBase
-- By Spacetech
--------------------

function STRTD.AddChat( um )
	local Text = um:ReadString()
	if !Text then return end
	STGamemodes.ChatBox:AddChatManual( nil, nil, Text, nil, Color( 0, 255, 255 ) )
end
usermessage.Hook( "STRTD.Chat", STRTD.AddChat )

--------------------------------------------------------------------
-- Invisible
--------------------------------------------------------------------
function STRTD:SetVisible( ply, visible )
	STGamemodes:SetPlayerColor( ply, visible and 255 or 11)
end
usermessage.Hook( "STRTD.SetVisible", function(um) STRTD:SetVisible( um:ReadEntity(), um:ReadBool() ) end )

--------------------------------------------------------------------
-- Screen Effects
--------------------------------------------------------------------
STRTD.bwe = {}
function STRTD:ResetBlind()
	self.bwe["$pp_colour_addr"]			= 1
	self.bwe["$pp_colour_addg"]			= 1
	self.bwe["$pp_colour_addb"]			= 1
	self.bwe["$pp_colour_brightness"]	= 0
	self.bwe["$pp_colour_contrast"]		= 0.5
	self.bwe["$pp_colour_colour"]		= 1
	self.bwe["$pp_colour_mulr"]			= 1
	self.bwe["$pp_colour_mulg"]			= 1
	self.bwe["$pp_colour_mulb"]			= 1
	self.Up = true
	self.DecreaseAmt = 0.002
end
STRTD:ResetBlind()

function STRTD:ScreenEffects()
	if !LocalPlayer():Alive() then return end
	if self.Blinded then
		-- Is there a better way to do this?
		if self.Up then
			self.bwe["$pp_colour_brightness"] = self.bwe["$pp_colour_brightness"] + 0.05
		else
			self.bwe["$pp_colour_brightness"] = self.bwe["$pp_colour_brightness"] - self.DecreaseAmt
		end
		
		if self.bwe["$pp_colour_brightness"] >= 1 then self.Up = false end
		
		if self.bwe["$pp_colour_brightness"] <= 0.62 and !self.Up then
			self.DecreaseAmt = 0.006
		end
		
		if self.bwe["$pp_colour_brightness"] <= 0 then self.EndBlind() end
		
		DrawMotionBlur( 0.1, 0.79, 0.05 )
		
		DrawColorModify(STRTD.bwe)
	elseif self.Blurred then
		DrawMotionBlur( 0.1, 1, 0.05 )
	end
end

function STRTD.StartBlind()
	STRTD:ResetBlind()
	STRTD.Blinded = true
	hook.Add( "RenderScreenspaceEffects", "STRTD.Blind", function() STRTD:ScreenEffects() end )
end

function STRTD.EndBlind()
	hook.Remove( "RenderScreenspaceEffects", "STRTD.Blind" )
	STRTD.Blinded = false
	STRTD:ResetBlind()
end
usermessage.Hook( "STRTD.BlindStart", STRTD.StartBlind )
-- usermessage.Hook( "STRTD.BlindEnd", STRTD.EndBlind )

function STRTD:SetBlurred( bool )
	if bool then 
		STRTD.Blurred = true
		hook.Add( "RenderScreenspaceEffects", "STRTD.Blur", function() STRTD:ScreenEffects() end )
	else
		hook.Remove( "RenderScreenspaceEffects", "STRTD.Blur" )
		STRTD.Blurred = false
	end
end
usermessage.Hook( "STRTD.Blur", function(um) STRTD:SetBlurred( um:ReadBool() ) end )


--------------------------------------------------------------------
-- Custom Views
--------------------------------------------------------------------
STRTD.CustomView = false
STRTD.Angle = Angle( 0, 0, 0 )

function STRTD:View( um )
	self.CustomView = um:ReadBool()
	self.Angle = um:ReadAngle()
end
usermessage.Hook( "STRTD.CustomView", function( um ) STRTD:View( um ) end )

local View = {}
function STRTD.CalcView(ply, origin, angles, fov)
	if(STGamemodes.ThirdPerson.GoodToGo(ply) or !STRTD.CustomView) then
		return
	end
	
	View.angles = angles + STRTD.Angle
	View.fov = fov
	View.origin = origin
	return View
end
hook.Add("CalcView", "STRTD.CalcView", STRTD.CalcView)

--------------------------------------------------------------------
-- Entity Disco
--------------------------------------------------------------------
local Disco = false

function STRTD.Disco( Reset )
	if LocalPlayer():Alive() and !Reset then
		for k,v in pairs( ents.GetAll() ) do
			if (v:IsPlayer() and !v:IsGhost()) or (v:IsValid() and !v:IsPlayer()) then
				local r,g,b,a = v:GetColor()
				v:SetColor( Color( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ), a ) )
			end
		end
	else
		for k,v in pairs( ents.GetAll() ) do
			if (v:IsPlayer() and !v:IsGhost()) or (v:IsValid() and !v:IsPlayer()) then
				local r,g,b,a = v:GetColor()
				v:SetColor( Color( 255, 255, 255, a ) )
			end
		end
		STRTD:ToggleDisco()
	end
end

function STRTD:ToggleDisco()
	Disco = !Disco
	if Disco then
		timer.Create( "Disco", 0.5, 0, function() self.Disco() end )
	elseif timer.Exists( "Disco" ) then
		self.Disco( true )
		timer.Destroy( "Disco" )
	end
end
usermessage.Hook( "STRTD.Disco", function() STRTD:ToggleDisco() end )

--------------------------------------------------------------------
-- Snow Vignette for Freeze
--------------------------------------------------------------------
local Frozen = false
usermessage.Hook( "STRTD.FreezeEffect", function()
	hook.Add( "HUDPaint", "STGamemodes.Christmas.SnowVignette", STGamemodes.Christmas.DrawSnowVignette )
	Frozen = true
	timer.Create( "EndFreeze", 10, 0, function() hook.Remove( "HUDPaint", "STGamemodes.Christmas.SnowVignette" ) end )
end )

--------------------------------------------------------------------
-- TimeBomb
--------------------------------------------------------------------
local EndTime = false
local Ent = false 
local QuadSize = 50
local IncAmt = 1
local Mat = Material("effects/select_ring")

function STRTD.BombPaint()
	if !Ent or !Ent:IsValid() then return end 
	QuadSize = QuadSize + IncAmt
	if QuadSize > 1000 then
		QuadSize = 50
		IncAmt = IncAmt*2
		if IncAmt > 1000 then IncAmt = 1 end 
		Ent:EmitSound( "buttons/blip2.wav", 511, 255 )
	end 
	
	cam.Start3D( Ent:EyePos(), Ent:EyeAngles(), nil, 0, 0, ScrW(), ScrH() )
		render.SetMaterial(Mat)
		render.DrawQuadEasy(Ent:EyePos()+Ent:GetForward(), vector_up, QuadSize, QuadSize, Color(50, 100, 150, 255))
	cam.End3D()
end 
hook.Add( "HUDPaint", "TimeBomb", STRTD.BombPaint )

usermessage.Hook( "STRTD.TimeBomb", function(um) 
	EndTime = um:ReadShort()
	Ent = um:ReadEntity()
end )

--------------------------------------------------------------------
-- Reset All
--------------------------------------------------------------------
function STRTD:ResetAll()
	if self.Blinded then
		self.EndBlind()
	end
	
	if self.Blurred then
		self:SetBlurred( false )
	end
	
	if Frozen then
		timer.Destroy( "EndFreeze" )
		hook.Remove( "HUDPaint", "STGamemodes.Christmas.SnowVignette" )
	end
	
	self.CustomView = false
	self.Angle = Angle( 0, 0, 0 )
	
	if Disco then
		self:ToggleDisco()
	end
	
	for k,v in pairs( player.GetAll() ) do
		STGamemodes:SetShrink( v, 1 )
		STRTD:SetVisible( v, true )
	end
end
usermessage.Hook( "STRTD:ResetAll", function() STRTD:ResetAll() end )
































