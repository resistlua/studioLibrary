--// studioLibrary.lua | 11/11/2022 | RESIST#3276



--[[
1.0

]]


--// Setup //
getgenv().uis = game:GetService('UserInputService')
getgenv().ts = game:GetService('TweenService')
getgenv().rs = game:GetService('RunService')



--// Settings //
local library = {
    title = 'Widget',

    --// Not settings //
    flags = {}
}

--// Main //
getgenv().library = library

local function create(instance,properties)
    local obj = Instance.new(instance)
    for i,v in pairs(properties) do
        obj[i] = v
    end
    return obj
end

local screenGui = create('ScreenGui',{['Name'] = 'StudioLibrary',['Parent'] = game.CoreGui,['DisplayOrder'] = 10,['ResetOnSpawn'] = false,['IgnoreGuiInset'] = true})

local main = create('Frame',{['Name'] = 'Main',['Parent'] = screenGui,['Size'] = UDim2.new(0,200,0,28),['BackgroundColor3'] = Color3.fromRGB(46,46,46),['BorderSizePixel'] = 4, ['BorderColor3'] = Color3.fromRGB(64,64,64),['AnchorPoint'] = Vector2.new(0,0),['Position'] = UDim2.new(0.1,0,0,30)})

local container = create('Frame',{['Name'] = 'Container',['Parent'] = main,['Size'] = UDim2.new(1, -8,1, -28),['BackgroundTransparency'] = 1,['BackgroundColor3'] = Color3.fromRGB(36, 36, 36),['BorderSizePixel'] = 0, ['BorderColor3'] = Color3.fromRGB(64,64,64),['AnchorPoint'] = Vector2.new(0,0),['Position'] = UDim2.new(0, 4,0, 24)})

local top = create('Frame',{['Name'] = 'Top',['Parent'] = main,['Size'] = UDim2.new(1,0,0,20),['BackgroundColor3'] = Color3.fromRGB(53, 53, 53),['BorderSizePixel'] = 0, ['BorderColor3'] = Color3.fromRGB(64,64,64),['AnchorPoint'] = Vector2.new(0,0),['Position'] = UDim2.new(0,0,0,0)})
local title = create('TextLabel',{['Name'] = 'Title',['Parent'] = top,['Size'] = UDim2.new(1,-32,1,-2),['BackgroundTransparency'] = 1,['TextColor3'] = Color3.fromRGB(204,204,204),['Text'] = library.title})
local close = create('ImageButton',{['Name'] = 'Close',['AutoButtonColor'] = false,['Parent'] = top,['BackgroundColor3'] = Color3.fromRGB(80,80,80),['BackgroundTransparency'] = 1,['BorderSizePixel'] = 0,['Position'] = UDim2.new(1,-14,0.5,0),['AnchorPoint'] = Vector2.new(0,0.5),['ImageColor3'] = Color3.fromRGB(204,204,204),['Image'] = 'rbxassetid://11530278545',['Size'] = UDim2.new(0,10,0,10)})
local minimize = create('ImageButton',{['Name'] = 'Minimize',['AutoButtonColor'] = false,['Parent'] = top,['BackgroundColor3'] = Color3.fromRGB(80,80,80),['BackgroundTransparency'] = 1,['BorderSizePixel'] = 0,['Position'] = UDim2.new(1,-28,0.5,0),['AnchorPoint'] = Vector2.new(0,0.5),['ImageColor3'] = Color3.fromRGB(204,204,204),['Image'] = 'rbxassetid://11530306783',['Size'] = UDim2.new(0,10,0,10)})

--// Draggable //
local dragging = false
local startpos
local dragstart
local function update(input)
    local delta = input.Position - dragstart
    main.Position = UDim2.new(startpos.X.Scale,startpos.X.Offset + delta.X,startpos.Y.Scale,startpos.Y.Offset + delta.Y)
end

top.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1) then
        dragging = true
        startpos = main.Position
        dragstart = input.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

uis.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging then
            update(input)
        end
    end
end)

--// Topbar control //
local oldSize = main.Size
local closed = false
close.MouseEnter:Connect(function()
    rs.RenderStepped:Wait()
    close.BackgroundTransparency = 0
end)
close.MouseLeave:Connect(function()
    rs.RenderStepped:Wait()
    close.BackgroundTransparency = 1
end)
close.MouseButton1Click:Connect(function()
    rs.RenderStepped:Wait()
    screenGui:Destroy()
end)

minimize.MouseEnter:Connect(function()
    rs.RenderStepped:Wait()
    minimize.BackgroundTransparency = 0
end)
minimize.MouseLeave:Connect(function()
    rs.RenderStepped:Wait()
    minimize.BackgroundTransparency = 1
end)
minimize.MouseButton1Click:Connect(function()
    rs.RenderStepped:Wait()
    if closed then
        main.Size = oldSize
        closed = false
        container.Visible = true
    else
        main.Size = UDim2.new(0,200,0,20)
        closed = true
        container.Visible = false
    end
end)

return main,container,top
