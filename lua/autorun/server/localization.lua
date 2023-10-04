class 'Localization'

local json = require("json")

function Localization:__init()
	Events:Subscribe( "ClientModuleLoad", self, self.GetLocalization )
	Events:Subscribe( "GetLocalization", self, self.GetLocalization )
end

function Localization:LoadLocalization( language )
	local file = io.open( "localization/" .. language .. ".json", "r" )

	if not file then return end

	local content = file:read( "*a" )

	file:close()

	return json.decode( content )
end

function Localization:GetLocalization( args )
	local language = args.player:GetValue( "Lang" ) or "EN"
	local localizationData = self:LoadLocalization( language )

	Network:Send( args.player, "LoadLocalizationData", localizationData )
end

localization = Localization()