class 'PublicDev'

function PublicDev:__init()
    Events:Subscribe( "PostRender", self, self.Render )

    Network:Subscribe( "LoadLocalizationData", function( language )
		local loc = language

		self.warning_txt = loc["warning_txt"] or "..."
	end )
end

function PublicDev:Render()
    local textSize = 15
    local text = self.warning_txt or "..."
    local pos = Vector2( Render.Size.x / 2 - Render:GetTextWidth( text, textSize ) / 2, 20 )

    ExtRender:DrawShadowedText( pos, text, Color.Red, Color.Black, textSize )
end

publicdev = PublicDev()