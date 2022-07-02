--------------------
-- STBase
-- By Spacetech
--------------------

surface.CreateFont("STHUD44", {font="coolvetica",size=44, weight=400, antialias=true})
surface.CreateFont("STHUD22", {font="coolvetica",size=22, weight=400, antialias=true})
surface.CreateFont("STHUD20", {font="coolvetica",size=20, weight=400, antialias=true})
surface.CreateFont("STHUD44NO", {font="Arial",size=44, weight=700, antialias=true})
surface.CreateFont("STHUD30NO", {font="Arial",size=30, weight=700, antialias=true})
surface.CreateFont("STHUD22NO", {font="Arial",size=22, weight=700, antialias=true})
surface.CreateFont("STHUD20NO", {font="Arial",size=20, weight=700, antialias=true})
surface.CreateFont("STHUD15NO", {font="Arial",size=15, weight=700, antialias=true})
surface.CreateFont("STHUD12", {font="Tahoma",size=12, weight=1000, antialias=true})


local PANEL = {}

PANEL.healthX = 42
PANEL.healthY = 19

PANEL.healthWidth = 159
PANEL.healthHeight = 13

PANEL.HPTextX = 60
PANEL.HPTextY = 7

PANEL.DoughTextX = 74
PANEL.DoughTextY = 44

PANEL.maxHealth = 100

PANEL.teamX = 185
PANEL.teamY = 46

PANEL.ShadowSpace = 1

local BGHud = Material("sassilization/hud/hud3")

function PANEL:Init()
	self:SetSize(240, 69)
	
	self.Target = LocalPlayer()
	
	self.image = vgui.Create("DImage", self)
	self.image:SetSize(256, 128)
	self.image:SetPos(0, 0)
	self.image:SetMaterial(BGHud)
	
	self.fakeavatar = vgui.Create("DImage", self)
	self.fakeavatar:SetPos(9,11)
	self.fakeavatar:SetSize(32,32)
	self.fakeavatar:SetImage("sassilization/hud/missing_avatar2")

	self.avatar = vgui.Create("AvatarImage", self)
	self.avatar:SetPos(9, 11)
	self.avatar:SetSize(32, 32)
	self.avatar:SetPlayer(self.Target)
end

function PANEL:PaintOver()
	if(!STValidEntity(self.Target)) then
		return
	end
	
	self.maxHealth = (self.Target:IsVIP() and !GAMEMODE.NoHealthBonus) and 200 or 100
	if self.Target:IsFake() then 
		if self.maxHealth > 100 and !(self.Target:GetRank() == "vip") then 
			self.maxHealth = 100 
		end 
	end 
	
	------------------------------------------------------------------------
	
	self.rank = self.Target:GetRank()
	if(RepMat and RepMat[self.rank]) then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(RepMat[self.rank])
		surface.DrawTexturedRect(9, 48, 32, 16)
	end
	
	------------------------------------------------------------------------
	
	self.healthText = tostring((self.Target:Health() >= 0 and self.Target:Health() or 0))
	if self.Target:IsFake() then 
		if !(self.Target:GetRank() == "vip") and self.Target:Health() > 100 then 
			self.healthText = 100 
		end 
	end 
	
	if(self.Target:Alive()) then
		self.greenBarWidth = (math.Clamp(self.Target:Health(), 0, self.maxHealth) / self.maxHealth) * self.healthWidth
		self.redBarWidth = self.healthWidth - self.greenBarWidth
		
		surface.SetDrawColor(57, 146, 57, 230)
		surface.DrawRect(self.healthX, self.healthY, self.greenBarWidth, self.healthHeight)
		
		surface.SetDrawColor(195, 42, 16, 230)
		surface.DrawRect(self.healthX + self.greenBarWidth, self.healthY, self.redBarWidth, self.healthHeight)
	else
		self.healthText = "0"
		surface.SetDrawColor(172, 68, 67, 230)
		surface.DrawRect(self.healthX, self.healthY, self.healthWidth, self.healthHeight)
	end
	
	------------------------------------------------------------------------
	
	surface.SetFont("STHUD44")
	
	self.healthTextWidth, self.healthTextHeight = surface.GetTextSize(self.healthText)

	-- Shadow
	surface.SetTextPos(self.HPTextX+self.ShadowSpace, self.HPTextY+self.ShadowSpace)
	surface.SetTextColor(38, 38, 38, 255) 
	surface.DrawText(self.healthText)

	surface.SetTextPos(self.HPTextX, self.HPTextY)
	surface.SetTextColor(255, 255, 255, 255)
	surface.DrawText(self.healthText)
	
	------------------------------------------------------------------------
	
	surface.SetFont("STHUD20")

	-- Shadow
	surface.SetTextPos(self.HPTextX + self.healthTextWidth + 5 + self.ShadowSpace, 17 + self.ShadowSpace)
	surface.SetTextColor(38, 38, 38, 255)
	surface.DrawText("HP")
	
	surface.SetTextPos(self.HPTextX + self.healthTextWidth + 5, 17)
	surface.SetTextColor(255, 255, 255, 255)
	surface.DrawText("HP")
	
	------------------------------------------------------------------------
	
	self.money = tostring(self.Target:GetMoney())
	
	surface.SetFont("STHUD22")

	-- Shadow
	surface.SetTextPos(self.DoughTextX+self.ShadowSpace, self.DoughTextY+self.ShadowSpace)
	surface.SetTextColor(38, 38, 38, 255)
	surface.DrawText(STFormatNum(self.money))
	
	surface.SetTextPos(self.DoughTextX, self.DoughTextY)
	surface.SetTextColor(255, 255, 255, 255)
	surface.DrawText(STFormatNum(self.money))
	
	------------------------------------------------------------------------
	
	self.currentTeam = team.GetName(self.Target:Team())
	if(self.currentTeam) then
		surface.SetFont("STHUD12")
		
		local textWidth, textHeight = surface.GetTextSize(self.currentTeam)
		
		draw.RoundedBox(4, self.teamX, self.teamY + 1, textWidth + 4, textHeight, team.GetColor(self.Target:Team()))
		
		surface.SetFont("STHUD12")
		
		surface.SetTextPos(self.teamX + (textWidth / 2) - ((textWidth + 4) / 2) + 4, self.teamY)
		surface.SetTextColor(255, 255, 255, 255)
		surface.DrawText(self.currentTeam)
	end
end

local NextThink = 0
function PANEL:Think()

	if NextThink <= CurTime() then 
		if ScrH() >= 100 then 
			self:SetPos(0, ScrH() - self:GetTall())
			NextThink = NextThink+15 
		end 
	end 

	-- No more pesky avatars for fakers
	if self.Target:IsFake() then 
		self.fakeavatar:SetVisible(true)
		self.avatar:SetVisible(false)
	else 
		self.fakeavatar:SetVisible(false)
		self.avatar:SetVisible(true)
	end 

	-- Change HUD target to observed player if valid
	local target = LocalPlayer():GetObserverTarget()
	if STValidEntity(target) then
		if self.Target != target then
			self.Target = target
		end
	else -- otherwise make sure the local player is the target
		if self.Target != LocalPlayer() then
			self.Target = LocalPlayer()
		else
			return
		end
	end

	self.avatar:SetPlayer(self.Target) -- change avatar on target change
end

vgui.Register("STGamemodes.VGUI.HUD", PANEL, "Panel")


