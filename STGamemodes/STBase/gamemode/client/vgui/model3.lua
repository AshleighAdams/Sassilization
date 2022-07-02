
local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )


/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.Entity = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	
	self:SetCamPos( Vector( 60, 60, 50 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 70 )
	
	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )
	
	self:SetAmbientLight( Color( 50, 50, 50 ) )
	
	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	
	self:SetColor( Color( 255, 255, 255, 255 ) )

end

function PANEL:OnCursorEntered()
	if (!self:GetParent().OnCursorEntered) then return end
	self:GetParent():OnCursorEntered()
end

function PANEL:OnCursorMoved()
	if (!self:GetParent().OnCursorMoved) then return end	
	self:GetParent():OnCursorMoved()
end

function PANEL:OnCursorExited()
	if (!self:GetParent().OnCursorExited) then return end	
	self:GetParent():OnCursorExited()
end

function PANEL:OnMousePressed(mc)
	if (!self:GetParent().OnMousePressed) then return end	
	self:GetParent():OnMousePressed(mc)
end

/*---------------------------------------------------------
   Name: SetDirectionalLight
---------------------------------------------------------*/
function PANEL:SetDirectionalLight( iDirection, color )
	self.DirectionalLight[iDirection] = color
end

/*---------------------------------------------------------
   Name: OnSelect
---------------------------------------------------------*/
function PANEL:SetModel( strModelName )

	// Note - there's no real need to delete the old 
	// entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
		self.Entity = nil		
	end
	
	// Note: Not in menu dll
	if ( !ClientsideModel ) then return end
	
	self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid(self.Entity) ) then return end
	
	self.Entity:SetNoDraw( true )
	
	// Try to find a nice sequence to play
	local iSeq = self.Entity:LookupSequence( "walk_all" );
	if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end
	
	if (iSeq > 0) then self.Entity:ResetSequence( iSeq ) end
	
	if (self.PostSetModel) then
		self:PostSetModel()
	end
end

/*---------------------------------------------------------
   Name: OnSelect
---------------------------------------------------------*/
function PANEL:SetHatModel( strModelName, posHat, scale )

	// Note - there's no real need to delete the old 
	// entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.HatEntity ) ) then
		self.HatEntity:Remove()
		self.HatEntity = nil		
	end
	
	// Note: Not in menu dll
	if ( !ClientsideModel ) then return end
	
	self.HatEntity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid(self.HatEntity) ) then return end
	
	self.HatEntity:SetNoDraw( true )
	self.HatEntity.HatPos = posHat
	self.HatEntity:SetModelScale(scale or 1, 0)
	
end

function PANEL:RemoveHat()

	if ( IsValid( self.HatEntity ) ) then
		self.HatEntity:Remove()
		self.HatEntity = nil
	end
	
end

/*---------------------------------------------------------
   Name: DrawBackground
---------------------------------------------------------*/
function PANEL:DrawBackground()
	local x, y = self:GetSize()
	-- draw black rect maybe?
	
	surface.SetDrawColor(255,255,255,40)
	surface.DrawRect(0,0,x,y)
end

/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
DEBUG_HAT_UP, DEBUG_HAT_RIGHT = nil, nil
function PANEL:Paint()
	if (self.PrePaint) then
		if (!self:PrePaint()) then
			return
		end
	end

	self:DrawBackground()

	if ( !IsValid( self.Entity ) ) then return end
	
	local x, y = self:LocalToScreen( 0, 0 )
	local w, h = self:GetWide(), self:GetTall()
	
	if h > w then
		h = w // hacky fix since cam.Start3D doesn't like this
	end
	
	self:LayoutEntity( self.Entity )
	
	cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, w, h )
	//cam.IgnoreZ( true )
	
	if (self.StartCam) then
		self:StartCam()
	end

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self.colColor.a/255 )
	
	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end
		
	self.Entity:DrawModel()
	
	if IsValid(self.HatEntity) && self.HatEntity.HatPos then
		local HatInfo = self.HatEntity.HatPos
		local Up = HatInfo[4]
		local Right = HatInfo[5]
		local AddAng = HatInfo[6]
	
		local attachId = self.Entity:LookupAttachment("anim_attachment_head")
		local attachment = self.Entity:GetAttachment(attachId)
		if attachment then 	
			local Add = Vector(0, 0, 0)
			if(string.find(string.lower(self.Entity:GetModel()), "gman")) then
				Add = Vector(0, 0, 3.05)
				Right = Right + 0.5
			end

			Add = self.HatEntity.HatPos
			local V = (attachment.Pos + (attachment.Ang:Up() * HatInfo[4]) + (attachment.Ang:Right() * Right) + (attachment.Ang:Forward() * (HatInfo[6] or 0)) + Add)
			V:Rotate(self.Entity:GetAngles())
			print(V) 

			self.HatEntity:SetPos(V)
			
			// simple hat offset testing
			if DEBUG_HAT_RIGHT then
				Right = DEBUG_HAT_RIGHT
			elseif DEBUG_HAT_UP then
				Up = DEBUG_HAT_UP
			end
			
			local ang = attachment.Ang;
		
			if(AddAng) then
				ang.p = ang.p + AddAng.p
				ang.y = ang.y + AddAng.y
				ang.r = ang.r + AddAng.r
			end
			
			local temp = ang.r
			ang.y = ang.y + 90
			ang.r = ang.p
			ang.p = ((temp - 90) * -1) - 10
			
			self.HatEntity:SetAngles(ang)
			
			self.HatEntity:DrawModel()
		end 
	end
	
	render.SuppressEngineLighting( false )
	//cam.IgnoreZ( false )

	if (self.EndCam) then
		self:EndCam()
	end

	cam.End3D()
	
	self.LastPaint = RealTime()

	if (self.PostPaint) then
		if (!self:PostPaint()) then
			return
		end
	end
	
end

/*---------------------------------------------------------
   Name: RunAnimation
---------------------------------------------------------*/
function PANEL:RunAnimation()
	self.Entity:FrameAdvance( (RealTime()-self.LastPaint) * self.m_fAnimSpeed )	
end

/*---------------------------------------------------------
   Name: LayoutEntity
---------------------------------------------------------*/
function PANEL:LayoutEntity( Entity )

	if ( self.bAnimated ) then
		self:RunAnimation()
	end
	
	Entity:SetAngles( Angle( 0, RealTime()*40,  0) )
	Entity:ClearPoseParameters()

end

derma.DefineControl( "DSassilizationModelPanel1337", "A panel containing a model", PANEL, "DModelPanel" )