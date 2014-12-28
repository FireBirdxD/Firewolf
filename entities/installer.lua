--  -------- Variables

-- Download URL
local downloadURL = "https://raw.github.com/1lann/firewolf/master/entities/other.lua"

local function isAdvanced()
	if term.isColor then return term.isColor()
	else return false end
end

-- Theme
local theme = {}
theme.background = colors.gray
theme.top = colors.red
theme.bottom = colors.orange
theme.text = colors.white
if not(isAdvanced()) then
	theme.background = colors.black
	theme.top = colors.black
	theme.bottom = colors.black
	theme.text = colors.white
end

-- Term size
local w, h = term.getSize()


--  ------- Utility Functions

local function prompt(list, dir)
	if isAdvanced() then
		for _, v in pairs(list) do
			if v.bg then term.setBackgroundColor(v.bg) end
			if v.tc then term.setTextColor(v.tc) end
			if v[2] == -1 then v[2] = math.ceil((w + 1)/2 - (v[1]:len() + 6)/2) end

			term.setCursorPos(v[2], v[3])
			write("[- " .. v[1])
			term.setCursorPos(v[2] + v[1]:len() + 3, v[3])
			write(" -]")
		end

		while true do
			local e, but, x, y = os.pullEvent()
			if e == "mouse_click" then
				for _, v in pairs(list) do
					if x >= v[2] and x <= v[2] + v[1]:len() + 5 and y == v[3] then
						return v[1]
					end
				end
			end
		end
	else
		for _, v in pairs(list) do
			term.setBackgroundColor(colors.black)
			term.setTextColor(colors.white)
			if v[2] == -1 then v[2] = math.ceil((w + 1)/2 - (v[1]:len() + 4)/2) end

			term.setCursorPos(v[2], v[3])
			write("  " .. v[1])
			term.setCursorPos(v[2] + v[1]:len() + 2, v[3])
			write("  ")
		end

		local key1 = 200
		local key2 = 208
		if dir == "horizontal" then
			key1 = 203
			key2 = 205
		end

		local curSel = 1
		term.setCursorPos(list[curSel][2], list[curSel][3])
		write("[")
		term.setCursorPos(list[curSel][2] + list[curSel][1]:len() + 3, list[curSel][3])
		write("]")

		while true do
			local e, key = os.pullEvent()
			term.setCursorPos(list[curSel][2], list[curSel][3])
			write(" ")
			term.setCursorPos(list[curSel][2] + list[curSel][1]:len() + 3, list[curSel][3])
			write(" ")
			if e == "key" and key == key1 and curSel > 1 then
				curSel = curSel - 1
			elseif e == "key" and key == key2 and curSel < #list then
				curSel = curSel + 1
			elseif e == "key" and key == 28 then
				return list[curSel][1]
			end
			term.setCursorPos(list[curSel][2], list[curSel][3])
			write("[")
			term.setCursorPos(list[curSel][2] + list[curSel][1]:len() + 3, list[curSel][3])
			write("]")
		end
	end
end

local function centerPrint(text)
	local x, y = term.getCursorPos()
	term.setCursorPos(math.ceil((w + 1)/2 - text:len()/2), y)
	print(text)
end

local function centerWrite(text)
	local x, y = term.getCursorPos()
	term.setCursorPos(math.ceil((w + 1)/2 - text:len()/2), y)
	write(text)
end

local function download(url, path)
	for i = 1, 3 do
		local response = http.get(url)
		if response then
			local data = response.readAll()
			response.close()
			if path then
				local f = io.open(path, "w")
				f:write(data)
				f:close()
			end
			return true
		end
	end

	return false
end


--  -------- Main

-- Splashscreen
term.setTextColor(theme.text)
term.setBackgroundColor(theme.background)
term.clear()
term.setCursorPos(1, 2)
term.setBackgroundColor(theme.top)
centerPrint(string.rep(" ", 47))
centerPrint([[          ______ ____ ____   ______            ]])
centerPrint([[ ------- / ____//  _// __ \ / ____/            ]])
centerPrint([[ ------ / /_    / / / /_/ // __/               ]])
centerPrint([[ ----- / __/  _/ / / _  _// /___               ]])
centerPrint([[ ---- / /    /___//_/ |_|/_____/               ]])
centerPrint([[ --- / /       _       __ ____   __     ______ ]])
centerPrint([[ -- /_/       | |     / // __ \ / /    / ____/ ]])
centerPrint([[              | | /| / // / / // /    / /_     ]])
centerPrint([[              | |/ |/ // /_/ // /___ / __/     ]])
centerPrint([[              |__/|__/ \____//_____//_/        ]])
centerPrint(string.rep(" ", 47))
print("\n")

term.setBackgroundColor(theme.bottom)
for i = 1, 3 do centerPrint(string.rep(" ", 47)) end

if not(http) then
	term.setCursorPos(1, 17)
	centerWrite("HTTP API Not Enabled! ")
	if isAdvanced() then write("Click to exit...")
	else write("Press any key to exit...") end
	while true do
		local e = os.pullEvent()
		if e == "key" or e == "mouse_click" then break end
	end

	error()
end

-- Prompt
local opt = prompt({{"Install Firewolf", 5, 17}, {"Cancel", w - 16, 17}}, "horizontal")
if opt == "Install Firewolf" then
	-- Install
	term.setCursorPos(1, 17)
	centerWrite(string.rep(" ", 47))
	centerWrite("Installing...")
	local a = download(downloadURL, "/firewolf")
	centerWrite(string.rep(" ", 47))
	if a then
		centerWrite("Done!")
	else
		centerWrite("Download Failed!")
	end
elseif opt == "Cancel" then
	-- Cancel
	term.setCursorPos(1, 17)
	centerWrite(string.rep(" ", 47))
	centerWrite("Cancelled!")
end

-- Clear screen
sleep(1.3)
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1, 1)