-- Ink Game - Ceiling Teleport Script (Solara)
-- Toggle with INSERT key

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local savedPosition = nil
local isToggled = false

-- Create Simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CeilingTP_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0.5, -125, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Ceiling Teleport"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = Frame

-- Toggle Function
local function toggleCeiling()
    isToggled = not isToggled
    
    if isToggled then
        -- Save current position
        savedPosition = root.CFrame
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        
        -- Raycast upwards to find closest part above head
        local rayOrigin = root.Position + Vector3.new(0, 6, 0)
        local rayDirection = Vector3.new(0, 200, 0)
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if result then
            local hitPos = result.Position
            root.CFrame = CFrame.new(hitPos.X, hitPos.Y + 4, hitPos.Z)
        else
            -- Fallback
            root.CFrame = root.CFrame + Vector3.new(0, 60, 0)
        end
    else
        -- Return to saved position
        if savedPosition then
            root.CFrame = savedPosition
        end
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end

ToggleButton.MouseButton1Click:Connect(toggleCeiling)

-- Toggle GUI with INSERT key
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("Ceiling Teleport script loaded! Press INSERT to toggle GUI.")
