Yes, absolutely. I have added a small floating red pill button that you can drag anywhere on your screen. If you tap it (without dragging), it will show or hide the main "serenade hub" menu.

Here is the updated complete script. Just copy and paste this to replace the old one:

```lua
-- ==================================================
-- SYSTEM: SERENADE HUB (Mobile Optimized)
-- STYLE: Dark/Red Macro UI + Floating Pill Toggle
-- ==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Clean up old UI
if PlayerGui:FindFirstChild("SerenadeHub") then
    PlayerGui.SerenadeHub:Destroy()
end

-- Variables / State
local GlideEnabled = false
local GlideStrength = 2.0
local PunchEnabled = false
local PunchDelay = 0.2
local HeadHidden = false
local HairHidden = false
local AntiFling = true

-- ==================================================
-- UI BUILDER
-- ==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SerenadeHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10
ScreenGui.Parent = PlayerGui

-- ==================================================
-- FLOATING PILL BUTTON (Mobile Toggle)
-- ==================================================
local PillButton = Instance.new("TextButton")
PillButton.Size = UDim2.new(0, 60, 0, 32)
PillButton.Position = UDim2.new(0, 20, 0.5, -16)
PillButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
PillButton.Text = "HUB"
PillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PillButton.Font = Enum.Font.GothamBold
PillButton.TextSize = 14
PillButton.BorderSizePixel = 0
PillButton.Parent = ScreenGui

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(1, 0)
pillCorner.Parent = PillButton

local pillStroke = Instance.new("UIStroke")
pillStroke.Color = Color3.fromRGB(255, 50, 50)
pillStroke.Thickness = 2
pillStroke.Parent = PillButton

-- Drag Logic for Pill
local pillDragging = false
local pillMoved = false
local pillStartPos = nil

PillButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        pillDragging = true
        pillMoved = false
        pillStartPos = {
            x = input.Position.X, 
            y = input.Position.Y, 
            px = PillButton.Position.X.Offset, 
            py = PillButton.Position.Y.Offset
        }
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if pillDragging and pillStartPos and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local dx = input.Position.X - pillStartPos.x
        local dy = input.Position.Y - pillStartPos.y
        
        -- If moved more than 8 pixels, consider it a drag
        if math.abs(dx) > 8 or math.abs(dy) > 8 then
            pillMoved = true
            PillButton.Position = UDim2.new(0, pillStartPos.px + dx, 0, pillStartPos.py + dy)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if pillDragging and not pillMoved then
            -- It was a tap, toggle the main UI
            Main.Visible = not Main.Visible
        end
        pillDragging = false
        pillStartPos = nil
    end
end)

-- ==================================================
-- MAIN HUB UI
-- ==================================================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 700, 0, 450)
Main.Position = UDim2.new(0.5, -350, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(200, 0, 0)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "serenade hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SearchBar = Instance.new("Frame")
SearchBar.Size = UDim2.new(0, 250, 0, 20)
SearchBar.Position = UDim2.new(1, -400, 0, 7)
SearchBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SearchBar.Parent = TopBar

local SearchText = Instance.new("TextLabel")
SearchText.Size = UDim2.new(1, -10, 1, 0)
SearchText.Position = UDim2.new(0, 10, 0, 0)
SearchText.BackgroundTransparency = 1
SearchText.Text = "Search"
SearchText.TextColor3 = Color3.fromRGB(100, 100, 100)
SearchText.Font = Enum.Font.Gotham
SearchText.TextSize = 12
SearchText.TextXAlignment = Enum.TextXAlignment.Left
SearchText.Parent = SearchBar

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -150, 1, -35)
Content.Position = UDim2.new(0, 150, 0, 35)
Content.BackgroundTransparency = 1
Content.Parent = Main

local MacroPage = Instance.new("ScrollingFrame")
MacroPage.Size = UDim2.new(1, 0, 1, 0)
MacroPage.BackgroundTransparency = 1
MacroPage.ScrollBarThickness = 2
MacroPage.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 0)
MacroPage.Parent = Content

local ExtraPage = Instance.new("ScrollingFrame")
ExtraPage.Size = UDim2.new(1, 0, 1, 0)
ExtraPage.BackgroundTransparency = 1
ExtraPage.Visible = false
ExtraPage.ScrollBarThickness = 2
ExtraPage.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 0)
ExtraPage.Parent = Content

-- ==================================================
-- UI COMPONENTS
-- ==================================================

local function CreateSection(parent, text, yPos)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, -20, 0, 30)
    sec.Position = UDim2.new(0, 10, 0, yPos)
    sec.BackgroundTransparency = 1
    sec.Text = text
    sec.TextColor3 = Color3.fromRGB(150, 150, 150)
    sec.Font = Enum.Font.GothamMedium
    sec.TextSize = 13
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = parent
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -20, 0, 1)
    line.Position = UDim2.new(0, 10, 0, yPos + 25)
    line.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    line.Parent = parent
    return sec
end

local function CreateToggle(parent, text, yPos, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 36, 0, 18)
    bg.Position = UDim2.new(1, -36, 0.5, -9)
    bg.BackgroundColor3 = default and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(50, 50, 50)
    bg.Parent = frame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = bg
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        bg.BackgroundColor3 = state and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(50, 50, 50)
        circle.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        callback(state)
    end)
    return frame
end

local function CreateSlider(parent, text, yPos, min, max, default, formatText, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.5, 0, 0, 20)
    valLabel.Position = UDim2.new(0.5, 0, 0, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = formatText(default)
    valLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valLabel.Font = Enum.Font.Gotham
    valLabel.TextSize = 12
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = frame
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 0, 6)
    bg.Position = UDim2.new(0, 0, 0, 30)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bg.Parent = frame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame
    
    local dragging = false
    local function update(input)
        local p = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = min + p * (max - min)
        fill.Size = UDim2.new(p, 0, 1, 0)
        valLabel.Text = formatText(val)
        callback(val)
    end
    
    btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end end)
    UserInputService.InputChanged:Connect(function(input) if dragging then update(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

local function CreateKeybind(parent, text, yPos, key, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 22)
    btn.Position = UDim2.new(1, -60, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = key.Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    
    local listening = false
    btn.MouseButton1Click:Connect(function()
        listening = true
        btn.Text = "..."
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                btn.Text = key.Name
                listening = false
            end
        else
            if input.KeyCode == key and not UserInputService:GetFocusedTextBox() then
                callback()
            end
        end
    end)
end

-- ==================================================
-- POPULATE UI
-- ==================================================

local function CreateTab(text, yPos, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. text
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    
    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        MacroPage.Visible = (page == "macro")
        ExtraPage.Visible = (page == "extra")
    end)
    return btn
end

local tabMacro = CreateTab("macro", 10, "macro")
tabMacro.TextColor3 = Color3.fromRGB(255, 255, 255)
local tabExtra = CreateTab("extra", 55, "extra")

-- Macro Page Content
CreateSection(MacroPage, "macro", 10)
CreateToggle(MacroPage, "hide accessories", 50, false, function(state) HairHidden = state; reapplyHeadStates() end)
CreateToggle(MacroPage, "headless", 90, false, function(state) HeadHidden = state; reapplyHeadStates() end)
CreateKeybind(MacroPage, "start glide macro", 130, Enum.KeyCode.Q, function() GlideEnabled = not GlideEnabled; print("Glide:", GlideEnabled) end)
CreateToggle(MacroPage, "auto punch (punch speed)", 170, false, function(state) PunchEnabled = state; if state then startPunchLoop() end end)

-- Extra Page Content
CreateSection(ExtraPage, "extra", 10)
CreateToggle(ExtraPage, "anti fling (glide guard)", 50, true, function(state) AntiFling = state end)
CreateSlider(ExtraPage, "glide strength", 95, 1, 5, 2.0, function(val) return string.format("%.1fx", val) end, function(val) GlideStrength = val end)
CreateSlider(ExtraPage, "punch interval delay", 145, 0.01, 0.5, 0.2, function(val) return string.format("%.2fs", val) end, function(val) PunchDelay = val end)

-- ==================================================
-- SCRIPT LOGIC
-- ==================================================

-- HEAD/HAIR LOGIC
local function getHeadAccessories(char)
    local accessories = {}
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Accessory") then
            local handle = item:FindFirstChild("Handle")
            if handle then
                local attachment = handle:FindFirstChildWhichIsA("Attachment")
                if attachment and (attachment.Name == "HatAttachment" or attachment.Name == "HairAttachment" or attachment.Name == "FaceFrontAttachment" or attachment.Name == "FaceCenterAttachment") then
                    table.insert(accessories, item)
                end
            end
        end
    end
    return accessories
end

function reapplyHeadStates()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    
    if head then
        head.Transparency = HeadHidden and 1 or 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = HeadHidden and 1 or 0 end
    end
    
    for _, acc in pairs(getHeadAccessories(char)) do
        local handle = acc:FindFirstChild("Handle")
        if handle then
            local isHair = acc.Name:lower():find("hair") or (handle:FindFirstChild("HairAttachment") ~= nil)
            if isHair then
                handle.LocalTransparencyModifier = HairHidden and 1 or 0
            else
                handle.LocalTransparencyModifier = HeadHidden and 1 or 0
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    reapplyHeadStates()
end)

-- PUNCH SPEED LOGIC
local attackRemote = nil
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and (v.Name:lower():find("attack") or v.Name:lower():find("punch")) then
        attackRemote = v
        break
    end
end

function startPunchLoop()
    task.spawn(function()
        while PunchEnabled do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if attackRemote then pcall(function() attackRemote:FireServer() end) end
                VirtualUser:Button1Down(Vector2.new(0, 0))
                task.wait(0.01)
                VirtualUser:Button1Up(Vector2.new(0, 0))
            end
            task.wait(PunchDelay)
        end
    end)
end

-- GLIDE LOGIC
local stunUntil = 0
local lastBurst = 0
local lastHealth = 100

local function isGrounded(h, r)
    if h.FloorMaterial == Enum.Material.Air then return false end
    if h:GetState() ~= Enum.HumanoidStateType.Running and h:GetState() ~= Enum.HumanoidStateType.RunningNoPhysics and h:GetState() ~= Enum.HumanoidStateType.Landed then return false end
    if math.abs(r.AssemblyLinearVelocity.Y) > 12 then return false end
    return true
end

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    
    if hum.Health < lastHealth and AntiFling then stunUntil = tick() + 0.45 end
    lastHealth = hum.Health
    
    if not GlideEnabled or tick() < stunUntil or tick() - lastBurst < 0.1 then return end
    if AntiFling and not isGrounded(hum, root) then return end
    if hum.MoveDirection.Magnitude < 0.05 then return end
    
    local v = root.AssemblyLinearVelocity
    local horiz = Vector3.new(v.X, 0, v.Z)
    if horiz.Magnitude < 0.5 or horiz.Magnitude > 120 then return end
    
    local boosted = horiz * GlideStrength
    if boosted.Magnitude > 100 then boosted = boosted.Unit * 100 end
    
    root.AssemblyLinearVelocity = Vector3.new(boosted.X, v.Y, boosted.Z)
    lastBurst = tick()
end)

-- Keyboard fallback to hide UI
local isVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        isVisible = not isVisible
        Main.Visible = isVisible
    end
end)

print("[SERENADE HUB] Loaded. Drag the red pill button to move, tap it to toggle the menu.")
```
