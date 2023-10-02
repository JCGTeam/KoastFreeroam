class 'HControls'

function HControls:__init()
	Events:Subscribe( "ModuleLoad", self, self.ModuleLoad )
	Events:Subscribe( "EngHelp", self, self.EngHelp )
end

function HControls:EngHelp()
	Events:Fire( "HelpRemoveItem",
		{
			name = "Информация"
		} )
	Events:Fire( "HelpAddItem",
		{
			name = "Information",
			text =
			    "> Main:\n" ..
                "    Group in VK              vk.com/rusjc\n" ..
                "    Group in Steam         steamcommunity.com/groups/rusjc\n" ..
				"    We're in Discord           https://cclx.win/NFXd0\n" ..
				"    Telegram Channel        t.me/rusjc\n \n" ..
				"> Our servers:\n" ..
				"    Just Cause 2 Multiplayer Mod:\n" ..
				"     - Koast Freeroam – 62.122.214.141:7777 (You are here)\n" ..
				"     - Panau Crisis – 62.122.214.141:6666\n" ..
				"         - Group in VK - vk.com/jcsurv\n \n" ..
				"> Developer:\n" ..
				"     Hallkezz\n \n" ..
				"> Help in development:\n" ..
				"     Neon\n \n" ..
				"> Also thanks for scripts:\n" ..
				"     Proxwian\n" ..
				"     JasonMRC\n" ..
				"     benank\n" ..
				"     Dev_34\n" ..
				"     DaAlpha\n" ..
				"     SinisterRectus\n" ..
				"     SK83RJOSH\n" ..
				"     dreadmullet\n" ..
				"     Trix\n" ..
				"     Castillos15\n" ..
				"     Jasonmrc\n" ..
				"     Philpax\n" ..
				"     BluShine\n" ..
				"     Rene-Sackers\n \n" ..
				"> API/Used libraries:\n" ..
				"     luasocket (by Diego Nehab)\n" ..
				"     json.lua (by rxi/David Kolf)\n" ..
				"     Discordia (by SinisterRectus)\n" ..
				"     Luvit (luvit.io)\n" ..
				"     IP-API (ip-api.com)\n \n" ..
				"> Also thanks:\n" ..
				"     Cavick (Artist)\n" ..
				"     Dragonshifter (RUSSIAN FREEROAM MAYHEM server source code)\n \n" ..
				"> Open source:\n" ..
				"     GitHub - github.com/Hallkezz/KoastFreeroam"
		} )
end

function HControls:ModuleLoad()
	Events:Fire( "HelpAddItem",
		{
			name = "Информация",
			text =
			    "> Главное:\n" ..
                "    Группа в VK               vk.com/rusjc\n" ..
                "    Группа в Steam         steamcommunity.com/groups/rusjc\n" ..
				"    Сервер в Discord      https://cclx.win/NFXd0\n" ..
				"    Телеграм канал         t.me/rusjc\n \n" ..
				"> Наши сервера:\n" ..
				"    Just Cause 2 Multiplayer Mod:\n" ..
				"     - Koast Freeroam – 62.122.214.141:7777 (Вы тут)\n" ..
				"     - Panau Crisis – 62.122.214.141:6666\n" ..
				"         - Группа в VK - vk.com/jcsurv\n \n" ..
				"> Разработчик:\n" ..
				"     Hallkezz\n \n" ..
				"> Помощь в разработке:\n" ..
				"     Neon\n \n" ..
				"> Заимствованный код:\n" ..
				"     Proxwian\n" ..
				"     JasonMRC\n" ..
				"     benank\n" ..
				"     Dev_34\n" ..
				"     DaAlpha\n" ..
				"     SinisterRectus\n" ..
				"     SK83RJOSH\n" ..
				"     dreadmullet\n" ..
				"     Trix\n" ..
				"     Castillos15\n" ..
				"     Jasonmrc\n" ..
				"     Philpax\n" ..
				"     BluShine\n" ..
				"     Rene-Sackers\n \n" ..
				"> API/Используемые библеотеки:\n" ..
				"     luasocket (by Diego Nehab)\n" ..
				"     json.lua (by rxi/David Kolf)\n" ..
				"     Discordia (by SinisterRectus)\n" ..
				"     Luvit (luvit.io)\n" ..
				"     IP-API (ip-api.com)\n \n" ..
				"> Также спасибо:\n" ..
				"     Cavick (Художник-аферист)\n" ..
				"     Dragonshifter (Исходный код сервера RUSSIAN FREEROAM MAYHEM)\n \n" ..
				"> Открытый исходный код:\n" ..
				"     GitHub - github.com/Hallkezz/KoastFreeroam\n \n" ..
				"> Спонсорство:\n" ..
				"     В список спонсоров попадают люди, которые поддержали сервер суммой более 500 рублей.\n" ..
				"     Для попадания в список - уведомите администрацию.\n \n" ..
				"Никнеймы спонсоров: Oleg, Arko, Cavick"
		} )
end

hcontrols = HControls()