class 'ExtRender'

function ExtRender:DrawShadowedText( pos, string, color, ShadowColor, size, scale )
	Render:DrawText( pos + Vector2.One, string, ShadowColor, ( size or 16 ), ( scale or 1 ) )
	Render:DrawText( pos, string, color, ( size or 16 ), ( scale or 1 ) )
end

function formatNumber( amount )
	local formatted = tostring( amount )

	while true do  
		formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", "%1.%2" )
		if (k==0) then
			break
		end
	end

	return formatted
end