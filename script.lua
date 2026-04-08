local gui_crown = loadstring(game:HttpGet("https://raw.githubusercontent.com/Viktor188834/gui_Crown/refs/heads/main/CrownGui.lua"))()

local w = gui_crown.Window({
	Text = "TSB Gui"
})

local page1 = w.AddPage({
	Text = "Target"
})

local page2 = w.AddPage({
	Text = "AFK Farm"
})

local page3 = w.AddPage({
	Text = "Another"
})

local TarPlr = nil
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
plr.CharacterAdded:Connect(function(newchar)
	char = newchar
	hrp = char:WaitForChild("HumanoidRootPart")
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

local run = game:GetService("RunService")
local Trashes = workspace.Map.Trash
local PlayersCharacters = workspace.Live

function find_lowest_hp_player()
	local Lower = 100
	local ToReturnCharacter = nil
 	for i,v in PlayersCharacters:GetChildren() do
		local Humanoid = v:FindFirstChildOfClass("Humanoid")
		if Humanoid and v ~= Character then
   			local hp = Humanoid.Health
     		if hp < Lower and hp >= 1 then
        		ToReturnCharacter = v
        		Lower = hp
      		end
    	end
  	end
	return ToReturnCharacter
end

function get_nearest_Character()
	local nearestDistance = 999999
	local char_Return = nil

	if hrp then
		for _, character in workspace.Live:GetChildren() do
			if character:FindFirstChild("HumanoidRootPart") and character ~= char then
				local hrp2 = character:FindFirstChild("HumanoidRootPart")
				local Distance = (hrp.Position-hrp2.Position).Magnitude
				if nearestDistance > Distance then
					char_Return = character
					nearestDistance = Distance
				end
			end
		end
	end
	
	return char_Return
end

function get_trash()
	local ToReturn = nil
	for i,v in Trashes:GetChildren() do
		if v:GetAttribute("Broken") == false then
			ToReturn = v
		end
	end
	return ToReturn
end

function Teleport(cframe)
	hrp.CFrame = cframe
end

local FARMING = false
page2.Slide({
	Text = "Trash Farm";
	Callback = function(value)
		FARMING = value
		wait(0.5)
		if FARMING then
			repeat
				run.Heartbeat:Wait()
				local Trash = get_trash()
				if Trash then
					local trashcframe = Trash:GetChildren()[1].CFrame
					repeat
						run.Heartbeat:Wait()
						Teleport(trashcframe*CFrame.new(0, 0, 2))
					until Character:FindFirstChild("Trash Can") or Trash:GetAttribute("Broken") == true
					repeat
						run.Heartbeat:Wait()
						local Target = find_lowest_hp_player()
						if Target then
							Teleport(Target:WaitForChild("HumanoidRootPart").CFrame*CFrame.new(0, 0, 13))
						end
					until not Character:FindFirstChild("Trash Can")
				else
					Teleport(CFrame.new(Vector3.new(129.62709045410156, -110.75439453125, 39.04447937011719)))
				end
			until FARMING == false
		end
	end
})

local LockOnTar = nil

local AutoClicking = false
page2.Slide({
	Text = "Auto Clicker";
	Callback = function(value)
		if value then
			AutoClicking = true
			wait(0.5)
			repeat
				wait()
				mouse1click()
			until AutoClicking == false
		end
	end
})

local LockOnBillboard = Instance.new("BillboardGui", game.CoreGui)
LockOnBillboard.ResetOnSpawn = false
LockOnBillboard.AlwaysOnTop = true
LockOnBillboard.Size = UDim2.new(1,0,1)

local Image = Instance.new("ImageLabel", LockOnBillboard)
Image.Size = UDim2.new(1, 0, 1)
Image.BackgroundTransparency = 1
Image.BorderSizePixel = 0
Image.Image = "rbxassetid://82817965256191"

local lock_on = false
local lock_on_anchor = nil
page3.Slide({
	Text = "Lock";
	Callback = function(value)
		lock_on = value
		if value then
			repeat
				local targetResult = nil
				if lock_on_anchor then
					local hrp2 = lock_on_anchor
					targetResult = hrp2
				else
					if hrp then
						targetResult = get_nearest_Character():FindFirstChild("HumanoidRootPart")
					end
				end
				print(targetResult)
				LockOnBillboard.Adornee = targetResult
				local cam = workspace.CurrentCamera
				cam.CFrame = CFrame.new(cam.CFrame.Position, targetResult.Position)
				game:GetService("RunService").Heartbeat:Wait()
			until lock_on == false
		end
	end
})

page3.Keybind({
	Text = "Anchor Aimlock";
	Keybind = Enum.KeyCode.T;
	ChangedEnabled = true;
	Callback = function()
		if LockOnBillboard and LockOnBillboard.Adornee and LockOnBillboard.Parent then
			lock_on_anchor = LockOnBillboard.Adornee
		end
	end;
})
