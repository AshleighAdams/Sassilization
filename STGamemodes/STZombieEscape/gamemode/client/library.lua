STGamemodes.HumansWin = nil

surface.CreateFont("GModNotify", {font="Verdana",size=17, weight=1000, antialias=true})
surface.CreateFont("ImpactHud", {font="Impact",size=32, weight=400, antialias=true})
surface.CreateFont("ImpactHudShadow", {font="Impact",size=32, weight=400, antialias=true, blursize=4})
surface.CreateFont("HudCalibri", {font="Calibri",size=24, weight=400, antialias=true})

local scale, fade
local grungeOverlay = surface.GetTextureID("ze/grungeoverlay")
function STGamemodes:PreChatBoxHUDPaint()

	if self.HumansWin == nil then
		fade = nil
		return
	end

	if fade == nil then
		fade = RealTime()
	end

	scale = math.Clamp(ScrH()/640,0,1.4)

	local fadeamount = math.Clamp( (RealTime()-fade) / 2, 0, 1)
	surface.SetDrawColor(255,255,255,255*fadeamount)

	--print("WIN? " .. tostring(self) .. " " .. tostring(self.HumansWin))

	if self.HumansWin then
		self:DrawHumansWin()
	elseif self.HumansWin == false then
		self:DrawZombiesWin()
	end

	surface.SetTexture(grungeOverlay)
	surface.DrawTexturedRect(0,0,ScrW(),ScrH())

end

local starOverlay = surface.GetTextureID("ze/staroverlay")
local humansWin = surface.GetTextureID("ze/humanswin") -- text
local hw, hh = surface.GetTextureSize(humansWin)
function STGamemodes:DrawHumansWin()

	surface.SetTexture(starOverlay)
	surface.DrawTexturedRect(0,0,ScrH(),ScrH())

	local w, h = math.floor(hw*scale), math.floor(hh*scale)
	local x, y = ScrW()/2 - w/2, math.floor(60*scale)
	surface.SetTexture(humansWin)
	surface.DrawTexturedRect(x,y,w,h)

end

local bloodOverlay = surface.GetTextureID("ze/bloodoverlay")
local zombieHand = surface.GetTextureID("ze/zombiehand")
local handw, handh = surface.GetTextureSize(zombieHand)
local zombiesWin = surface.GetTextureID("ze/zombieswin") -- text
local zw, zh = surface.GetTextureSize(zombiesWin)
function STGamemodes:DrawZombiesWin()

	surface.SetTexture(bloodOverlay)
	surface.DrawTexturedRect(0,0,ScrW(),ScrH())

	local w, h = math.floor(handw*scale), math.floor(handh*scale)
	local x, y = ScrW() - w - 128, ScrH() - h
	surface.SetTexture(zombieHand)
	surface.DrawTexturedRect(x,y,w,h)

	local w, h = math.floor(zw*scale), math.floor(zh*scale)
	local x, y = ScrW()/2 - w/2, math.floor(100*scale)
	surface.SetTexture(zombiesWin)
	surface.DrawTexturedRect(x,y,w,h)

end

usermessage.Hook("WinningTeam", function(um)
	local bHumansWin = um:ReadBool()
	local bReset = um:ReadBool()
	if bReset then
		STGamemodes.HumansWin = nil
	else
		STGamemodes.HumansWin = bHumansWin
	end
end)

/*---------------------------------------------------------
	DamageNotes displays the amount of damage done
	to enemies above their heads
---------------------------------------------------------*/
DamageNotes = {}
local fadetime = 3
function GM:DamageNotes()
	for k, v in pairs(DamageNotes) do
		local scrpos = v.Pos:ToScreen()
		local percent = math.Clamp((v.Time - RealTime())/fadetime, 0, 1)
		local c = Color(210, 0, 0, 255*percent) -- gradually fade
		local y = scrpos.y + 60*percent -- gradually rise
		
		draw.SimpleText(v.Amount, "ImpactHudShadow", scrpos.x, y, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(v.Amount, "ImpactHud", scrpos.x, y, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		if percent == 0 then table.remove(DamageNotes, k) end
	end
end

function AddDamageNote( um )
	local note = {}
	note.Amount	= um:ReadFloat()
	note.Pos 		= um:ReadVector() + Vector( 0, 0, 65 )
	note.Time 		= RealTime() + fadetime
	table.insert(DamageNotes, note)
end
usermessage.Hook( "DamageNotes", AddDamageNote )

/*---------------------------------------------------------
	Boss Health
---------------------------------------------------------*/
GM.BossEntities = {}
GM.LastBossUpdate = RealTime()

surface.CreateFont("BossFont", {font="Impact",size=24, weight=400, antialias=true})
local gradientUp = surface.GetTextureID("VGUI/gradient_up")
local maxBarHealth = 100
local deltaVelocity = 0.08 -- [0-1]
local bw = 12 -- bar segment width
local padding = 2
local colGreen = Color( 129, 215, 30, 255 )
local colDarkGreen = Color( 50, 83, 35, 255 )
local colDarkRed = Color( 132, 43, 24, 255 )
local curPercent = nil
function GM:BossHealth()
	for k, boss in pairs(self.BossEntities) do

		if !IsValid(boss.Ent) or boss.Health <= 0 then self.BossEntities[k] = nil return end
		if (LocalPlayer():GetPos() - boss.Ent:GetPos()):Length() > 4096 then return end

		-- Let's do some calculations first
		maxBarHealth = (boss.MaxHealth > 1000) and 1000 or 100
		local name = boss.Name and boss.Name or "BOSS"
		local totalHealthBars = math.ceil(boss.MaxHealth / maxBarHealth)
		local curHealthBar = math.floor(boss.Health / maxBarHealth)
		local percent = (boss.Health - curHealthBar*maxBarHealth) / maxBarHealth
		curPercent = !curPercent and 1 or math.Approach(curPercent, percent, math.abs(curPercent-percent)*0.08)

		local x, y = ScrW()/2, 80
		local w, h = ScrW()/3, 20

		-- Boss name
		surface.SetFont("BossFont")
		local tw, th = surface.GetTextSize(name)
		local x3, y3 = x-(w/2), y + h - padding*2
		local w3, h3 = tw + padding*4, th + padding
		draw.RoundedBox( 4, x3, y3, w3, h3, Color( 0, 0, 0, 255 ) )
		draw.SimpleText(name, "BossFont", x3 + padding*2, y3 + padding, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		
		-- Boss health bar segments
		local rw, rh = (bw + padding)*totalHealthBars + padding, th + padding
		local x4, y4 = x+(w/2)-rw, y + h - padding*2
		draw.RoundedBox( 4, x4, y4, rw, rh, Color( 0, 0, 0, 255 ) )

		for i=0,totalHealthBars-1 do
			local col = (i<curHealthBar) and colGreen or colDarkGreen
			draw.RoundedBox( 4, x4 + (bw + padding)*i + padding, y4 + padding*3, bw, bw + padding*2, col )
		end

		-- Health bar background
		draw.RoundedBox( 4, x-(w/2), y, w, h, Color( 0, 0, 0, 255 ) )

		-- Boss health bar
		local x2, y2 = x-(w/2) + padding, y + padding
		local w2, h2 = w - padding*2, h - padding*2
		draw.RoundedBox( 4, x2, y2, w2, h2, colDarkGreen ) -- dark green background
		draw.RoundedBox( 0, x2, y2, w*curPercent - padding*2, h2, colGreen )

		surface.SetDrawColor(0,0,0,100)
		surface.SetTexture(gradientUp)
		surface.DrawTexturedRect( x2, y2, w2, h2 )

	end
end

function RecieveBossSpawn( um )

	local index = um:ReadShort()
	local name = um:ReadString()
	
	local boss = GAMEMODE.BossEntities[index]
	if !boss then
		GAMEMODE.BossEntities[index] = {}
		boss = GAMEMODE.BossEntities[index]
		boss.Ent = Entity(index)
		boss.Name = string.upper(name)
		boss.bSpawned = true

		Msg(name .. " boss has spawned.\n")
	end


end
usermessage.Hook( "BossSpawn", RecieveBossSpawn )

function RecieveBossUpdate( um )

	local index = um:ReadShort()
	local health, maxhealth = um:ReadShort(), um:ReadShort()
	
	local boss = GAMEMODE.BossEntities[index]
	if !boss then
		--Msg("Received boss update for non-existant boss.\n")
		GAMEMODE.BossEntities[index] = {}
		boss = GAMEMODE.BossEntities[index]
		boss.Ent = Entity(index)
	end
	
	boss.Health = health
	boss.MaxHealth = maxhealth
	--Msg("BOSS UPDATE " .. tostring(GAMEMODE.BossEntities[index].Ent) .. "\t" .. health .. "\t" .. boss.MaxHealth .. "\n")

	GAMEMODE.LastBossUpdate = RealTime()

end
usermessage.Hook( "BossTakeDamage", RecieveBossUpdate )

function RecieveBossDefeated( um )

	local index = um:ReadShort()
		
	if !GAMEMODE.BossEntities[index] then
		--Msg("Warning: Received boss death for non-existant boss!\n")
	else
		--Msg("BOSS DEATH " .. tostring(GAMEMODE.BossEntities[index].Ent) .. "\n")
		GAMEMODE.BossEntities[index] = nil
	end
	
end
usermessage.Hook( "BossDefeated", RecieveBossDefeated )


/*---------------------------------------------------------
	Throws a Hint sent from the map to the screen
	Entity: point_servercommand
---------------------------------------------------------*/
local MapMessages = {}

local colBlue			= Color(41,112,179,255)
local colOrange		= Color(214,143,76,255)

function GM:MapMessages()

	for k, v in pairs( MapMessages ) do
		
		local H = ScrH() / 1024
		local x = v.x - 75 * H
		local y = v.y - 300 * H
		
		if ( !v.w ) then
		
			surface.SetFont( "HudCalibri" )
			v.w, v.h = surface.GetTextSize( v.text )
		
		end
		
		local w = v.w
		local h = v.h

		draw.Rectangle( x - w + 8, y - 8, w + h, h, Color( 30, 30, 30, v.a ) )
		draw.SimpleText( v.text, "HudCalibri", x + h - 4, y - 8, Color(255,255,255,v.a), TEXT_ALIGN_RIGHT )
		
		-- Timer
		local wTime = math.Clamp( ((v.time + v.len - SysTime()) / v.len) * (w+h), 0, w+h )
		local xTime = (x - w + 8) + (w + h - wTime)	-- Timer bar drains to the right
		draw.Rectangle( x -w + 8, (y - 8) + h, w + h, 2, colOrange )
		draw.Rectangle( xTime, (y - 8) + h, wTime, 2, colBlue )
		
		local ideal_y = ScrH() - (#MapMessages - k) * (h + 6)
		local ideal_x = ScrW()
		
		local timeleft = v.len - (SysTime() - v.time)
		
		-- Cartoon style about to go thing
		if ( timeleft < 0.8  ) then
			ideal_x = ScrW() - 50
		end
		 
		-- Gone!
		if ( timeleft < 0.5  ) then
		
			ideal_x = ScrW() + (w+h) * 2
		
		end
		
		local spd = RealFrameTime() * 15
		
		v.y = v.y + v.vely * spd
		v.x = v.x + v.velx * spd
		
		local dist = ideal_y - v.y
		v.vely = v.vely + dist * spd * 1
		if (math.abs(dist) < 2 && math.abs(v.vely) < 0.1) then v.vely = 0 end
		local dist = ideal_x - v.x
		v.velx = v.velx + dist * spd * 1
		if (math.abs(dist) < 2 && math.abs(v.velx) < 0.1) then v.velx = 0 end
		
		-- Friction.. kind of FPS independant.
		v.velx = v.velx * (0.95 - RealFrameTime() * 8 )
		v.vely = v.vely * (0.95 - RealFrameTime() * 8 )
		
		if ( v.len - (SysTime() - v.time) ) < 0 then table.remove( MapMessages, k ) end

	end

end

function AddMapMessage( um )
	local msg	= {}
	msg.text	= um:ReadString()
	msg.time 	= SysTime()
	msg.len		= 10
	msg.velx	= -5
	msg.vely	= 0
	msg.x		= ScrW() + 200
	msg.y		= ScrH()
	msg.a		= 200
	table.insert( MapMessages, msg )
	
	print( "[ZE] " .. msg.text )
end
usermessage.Hook( "MapMessage", AddMapMessage )