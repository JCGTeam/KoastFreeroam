class 'DevKit'

function DevKit:__init()
    Events:Subscribe( "PostRender", self, self.Render )
end

function DevKit:DrawShadowedText( pos, string, color, size, scale )
    Render:DrawText( pos + Vector2.One, string, Color.Black, ( size or 16 ), ( scale or 1 ) )
    Render:DrawText( pos, string, color, ( size or 16 ), ( scale or 1 ) )
end

function DevKit:Render()
    local textSize = 15
    local text = "ВНИМАНИЕ! ВЫ НАХОДИТЕСЬ НА DEV-ВЕРСИИ KOAST FREEROAM\nДанная сборка предназначена для разработки и тестирования новых функций KOAST FREEROAM\nФункции могут быть нестабильны, набранный прогресс может быть потерян! Чтобы этого избежать - играйте на стабильной сборке.\nP.S. Данное предупреждение невозможно убрать на DEV-сборке.\n\nИсходный код (GitHub): https://github.com/JCGTeam/KoastFreeroam"
    local pos = Vector2( Render.Size.x / 2 - Render:GetTextWidth( text, textSize ) / 2, 20 )

    self:DrawShadowedText( pos, text, Color.Red, textSize )
end

devkit = DevKit()