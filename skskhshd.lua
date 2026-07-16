-- [[ SUPA TECH MOBILE SCRIPT ]] --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local ATTACK_RANGE = 20
local TAG_NAME = "SupaTechTarget"

local function getClosestTarget()
	local closestTarget = nil
	local shortestDistance = ATTACK_RANGE
	
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("Humanoid") and obj.Parent ~= character and obj.Health > 0 then
			local enemyRoot = obj.Parent:FindFirstChild("HumanoidRootPart")
			if enemyRoot then
				local distance = (rootPart.Position - enemyRoot.Position).Magnitude
				if distance < shortestDistance then
					closestTarget = obj.Parent
					shortestDistance = distance
				end
			end
		end
	end
	return closestTarget
end

local function runUppercutLogic()
	local enemy = getClosestTarget()
	if enemy then
		local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
		if enemyRoot then
			enemyRoot.AssemblyLinearVelocity = Vector3.new(0, 55, 0)
			
			if enemyRoot:FindFirstChild(TAG_NAME) then
				enemyRoot[TAG_NAME]:Destroy()
			end
			
			local billboard = Instance.new("BillboardGui")
			billboard.Name = TAG_NAME
			billboard.Size = UDim2.new(4, 0, 0.8, 0)
			billboard.AlwaysOnTop = true
			billboard.StudsOffset = Vector3.new(0, 4, 0)
			
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			frame.BorderSizePixel = 0
			frame.Parent = billboard
			
			billboard.Adornee = enemyRoot
			billboard.Parent = enemyRoot
			billboard:SetAttribute("TargetOf", player.Name)
			
			game.Debris:AddItem(billboard, 3)
			return enemyRoot
		end
	end
	return nil
end

local function runDashLogic()
	local targetEnemyRoot = nil
	
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BillboardGui") and obj.Name == TAG_NAME then
			if obj:GetAttribute("TargetOf") == player.Name then
				targetEnemyRoot = obj.Adornee
				break
			end
		end
	end
	
	if targetEnemyRoot then
		local targetPos = targetEnemyRoot.Position
		local dashDestination = targetPos - (targetEnemyRoot.CFrame.LookVector * 3)
		rootPart.CFrame = CFrame.new(dashDestination, targetPos)
		
		local marker = targetEnemyRoot:FindFirstChild(TAG_NAME)
		if marker then marker:Destroy() end
	else
		rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -18)
	end
end

local function startSupaTechCombo()
	local targetFound = runUppercutLogic()
	if targetFound then
		task.wait(0.15) 
		runDashLogic()
	end
end

-- สร้างปุ่มบนหน้าจอ
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SupaTechGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

if player.PlayerGui:FindFirstChild("SupaTechGui") and player.PlayerGui.SupaTechGui ~= screenGui then
	player.PlayerGui.SupaTechGui:Destroy()
end

local supaBtn = Instance.new("TextButton")
supaBtn.Size = UDim2.new(0, 120, 0, 55)
supaBtn.Position = UDim2.new(0.7, -20, 0.45, 0)
supaBtn.BackgroundColor3 = Color3.fromRGB(235, 110, 30)
supaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
supaBtn.Text = "Supa Tech ✨"
supaBtn.Font = Enum.Font.SourceSansBold
supaBtn.TextSize = 20
supaBtn.Parent = screenGui

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(0, 10)
corner1.Parent = supaBtn

local dashBtn = Instance.new("TextButton")
dashBtn.Size = UDim2.new(0, 120, 0, 50)
dashBtn.Position = UDim2.new(0.7, -20, 0.57, 0)
dashBtn.BackgroundColor3 = Color3.fromRGB(45, 140, 45)
dashBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dashBtn.Text = "Dash ⚡"
dashBtn.Font = Enum.Font.SourceSansBold
dashBtn.TextSize = 18
dashBtn.Parent = screenGui

local corner2 = Instance.new("UICorner")
corner2.Corner

