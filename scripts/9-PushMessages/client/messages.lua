class 'Messages'

function Messages:__init()
	self:Lang()

	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "ModulesLoad", self, self.ModulesLoad )
	Events:Subscribe( "ModuleError", self, self.ModuleError )
	Network:Subscribe( "HighPing", self, self.HighPing )
	Network:Subscribe( "CriticalError", self, self.CriticalError )
end

function Messages:Lang()
	self.loc = _G[LocalPlayer:GetValue( "Lang" )] or EN
end

function Messages:ModulesLoad()
	Events:Fire( "SendNotification", {txt = self.loc.updatefiles_txt or "...", image = "Upgrade", subtxt = self.loc.loadfiles_txt or "..." } )
	Events:Fire( "LoadUI" )
end

function Messages:ModuleError( e )
	Events:Fire( "SendNotification", {txt = self.loc.err_txt, image = "Warning", subtxt = "Module: " .. e.module} )
	Network:Send( "ClientError", { moduletxt = e.module, errortxt = e.error } )
end

function Messages:HighPing()
	Events:Fire( "SendNotification", {txt = self.loc.higping_txt, image = "Warning", subtxt = self.loc.mblags_txt} )
end

function Messages:CriticalError( args )
    Events:Fire( "SendNotification", {txt = self.loc.criticalerr_txt, image = "Warning", subtxt = "Module: " .. args.error} )
end

messages = Messages()