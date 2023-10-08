class 'PublicDev'

function PublicDev:__init()
    self:Lang()

	Events:Subscribe( "Lang", self, self.Lang )
    Events:Subscribe( "PostRender", self, self.Render )
end

function PublicDev:Lang()
	self.loc = _G[LocalPlayer:GetValue( "Lang" )] or EN
end

function PublicDev:Render()
    local textSize = 15
    local text = self.loc.warning_txt
    local pos = Vector2( Render.Size.x / 2 - Render:GetTextWidth( text, textSize ) / 2, 20 )

    ExtRender:DrawShadowedText( pos, text, Color.Red, Color.Black, textSize )
end

publicdev = PublicDev()