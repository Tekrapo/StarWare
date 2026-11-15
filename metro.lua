-- femboy.gg UI
-- Library: original Lumen build (same loader as the working example).
-- License key: "femboy.gg"

local Femboy = loadstring(game:HttpGet("https://raw.githubusercontent.com/chromatiks/Lumen/main/Library.lua"))()

Femboy.SetConfigFolder("femboy")

-- ===== femboy.gg HUD: watermark / keybind list / auto scale =====
-- Self-contained: only uses Femboy's public table and every step is pcall-guarded,
-- so a failed patch can never stop the menu from loading.
local Hud = { Binds = {}, Settings = { Watermark = true, KeybindList = false, AutoScale = true, Scale = 1 } }

do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local GuiService = game:GetService("GuiService")
	local CoreGui = game:GetService("CoreGui")

	local BASE_W, BASE_H = 658, 461
	local UIT = Enum.UserInputType

	local LOGO_B64 = [==[
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
]==]

	local function DecodeBase64(Data)
		local Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		local Map = {}
		for i = 1, #Chars do
			Map[Chars:sub(i, i)] = i - 1
		end
		Data = Data:gsub("[^%w%+/]", "")
		local Out, n = {}, 0
		local Len = #Data
		local i = 1
		while i <= Len do
			local a = Map[Data:sub(i, i)]
			local b = Map[Data:sub(i + 1, i + 1)]
			local c = Map[Data:sub(i + 2, i + 2)]
			local d = Map[Data:sub(i + 3, i + 3)]
			if not a or not b then
				break
			end
			local Num = a * 262144 + b * 4096 + (c or 0) * 64 + (d or 0)
			n = n + 1
			Out[n] = string.char(math.floor(Num / 65536) % 256)
			if c then
				n = n + 1
				Out[n] = string.char(math.floor(Num / 256) % 256)
			end
			if d then
				n = n + 1
				Out[n] = string.char(Num % 256)
			end
			i = i + 4
		end
		return table.concat(Out)
	end

	local function Warn(Where, Err)
		warn("[femboy.gg] " .. Where .. ": " .. tostring(Err))
	end

	local function New(Class, Props, Parent)
		local Obj = Instance.new(Class)
		for Key, Value in pairs(Props) do
			pcall(function()
				Obj[Key] = Value
			end)
		end
		if Parent then
			Obj.Parent = Parent
		end
		return Obj
	end

	local function ThemeColor(Key, Default)
		local Value = Femboy.Theme and Femboy.Theme[Key]
		if typeof(Value) == "Color3" then
			return Value
		end
		return Default
	end

	local function IsPress(Input)
		return Input.UserInputType == UIT.MouseButton1 or Input.UserInputType == UIT.Touch
	end

	-- ---------- logo (embedded jpg -> custom asset) ----------
	local function LogoAsset()
		local GetAsset = getcustomasset or getsynasset
		if not (writefile and GetAsset) then
			return nil
		end
		local Ok, Asset = pcall(function()
			local Folder = "femboy"
			if makefolder and isfolder and not isfolder(Folder) then
				pcall(makefolder, Folder)
			end
			local Path = Folder .. "/logo_v1.jpg"
			if not (isfile and isfile(Path)) then
				writefile(Path, DecodeBase64(LOGO_B64))
			end
			return GetAsset(Path)
		end)
		if Ok and type(Asset) == "string" and Asset ~= "" then
			return Asset
		end
		return nil
	end

	-- ---------- scale ----------
	local function Viewport()
		local Camera = workspace.CurrentCamera
		local Size = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
		local Inset = 0
		pcall(function()
			Inset = GuiService:GetGuiInset().Y
		end)
		return Size, Inset
	end

	function Hud.GetScale()
		if Hud.Settings.AutoScale then
			local Size, Inset = Viewport()
			local Fit = math.min((Size.X - 16) / BASE_W, (Size.Y - Inset - 16) / BASE_H)
			return math.clamp(Fit, 0.35, 1)
		end
		return math.clamp(Hud.Settings.Scale, 0.35, 1.25)
	end

	local function FindWindow()
		for _, Win in ipairs(Femboy.Windows or {}) do
			if type(Win) == "table" and typeof(Win.Canvas) == "Instance" and Win.Canvas.Parent then
				return Win.Canvas, Win
			end
		end
		local Root = Femboy._Instance
		if typeof(Root) == "Instance" then
			local View = Viewport()
			local Best, BestArea = nil, 0
			for _, Child in ipairs(Root:GetChildren()) do
				if Child:IsA("GuiObject") then
					local Size = Child.AbsoluteSize
					local Full = Size.X >= View.X * 0.95 and Size.Y >= View.Y * 0.95
					local Area = Size.X * Size.Y
					if not Full and Area > BestArea then
						Best, BestArea = Child, Area
					end
				end
			end
			return Best, nil
		end
		return nil, nil
	end

	function Hud.ApplyScale()
		local Scale = Hud.GetScale()

		local Canvas, Win = FindWindow()
		if Canvas then
			local Existing = Canvas:FindFirstChildOfClass("UIScale")
			if not Existing then
				Existing = New("UIScale", { Name = "FemboyScale" }, Canvas)
			end
			Existing.Scale = Scale
			if Win and type(Win.Center) == "function" then
				task.defer(Win.Center)
			else
				Canvas.AnchorPoint = Vector2.new(0.5, 0.5)
				Canvas.Position = UDim2.fromScale(0.5, 0.5)
			end
		end

		local HudScale = math.clamp(Scale, 0.65, 1)
		for _, Name in ipairs({ "Watermark", "KeybindList" }) do
			local Frame = Hud.Gui and Hud.Gui:FindFirstChild(Name)
			local Sc = Frame and Frame:FindFirstChild("HudScale")
			if Sc then
				Sc.Scale = HudScale
			end
		end
	end

	-- ---------- menu toggle (used by the watermark) ----------
	function Hud.ToggleMenu()
		local Canvas = FindWindow()
		local Open = true
		if Canvas then
			Open = not Canvas.Visible
		end
		if type(Femboy.ToggleMenu) == "function" then
			pcall(Femboy.ToggleMenu, Open)
		end
		if Canvas then
			Canvas.Visible = Open
		end
		if not Open then
			pcall(function()
				if Femboy.OpenPopup and Femboy.OpenPopup.Close then
					Femboy.OpenPopup.Close()
				end
			end)
		end
	end

	-- ---------- gui root ----------
	local function Mount(Gui)
		local Parents = {}
		if gethui then
			table.insert(Parents, function()
				return gethui()
			end)
		end
		table.insert(Parents, function()
			return CoreGui
		end)
		table.insert(Parents, function()
			return Players.LocalPlayer:WaitForChild("PlayerGui", 5)
		end)
		for _, Get in ipairs(Parents) do
			local Ok, Parent = pcall(Get)
			if Ok and Parent then
				pcall(function()
					local Old = Parent:FindFirstChild("femboyHud")
					if Old then
						Old:Destroy()
					end
				end)
				local Set = pcall(function()
					Gui.Parent = Parent
				end)
				if Set and Gui.Parent then
					return true
				end
			end
		end
		return false
	end

	local function Draggable(Frame)
		local Dragging, StartInput, StartPos = false, nil, nil
		Frame.InputBegan:Connect(function(Input)
			if not IsPress(Input) then
				return
			end
			Dragging = true
			StartInput = Input.Position
			StartPos = Frame.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end)
		UserInputService.InputChanged:Connect(function(Input)
			if Dragging and (Input.UserInputType == UIT.MouseMovement or Input.UserInputType == UIT.Touch) then
				local Delta = Input.Position - StartInput
				Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
			end
		end)
	end

	-- ---------- watermark ----------
	local function BuildWatermark(Gui)
		local Surface = ThemeColor("Surface", Color3.fromRGB(14, 14, 16))
		local Border = ThemeColor("Border", Color3.fromRGB(38, 38, 46))
		local Accent = ThemeColor("Accent", Color3.fromRGB(120, 140, 255))

		local Frame = New("Frame", {
			Name = "Watermark",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 10),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 34),
			BackgroundColor3 = Surface,
			BorderSizePixel = 0,
			Active = true,
			ZIndex = 50,
			Visible = Hud.Settings.Watermark,
		}, Gui)
		New("UICorner", { CornerRadius = UDim.new(0, 10) }, Frame)
		New("UIStroke", { Color = Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Frame)
		New("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 12) }, Frame)
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 8),
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}, Frame)
		New("UIScale", { Name = "HudScale" }, Frame)

		local Asset = LogoAsset()
		local Logo = New("ImageLabel", {
			Name = "Logo",
			LayoutOrder = 0,
			Size = UDim2.fromOffset(24, 24),
			BackgroundColor3 = Accent,
			BackgroundTransparency = Asset and 1 or 0,
			BorderSizePixel = 0,
			Image = Asset or "",
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 51,
		}, Frame)
		New("UICorner", { CornerRadius = UDim.new(1, 0) }, Logo)

		local function Chip(Text, Order, Dim)
			return New("TextLabel", {
				LayoutOrder = Order,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.fromOffset(0, 34),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				Text = Text,
				TextSize = 12,
				TextColor3 = Dim and Color3.fromRGB(150, 154, 170) or Color3.fromRGB(235, 236, 240),
				ZIndex = 51,
			}, Frame)
		end

		Chip("femboy.gg", 1, false)
		Chip("-", 2, true)
		local Fps = Chip("0 fps", 3, true)
		Chip("-", 4, true)
		local Ping = Chip("0 ms", 5, true)
		Chip("-", 6, true)
		local Clock = Chip(os.date("%H:%M:%S"), 7, true)

		local Frames, Last = 0, os.clock()
		Hud.StatsConn = RunService.RenderStepped:Connect(function()
			Frames = Frames + 1
			local Now = os.clock()
			if Now - Last >= 1 then
				Fps.Text = string.format("%d fps", Frames)
				local Value = 0
				pcall(function()
					Value = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
				end)
				Ping.Text = string.format("%d ms", Value)
				Clock.Text = os.date("%H:%M:%S")
				Frames = 0
				Last = Now
			end
		end)

		-- tap / click (without dragging) toggles the menu
		Frame.InputBegan:Connect(function(Input)
			if not IsPress(Input) then
				return
			end
			local Start = Input.Position
			local Conn
			Conn = Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Conn:Disconnect()
					if (Input.Position - Start).Magnitude < 8 then
						Hud.ToggleMenu()
					end
				end
			end)
		end)

		Hud.Watermark = Frame
	end

	-- ---------- keybind list ----------
	local KeyNames = {
		MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3",
		LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
		LeftAlt = "LAlt", RightAlt = "RAlt", Backspace = "Back", Return = "Enter",
	}

	local function KeyText(Key)
		if typeof(Key) ~= "EnumItem" then
			return "-"
		end
		return KeyNames[Key.Name] or Key.Name
	end

	local function IsActive(Entry)
		local Obj = Entry.Obj
		if type(Obj) == "table" and type(Obj.State) == "boolean" then
			return Obj.State
		end
		return Entry.Tracked == true
	end

	local function BuildList(Gui)
		local Surface = ThemeColor("Surface", Color3.fromRGB(14, 14, 16))
		local Border = ThemeColor("Border", Color3.fromRGB(38, 38, 46))

		local Panel = New("Frame", {
			Name = "KeybindList",
			Position = UDim2.new(0, 14, 0.35, 0),
			Size = UDim2.fromOffset(210, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Surface,
			BorderSizePixel = 0,
			Active = true,
			Visible = false,
			ZIndex = 50,
		}, Gui)
		New("UICorner", { CornerRadius = UDim.new(0, 10) }, Panel)
		New("UIStroke", { Color = Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Panel)
		New("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, Panel)
		New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, Panel)
		New("UIScale", { Name = "HudScale" }, Panel)

		New("TextLabel", {
			Name = "Header",
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 18),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = "Keybinds",
			TextSize = 12,
			TextColor3 = ThemeColor("Accent", Color3.fromRGB(120, 140, 255)),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 51,
		}, Panel)

		Draggable(Panel)
		Hud.List = Panel
		Hud.Rows = {}
	end

	function Hud.Refresh()
		local Panel = Hud.List
		if not Panel then
			return
		end

		local ActiveNow = {}
		local Count = 0
		for Index, Entry in ipairs(Hud.Binds) do
			if IsActive(Entry) then
				Count = Count + 1
				local Obj = Entry.Obj
				local Mode = (type(Obj) == "table" and Obj.Type) or Entry.Mode or "Toggle"
				local Key = KeyText(type(Obj) == "table" and Obj.Key or nil)
				local Id = tostring(Index)
				ActiveNow[Id] = true

				local Row = Hud.Rows[Id]
				if not Row then
					local Frame = New("Frame", {
						LayoutOrder = Index,
						Size = UDim2.new(1, 0, 0, 22),
						BackgroundTransparency = 1,
						ZIndex = 51,
					}, Panel)
					local function Cell(Name, Pos, Size, Align, Color)
						return New("TextLabel", {
							Name = Name,
							Position = Pos,
							Size = Size,
							BackgroundTransparency = 1,
							Font = Enum.Font.GothamMedium,
							TextSize = 12,
							TextColor3 = Color,
							TextXAlignment = Align,
							TextTruncate = Enum.TextTruncate.AtEnd,
							ZIndex = 52,
						}, Frame)
					end
					local Accent = ThemeColor("Accent", Color3.fromRGB(120, 140, 255))
					Row = {
						Frame = Frame,
						Name = Cell("Name", UDim2.fromOffset(0, 0), UDim2.new(0.5, 0, 1, 0), Enum.TextXAlignment.Left, Color3.fromRGB(235, 236, 240)),
						Key = Cell("Key", UDim2.fromScale(0.5, 0), UDim2.new(0.25, 0, 1, 0), Enum.TextXAlignment.Center, Accent),
						Mode = Cell("Mode", UDim2.fromScale(0.75, 0), UDim2.new(0.25, 0, 1, 0), Enum.TextXAlignment.Right, Color3.fromRGB(150, 154, 170)),
					}
					Hud.Rows[Id] = Row
				end
				Row.Name.Text = Entry.Name
				Row.Key.Text = Key
				Row.Mode.Text = tostring(Mode)
			end
		end

		for Id, Row in pairs(Hud.Rows) do
			if not ActiveNow[Id] then
				Row.Frame:Destroy()
				Hud.Rows[Id] = nil
			end
		end

		Panel.Visible = Hud.Settings.KeybindList == true and Count > 0
	end

	-- ---------- public api ----------
	function Hud.Bind(Label, Props)
		local Entry = {
			Name = tostring(Label.Text or "Keybind"),
			Mode = Props.Type or "Toggle",
			Tracked = false,
		}
		local Original = Props.Callback
		Props.Callback = function(State, ...)
			Entry.Tracked = State == true
			if Original then
				return Original(State, ...)
			end
		end
		local Obj = Label:Keybind(Props)
		Entry.Obj = Obj
		table.insert(Hud.Binds, Entry)
		return Obj
	end

	function Hud.SetWatermark(State)
		Hud.Settings.Watermark = State == true
		if Hud.Watermark then
			Hud.Watermark.Visible = Hud.Settings.Watermark
		end
	end

	function Hud.SetKeybindList(State)
		Hud.Settings.KeybindList = State == true
		pcall(Hud.Refresh)
	end

	function Hud.SetAutoScale(State)
		Hud.Settings.AutoScale = State == true
		pcall(Hud.ApplyScale)
	end

	function Hud.SetScale(Percent)
		if type(Percent) == "number" then
			Hud.Settings.Scale = Percent / 100
			pcall(Hud.ApplyScale)
		end
	end

	function Hud.Start()
		local Gui = New("ScreenGui", {
			Name = "femboyHud",
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			DisplayOrder = 100,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		})
		if not Mount(Gui) then
			Warn("hud", "could not parent the HUD gui")
			return
		end
		Hud.Gui = Gui

		local Ok, Err = pcall(BuildWatermark, Gui)
		if not Ok then
			Warn("watermark", Err)
		end
		Ok, Err = pcall(BuildList, Gui)
		if not Ok then
			Warn("keybind list", Err)
		end
		Ok, Err = pcall(Hud.ApplyScale)
		if not Ok then
			Warn("scale", Err)
		end
		task.delay(0.15, function()
			pcall(Hud.ApplyScale)
		end)

		local Camera = workspace.CurrentCamera
		if Camera then
			Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
				pcall(Hud.ApplyScale)
			end)
		end

		task.spawn(function()
			while Gui.Parent do
				local Done, Problem = pcall(Hud.Refresh)
				if not Done then
					Warn("keybind list refresh", Problem)
				end
				task.wait(0.2)
			end
			if Hud.StatsConn then
				Hud.StatsConn:Disconnect()
			end
		end)
	end
end
-- ===== end HUD =====

Femboy:KeySystem({
	Title = "femboy.gg Login";
	Placeholder = "License key";
	ButtonText = "Sign in";
	Remember = true;
	ShowExpiry = true;
	WatermarkExpiry = false;
	Validate = function(key, finish)
		if key == "femboy.gg" then
			return true, 1826323200
		end
		return false, nil, "Invalid key"
	end;
})

Femboy:LoadingScreen({ Title = "femboy.gg"; Subtitle = "Initializing…"; Duration = 1.25 })

Femboy.SetWatermark("femboy.gg", false) -- library watermark off, Hud draws its own
Femboy.SetKeybindList(false) -- off by default, toggle in Settings > Interface

local Window = Femboy:Window({
	Title = "femboy.gg";
	Footer = "femboy.gg";
})

local Combat = Window:Page({ Icon = "swords" })
local Aimbot = Combat:SubPage({ Name = "Aimbot" })
local AntiAim = Combat:SubPage({ Name = "Anti-Aim" })
local Trigger = Combat:SubPage({ Name = "Triggerbot" })

local AimMain = Aimbot:Section({ Name = "Main"; Side = "Left"; Icon = "crosshair" })
local AimTarget = Aimbot:Section({ Name = "Targeting"; Side = "Left"; Icon = "target" })
local AimMisc = Aimbot:Section({ Name = "Misc"; Side = "Right"; Icon = "layers" })
local AimExtra = Aimbot:Section({ Name = "Extra"; Side = "Right"; Icon = "star" })

local EnableAim = AimMain:Label({ Text = "Enable aimbot" })
EnableAim:Toggle({ State = false; Flag = "AimbotEnabled"; Callback = function() end })
Hud.Bind(EnableAim, { Key = Enum.KeyCode.RightShift; Type = "Hold"; Flag = "AimbotKey"; Callback = function() end })
EnableAim:Colorpicker({ Color = Color3.fromRGB(255, 80, 80); Flag = "AimbotColor"; Callback = function() end })

AimMain:Slider({ Name = "Field of view"; Suffix = "°"; Value = 90; Min = 1; Max = 180; Increment = 1; Flag = "AimbotFOV"; Callback = function() end })
AimMain:Slider({ Name = "Smoothness"; Suffix = "%"; Value = 35; Min = 0; Max = 100; Increment = 1; Flag = "AimbotSmooth"; Callback = function() end })
AimMain:Dropdown({ Name = "Target part"; Options = { "Head", "Torso", "HumanoidRootPart", "Random" }; Value = "Head"; Flag = "AimbotPart"; Callback = function() end })

AimTarget:Dropdown({ Name = "Priority"; Options = { "Closest", "Lowest health", "Crosshair", "Threat" }; Value = "Closest"; Flag = "AimbotPriority"; Callback = function() end })
AimTarget:Slider({ Name = "Max distance"; Suffix = " studs"; Value = 400; Min = 50; Max = 2000; Increment = 25; Flag = "AimbotDistance"; Callback = function() end })
AimTarget:Dropdown({ Name = "Team check"; Options = { "Off", "Friendly", "Enemy only" }; Value = "Enemy only"; Flag = "AimbotTeam"; Callback = function() end })

local PlayerNames = {}
for _, Plr in game:GetService("Players"):GetPlayers() do
	table.insert(PlayerNames, Plr.Name)
end
AimTarget:Dropdown({
	Name = "Priority player";
	Options = PlayerNames;
	Value = PlayerNames[1] or "";
	Search = true;
	Flag = "PriorityPlayer";
	Callback = function() end;
})

AimMisc:Paragraph({ Title = "femboy.gg"; Body = "License key: femboy.gg (owner only)" })
local EspModes = AimMisc:Label({ Text = "ESP modes" })
EspModes:Toggle({ State = true; Flag = "ESPEnabled"; Callback = function() end })
AimMisc:Dropdown({
	Name = "ESP";
	Multi = true;
	Options = { "Box", "Name", "Health", "Distance", "Tracer" };
	Value = { "Box", "Name" };
	Flag = "ESPModes";
	Callback = function() end;
})
AimMisc:Slider({ Name = "ESP range"; Suffix = " studs"; Value = 500; Min = 50; Max = 3000; Increment = 50; Flag = "ESPRange"; Callback = function() end })

local Silent = AimExtra:Label({ Text = "Silent aim" })
Silent:Toggle({ State = false; Flag = "SilentAim"; Callback = function() end })
Hud.Bind(Silent, { Key = Enum.KeyCode.E; Type = "Toggle"; Flag = "SilentKey"; Callback = function() end })
AimExtra:Slider({ Name = "Hit chance"; Suffix = "%"; Value = 100; Min = 1; Max = 100; Increment = 1; Flag = "HitChance"; Callback = function() end })
AimExtra:Dropdown({ Name = "Prediction"; Options = { "None", "Linear", "Velocity" }; Value = "Linear"; Flag = "Prediction"; Callback = function() end })

local AAMain = AntiAim:Section({ Name = "Angles"; Side = "Left"; Icon = "move" })
local AAExtra = AntiAim:Section({ Name = "Desync"; Side = "Right"; Icon = "activity" })
local AAEnable = AAMain:Label({ Text = "Enable anti-aim" })
AAEnable:Toggle({ State = false; Flag = "AAEnabled"; Callback = function() end })
Hud.Bind(AAEnable, { Key = Enum.KeyCode.X; Type = "Toggle"; Flag = "AAKey"; Callback = function() end })
AAMain:Dropdown({ Name = "Yaw mode"; Options = { "Static", "Jitter", "Spin", "Random" }; Value = "Jitter"; Flag = "AAYaw"; Callback = function() end })

local TBMain = Trigger:Section({ Name = "Main"; Side = "Left"; Icon = "mouse-pointer" })
local TBEnable = TBMain:Label({ Text = "Enable triggerbot" })
TBEnable:Toggle({ State = false; Flag = "TriggerEnabled"; Callback = function() end })
Hud.Bind(TBEnable, { Key = Enum.UserInputType.MouseButton2; Type = "Hold"; Flag = "TriggerKey"; Callback = function() end })

local Rage = Window:Page({ Icon = "flame" })
local RageAim = Rage:SubPage({ Name = "Aimbot" })
local RB = RageAim:Section({ Name = "Ragebot"; Side = "Left"; Icon = "crosshair" })
local REnable = RB:Label({ Text = "Enable ragebot" })
REnable:Toggle({ State = false; Flag = "RageEnabled"; Callback = function() end })
Hud.Bind(REnable, { Key = Enum.KeyCode.R; Type = "Toggle"; Flag = "RageKey"; Callback = function() end })

local Legit = Window:Page({ Icon = "crosshair" })
local LegitAim = Legit:SubPage({ Name = "Aim Assist" })
local LA = LegitAim:Section({ Name = "Assist"; Side = "Left"; Icon = "target" })
local LAE = LA:Label({ Text = "Enable assist" })
LAE:Toggle({ State = false; Flag = "LegitAssist"; Callback = function() end })
Hud.Bind(LAE, { Key = Enum.UserInputType.MouseButton2; Type = "Hold"; Flag = "LegitKey"; Callback = function() end })

local Visuals = Window:Page({ Icon = "eye" })
local ESP = Visuals:SubPage({ Name = "ESP" })
local ESPP = ESP:Section({ Name = "Players"; Side = "Left"; Icon = "users" })
local Box = ESPP:Label({ Text = "Box ESP" })
Box:Toggle({ State = true; Flag = "BoxESP"; Callback = function() end })

local Player = Window:Page({ Icon = "user" })
local Movement = Player:SubPage({ Name = "Movement" })
local Flight = Movement:Section({ Name = "Flight"; Side = "Right"; Icon = "move" })
local Fly = Flight:Label({ Text = "Fly" })
Fly:Toggle({ State = false; Flag = "Fly"; Callback = function() end })
Hud.Bind(Fly, { Key = Enum.KeyCode.F; Type = "Toggle"; Flag = "FlyKey"; Callback = function() end })

local Misc = Window:Page({ Icon = "wrench" })
local Scripts = Window:Page({ Icon = "terminal" })
local Settings = Window:Page({ Icon = "settings" })
local Meta = Settings:Section({ Name = "About"; Side = "Right"; Icon = "info" })
Meta:Paragraph({ Title = "Build"; Body = "femboy.gg UI" })

local Interface = Settings:Section({ Name = "Interface"; Side = "Left"; Icon = "layers" })
local KBL = Interface:Label({ Text = "Keybind list" })
KBL:Toggle({ State = false; Flag = "HudKeybindList"; Callback = function(State) Hud.SetKeybindList(State) end })
local WML = Interface:Label({ Text = "Watermark" })
WML:Toggle({ State = true; Flag = "HudWatermark"; Callback = function(State) Hud.SetWatermark(State) end })
local ASL = Interface:Label({ Text = "Auto scale" })
ASL:Toggle({ State = true; Flag = "HudAutoScale"; Callback = function(State) Hud.SetAutoScale(State) end })
Interface:Slider({ Name = "UI scale (auto scale off)"; Suffix = "%"; Value = 100; Min = 40; Max = 125; Increment = 5; Flag = "HudScale"; Callback = function(Value) Hud.SetScale(Value) end })

Hud.Start()

pcall(function()
		Femboy:KeybindPage(Window)
	end)
Femboy:BuildConfigPage(Window)
Femboy.Notify({ Title = "femboy.gg"; Text = "Loaded successfully"; Type = "Success"; Duration = 3 })
print("[femboy.gg] ready")
