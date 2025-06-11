-- ZScript UI for Blade Ball
-- Created by [Đào Minh Dũng]
-- Version 1.0

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Kiểm tra thiết bị
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZScriptGui"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Tạo Frame chính (Menu)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "ZScript - Blade Ball"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Nút ẩn/hiện menu
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0.5, -50, 1, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.Text = "Hide Menu"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- Logic ẩn/hiện menu
local menuVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    ToggleButton.Text = menuVisible and "Hide Menu" or "Show Menu"
end)

-- Nút Auto Spam Mobile
local SpamButton
local function createMobileSpamButton()
    if not isMobile() then
        return
    end

    SpamButton = Instance.new("Frame")
    SpamButton.Size = UDim2.new(0, 50, 0, 50)
    SpamButton.Position = UDim2.new(0.5, -25, 0.5, -25)
    SpamButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SpamButton.BorderSizePixel = 0
    SpamButton.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = SpamButton

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "OFF"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextScaled = true
    StatusLabel.Parent = SpamButton

    local dragging, dragInput, dragStart, startPos
    local function updateInput(input)
        local delta = input.Position - dragStart
        SpamButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    SpamButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = SpamButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    SpamButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            dragInput = input
            updateInput(input)
        end
    end)

    local mobileSpamEnabled = false
    SpamButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            mobileSpamEnabled = not mobileSpamEnabled
            StatusLabel.Text = mobileSpamEnabled and "ON" or "OFF"
            SpamButton.BackgroundColor3 = mobileSpamEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
            createNotification("ZScript", mobileSpamEnabled and "Mobile Auto Spam Enabled" or "Mobile Auto Spam Disabled", 2)
        end
    end)
end

-- Hàm tạo thông báo
local function createNotification(title, content, duration)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 200, 0, 60)
    Notification.Position = UDim2.new(1, -210, 1, -70)
    Notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Notification.BorderSizePixel = 0
    Notification.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Notification

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 20)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextScaled = true
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = Notification

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, 0, 0, 40)
    ContentLabel.Position = UDim2.new(0, 0, 0, 20)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = content
    ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ContentLabel.TextScaled = true
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextWrapped = true
    ContentLabel.Parent = Notification

    spawn(function()
        wait(duration)
        Notification:Destroy()
    end)
end

-- Tạo các nút điều khiển
local AutoParryToggle = Instance.new("TextButton")
AutoParryToggle.Size = UDim2.new(0, 260, 0, 40)
AutoParryToggle.Position = UDim2.new(0, 20, 0, 70)
AutoParryToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoParryToggle.Text = "Auto Parry: OFF"
AutoParryToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoParryToggle.TextScaled = true
AutoParryToggle.Font = Enum.Font.Gotham
AutoParryToggle.Parent = MainFrame

local UICornerParry = Instance.new("UICorner")
UICornerParry.CornerRadius = UDim.new(0, 8)
UICornerParry.Parent = AutoParryToggle

local autoParryEnabled = false
AutoParryToggle.MouseButton1Click:Connect(function()
    autoParryEnabled = not autoParryEnabled
    AutoParryToggle.Text = "Auto Parry: " .. (autoParryEnabled and "ON" or "OFF")
    AutoParryToggle.BackgroundColor3 = autoParryEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
    createNotification("ZScript", autoParryEnabled and "Auto Parry Enabled" or "Auto Parry Disabled", 2)
end)

local AutoSpamPCToggle = Instance.new("TextButton")
AutoSpamPCToggle.Size = UDim2.new(0, 260, 0, 40)
AutoSpamPCToggle.Position = UDim2.new(0, 20, 0, 120)
AutoSpamPCToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoSpamPCToggle.Text = "Auto Spam PC: OFF (E)"
AutoSpamPCToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoSpamPCToggle.TextScaled = true
AutoSpamPCToggle.Font = Enum.Font.Gotham
AutoSpamPCToggle.Parent = MainFrame

local UICornerSpamPC = Instance.new("UICorner")
UICornerSpamPC.CornerRadius = UDim.new(0, 8)
UICornerSpamPC.Parent = AutoSpamPCToggle

local autoSpamPCEnabled = false
AutoSpamPCToggle.MouseButton1Click:Connect(function()
    if isMobile() then
        createNotification("ZScript", "Auto Spam PC chỉ dành cho PC!", 2)
        return
    end
    autoSpamPCEnabled = not autoSpamPCEnabled
    AutoSpamPCToggle.Text = "Auto Spam PC: " .. (autoSpamPCEnabled and "ON" or "OFF") .. " (E)"
    AutoSpamPCToggle.BackgroundColor3 = autoSpamPCEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
    createNotification("ZScript", autoSpamPCEnabled and "Auto Spam PC Enabled" or "Auto Spam PC Disabled", 2)
end)

local MobileSpamButton = Instance.new("TextButton")
MobileSpamButton.Size = UDim2.new(0, 260, 0, 40)
MobileSpamButton.Position = UDim2.new(0, 20, 0, 170)
MobileSpamButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MobileSpamButton.Text = "Create Mobile Spam Button"
MobileSpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileSpamButton.TextScaled = true
MobileSpamButton.Font = Enum.Font.Gotham
MobileSpamButton.Parent = MainFrame

local UICornerMobile = Instance.new("UICorner")
UICornerMobile.CornerRadius = UDim.new(0, 8)
UICornerMobile.Parent = MobileSpamButton

MobileSpamButton.MouseButton1Click:Connect(function()
    createMobileSpamButton()
    createNotification("ZScript", "Mobile Auto Spam Button Created", 2)
end)

-- Khởi tạo
createNotification("ZScript", "Script Loaded", 3)