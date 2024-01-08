class "Grenades"

function Grenades:__init()
	if LocalPlayer:GetValue( "Explosive" ) ~= 0 then
		self.TossTimer = Timer()
	end

	self.C4Max = LocalPlayer:GetValue( "MoreC4" ) and tostring( LocalPlayer:GetValue( "MoreC4" ) ) or "3"

	self.cooldown = 0.5
	self.cooltime = 0

	self.vehicle_blacklist = { 64, 37, 57, 30, 34, 20, 53, 24 }

	--[[self.leftarm_blacklist = {
		[AnimationState.LaSWielding] = false,
		[AnimationState.LaSAiming] = false,
		[AnimationState.LaSReload] = false
	}]]--

	Events:Subscribe( "KeyUp", self, self.KeyUp )
	Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	Events:Subscribe( "Render", self, self.Render )

	self.grenadeIMG = Image.Create( AssetLocation.Resource, "Grenade" )
	self.grenade1 = Image.Create( AssetLocation.Resource, "Grenade1" )
	self.c4 = Image.Create( AssetLocation.Resource, "C4" )
	self.clay = Image.Create( AssetLocation.Resource, "Claymore" )
	self.background = Image.Create( AssetLocation.Resource, "Background" )

	self.textb = Image.Create( AssetLocation.Resource, "TextBackground" )

--[[
	self.stars = Image.Create( AssetLocation.Resource, "Stars0" )
	self.stars1 = Image.Create( AssetLocation.Resource, "Stars1" )
	self.stars2 = Image.Create( AssetLocation.Resource, "Stars2" )
	self.stars3 = Image.Create( AssetLocation.Resource, "Stars3" )
	self.stars4 = Image.Create( AssetLocation.Resource, "Stars4" )
	self.stars5 = Image.Create( AssetLocation.Resource, "Stars5" )
]]--
end

function Grenades:CheckList( tableList, modelID )
	for k,v in pairs(tableList) do
		if v == modelID then return true end
	end
	return false
end

function Grenades:KeyUp( args )
	if args.key == string.byte( "G" ) then
		self:ToggleGrenades()
	end

	if args.key == string.byte( "2" ) then
		LocalPlayer:SetValue( "l_exp", LocalPlayer:GetValue( "Explosive" ) )
		LocalPlayer:SetValue( "Explosive", 0 )
		self.FadeOutTimer = nil
	elseif args.key == string.byte( "1" ) then
		if LocalPlayer:GetValue( "l_exp" ) then
			LocalPlayer:SetValue( "Explosive", LocalPlayer:GetValue( "l_exp" ) )
			LocalPlayer:SetValue( "l_exp", nil )
			if self.FadeOutTimer then
				self.FadeOutTimer:Restart()
			else
				self.FadeOutTimer = Timer()
			end
		end
	end
end

function Grenades:LocalPlayerInput( args )
	if args.input == Action.ThrowGrenade then
		if Game:GetState() ~= GUIState.Game then return end
		if LocalPlayer:GetValue( "Freeze" ) then return end
		if LocalPlayer:GetValue( "Passive" ) then return end
		if LocalPlayer:GetValue( "ServerMap" ) then return end
	
		local driver = LocalPlayer:GetVehicle() and LocalPlayer:GetVehicle():GetDriver()

		if driver and IsValid( driver ) and driver.__type == 'LocalPlayer' then
			local vehicle = LocalPlayer:GetVehicle()
			if vehicle:GetModelId() == 7 or vehicle:GetModelId() == 77 or vehicle:GetModelId() == 56 or vehicle:GetModelId() == 18 then
				if vehicle:GetTemplate() == "Armed" or vehicle:GetTemplate() == "FullyUpgraded" or vehicle:GetTemplate() == "" or vehicle:GetTemplate() == "Cannon" then return end
			else
				if vehicle:GetTemplate() == "Armed" or vehicle:GetTemplate() == "FullyUpgraded" or vehicle:GetTemplate() == "Dome" then return end
			end
			local LocalVehicleModel	= vehicle:GetModelId()
			if self:CheckList( self.vehicle_blacklist, LocalVehicleModel ) then return end
		end

		--local bs = LocalPlayer:GetBaseState()
		--if self.leftarm_blacklist[bs] then return end

		if LocalPlayer:GetValue( "Explosive" ) == 1 and self.grenade then
			Events:Fire( "FireGrenade", { type = "Frag" } )
			self.grenade = nil
			self.TossTimer = Timer()
		elseif LocalPlayer:GetValue( "Explosive" ) == 2 then
			Events:Fire( "FireC4" )
		elseif LocalPlayer:GetValue( "Explosive" ) == 4 and self.grenade then
			self.grenade = nil
			Events:Fire( "FireGrenade", { type = "Smoke" } )
			self.TossTimer = Timer()
		elseif LocalPlayer:GetValue( "Explosive" ) == 5 and self.grenade then
			self.grenade = nil
			Events:Fire( "FireGrenade", { type = "MichaelBay" } )
			self.TossTimer = Timer()
		elseif LocalPlayer:GetValue( "Explosive" ) == 6 and self.grenade then
			self.grenade = nil
			Events:Fire( "FireGrenade", { type = "Atom" } )
			self.TossTimer = Timer()
		end

		if LocalPlayer:GetValue( "Explosive" ) ~= 0 and LocalPlayer:GetValue( "Explosive" ) then
			if self.FadeOutTimer then
				self.FadeOutTimer:Restart()
			else
				self.FadeOutTimer = Timer()
			end
		end
	end

	if Game:GetSetting(GameSetting.GamepadInUse) == 1 then
		if args.input == Action.EquipLeftSlot then
			if not LocalPlayer:InVehicle() then
				local time = Client:GetElapsedSeconds()
				if time < self.cooltime then
					return
				else
					self:ToggleGrenades()
				end
				self.cooltime = time + self.cooldown
				return false
			end
		end
	end
end

function Grenades:ToggleGrenades()
	if not self.TossTimer then
		self.TossTimer = Timer()
	else
		self.TossTimer:Restart()
	end

	if not LocalPlayer:GetValue( "Explosive" ) then
		LocalPlayer:SetValue( "Explosive", 1 )
		if self.FadeOutTimer then
			self.FadeOutTimer:Restart()
		else
			self.FadeOutTimer = Timer()
		end
	elseif LocalPlayer:GetValue( "Explosive" ) == 0 then
		LocalPlayer:SetValue( "Explosive", 1 )
		if self.FadeOutTimer then
			self.FadeOutTimer:Restart()
		else
			self.FadeOutTimer = Timer()
		end
	elseif LocalPlayer:GetValue( "Explosive" ) == 1 then
		LocalPlayer:SetValue( "Explosive", 2 )

		if LocalPlayer:GetValue( "MoreC4" ) then
			self.C4Max = tostring( LocalPlayer:GetValue( "MoreC4" ) )
		end

		if self.FadeOutTimer then
			self.FadeOutTimer:Restart()
		else
			self.FadeOutTimer = Timer()
		end
	elseif LocalPlayer:GetValue( "Explosive" ) == 2 then
		LocalPlayer:SetValue( "Explosive", 3 )

		if self.FadeOutTimer then
			self.FadeOutTimer:Restart()
		else
			self.FadeOutTimer = Timer()
		end
	elseif LocalPlayer:GetValue( "Explosive" ) == 3 then
		LocalPlayer:SetValue( "Explosive", 4 )
		if self.FadeOutTimer then
			self.FadeOutTimer:Restart()
		else
			self.FadeOutTimer = Timer()
		end
	elseif LocalPlayer:GetValue( "Explosive" ) == 4 then
		LocalPlayer:SetValue( "Explosive", 5 )
		if self.FadeOutTimer then
			self.FadeOutTimer:Restart()
		else
			self.FadeOutTimer = Timer()
		end
	elseif LocalPlayer:GetValue( "Explosive" ) == 5 then
		if LocalPlayer:GetValue( "SuperNuclearBomb" ) then
			LocalPlayer:SetValue( "Explosive", 6 )
		else
			LocalPlayer:SetValue( "Explosive", 0 )
		end
		if self.FadeOutTimer then
			self.FadeOutTimer:Restart()
		else
			self.FadeOutTimer = Timer()
		end
	else
		LocalPlayer:SetValue( "Explosive", 0 )
		self.TossTimer = nil
	end
end

function Grenades:Render()
	if Game:GetState() ~= GUIState.Game then return end

	if LocalPlayer:GetValue( "Explosive" ) ~= 0 and LocalPlayer:GetValue( "Explosive" ) ~= nil and self.FadeOutTimer then
		local text_timer = ""
		local text_max = ""

		self.background:SetSize( Vector2( Render.Height * 0.18, Render.Height * 0.09 ) )
		self.textb:SetSize( Vector2( Render.Height * 0.2, Render.Height * 0.035 ) )

		local imga = self.grenadeIMG
		local text = "Осколочная граната"

		if LocalPlayer:GetValue( "Explosive" ) == 1 then
			imga = self.grenadeIMG
			text = LocalPlayer:GetValue( "Lang" ) == "ENG" and "Fragmentation Grenade" or "Осколочная граната"
			text_timer = "R"

			if self.TossTimer then
				local rem = 2 - self.TossTimer:GetSeconds()
				if rem - (rem % 1) > 0 then
					text_timer = tostring( rem - (rem % 1) )
				else
					self.TossTimer = nil
					self.grenade = true
				end
			end
		elseif LocalPlayer:GetValue( "Explosive" ) == 2 then
			imga = self.c4
			text = LocalPlayer:GetValue( "Lang" ) == "ENG" and "Triggered Explosive" or "Бомбы-липучки"
			text_max = self.C4Max
			text_timer = LocalPlayer:GetValue( "C4Count" ) and tostring( LocalPlayer:GetValue( "C4Count" ) ) or "0"

			self.c4actv = true
		elseif LocalPlayer:GetValue( "Explosive" ) == 3 then
			imga = self.clay
			text = LocalPlayer:GetValue( "Lang" ) == "ENG" and "Claymore Mine" or "Мины Клеймор"
			text_timer = "∞"

			self.c4actv = false
		elseif LocalPlayer:GetValue( "Explosive" ) == 4 then
			text = LocalPlayer:GetValue( "Lang" ) == "ENG" and "Firework Grenade" or "Фейерверковая граната"
			text_timer = "R"

			if self.TossTimer then
				local rem = 2 - self.TossTimer:GetSeconds()
				if rem - (rem % 1) > 0 then
					text_timer = tostring( rem - (rem % 1) )
				else
					self.TossTimer = nil
					self.grenade = true
				end
			end
		elseif LocalPlayer:GetValue( "Explosive" ) == 5 then
			text = LocalPlayer:GetValue( "Lang" ) == "ENG" and "Nuclear Grenade" or "Ядерная граната"
			text_timer = "R"

			if self.TossTimer then
				local rem = 6 - self.TossTimer:GetSeconds()
				if rem - (rem % 1) > 0 then
					text_timer = tostring( rem - (rem % 1) )
				else
					self.TossTimer = nil
					self.grenade = true
				end
			end
		elseif LocalPlayer:GetValue( "Explosive" ) == 6 then
			text = LocalPlayer:GetValue( "Lang" ) == "ENG" and "SUPER Nuclear Grenade" or "СУПЕР Ядерная граната"
			text_timer = "R"

			if self.TossTimer then
				local rem = 61 - self.TossTimer:GetSeconds()
				if rem - (rem % 1) > 0 then
					text_timer = tostring( rem - (rem % 1) )
				else
					self.TossTimer = nil
					self.grenade = true
				end
			end
		end
		
		if self.FadeOutTimer:GetSeconds() >= 11 then
			self.FadeOutTimer = nil
			return
		end

		Render:SetFont( AssetLocation.Disk, "Archivo.ttf" )

		imga:SetSize( Vector2( Render.Height * 0.09, Render.Height * 0.045 ) )

		local timerwidth = Render:GetTextSize( text_timer, imga:GetSize().y / 1.8 ).x / 2
		local c4maxwidth = Render:GetTextSize( text_max, imga:GetSize().y / 1.8 ).x / 2

		local pos_2d = Vector2( Render.Size.x / 0.995 - self.background:GetSize().x, ( Render.Height - Render.Height * 0.24 ) - imga:GetSize().y / 2 )
		local pos_2d_a = Vector2( Render.Size.x / 1.009 - self.background:GetSize().x, ( Render.Height - Render.Height * 0.24 ) - self.background:GetSize().y / 2 )
		local pos_2d_t = Vector2( Render.Size.x / 1.015 - self.textb:GetSize().x, ( Render.Height - Render.Height * 0.193 ) - self.textb:GetSize().y / 2 )
		local pos_2d_timer = Vector2( Render.Size.x / 1.01 - timerwidth /2  - imga:GetSize().x / 2, ( Render.Height - Render.Height * 0.234 ) - self.textb:GetSize().y / 2 )
		if self.c4actv then
			pos_2d_timer = Vector2( Render.Size.x / 1.009 - timerwidth / 2 - imga:GetSize().x / 2, ( Render.Height - Render.Height * 0.242 ) - self.textb:GetSize().y / 2 )
		end
		local pos_2d_c4max = Vector2( Render.Size.x / 1.0085 - c4maxwidth / 2 - imga:GetSize().x / 2, ( Render.Height - Render.Height * 0.22 ) - self.textb:GetSize().y / 2 )
		local pos_2d_text = Vector2( Render.Size.x - ( Render:GetTextWidth( text, self.textb:GetSize().y / 0.018 / Render:GetTextWidth( "BTextResoliton" ) ) ) - Render.Size.x / 40, ( Render.Height - Render.Height * 0.186 ) - self.textb:GetSize().y / 2 )

		if Game:GetSetting(4) >= 1 then
			imga:SetPosition( pos_2d )
			imga:SetAlpha( 201 - Game:GetSetting(4) * 2 )
			self.background:SetPosition( pos_2d_a )
			self.background:SetAlpha( 201 - Game:GetSetting(4) * 2 )
			self.textb:SetPosition( pos_2d_t )
			self.textb:SetAlpha( 201 - Game:GetSetting(4) * 2 )

			self.textb:Draw()
			self.background:Draw()
			imga:Draw()

			Render:DrawText( pos_2d_text + Vector2.One, text, Color( 0, 0, 0, Game:GetSetting(4) * 2.25 ), self.textb:GetSize().y / 0.018 / Render:GetTextWidth( "BTextResoliton" ) )
			Render:DrawText( pos_2d_text, text, Color( 255, 255, 255, Game:GetSetting(4) * 2.25 ), self.textb:GetSize().y / 0.018 / Render:GetTextWidth( "BTextResoliton" ) )

			Render:DrawText( pos_2d_timer, text_timer, Color( 0, 0, 0, Game:GetSetting(4) * 2.25 ), imga:GetSize().y / 0.13 / Render:GetTextWidth( "00" ) )
			Render:DrawText( pos_2d_timer, text_timer, Color( 255, 255, 255, Game:GetSetting(4) * 2.25 ), imga:GetSize().y / 0.13 / Render:GetTextWidth( "00" ) )

			Render:DrawText( pos_2d_c4max, text_max, Color( 0, 0, 0, Game:GetSetting(4) * 2.25 ), imga:GetSize().y / 0.18 / Render:GetTextWidth( "00" ) )
			Render:DrawText( pos_2d_c4max, text_max, Color( 169, 169, 169, Game:GetSetting(4) * 2.25 ), imga:GetSize().y / 0.18 / Render:GetTextWidth( "00" ) )
		end
	end
end

grenades = Grenades()