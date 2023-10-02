class 'DevKit'

function DevKit:__init()
    Events:Subscribe( "PostRender", self, self.Render )
end

function DevKit:DrawShadowedText( pos, string, color, size, scale )
    Render:DrawText( pos + Vector2.One, string, Color.Black, ( size or 16 ), ( scale or 1 ) )
    Render:DrawText( pos, string, color, ( size or 16 ), ( scale or 1 ) )
end

function DevKit:Render()
    if not LocalPlayer:GetValue( "DEBUGShowOSD" ) then return end

    local textSize = 15
    local pos = Vector2( 250, 20 )

    if LocalPlayer:GetValue( "DEBUGShowPlayerInfo" ) then
        self:DrawShadowedText( pos, "NAME: " .. tostring( LocalPlayer:GetName() ), LocalPlayer:GetColor(), textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "COLOR (RGBA): " .. tostring( LocalPlayer:GetColor() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "ID: " .. tostring( LocalPlayer:GetId() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "SteamID: " .. tostring( LocalPlayer:GetSteamId().string ) .. " / " .. tostring( LocalPlayer:GetSteamId().id ), Color.White, textSize )

        pos.y = pos.y + 20

        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "POS: " .. tostring( LocalPlayer:GetPosition() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "ANGLE: " .. tostring( LocalPlayer:GetAngle() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "LINEAR VELOCITY: " .. tostring( LocalPlayer:GetLinearVelocity() ), Color.White, textSize )

        pos.y = pos.y + 20

        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "STATE: " .. tostring( LocalPlayer:GetState() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "BaseState: " .. tostring( LocalPlayer:GetBaseState() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "UpperBodyState: " .. tostring( LocalPlayer:GetUpperBodyState() ), Color.White, textSize )

        pos.y = pos.y + 20

        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "HEALTH: " .. tostring( LocalPlayer:GetHealth() ) .. " / " .. tostring( LocalPlayer:GetHealth() * 100 ), Color.Aquamarine, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "OXYGEN: " .. tostring( LocalPlayer:GetOxygen() ) .. " / " .. tostring( LocalPlayer:GetOxygen() * 100 ), Color.CornflowerBlue, textSize )

        pos.y = pos.y + 20

        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "EquippedSlot: " .. tostring( LocalPlayer:GetEquippedSlot() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "EquippedWeapon: " .. "ID: " .. tostring( LocalPlayer:GetEquippedWeapon().id ) .. ", AmmpClip: " .. tostring( LocalPlayer:GetEquippedWeapon().ammo_clip ) .. ", AmmoReserve: " .. tostring( LocalPlayer:GetEquippedWeapon().ammo_reserve ), Color.White, textSize )

        pos.y = pos.y + 20

        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "WORLD ID: " .. tostring( LocalPlayer:GetWorld():GetId() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "ClimateZone: " .. tostring( LocalPlayer:GetClimateZone() ), Color.White, textSize )

        if LocalPlayer:GetValue( "GameMode" ) then
            pos.y = pos.y + 20
            self:DrawShadowedText( pos, "GAMEMODE: " .. tostring( LocalPlayer:GetValue( "GameMode" ) ), Color.White, textSize )
        end

        pos.y = pos.y + 20

        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "MONEY: " .. "$" .. tostring( LocalPlayer:GetMoney() ), Color.Orange, textSize )

        if LocalPlayer:GetValue( "PlayerLevel" ) then
            pos.y = pos.y + 20
            self:DrawShadowedText( pos, "LEVEL: " .. tostring( LocalPlayer:GetValue( "PlayerLevel" ) ), Color.White, textSize )
        end

        if LocalPlayer:GetValue( "Kills" ) then
            pos.y = pos.y + 20
            self:DrawShadowedText( pos, "KILLS: " .. tostring( LocalPlayer:GetValue( "Kills" ) ), Color.White, textSize )
        end

        if LocalPlayer:GetValue( "ClanTag" ) then
            pos.y = pos.y + 20
            self:DrawShadowedText( pos, "CLAN TAG: " .. tostring( LocalPlayer:GetValue( "ClanTag" ) ), Color.White, textSize )
        end

        pos.y = pos.y + 20

        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "AIM TARGET: " .. tostring( LocalPlayer:GetAimTarget().position ) .. " / " .. tostring( LocalPlayer:GetAimTarget().entity ), Color.White, textSize )
    end

    local vehicle = LocalPlayer:GetVehicle()
    if vehicle and LocalPlayer:GetValue( "DEBUGShowVehicleInfo" ) then
        pos.y = pos.y + 20

        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "VEHICLE NAME: " .. tostring( vehicle:GetName() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "VEHICLE COLOR (RGBA): " .. tostring( vehicle:GetColors() ), Color.White, textSize )
        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "VEHICLE ID: " .. tostring( vehicle:GetId() ), Color.White, textSize )

        pos.y = pos.y + 20

        pos.y = pos.y + 20
        self:DrawShadowedText( pos, "SEAT: " .. tostring( LocalPlayer:GetSeat() ), Color.White, textSize )
    end
end

devkit = DevKit()