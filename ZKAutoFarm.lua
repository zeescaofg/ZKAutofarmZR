local groundDistance = 8
local Player = game:GetService("Players").LocalPlayer

local function getNearest()
    local nearest, dist = nil, 99999

    -- Check zombies in the "Zombie Storage" folder
    for _, v in pairs(game.Workspace:FindFirstChild("Zombie Storage"):GetChildren()) do
        if v:FindFirstChild("Head") then
            local m = (Player.Character.Head.Position - v.Head.Position).magnitude
            if m < dist then
                dist = m
                nearest = v
            end
        end
    end

    -- Check for BasePlayerZombie directly in the Workspace
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "BasePlayerZombie" and v:FindFirstChild("Head") then
            local m = (Player.Character.Head.Position - v.Head.Position).magnitude
            if m < dist then
                dist = m
                nearest = v
            end
        end
    end

    return nearest
end

_G.farm2 = true

Player.Chatted:Connect(function(m)
    if m == ";autofarm false" then
        _G.farm2 = false
    elseif m == ";autofarm true" then
        _G.farm2 = true
    end
end)

_G.globalTarget = nil

game:GetService("RunService").RenderStepped:Connect(function()
    if _G.farm2 then
        local target = getNearest()
        if target then
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                game:GetService("Workspace").CurrentCamera.CFrame = CFrame.new(game:GetService("Workspace").CurrentCamera.CFrame.p, target.Head.Position)
                Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, groundDistance, 9)
                _G.globalTarget = target
            end
        end
    end
end)

spawn(function()
    while wait() do
        if Player.Character then
            local humanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

while wait() do
    if _G.farm2 and _G.globalTarget and _G.globalTarget:FindFirstChild("Head") and Player.Character:FindFirstChildOfClass("Tool") then
        local target = _G.globalTarget
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool then
            game.ReplicatedStorage.Gun:FireServer({
                Normal = Vector3.new(0, 0, 0),
                Direction = target.Head.Position,
                Name = tool.Name,
                Hit = target.Head,
                Origin = target.Head.Position,
                Pos = target.Head.Position,
            })
        end
        wait()
    end
end
