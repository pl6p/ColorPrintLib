local PrintLib = {}

--[[
	This was been ai optimizated btw dwbi
	PrintLib.CPrint(string, color)   ---------------------- Colored print
	PrintLib.RPrint(string, speed) ---------------------- Rainbow print (rainbow speed)
	PrintLib.SPrint(string, speed, color1 - ∞) -------- Tween Color Switch 
	PrintLib.SIPrint(string, speed, color1 - ∞) ------- Instant Color Switch 
	PrintLib.GPrint(string, speed, col1 - ∞)  --------- Tween Gradient
	PrintLib.GSPrint(string, 0, col1 - ∞) -------------- Static Gradient
--]]

local _usedMarkers = {}
local _chars = "abcdefghijklmnopqrstuvwxyz0123456789"

local function genMarker()
	local len = math.random(16, 32)
	local mk = ""
	for i = 1, len do
		local idx = math.random(1, #_chars)
		mk = mk .. string.sub(_chars, idx, idx)
	end
	return mk
end

local function getUniqueMarker()
	local mk = genMarker()
	local attempts = 0
	while _usedMarkers[mk] and attempts < 100 do
		mk = genMarker()
		attempts = attempts + 1
	end
	_usedMarkers[mk] = true
	return mk
end

function PrintLib.CPrint(txt, col)
	if type(col) == "number" then
		col = Color3.fromRGB(col, col, col)
	end
	local k = getUniqueMarker()
	local ft = tostring(txt) .. k
	print(ft)
	task.spawn(function()
		local lbl = nil
		local cg = game:GetService("CoreGui")
		local tm = tick()
		while not lbl and tick() - tm < 2 do
			local con = cg:FindFirstChild("DevConsoleMaster")
			if con then
				for _, v in pairs(con:GetDescendants()) do
					if v:IsA("TextLabel") and string.find(v.Text, k, 1, true) then
						lbl = v
						break
					end
				end
			end
			if not lbl then task.wait() end
		end
		if lbl then
			lbl.RichText = true
			local r = math.floor(col.R * 255)
			local g = math.floor(col.G * 255)
			local b = math.floor(col.B * 255)
			local ot = string.gsub(lbl.Text, k, "")
			lbl.Text = string.format("<font color='rgb(%d,%d,%d)'>%s</font>", r, g, b, ot)
		end
	end)
end

function PrintLib.RPrint(txt, spd)
	spd = spd or 1
	local k = getUniqueMarker()
	local ft = tostring(txt) .. k
	print(ft)
	task.spawn(function()
		local lbl = nil
		local cg = game:GetService("CoreGui")
		local tm = tick()
		while not lbl and tick() - tm < 2 do
			local con = cg:FindFirstChild("DevConsoleMaster")
			if con then
				for _, v in pairs(con:GetDescendants()) do
					if v:IsA("TextLabel") and string.find(v.Text, k, 1, true) then
						lbl = v
						break
					end
				end
			end
			if not lbl then task.wait() end
		end
		if lbl then
			lbl.RichText = true
			local ot = string.gsub(lbl.Text, k, "")
			local h = 0
			while task.wait() do
				h = (h + spd * task.wait()) % 1
				local c = Color3.fromHSV(h, 1, 1)
				local r = math.floor(c.R * 255)
				local g = math.floor(c.G * 255)
				local b = math.floor(c.B * 255)
				lbl.Text = string.format("<font color='rgb(%d,%d,%d)'>%s</font>", r, g, b, ot)
			end
		end
	end)
end

function PrintLib.SPrint(txt, spd, ...)
	spd = spd or 1
	local cols = {...}
	if #cols == 0 then return end
	local k = getUniqueMarker()
	local ft = tostring(txt) .. k
	print(ft)
	task.spawn(function()
		local lbl = nil
		local cg = game:GetService("CoreGui")
		local tm = tick()
		while not lbl and tick() - tm < 2 do
			local con = cg:FindFirstChild("DevConsoleMaster")
			if con then
				for _, v in pairs(con:GetDescendants()) do
					if v:IsA("TextLabel") and string.find(v.Text, k, 1, true) then
						lbl = v
						break
					end
				end
			end
			if not lbl then task.wait() end
		end
		if lbl then
			lbl.RichText = true
			local ot = string.gsub(lbl.Text, k, "")
			local ci = 1
			local ts = game:GetService("TweenService")
			local ti = TweenInfo.new(spd, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true, 0)
			local tc = cols[ci]
			local tw = ts:Create(lbl, ti, {TextColor3 = tc})
			tw:Play()
			while task.wait() do
				ci = (ci % #cols) + 1
				tc = cols[ci]
				tw = ts:Create(lbl, ti, {TextColor3 = tc})
				tw:Play()
				task.wait(spd)
			end
		end
	end)
end

function PrintLib.SIPrint(txt, spd, ...)
	spd = spd or 1
	local cols = {...}
	if #cols == 0 then return end
	local k = getUniqueMarker()
	local ft = tostring(txt) .. k
	print(ft)
	task.spawn(function()
		local lbl = nil
		local cg = game:GetService("CoreGui")
		local tm = tick()
		while not lbl and tick() - tm < 2 do
			local con = cg:FindFirstChild("DevConsoleMaster")
			if con then
				for _, v in pairs(con:GetDescendants()) do
					if v:IsA("TextLabel") and string.find(v.Text, k, 1, true) then
						lbl = v
						break
					end
				end
			end
			if not lbl then task.wait() end
		end
		if lbl then
			lbl.RichText = true
			local ot = string.gsub(lbl.Text, k, "")
			local ci = 1
			while task.wait(spd) do
				local c = cols[ci]
				local r = math.floor(c.R * 255)
				local g = math.floor(c.G * 255)
				local b = math.floor(c.B * 255)
				lbl.Text = string.format("<font color='rgb(%d,%d,%d)'>%s</font>", r, g, b, ot)
				ci = (ci % #cols) + 1
			end
		end
	end)
end

function PrintLib.GPrint(txt, spd, ...)
	spd = spd or 1
	local cols = {...}
	if #cols == 0 then return end
	local k = getUniqueMarker()
	local ft = tostring(txt) .. k
	print(ft)
	task.spawn(function()
		local lbl = nil
		local cg = game:GetService("CoreGui")
		local tm = tick()
		while not lbl and tick() - tm < 2 do
			local con = cg:FindFirstChild("DevConsoleMaster")
			if con then
				for _, v in pairs(con:GetDescendants()) do
					if v:IsA("TextLabel") and string.find(v.Text, k, 1, true) then
						lbl = v
						break
					end
				end
			end
			if not lbl then task.wait() end
		end
		if lbl then
			lbl.RichText = true
			local ot = string.gsub(lbl.Text, k, "")
			while task.wait() do
				local gt = ""
				local to = tick() * spd
				for i = 1, #ot do
					local pr = (i - 1) / (#ot - 1)
					local ap = (pr + to) % 1
					local ci = math.floor(ap * (#cols - 1)) + 1
					local ni = math.min(ci + 1, #cols)
					local bl = (ap * (#cols - 1)) - (ci - 1)
					local bc = cols[ci]:Lerp(cols[ni], bl)
					local r = math.floor(bc.R * 255)
					local g = math.floor(bc.G * 255)
					local b = math.floor(bc.B * 255)
					gt = gt .. string.format("<font color='rgb(%d,%d,%d)'>%s</font>", r, g, b, string.sub(ot, i, i))
				end
				lbl.Text = gt
			end
		end
	end)
end

function PrintLib.GSPrint(txt, rot, ...)
	local cols = {...}
	if #cols == 0 then return end
	local k = getUniqueMarker()
	local ft = tostring(txt) .. k
	print(ft)
	task.spawn(function()
		local lbl = nil
		local cg = game:GetService("CoreGui")
		local tm = tick()
		while not lbl and tick() - tm < 2 do
			local con = cg:FindFirstChild("DevConsoleMaster")
			if con then
				for _, v in pairs(con:GetDescendants()) do
					if v:IsA("TextLabel") and string.find(v.Text, k, 1, true) then
						lbl = v
						break
					end
				end
			end
			if not lbl then task.wait() end
		end
		if lbl then
			lbl.RichText = true
			local ot = string.gsub(lbl.Text, k, "")
			local gt = ""
			for i = 1, #ot do
				local pr = (#ot > 1) and (i - 1) / (#ot - 1) or 0
				local ci = math.floor(pr * (#cols - 1)) + 1
				local ni = math.min(ci + 1, #cols)
				local bl = (pr * (#cols - 1)) - (ci - 1)
				local bc = cols[ci]:Lerp(cols[ni], bl)
				local r = math.floor(bc.R * 255)
				local g = math.floor(bc.G * 255)
				local b = math.floor(bc.B * 255)
				gt = gt .. string.format("<font color='rgb(%d,%d,%d)'>%s</font>", r, g, b, string.sub(ot, i, i))
			end
			lbl.Text = gt
		end
	end)
end

return PrintLib
