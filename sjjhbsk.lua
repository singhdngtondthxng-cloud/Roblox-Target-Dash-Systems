print("[Supa Tech System] สคริปต์กำลังเริ่มทำงาน...")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local ATTACK_RANGE = 20
local TAG_NAME = "SupaTechTarget"

-- ฟังก์ชันหาเป้าหมายใกล้ตัว
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

-- ฟังก์ชันทำท่า Uppercut และแปะป้ายล็อกเป้า
local function runUppercutLogic()
	local enemy = getClosestTarget()
	if enemy then
		local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
		if enemyRoot then
			-- เสยศัตรูขึ้นฟ้า
			enemyRoot.AssemblyLinearVelocity = Vector3.new(0, 55, 0)
			
			if enemyRoot:FindFirstChild(TAG_NAME) then
				enemyRoot[TAG_NAME]:Destroy()
			end
			
			-- 🔴 แปะแท่งแดงแสดงสถานะโดนคอมโบ
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

-- ฟังก์ชันพุ่งตัวหาเป้าหมาย
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
		-- ล็อกเป้าพุ่งไปโผล่ตรงหน้าประชิดตัว (ห่าง 3 studs)
		local dashDestination = targetPos - (targetEnemyRoot.CFrame.LookVector * 3)
		rootPart.CFrame = CFrame.new(dashDestination, targetPos)
		
		local marker = targetEnemyRoot:FindFirstChild(TAG_NAME)
		if marker then marker:Destroy() end
		print("Supa Tech Dash ประสบความสำเร็จ!")
	else
		-- แดชธรรมดา
		rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -18)
	end
end

-- 📱 ฟังก์ชันสำหรับปุ่มอัตโนมัติ Supa Tech (กดทีเดียวจัดให้ครบชุด)
local function startSupaTechCombo()
	print("เริ่มทำคอมโบ Supa Tech อัตโนมัติ...")
	local targetFound = runUppercutLogic()
	
	-- ถ้าตรวจเจอเป้าหมายและทำการ Uppercut แล้ว ระบบจะรอจังหวะนิดนึงแล้วแดชตามทันที
	if targetFound then
		-- ตั้งดีเลย์ (วินาที) ให้พอดีกับจังหวะตัวลอยและพุ่งชนคอมโบ (ปรับตัวเลข 0.15 เพิ่ม/ลด ได้ตามใจชอบ)
		task.wait(0.15) 
		runDashLogic()
	else
		print("ไม่พบเป้าหมายในระยะทำคอมโบ")
	end
end

-- 📱 สร้าง UI ปุ่มกดบนมือถือ
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SupaTechGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ลบ UI เก่าออกป้องกันปุ่มซ้อน
if player.PlayerGui:FindFirstChild("SupaTechGui") and player.PlayerGui.SupaTechGui ~= screenGui then
	player.PlayerGui.SupaTechGui:Destroy()
end

-- 1. ปุ่มคอมโบด่วน Supa Tech (สีส้มเด่นๆ)
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

-- 2. ปุ่มแดชแยก (สีเขียว)
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
corner2.CornerRadius = UDim.new(0, 10)
corner2.Parent = dashBtn

-- เชื่อมปุ่มกับคำสั่ง
supaBtn.MouseButton1Click:Connect(startSupaTechCombo)
dashBtn.MouseButton1Click:Connect(runDashLogic)

print("[Supa Tech System] สร้างปุ่มช่วยเล่นบนมือถือเรียบร้อย! ไปลองกดที่หุ่น Dummy ได้เลย")

