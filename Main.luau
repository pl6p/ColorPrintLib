local PrintLib = {}
--[[
    Examples:
    PrintLib.CPrint(text, color)          -- color: Color3 or number (0-255 grayscale)
    PrintLib.RPrint(text, speed)          -- rainbow, speed = seconds per cycle
    PrintLib.SPrint(text, speed, colors)  -- smooth switch, speed per transition
    PrintLib.SIPrint(text, speed, colors) -- instant switch
    PrintLib.GPrint(text, speed, colors)  -- animated gradient across chars
    PrintLib.GSPrint(text, colors)        -- static gradient
]]

local function getLabel(k)
    local gui = game:GetService("CoreGui")
    local t = tick()
    while tick() - t < 2 do
        local con = gui:FindFirstChild("DevConsoleMaster")
        if con then
            for _, v in pairs(con:GetDescendants()) do
                if v:IsA("TextLabel") and string.find(v.Text, k, 1, true) then
                    return v
                end
            end
        end
        task.wait()
    end
    return nil
end

local function colText(txt, col)
    local r = math.floor(math.clamp(col.R, 0, 1) * 255)
    local g = math.floor(math.clamp(col.G, 0, 1) * 255)
    local b = math.floor(math.clamp(col.B, 0, 1) * 255)
    return string.format("<font color='rgb(%d,%d,%d)'>%s</font>", r, g, b, txt)
end

function PrintLib.CPrint(text, color)
    local col
    if type(color) == "number" then
        local b = math.clamp(color, 0, 255) / 255
        col = Color3.new(b, b, b)
    else
        col = color or Color3.new(1, 1, 1)
    end
    local k = string.char(1) .. tostring(math.random(1000, 9999))
    print(tostring(text) .. k)
    task.spawn(function()
        local l = getLabel(k)
        if l then
            l.RichText = true
            local orig = string.gsub(l.Text, k, "")
            l.Text = colText(orig, col)
        end
    end)
end

function PrintLib.RPrint(text, speed)
    speed = speed or 1
    local k = string.char(1) .. tostring(math.random(1000, 9999))
    print(tostring(text) .. k)
    task.spawn(function()
        local l = getLabel(k)
        if not l then return end
        l.RichText = true
        local orig = string.gsub(l.Text, k, "")
        local h = 0
        while l and l.Parent do
            local dt = task.wait()
            h = (h + dt / speed) % 1
            l.Text = colText(orig, Color3.fromHSV(h, 1, 1))
        end
    end)
end

function PrintLib.SPrint(text, speed, ...)
    speed = speed or 1
    local colors = {...}
    if #colors == 0 then return end
    local k = string.char(1) .. tostring(math.random(1000, 9999))
    print(tostring(text) .. k)
    task.spawn(function()
        local l = getLabel(k)
        if not l then return end
        l.RichText = true
        local orig = string.gsub(l.Text, k, "")
        local idx = 1
        local cur = colors[1]
        while l and l.Parent do
            local nxt = (idx % #colors) + 1
            local target = colors[nxt]
            local elapsed = 0
            while elapsed < speed and l and l.Parent do
                local dt = task.wait()
                elapsed = elapsed + dt
                local a = math.min(elapsed / speed, 1)
                local blended = cur:Lerp(target, a)
                l.Text = colText(orig, blended)
            end
            cur = target
            idx = nxt
        end
    end)
end

function PrintLib.SIPrint(text, speed, ...)
    speed = speed or 1
    local colors = {...}
    if #colors == 0 then return end
    local k = string.char(1) .. tostring(math.random(1000, 9999))
    print(tostring(text) .. k)
    task.spawn(function()
        local l = getLabel(k)
        if not l then return end
        l.RichText = true
        local orig = string.gsub(l.Text, k, "")
        local idx = 1
        local acc = 0
        while l and l.Parent do
            local dt = task.wait()
            acc = acc + dt
            if acc >= speed then
                acc = 0
                l.Text = colText(orig, colors[idx])
                idx = (idx % #colors) + 1
            end
        end
    end)
end

function PrintLib.GPrint(text, speed, ...)
    speed = speed or 1
    local colors = {...}
    if #colors == 0 then return end
    local k = string.char(1) .. tostring(math.random(1000, 9999))
    print(tostring(text) .. k)
    task.spawn(function()
        local l = getLabel(k)
        if not l then return end
        l.RichText = true
        local orig = string.gsub(l.Text, k, "")
        local len = #orig
        if len == 0 then return end
        while l and l.Parent do
            local off = tick() * speed
            local parts = {}
            for i = 1, len do
                local prog = (len > 1) and ((i - 1) / (len - 1)) or 0
                local anim = (prog + off) % 1
                local segs = #colors - 1
                local pos = anim * segs
                local idx = math.floor(pos) + 1
                local nxt = math.min(idx + 1, #colors)
                local blend = pos - math.floor(pos)
                local blended = colors[idx]:Lerp(colors[nxt], blend)
                local ch = string.sub(orig, i, i)
                parts[i] = colText(ch, blended)
            end
            l.Text = table.concat(parts)
            task.wait()
        end
    end)
end

function PrintLib.GSPrint(text, rotation, ...)
    local colors = {...}
    if #colors == 0 then return end
    local k = string.char(1) .. tostring(math.random(1000, 9999))
    print(tostring(text) .. k)
    task.spawn(function()
        local l = getLabel(k)
        if not l then return end
        l.RichText = true
        local orig = string.gsub(l.Text, k, "")
        local len = #orig
        if len == 0 then return end
        local parts = {}
        for i = 1, len do
            local prog = (len > 1) and ((i - 1) / (len - 1)) or 0
            local segs = #colors - 1
            local pos = prog * segs
            local idx = math.floor(pos) + 1
            local nxt = math.min(idx + 1, #colors)
            local blend = pos - math.floor(pos)
            local blended = colors[idx]:Lerp(colors[nxt], blend)
            local ch = string.sub(orig, i, i)
            parts[i] = colText(ch, blended)
        end
        l.Text = table.concat(parts)
    end)
end

return PrintLib
