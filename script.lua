local gui_crown = loadstring(game:HttpGet("https://raw.githubusercontent.com/Viktor188834/gui_Crown/refs/heads/main/CrownGui.lua"))()

local w = gui_crown.Window({
	Text = "Target GUI"
})

local page1 = w.AddPage({
	Text = "main"
})

local TarPlr = nil
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
plr.CharacterAdded:Connect(function(newchar)
	char = newchar
end)
local CFrameOffset = nil

local selectPlayer = page1.PlrSelect({
	Callback = function(newplr)
		TarPlr = newplr
	end;
	Text = "Choose Target";
	PlayerIcon = true;
})

local plrTargetOffset = page1.TextBox({
	Text = "Position Offset Of Teleport Target";
	StarterValue = "0, 0, -4.5";
	Callback = function(text)
		local numbers: string = string.split(text, ",")
		local numbers_Tab = {}
		
		for i, v in numbers do
			numbers_Tab[i] = tonumber(v)
		end

		if #numbers_Tab == 3 then
			CFrameOffset = CFrame.new(numbers_Tab[1], numbers_Tab[2], numbers_Tab[3])
		end
	end
})

local Targeting = false
local targetTeleport = page1.Slide({
	Text = "Target Teleport";
	Callback = function(value)
		Targeting = value
		if CFrameOffset and TarPlr and char and value then
			repeat
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local char2 = TarPlr.Character
				if hrp and char2 then
					local hrp2 = char2:FindFirstChild("HumanoidRootPart")
					if hrp2 then
						hrp.CFrame = hrp2.CFrame * CFrameOffset
					end
				end
				game:GetService("RunService").Heartbeat:Wait()
			until Targeting == false or not char or not TarPlr
		end
	end
})
