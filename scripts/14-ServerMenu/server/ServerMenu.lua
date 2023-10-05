class 'ServerMenu'

function ServerMenu:__init()
	Events:Subscribe( "PostTick", self, self.PostTick )

	Network:Subscribe( "PayDay", self, self.PayDay )
	Network:Subscribe( "ToggleHideMe", self, self.ToggleHideMe )

	self.timer = Timer()
end

function ServerMenu:PostTick()
	if self.timer:GetHours() <= PayDay.Delay then return end

	for p in Server:GetPlayers() do
		Network:Send( p, "Bonus" )
	end

	self.timer:Restart()
end

function ServerMenu:PayDay( args, sender )
	local payday_value = PayDay.Value[math.random(#PayDay.Value)]

	if sender:GetValue( "MoneyBonus" ) then
		sender:SetMoney( sender:GetMoney() + payday_value )
	end
end

function ServerMenu:ToggleHideMe( args, sender )
	sender:SetNetworkValue( "HideMe", not sender:GetValue( "HideMe" ) )
end

servermenu = ServerMenu()