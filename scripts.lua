print("[Target System] สคริปต์เวอร์ชันมือถือเริ่มต้นทำงาน...")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local ATTACK_RANGE = 20
local TAG_NAME = "TargetMarker"

-- ฟังก์ชันหาเป้าหมาย
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

-- 🟥 1. ฟังก์ชัน Uppercut
local function doUppercut()
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
			
			game.Debris:AddItem(billboard, 4)
			print("Uppercut สำเร็จ!")
		end
	else
		print("ไม่มีเป้าหมายใกล้ๆ")
	end
end

-- ⚡ 2. ฟังก์ชันแดชล็อกเป้า
local function doDash()
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
		print("แดชล็อกเป้า!")
	else
		rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -18)
		print("แดชธรรมดา")
	end
end

-- 📱 สร้างปุ่มจำลองบนหน้าจอมือถือ
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileCombatGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ลบปุ่มเก่าออกถ้าเคยกดรันซ้ำ
if player.PlayerGui:FindFirstChild("MobileCombatGui") and player.PlayerGui.MobileCombatGui ~= screenGui then
	player.PlayerGui.MobileCombatGui:Destroy()
end

-- สร้างปุ่ม Uppercut
local uppercutBtn = Instance.new("TextButton")
uppercutBtn.Size = UDim2.new(0, 90, 0, 50)
uppercutBtn.Position = UDim2.new(0.7, 0, 0.5, 0) -- พิกัดขวาบนหน้าจอ
uppercutBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
uppercutBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
uppercutBtn.Text = "Uppercut"
uppercutBtn.Font = Enum.Font.SourceSansBold
uppercutBtn.TextSize = 18
uppercutBtn.Parent = screenGui

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(0, 8)
corner1.Parent = uppercutBtn

-- สร้างปุ่ม Dash
local dashBtn = Instance.new("TextButton")
dashBtn.Size = UDim2.new(0, 90, 0, 50)
dashBtn.Position = UDim2.new(0.7, 0, 0.6, 0) -- ถัดลงมาจากปุ่มแรก
dashBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
dashBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dashBtn.Text = "Dash"
dashBtn.Font = Enum.Font.SourceSansBold
dashBtn.TextSize = 18
dashBtn.Parent = screenGui

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 8)
corner2.Parent = dashBtn

-- เชื่อมปุ่มหน้าจอมือถือกับระบบ
uppercutBtn.MouseButton1Click:Connect(doUppercut)
dashBtn.MouseButton1Click:Connect(doDash)

print("[Target System] สร้างปุ่มบนจอมือถือเสร็จสิ้น!")

