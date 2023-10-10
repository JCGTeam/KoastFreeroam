class 'Menu'

function Menu:__init()
	self.engflag = Image.Create( AssetLocation.Resource, "EngFlag" )
	self.rusflag = Image.Create( AssetLocation.Resource, "RusFlag" )

	self.upgrade = true
	self.hider = true

	self.active = true

	self.langButtons = {}

	self:Lang()
	self:GameLoad()

	Events:Subscribe( "Lang", self, self.Lang )

	local en = self:LangButton( "English [EN]", "EN", self.engflag, Vector2( Render.Size.x / 3.5, Render.Size.y - Render.Size.x / 3.5 ) )
	local ru = self:LangButton( "Русский [RU]", "RU", self.rusflag, Vector2( en.img:GetPosition().x + Render.Size.x / 4.8, en.img:GetPosition().y ) )

	Console:Subscribe( "misload", self, self.Mission )

	self.ResolutionChangeEvent = Events:Subscribe( "ResolutionChange", self, self.ResolutionChange )
	self.RenderEvent = Events:Subscribe( "Render", self, self.Render )
	self.GameLoadEvent = Events:Subscribe( "GameLoad", self, self.GameLoad )
	self.LocalPlayerWorldChangeEvent = Events:Subscribe( "LocalPlayerWorldChange", self, self.LocalPlayerWorldChange )
	self.ModuleLoadEvent = Events:Subscribe( "ModuleLoad", self, self.ModuleLoad )
	self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	self.ModuleUnloadEvent = Events:Subscribe( "ModuleUnload", self, self.ModuleUnload )
	self.SelectedNetwork = Network:Subscribe( "Selected", self, self.Selected )
end

function Menu:Lang()
	self.loc = _G[LocalPlayer:GetValue( "Lang" )] or EN

	for _, btnData in ipairs(self.langButtons) do
		btnData.btn:SetToolTip( self.loc.translatehelp_txt )
	end
end

function Menu:LangButton( lang, lang_key, flag, pos )
	local img = ImagePanel.Create()
	img:SetImage( flag )
	img:SetPosition( pos )
	img:SetSize( Vector2( Render.Size.x / 5.5, Render.Size.x / 9 ) )

	local btn = MenuItem.Create()
	if LocalPlayer:GetValue( "SystemFonts" ) then
		btn:SetFont( AssetLocation.SystemFont, "Impact" )
	end
	btn:SetSize( Vector2( Render.Size.x / 5.5, Render.Size.x / 7 ) )
	btn:SetPosition( img:GetPosition() )
	btn:SetText( lang )
	btn:SetToolTip( self.loc.translatehelp_txt )
	btn:SetTextPadding( Vector2( 0, Render.Size.x / 9 ), Vector2.Zero )
	btn:SetTextSize( Render.Size.x / 0.75 / Render:GetTextWidth( "BTextResoliton" ) )
	btn:Subscribe( "Press", function() self:Select( lang_key ) end )

	table.insert(self.langButtons, { btn = btn, img = img })

	return { btn = btn, img = img }
end

function Menu:Mission( args )
	if LocalPlayer:GetWorld() ~= DefaultWorld then return end

	if tonumber(args.text) == 1 then
		print( "Start msy.km01.completed" )
		print( "Please wait..." )
		Game:FireEvent( "msy.km01.completed" )
	elseif tonumber(args.text) == 6 then
		print( "Start msy.km06.completed" )
		print( "Please wait..." )
		Game:FireEvent( "msy.km06.completed" )
	end
end

function Menu:GameLoad()
	if LocalPlayer:GetValue( "Tag" ) == "Creator" then
		self.status = "  " .. self.loc.owner_txt
	elseif LocalPlayer:GetValue( "Tag" ) == "GlAdmin" then
		self.status = "  " .. self.loc.chiefadmin_txt
	elseif LocalPlayer:GetValue( "Tag" ) == "Admin" then
		self.status = "  " .. self.loc.admin_txt
	elseif LocalPlayer:GetValue( "Tag" ) == "AdminD" then
		self.status = "  " .. self.loc.donatadmin_txt
	elseif LocalPlayer:GetValue( "Tag" ) == "ModerD" then
		self.status = "  " .. self.loc.donatmoder_txt
	elseif LocalPlayer:GetValue( "Tag" ) == "VIP" then
		self.status = "  " .. self.loc.vip_txt
	elseif LocalPlayer:GetValue( "Tag" ) == "YouTuber" then
		self.status = "  " .. self.loc.youtube_Txt
	elseif LocalPlayer:GetValue( "NT_TagName" ) then
		self.status = "  " .. "[" .. LocalPlayer:GetValue( "NT_TagName" ) .. "]"
	end

	Events:Fire( "Lang" )

	if self.GameLoadEvent then
		Events:Unsubscribe( self.GameLoadEvent )
		self.GameLoadEvent = nil
	end
end

function Menu:ResolutionChange( args )
--[[	self.ru_img:SetPosition( Vector2( args.size.x / 3.5, (args.size.y - args.size.x / 3.5 ) ) )
	self.ru_img:SetSize( Vector2( args.size.x / 5.5, args.size.x / 9 ) )

	self.ru_btn:SetSize( Vector2( args.size.x / 5.5, args.size.x / 7 ) )
	self.ru_btn:SetPosition( self.ru_img:GetPosition() )
	self.ru_btn:SetTextPadding( Vector2( 0, args.size.x / 9 ), Vector2.Zero )
	self.ru_btn:SetTextSize( args.size.x / 0.75 / Render:GetTextWidth( "BTextResoliton" ) )

	self.en_img:SetPosition( Vector2( self.ru_btn:GetPosition().x + args.size.x / 4.8, self.ru_btn:GetPosition().y ) )
	self.en_img:SetSize( Vector2( args.size.x / 5.5, args.size.x / 9 ) )

	self.en_btn:SetSize( Vector2( args.size.x / 5.5, args.size.x / 7 ) )
	self.en_btn:SetPosition( self.en_img:GetPosition() )
	self.en_btn:SetTextPadding( Vector2( 0, args.size.x / 9 ), Vector2.Zero )
	self.en_btn:SetTextSize( args.size.x / 0.75 / Render:GetTextWidth( "BTextResoliton" ) )]]--
end

function Menu:LocalPlayerWorldChange( args )
	self:SetActive( false )
end

function Menu:ModuleLoad()
	Game:FireEvent( "ply.pause" )
	Mouse:SetVisible( true )
	Chat:SetEnabled( false )

	local sound = ClientSound.Create(AssetLocation.Game, {
				bank_id = 13,
				sound_id = 1,
				position = Camera:GetPosition(),
				angle = Angle()
	})

	sound:SetParameter(0,1)
end

function Menu:LocalPlayerInput( args )
	return false
end

function Menu:SetActive( active )
	if self.active ~= active then
		if not active then
			if self.ResolutionChangeEvent then
				Events:Unsubscribe( self.ResolutionChangeEvent )
				self.ResolutionChangeEvent = nil
			end

			if self.RenderEvent then
				Events:Unsubscribe( self.RenderEvent )
				self.RenderEvent = nil
			end

			if self.LocalPlayerWorldChangeEvent then
				Events:Unsubscribe( self.LocalPlayerWorldChangeEvent )
				self.LocalPlayerWorldChangeEvent = nil
			end

			if self.ModuleLoadEvent then
				Events:Unsubscribe( self.ModuleLoadEvent )
				self.ModuleLoadEvent = nil
			end

			if self.LocalPlayerInputEvent then
				Events:Unsubscribe( self.LocalPlayerInputEvent )
				self.LocalPlayerInputEvent = nil
			end

			if self.ModuleUnloadEvent then
				Events:Unsubscribe( self.ModuleUnloadEvent )
				self.ModuleUnloadEvent = nil
			end

			self:CleanUp()

			Game:FireEvent( "gui.hud.show" )
			Chat:SetEnabled( true )

			local sound = ClientSound.Create(AssetLocation.Game, {
						bank_id = 35,
						sound_id = 6,
						position = Camera:GetPosition(),
						angle = Angle()
			})

			sound:SetParameter(0,0.75)
			sound:SetParameter(1,0)
		end

		self.active = active
		Mouse:SetVisible( self.active )
    end
end

function Menu:Render()
	if self.active then
		Game:FireEvent( "gui.hud.hide" )
		Render:FillArea( Vector2.Zero, Render.Size, Color( 10, 10, 10, 200 ) )

		if self.ambsound then
			self.ambsound:SetParameter( 0, Game:GetSetting(GameSetting.MusicVolume) / 100 )
		end
	end

	if self.hider then
		if Game:GetState() ~= GUIState.Loading then
			for _, btnData in ipairs(self.langButtons) do
				btnData.img:SetVisible( true )
				btnData.btn:SetVisible( true )
			end
			if LocalPlayer:GetValue( "SystemFonts" ) then
				for _, btnData in ipairs(self.langButtons) do
					btnData.btn:SetFont( AssetLocation.SystemFont, "Impact" )
				end
			end
		else
			for _, btnData in ipairs(self.langButtons) do
				btnData.img:SetVisible( false )
				btnData.btn:SetVisible( false )
			end
		end
	end

	if self.active then
		local version_txt = "KMod Version: " .. tostring( LocalPlayer:GetValue( "KoastBuild" ) )

		if self.upgrade then
			Game:FireEvent( "gui.minimap.hide" )
		end
		if LocalPlayer:GetValue( "KoastBuild" ) then
			Render:DrawText( Vector2( (Render.Width - Render:GetTextWidth( version_txt, 15 ) - 30 ), Render.Size.y - 45 ), version_txt, Color( 255, 255, 255, 100 ), 15 )
		end
		if LocalPlayer:GetValue( "SystemFonts" ) then
			Render:SetFont( AssetLocation.SystemFont, "Impact" )
		end

		local playername_pos = Vector2( 20, Render.Size.y - 60 )
		local links_pos = Vector2( 40, 50 )

		Render:DrawText( links_pos, self.loc.links_txt, Color.White, 25 )
		Render:DrawText( Vector2( links_pos.x, links_pos.y + Render:GetTextHeight( self.loc.links_txt, 25 ) + 10 ), "- TELEGRAM | t.me/rusjc\n- DISCORD | https://cclx.win/NFXd0\n- STEAM | steamcommunity.com/groups/rusjc\n- VK | vk.com/rusjc", Color( 180, 180, 180 ), 20 )
		Render:DrawText( Vector2( Render.Size.x / 2 - Render:GetTextWidth( self.loc.langselect_txt, 30 ) / 2, Render.Size.y / 2.5 ), self.loc.langselect_txt, Color.White, 30 )

		LocalPlayer:GetAvatar():Draw( playername_pos, Vector2( 40, 40 ), Vector2.Zero, Vector2.One )
		Render:DrawText( playername_pos + Vector2( 50, 15 ), LocalPlayer:GetName(), Color.White, 17 )
		if self.status then
			Render:DrawText( playername_pos + Vector2( 50, 15 ) + Vector2( Render:GetTextWidth( LocalPlayer:GetName(), 17 ), 0 ), self.status, Color.DarkGray, 17 )
		end
	end
end

function Menu:Freeroam()
	self:SetActive( false )

	Game:FireEvent( "ply.unpause" )
	if LocalPlayer:GetValue( "Passive" ) then
		Game:FireEvent( "ply.invulnerable" )
	end
	Network:Send( "SetFreeroam" )
	Events:Fire( "CastCenterText", { text = self.loc.tofreeroam_txt, time = 2, color = Color( 255, 255, 255 ) } )
end

function Menu:CleanUp()
	if self.ambsound then
		self.ambsound:Remove()
		self.ambsound = nil
	end
end

function Menu:ModuleUnload()
	self:CleanUp()
end

function Menu:Selected()
	Events:Fire( "Lang" )

	if LocalPlayer:GetMoney() >= 0.5 then
		if LocalPlayer:GetValue( "Lang" ) == "RU" then
			local type = 0

			if type == 0 then
				Events:Fire( "OpenWhatsNew", { titletext = "СТАНЬТЕ СПОНСОРОМ СЕРВЕРА", text = "Задонатьте более, чем 500 рублей для попадания в список спонсоров!\nСпонсируя сервер и его автора, вы мотивируете и продлеваете жизнь проекту ( и не только ).\n \nСсылки:\n> Донат - https://cclx.win/FGXd0\n> Discord - https://cclx.win/NFXd0\n> Telegram - t.me/rusjc\n \nС помощью доната, вы также можете приобрести какую-либо услугу на сервере или привилегию.", usepause = true } )
			elseif type == 1 then
				Events:Fire( "OpenWhatsNew", { titletext = "РАЗ И НАВСЕГДА ( ͡° ͜ʖ ͡°)", text = "Успейте приобрести VIP навсегда за 50 рублей!\nАкция действует до 16-го апреля.\n \nСсылки:\n> Донат - https://cclx.win/FGXd0\n> Discord - https://cclx.win/NFXd0\n> Telegram - t.me/rusjc\n\nСписок возможностей для VIP перечислен в меню помощи.", usepause = true } )
			elseif type == 2 then
				Events:Fire( "OpenWhatsNew", { titletext = "ПОДДЕРЖКА СООБЩЕСТВА", text = "Создавайте контент с участием нашего сервера, а мы будем продвигать вас!\n      Подробности о поддержке сообщества сможете найти в меню помощи.", usepause = true } )
			end
		elseif LocalPlayer:GetValue( "Lang" ) == "EN" then
			Events:Fire( "EngHelp" )

			--Events:Fire( "OpenWhatsNew", { titletext = "SPONSOR THE SERVER", text = "Donate more than 6,16$ to be in the list of sponsors!\nBy sponsoring the server and its author, you motivate and prolong the life of the project (and not only).\n \nLinks:\n> Donate - https://cclx.win/FGXd0\n> Discord - https://cclx.win/NFXd0\n> Telegram - t.me/rusjc\n \nWith donation, you can also buy some service on the server or a privilege.", usepause = true } )
		end
	else
		--[[WelcomeScreen:Open()

		local sound = ClientSound.Create(AssetLocation.Game, {
			bank_id = 18,
			sound_id = 0,
			position = Camera:GetPosition(),
			angle = Angle()
		})

		sound:SetParameter(0,1)]]--
	end

	Network:Send( "JoinMessage" )
	self.hider = false

	for _, btnData in ipairs(self.langButtons) do
		btnData.img:Remove()
		btnData.btn:Remove()

		btnData.img = nil
		btnData.btn = nil
	end

	self:Freeroam()

	if self.SelectedNetwork then
		Network:Unsubscribe( self.SelectedNetwork )
		self.SelectedNetwork = nil
	end
end

function Menu:Select( selected_lang )
	Network:Send( "Initialization", { lang = selected_lang } )

	local sound = ClientSound.Create(AssetLocation.Game, {
		bank_id = 18,
		sound_id = 1,
		position = Camera:GetPosition(),
		angle = Angle()
	})

	sound:SetParameter(0,1)

	for _, btnData in ipairs(self.langButtons) do
		btnData.btn:SetEnabled( false )
	end
end

menu = Menu()