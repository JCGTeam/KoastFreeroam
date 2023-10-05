class 'Load'

function Load:__init()
	self.loads = {
		"BackgroundImage",
		"BackgroundImageTw",
		"BackgroundImageTh",
		"BackgroundImageFo",
		"BackgroundImageFi",
		"BackgroundImageSi"
	}

	self.BackgroundImage = Image.Create( AssetLocation.Resource, self.loads[math.random(#self.loads)] )
	self.LoadingCircle_Outer = Image.Create( AssetLocation.Game, "fe_initial_load_icon_dif.dds" )

	Network:Subscribe( "LoadLocalizationData", function( language )
		local loc = language

		self.tip_txt = loc["tip_txt"] or "..."
		self.warningtitle_txt = loc["warningtitle_txt"] or "..."
		self.warningdescription_txt = loc["warningdescription_txt"] or "..."
		self.warningbtn_txt = loc["warningbtn_txt"] or "..."
	end )

	Events:Subscribe( "ModuleLoad", self, self.ModuleLoad )
	Events:Subscribe( "GameLoad", self, self.GameLoad )
	Events:Subscribe( "LocalPlayerDeath", self, self.LocalPlayerDeath )
	self.PostRenderEvent = Events:Subscribe( "PostRender", self, self.PostRender )

	self.IsJoining = false

	self.border_width = Vector2( Render.Width, 25 )
end

function Load:ModuleLoad()
	if Game:GetState() ~= GUIState.Loading then
		self.IsJoining = false
	else
		self.IsJoining = true
		self.FadeInTimer = Timer()
	end
end

function Load:GameLoad()
	self.FadeInTimer = nil

	if not self.PostRenderEvent then
		self.PostRenderEvent = Events:Subscribe( "PostRender", self, self.PostRender )
		self:WindowClosed()
	end
end

function Load:LocalPlayerDeath()
	self.BackgroundImage = Image.Create( AssetLocation.Resource, self.loads[math.random(#self.loads)] )
	self.FadeInTimer = Timer()
end

function Load:PostRender()
	if Game:GetState() == GUIState.Loading then
		local tip_txt = self.tip_txt or "..."
		local TxtSizePos = Render.Size.x / 0.55 / Render:GetTextWidth( "BTextResoliton" )
		local TxtSize = Render:GetTextSize( tip_txt, TxtSizePos )
		local CircleSize = Vector2( 70, 70 )
		local TransformOuter = Transform2()
		local TxtPos = Vector2( ( Render.Size.x/2 ) - ( TxtSize.x/2 ), Render.Size.y / 1.100 )
		local Rotation = self:GetRotation()
		local Pos = Vector2( 40, Render.Size.y / 1.075 )
		local PosTw = Vector2( 40.5, Render.Size.y / 1.074 )
		local PosTh = Vector2( (Render.Width - 60), 60 )

		self.BackgroundImage:SetPosition( Vector2.Zero )
		self.BackgroundImage:SetSize( Vector2( Render.Width, Render.Height ) )
		self.BackgroundImage:Draw()

		Render:FillArea( TxtPos-self.border_width, Vector2( Render.Width, 100 ) + self.border_width*2, Color( 0, 0, 0, 150 ) )

		if LocalPlayer:GetValue( "SystemFonts" ) then
			Render:SetFont( AssetLocation.SystemFont, "Impact" )
		end
		ExtRender:DrawShadowedText( Pos, tip_txt, Color.White, Color.Black, TxtSizePos )

		if self.FadeInTimer then
			TransformOuter:Translate( PosTh )
			TransformOuter:Rotate( math.pi * Rotation )

			Render:SetTransform( TransformOuter )
			self.LoadingCircle_Outer:Draw( -(CircleSize / 2), CircleSize, Vector2.Zero, Vector2.One )
			Render:ResetTransform()

			if self.FadeInTimer:GetMinutes() >= 1 then
				if self.PostRenderEvent then
					Events:Unsubscribe( self.PostRenderEvent )
					self.PostRenderEvent = nil
				end
				self:ExitWindow()
			end
		end
	end
end

function Load:ExitWindow()
	self.FadeInTimer = nil
	Mouse:SetVisible( true )

	self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.2, 0.2 ) )
	self.window:SetMinimumSize( Vector2( 500, 200 ) )
	self.window:SetPositionRel( Vector2( 0.7, 0.5 ) - self.window:GetSizeRel()/2 )
	self.window:SetVisible( true )
	self.window:SetTitle( self.warningtitle_txt or "..." )
	self.window:Subscribe( "WindowClosed", self, self.WindowClosed )

	self.errorText = Label.Create( self.window )
	self.errorText:SetPosition( Vector2( 20, 30 ) )
	self.errorText:SetSize( Vector2( 450, 100 ) )
	self.errorText:SetText( self.warningdescription_txt or "..." )
	self.errorText:SetTextSize( 20 )

	self.leaveButton = Button.Create( self.window )
	self.leaveButton:SetSize( Vector2( 100, 40 ) )
	self.leaveButton:SetDock( GwenPosition.Bottom )
	self.leaveButton:SetText( self.warningbtn_txt or "..."  )
	self.leaveButton:Subscribe( "Press", self, self.Exit )
end

function Load:WindowClosed()
	if self.window then
		self.window:Remove()
		self.window = nil
	end

	if self.errorText then
		self.errorText:Remove()
		self.errorText = nil
	end

	if self.leaveButton then
		self.leaveButton:Remove()
		self.leaveButton = nil
	end

	Mouse:SetVisible( false )
end

function Load:Exit()
	self:WindowClosed()
	Network:Send( "KickPlayer" )
end

function Load:GetRotation()
	if self.FadeInTimer then
		local RotationValue = self.FadeInTimer:GetSeconds()* 3
		return RotationValue
	end
end

load = Load()