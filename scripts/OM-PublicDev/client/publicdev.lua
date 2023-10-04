class 'PublicDev'

function PublicDev:__init()
    Events:Subscribe( "PostRender", self, self.Render )

    Network:Subscribe( "LoadLocalizationData", function( language )
		local loc = language

		self.warning_txt = loc["warning_txt"] or "..."
	end )
end

function PublicDev:DrawShadowedText( pos, string, color, size, scale )
    Render:DrawText( pos + Vector2.One, string, Color.Black, ( size or 16 ), ( scale or 1 ) )
    Render:DrawText( pos, string, color, ( size or 16 ), ( scale or 1 ) )
end

function PublicDev:Render()
    local textSize = 15
    local text = self.warning_txt or "..."
    local pos = Vector2( Render.Size.x / 2 - Render:GetTextWidth( text, textSize ) / 2, 20 )

    self:DrawShadowedText( pos, text, Color.Red, textSize )
end

publicdev = PublicDev()