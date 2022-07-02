--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.HideDistance = 128
STGamemodes.TeamCloaking = true

function GM:Think()
	STGamemodes:DistanceCloaking()
end

--[[---------------------------------------
		HUD
-----------------------------------------]]
function GM:HUDPaint()
	self.BaseClass.HUDPaint(self)
	self:MapMessages()
	self:DamageNotes()
	self:BossHealth()
end

-- Because vignettes make everything look nicer	
local VignetteMat = Material( "sunabouzu/apartment_vignette" )
function GM:HUDPaintBackground()
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.SetMaterial( VignetteMat )
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
end

-- Zombie should only have one weapon, no need to see the weapon selection
local HideHUD = { "CHudWeaponSelection", "CHudCrosshair" }
local ShowHUD = { "CHudGMod", "CHudChat" }
hook.Add( "HUDShouldDraw", "ZombieWeapons", function(name)

	-- Don't draw too much over the win overlays
	if STGamemodes.HumansWin != nil and !table.HasValue(ShowHUD,name) then
		return false
	end

	if IsValid(LocalPlayer()) && LocalPlayer():IsZombie() && table.HasValue(HideHUD,name) then
		return false
	end
	
end )

--[[---------------------------------------
		Zombie Vision
-----------------------------------------]]
local delay
local tab = {}
	tab[ "$pp_colour_addr" ] 		= 0
	tab[ "$pp_colour_addg" ] 		= 0
	tab[ "$pp_colour_addb" ] 		= 0
	tab[ "$pp_colour_brightness" ] 	= 0
	tab[ "$pp_colour_contrast" ] 	= 1
	tab[ "$pp_colour_colour" ] 		= 1
	tab[ "$pp_colour_mulr" ] 		= 0
	tab[ "$pp_colour_mulg" ] 		= 0
	tab[ "$pp_colour_mulb" ] 		= 0
function ZombieVision()

	if !LocalPlayer():IsZombie() then delay = nil return end

	if GAMEMODE.bZombieLight then
		local dlight = DynamicLight( LocalPlayer():EntIndex() )
		if ( dlight ) then
			dlight.r = color_white.r
			dlight.g = color_white.r
			dlight.b = color_white.r
			dlight.Brightness = 0.5
			dlight.Size = 512
			dlight.Decay = 512
			dlight.Pos = LocalPlayer():GetShootPos()
			dlight.DieTime = CurTime() + 0.1
		end
	end

	delay = delay and math.Approach(delay, 1, 0.003) or 0
	tab[ "$pp_colour_colour" ] = 1 - (0.5 * delay)

	DrawColorModify( tab )

end
hook.Add( "RenderScreenspaceEffects", "ZombieVisionEffects", ZombieVision )

function ToggleLight(ply, bind, pressed)
	if !LocalPlayer():Alive() or !LocalPlayer():IsZombie() or LocalPlayer():FlashlightIsOn() then return end
	if string.find(bind, "impulse 100") then
		if GAMEMODE.bZombieLight then
			LocalPlayer():EmitSound('HL2Player.FlashLightOff')
			GAMEMODE.bZombieLight = false
		else
			LocalPlayer():EmitSound('HL2Player.FlashLightOn')
			GAMEMODE.bZombieLight = true
		end
	end
end
hook.Add( "PlayerBindPress", "ToggleZombieLight", ToggleLight )

--[[---------------------------------------
		Disable Bunny Hopping
-----------------------------------------]]
hook.Add( "CreateMove", "DisableBhop", function( input )
	local ply = LocalPlayer()
	if ply:Alive() && input:KeyDown( IN_JUMP ) && ply.NextJump &&  CurTime() < ply.NextJump then
		--Msg("Disabled jump for player\n")
		input:SetButtons( input:GetButtons() - IN_JUMP )
	end
end )

hook.Add( "OnPlayerHitGround", "SetNextJump", function( ply, bInWater, bOnFloater, flFallSpeed )
	--Msg("Player hit the ground\n")
	ply.NextJump = CurTime() + 0.08
end )